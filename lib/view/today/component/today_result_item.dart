import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/viewmodel/today/today_test_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import '../../../utility/system/color_system.dart';
import '../../../utility/system/font_system.dart';

class TodayResultItem extends BaseWidget<TodayTestViewModel> {
  const TodayResultItem({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // 문제
          Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child:
                  Text(viewModel.currentQuestion.description, style: FontSystem.KR22B.copyWith(height: 1.3),),
              ),
          // 스크롤뷰 (사진 + 보기)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children : [
                  // 보기 (옵션 리스트)
                  ...viewModel.currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final correctAnswer = viewModel.correctAnswers[viewModel.currentIndex]; // 1~4
                    final userAnswer = viewModel.selectedOption;
                    final optionExplanations = viewModel.currentQuestion.optionExplanations;
                    final explanationText = optionExplanations[index];

                    final isCorrect = (index + 1) == correctAnswer;
                    final isSelected = userAnswer == index;

                    // 색상 로직
                    Color bgColor;
                    Color borderColor;
                    Color textColor;

                    if (isSelected && isCorrect) {
                      // 정답이고 선택한 보기
                      bgColor = ColorSystem.lightGreen;
                      borderColor = ColorSystem.green;
                      textColor = ColorSystem.deepBlue;
                    } else if (isSelected && !isCorrect) {
                      // 틀린 보기
                      bgColor = ColorSystem.lightRed;
                      borderColor = ColorSystem.red;
                      textColor = ColorSystem.red;
                    } else if (isCorrect) {
                      // 정답이지만 사용자가 고르진 않음
                      bgColor = ColorSystem.lightGreen;
                      borderColor = ColorSystem.green;
                      textColor = ColorSystem.deepBlue;
                    } else {
                      bgColor = ColorSystem.white;
                      borderColor = ColorSystem.grey.shade300;
                      textColor = ColorSystem.grey.shade800;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 280,
                                child: Text(
                                  option,
                                  style: FontSystem.KR14B.copyWith(
                                    color: textColor,
                                    height: 1.5,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              SvgPicture.asset(
                                    () {
                                  if ((isSelected && isCorrect) || isCorrect) {
                                    return "assets/icons/test/radioBtnSelectedGreen.svg";
                                  } else if (isSelected && !isCorrect) {
                                    return "assets/icons/test/radioBtnSelectedRed.svg";
                                  } else {
                                    return "assets/icons/test/radioBtn.svg";
                                  }
                                }(),),
                            ],
                          ),
                          if (explanationText != null && explanationText.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: ColorSystem.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 1, color: ColorSystem.grey.shade400),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding:const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: ColorSystem.lightBrown,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text("해설",style: FontSystem.KR12SB.copyWith(color: ColorSystem.brown, height: 1.2),),
                                  ),
                                  SizedBox(
                                    width:240,
                                    child: Text(
                                      explanationText,
                                      style: FontSystem.KR12M.copyWith(color: isCorrect ? ColorSystem.deepBlue : ColorSystem.grey.shade600, height: 1.5),
                                      softWrap: true,
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}