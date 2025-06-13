import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/review/component/review_detail_item.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';
import '../../utility/static/app_routes.dart';
import '../../utility/system/color_system.dart';
import '../../utility/system/font_system.dart';
import '../../widget/appbar/default_close_appbar.dart';
import '../../widget/button/rounded_rectangle_text_button.dart';

class ReviewContentScreen extends BaseScreen<ReviewViewModel> {
  const ReviewContentScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.white;

  @override
  Color? get screenBackgroundColor => ColorSystem.white;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: DefaultCloseAppbar(
          title: '복습 문제 보기',
          backColor: ColorSystem.white,
          onBackPress: () {
            Get.toNamed(Routes.ROOT);
          },
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        _buildTagWrap(),
        // 메인 콘텐츠 영역
        const Expanded(
          child: ReviewDetailItem(),
        ),
        _buildBottomBar(),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Obx(() {
      final hasPrev = viewModel.currentIndex > 0;
      final hasNext = viewModel.currentIndex < viewModel.questions.length - 1;

      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorSystem.white,
              border: Border(top: BorderSide(color: ColorSystem.grey.shade300))
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RoundedRectangleTextButton(
                      width: double.infinity,
                      text: "이전 문제",
                      backgroundColor:
                      hasPrev ? ColorSystem.grey.shade200 : ColorSystem.grey.shade100,
                      textStyle: FontSystem.KR16SB.copyWith(
                        color: hasPrev ? ColorSystem.grey.shade600 : ColorSystem.grey.shade400,
                      ),
                      onPressed: hasPrev
                          ? () => viewModel.prevQuestion()
                          : null),
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: RoundedRectangleTextButton(
                      width: double.infinity,
                      text: hasNext ? "다음 문제" : "종료하기",
                      backgroundColor: ColorSystem.blue,
                      textStyle: FontSystem.KR16SB.copyWith(
                          color: ColorSystem.white),
                      onPressed: hasNext
                          ? () => viewModel.nextQuestion()
                          : () => Get.offAllNamed(Routes.ROOT)
                  ),
                ),
              ],
            ),)
      );
    });
  }
  Widget _buildTag(String label, Color color, Color textColor){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: FontSystem.KR12SB.copyWith(height: 1.3, color: textColor),
      ),
    );
  }

  Widget _buildTagWrap() {
    return Obx((){
      final exam = viewModel.reviewDetail?.exam;

      if (exam == null) {
        return const SizedBox.shrink(); // 혹은 로딩 인디케이터 등
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                    spacing: 4.0,
                    children: [
                      _buildTag(viewModel.reviewDetail?.exam.name ?? '시험명', ColorSystem.lightBlue, ColorSystem.blue),
                      _buildTag('${viewModel.reviewDetail?.exam.year}년도 ${viewModel.reviewDetail?.exam.month}회', ColorSystem.grey.shade200, ColorSystem.grey.shade600),
                    ]
                ),
                SizedBox(
                  height: 4,
                ),
                Wrap(
                  spacing: 4.0,
                  children: [
                    _buildTag(
                      "${exam.passRate} 점",
                      exam.passRate >= 80.0
                          ? ColorSystem.lightBlue
                          : exam.passRate >= 60.0
                          ? ColorSystem.lightGreen
                          : ColorSystem.lightRed,
                      exam.passRate >= 80.0
                          ? ColorSystem.blue
                          : exam.passRate >= 60.0
                          ? ColorSystem.green
                          : ColorSystem.red,
                    ),
                  ],),
              ],
            ),
            _buildButton(),
          ],
        ),
      );
    });
  }

Widget _buildButton() {
  return GestureDetector(
    onTap: () {
      _showExamSelectDialog(Get.context!);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: ColorSystem.grey.shade300, width: 1.0)
      ),
      child: Center(
        child: Text("문제이동", style: FontSystem.KR12M.copyWith(color: ColorSystem.grey.shade600),),
      ),
    )
  );
}

  void _showExamSelectDialog(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width - 40;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
            color: ColorSystem.black.withOpacity(0.3),
            child: Align(
              alignment: Alignment.center,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: modalWidth,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  decoration: BoxDecoration(
                    color: ColorSystem.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("복습 문제 전체 보기", style: FontSystem.KR24B.copyWith(color: ColorSystem.grey.shade800),),
                      SizedBox(height: 8,),
                      Text("문제 번호를 누르면 해당 문제로 이동합니다.", style: FontSystem.KR12M.copyWith(color: ColorSystem.grey.shade400),),
                      SizedBox(height: 24,),
                      _buildexamList(entry),
                    ],
                  ),
                ),
              ),
            )
        ),
      ),
    );

    Navigator.of(context).overlay!.insert(entry);
  }

  Widget _buildexamList(OverlayEntry entry) {
    return Obx(() => Container(
        width: double.infinity,
        height: 320,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 한 줄에 5개
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: viewModel.questions.length, // 예: 총 문제 수
          itemBuilder: (context, index) {
            final correctAnswer = viewModel.correctAnswers[index];
            final userAnswer = viewModel.selectedOptions[index];

            final bool isCorrect = userAnswer != null && userAnswer == correctAnswer;

            // 색상 로직
            final bgColor = isCorrect
                ? ColorSystem.green
                : ColorSystem.red;

            return GestureDetector(
              onTap: () {
                viewModel.goToQuestion(index);
                entry.remove();
              },
              child: _buildExamNumber(index + 1, bgColor, ColorSystem.white),
            );
          },
        )
    ),);
  }

  Widget _buildExamNumber(int number, Color color, Color textColor) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: textColor),
      ),
      child: Center(child: Text(number.toString(), style: FontSystem.KR24B.copyWith(color: textColor, height: 1.3, ),)),
    );
  }
}