import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/utility/static/app_routes.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';

class ReviewExamItem extends BaseWidget<ReviewViewModel> {
  final ReviewListModel review;

  const ReviewExamItem({super.key, required this.review});

  @override
  Widget buildView(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 복습노트 상세 데이터 로드
        await viewModel.loadReviewDetail(int.parse(review.reviewNoteId));
        Get.toNamed(Routes.REVIEW_ITEM);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
            color: ColorSystem.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: ColorSystem.grey.shade200, style: BorderStyle.solid)),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitle(review.name),
                _buildPassTag(review.isPassed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTagWrap(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(title, style: FontSystem.KR18B);
  }

  Widget _buildTag(String label, Color color, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: FontSystem.KR12SB.copyWith(height: 1.3, color: textColor),
      ),
    );
  }

  Widget _buildPassTag(bool pass) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      height: 20,
      decoration: BoxDecoration(
        color: pass ? ColorSystem.lightBlue : ColorSystem.lightRed,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(pass ? "합격" : "불합격",
          style: FontSystem.KR12SB.copyWith(
              height: 1.3, color: pass ? ColorSystem.blue : ColorSystem.red)),
    );
  }

  Widget _buildTagWrap() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: [
              _buildTag(
                  review.certificate, ColorSystem.lightBlue, ColorSystem.blue),
              _buildTag("${review.readCount}회독", ColorSystem.lightGreen,
                  ColorSystem.green),
            ],
          ),
          const SizedBox(height: 4), // 간격 조절
          Wrap(
            spacing: 4.0,
            children: [
              _buildTag(
                "${review.passRate > 100 ? (review.passRate / 100).toStringAsFixed(1) : review.passRate.toStringAsFixed(1)}%",
                (review.passRate > 100
                            ? review.passRate / 100
                            : review.passRate) >=
                        80.0
                    ? ColorSystem.lightBlue
                    : (review.passRate > 100
                                ? review.passRate / 100
                                : review.passRate) >=
                            60.0
                        ? ColorSystem.lightGreen
                        : ColorSystem.lightRed,
                (review.passRate > 100
                            ? review.passRate / 100
                            : review.passRate) >=
                        80.0
                    ? ColorSystem.blue
                    : (review.passRate > 100
                                ? review.passRate / 100
                                : review.passRate) >=
                            60.0
                        ? ColorSystem.green
                        : ColorSystem.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
