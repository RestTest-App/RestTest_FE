import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/viewmodel/today/today_test_view_model.dart';

import '../../../utility/system/color_system.dart';
import '../../../utility/system/font_system.dart';
import '../../../widget/button/rounded_rectangle_text_button.dart';

class TodayExamCommentSelectDialog extends BaseWidget<TodayTestViewModel> {
  const TodayExamCommentSelectDialog({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Transform.translate(
        offset: Offset(0, 2),
        child: RoundedRectangleTextButton(
          text: "문제 선택",
          height : 48,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          backgroundColor: ColorSystem.blue,
          textStyle: FontSystem.KR16B.copyWith(color: ColorSystem.white, height: 1.2, ),
          onPressed: () {
            _showExamSelectDialog(context);
          },
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
                      Text("문제 전체 보기", style: FontSystem.KR24B.copyWith(color: ColorSystem.grey.shade800),),
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
          itemCount: viewModel.todayTestState!.questionCount, // 예: 총 문제 수
          itemBuilder: (context, index) {
            final correctAnswer = viewModel.correctAnswers[index];
            final userAnswer = viewModel.selectedOptions[index];
            final bool isCorrect = userAnswer != null && (userAnswer == correctAnswer);

            // 색상 로직
            final bgColor = isCorrect
                ? ColorSystem.green
                : ColorSystem.red;

            return GestureDetector(
              onTap: () {
                viewModel.goTo(index);
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