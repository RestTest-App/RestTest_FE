import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class QuestionCard extends StatefulWidget {
  final Map<String, dynamic> question;
  final int index;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  // 0: 초기 상태, 1: 정답 확인, 2: 해설 보기
  final RxInt step = 0.obs;
  // 선택한 답 (0-based index, -1이면 미선택)
  final RxInt selectedAnswer = (-1).obs;

  @override
  Widget build(BuildContext context) {
    final description = widget.question['description'] ?? '문제 없음';
    final options = (widget.question['options'] as List?) ?? [];
    final answer = widget.question['answer'] ?? 0;
    final explanation = widget.question['explanation'] ?? '';

    return Obx(() => Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: ColorSystem.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문제 ${widget.index + 1}',
                      style: FontSystem.KR16B.copyWith(
                        color: ColorSystem.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: FontSystem.KR16M.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (options.isNotEmpty)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final isSelected = selectedAnswer.value == index &&
                            selectedAnswer.value != -1;
                        final isCorrect = (index + 1) == answer;
                        final showAnswer = step.value >= 1;

                        Color bgColor;
                        Color borderColor;
                        Color textColor;
                        String radioIcon;

                        if (showAnswer) {
                          if (isSelected && isCorrect) {
                            // 정답이고 선택한 보기
                            bgColor = ColorSystem.lightGreen;
                            borderColor = ColorSystem.green;
                            textColor = ColorSystem.deepBlue;
                            radioIcon =
                                "assets/icons/test/radioBtnSelectedGreen.svg";
                          } else if (isSelected && !isCorrect) {
                            // 틀린 보기
                            bgColor = ColorSystem.lightRed;
                            borderColor = ColorSystem.red;
                            textColor = ColorSystem.red;
                            radioIcon =
                                "assets/icons/test/radioBtnSelectedRed.svg";
                          } else if (isCorrect) {
                            // 정답이지만 사용자가 고르지 않음
                            bgColor = ColorSystem.lightGreen;
                            borderColor = ColorSystem.green;
                            textColor = ColorSystem.deepBlue;
                            radioIcon =
                                "assets/icons/test/radioBtnSelectedGreen.svg";
                          } else {
                            bgColor = ColorSystem.white;
                            borderColor = ColorSystem.grey.shade300;
                            textColor = ColorSystem.grey.shade800;
                            radioIcon = "assets/icons/test/radioBtn.svg";
                          }
                        } else {
                          // 초기 상태
                          if (isSelected) {
                            bgColor = ColorSystem.selectedBlue;
                            borderColor = ColorSystem.blue;
                            textColor = ColorSystem.deepBlue;
                            radioIcon =
                                "assets/icons/test/radioBtnSelected.svg";
                          } else {
                            bgColor = ColorSystem.white;
                            borderColor = ColorSystem.grey.shade300;
                            textColor = ColorSystem.grey.shade800;
                            radioIcon = "assets/icons/test/radioBtn.svg";
                          }
                        }

                        return GestureDetector(
                          onTap: step.value == 0
                              ? () {
                                  selectedAnswer.value = index;
                                }
                              : null, // 정답 확인 후에는 선택 불가
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: borderColor),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    option,
                                    style: FontSystem.KR14B.copyWith(
                                      color: textColor,
                                      height: 1.5,
                                    ),
                                    softWrap: true,
                                  ),
                                ),
                                SvgPicture.asset(radioIcon),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              // 해설 영역
              if (step.value == 2 && explanation.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorSystem.back,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorSystem.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      explanation,
                      style: FontSystem.KR14M.copyWith(
                        color: ColorSystem.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              // 하단 버튼
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RoundedRectangleTextButton(
                    text: step.value == 0
                        ? '정답 확인'
                        : step.value == 1
                            ? '해설 보기'
                            : '다시 풀기',
                    textStyle: FontSystem.KR16B.copyWith(
                      color: ColorSystem.white,
                    ),
                    backgroundColor: ColorSystem.blue,
                    onPressed: () {
                      if (step.value == 0) {
                        // 정답 확인
                        if (selectedAnswer.value != -1) {
                          step.value = 1;
                        }
                      } else if (step.value == 1) {
                        // 해설 보기
                        step.value = 2;
                      } else {
                        // 다시 풀기
                        step.value = 0;
                        selectedAnswer.value = -1;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
