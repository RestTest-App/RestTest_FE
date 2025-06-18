import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/review/widget/review_exam_item.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';
import 'package:rest_test/widget/appbar/default_appbar.dart';

class ReviewScreen extends BaseScreen<ReviewViewModel> {
  ReviewScreen({super.key});

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _categoryKeys = {};

  void dispose() {
    _scrollController.dispose();
  }

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.back;

  @override
  Color? get screenBackgroundColor => ColorSystem.back;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: DefaultAppBar(
          title: '나의 복습노트',
          backColor: ColorSystem.back,
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        _buildCategoryTab(),
        Obx(
          () => _buildInfo(viewModel.filteredReviews.length),
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                itemCount: viewModel.filteredReviews.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final review = viewModel.filteredReviews[index];
                  return ReviewExamItem(review: review);
                },
              )),
        ),
      ],
    );
  }

  // 카테고리탭 위젯
  Widget _buildCategoryTab() {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: List.generate(controller.categories.length, (index) {
                  final category = controller.categories[index];
                  final selected = controller.selectedCategory == category;
                  _categoryKeys.putIfAbsent(category, () => GlobalKey());

                  // margin을 첫 번째만 다르게 주기
                  final isFirst = index == 0;
                  final isFinal = index == 3;
                  final margin = isFirst
                      ? const EdgeInsets.only(left: 20, right: 4)
                      : isFinal
                          ? const EdgeInsets.only(left: 4, right: 20)
                          : const EdgeInsets.symmetric(horizontal: 4);

                  return GestureDetector(
                    onTap: () async {
                      controller.selectCategory(category);
                      await controller.loadReviewListByCategory(category);
                      _scrollToCategory(category); // 위치 이동
                    },
                    child: _buildCategory(
                        _categoryKeys[category], // key 부여
                        category,
                        selected,
                        margin),
                  );
                }).toList(),
              )),
        ));
  }

  void _scrollToCategory(String category) {
    final key = _categoryKeys[category];
    if (key != null && key.currentContext != null) {
      final box = key.currentContext!.findRenderObject() as RenderBox;
      final scrollBox = _scrollController.position.context.storageContext
          .findRenderObject() as RenderBox;

      final boxOffset = box.localToGlobal(Offset.zero, ancestor: scrollBox).dx;
      final scrollViewWidth = scrollBox.size.width;
      final boxWidth = box.size.width;

      final targetOffset = _scrollController.offset +
          boxOffset -
          (scrollViewWidth / 2) +
          (boxWidth / 2);

      _scrollController.animateTo(
        targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  // 카테고리 위젯
  Widget _buildCategory(
      Key? key, String exam, bool selected, EdgeInsets margin) {
    return Container(
      key: key,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      height: 32,
      decoration: BoxDecoration(
        color: selected ? ColorSystem.blue : ColorSystem.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
          child: Text(
        exam,
        style: FontSystem.KR16SB.copyWith(
            color: selected ? ColorSystem.white : ColorSystem.grey.shade600),
      )),
    );
  }

  // Total & 필터
  Widget _buildInfo(int total) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTotal(total),
          _buildFilter(),
        ],
      ),
    );
  }

  Widget _buildTotal(int total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      width: 46,
      height: 19,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total",
            style: FontSystem.KR10SB.copyWith(color: ColorSystem.grey.shade600),
          ),
          Text(
            total.toString(),
            style: FontSystem.KR10SB.copyWith(color: ColorSystem.deepBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: ColorSystem.white, borderRadius: BorderRadius.circular(4.0)),
      width: 70,
      height: 19,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "최근 응시순",
            style: FontSystem.KR10SB.copyWith(color: ColorSystem.grey.shade600),
          ),
          SvgPicture.asset(
            "assets/icons/arrowDown.svg",
          )
        ],
      ),
    );
  }
}
