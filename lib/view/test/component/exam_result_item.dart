import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import '../../../utility/system/color_system.dart';
import '../../../utility/system/font_system.dart';

class ExamResultItem extends BaseWidget<TestViewModel> {
  const ExamResultItem({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 문제
              Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.currentQuestion.description,
                        style: FontSystem.KR22B.copyWith(height: 1.3),
                      ),
                      _buildStarAndReport(context),
                    ],
                  )),
              // 스크롤뷰 (사진 + 보기)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (viewModel.currentQuestion.descriptionImage != null &&
                          viewModel
                              .currentQuestion.descriptionImage!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.asset(
                            viewModel.currentQuestion.descriptionImage!,
                            width: double.infinity,
                          ),
                        ),
                      // 보기 (옵션 리스트)
                      ...viewModel.currentQuestion.options.entries.map((entry) {
                        // final index = entry.key;
                        // final option = entry.value;
                        // final correctAnswer = viewModel
                        //     .correctAnswers[viewModel.currentIndex]; // 1~4
                        // final userAnswer = viewModel.selectedOption;
                        // final explanation = viewModel
                        //     .answerExplanations[viewModel.currentIndex];
                        // final optionExplanations =
                        //     explanation.optionExplanations.options;
                        //
                        // final explanationText =
                        //     optionExplanations["no${index + 1}"];
                        // final isCorrect = (index + 1) == correctAnswer;
                        // final isSelected = userAnswer == index;

                        final int optionId =
                            int.parse(entry.key); // Key를 숫자로 변환
                        final option = entry.value;
                        final correctAnswer =
                            viewModel.correctAnswers[viewModel.currentIndex];
                        final userAnswer = viewModel.selectedOption; // 현재 선택된 답

                        // 해설 데이터
                        final explanation = viewModel
                            .answerExplanations[viewModel.currentIndex];
                        final optionExplanations =
                            explanation.optionExplanations.options;
                        final explanationText =
                            optionExplanations["no${optionId}"];

                        // 정답 및 선택 여부 확인
                        final isCorrect = optionId == correctAnswer;
                        final isSelected = userAnswer == optionId;

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
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 1, color: borderColor),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      if ((isSelected && isCorrect) ||
                                          isCorrect) {
                                        return "assets/icons/test/radioBtnSelectedGreen.svg";
                                      } else if (isSelected && !isCorrect) {
                                        return "assets/icons/test/radioBtnSelectedRed.svg";
                                      } else {
                                        return "assets/icons/test/radioBtn.svg";
                                      }
                                    }(),
                                  ),
                                ],
                              ),
                              if (explanationText != null &&
                                  explanationText.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: ColorSystem.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 1,
                                        color: ColorSystem.grey.shade400),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 6),
                                        decoration: BoxDecoration(
                                          color: ColorSystem.lightBrown,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        child: Text(
                                          "해설",
                                          style: FontSystem.KR12SB.copyWith(
                                              color: ColorSystem.brown,
                                              height: 1.2),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 240,
                                        child: Text(
                                          explanationText,
                                          style: FontSystem.KR12M.copyWith(
                                              color: isCorrect
                                                  ? ColorSystem.deepBlue
                                                  : ColorSystem.grey.shade600,
                                              height: 1.5),
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
        ));
  }

  // 복습노트 저장 및 신고
  Widget _buildStarAndReport(BuildContext context) {
    final currentIndex = viewModel.currentIndex;

    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              viewModel.toggleStarForQuestion(currentIndex);
            },
            child: Obx(() => SvgPicture.asset(
                  viewModel.isStarred(currentIndex)
                      ? "assets/icons/test/starIconSelected.svg"
                      : "assets/icons/test/starIcon.svg",
                )),
          ),
          SizedBox(
            width: 4,
          ),
          GestureDetector(
              onTap: () {
                _showReportBottomSheet(context);
              },
              child: SvgPicture.asset("assets/icons/test/reportIcon.svg")),
        ],
      ),
    );
  }

  void _showReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: ColorSystem.white,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: ColorSystem.grey.shade200,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Row 크기를 내용에 맞게
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/bottom_navigation/mypage.svg",
                        colorFilter:
                            ColorFilter.mode(ColorSystem.blue, BlendMode.srcIn),
                        width: 44,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "불편을 드려서 죄송합니다.",
                            style: FontSystem.KR10M
                                .copyWith(color: ColorSystem.grey.shade600),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "어떤 내용이 문제인가요?",
                            style: FontSystem.KR20B,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildReportOption("잘못된 정보를 알려주고 있어요."),
                _buildReportOption("설명이 너무 모호해요."),
                _buildReportOption("설명이 너무 어려워요."),
                Obx(() {
                  final isSelected =
                      viewModel.selectedReportOption.value == "기타";
                  return Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorSystem.lightBlue
                          : ColorSystem.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? ColorSystem.blue
                            : ColorSystem.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: TextField(
                        onChanged: viewModel.onEtcTextChanged,
                        decoration: InputDecoration(
                          hintText: "기타 : ",
                          hintStyle: FontSystem.KR16SB
                              .copyWith(color: ColorSystem.grey.shade600),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          border: InputBorder.none,
                        ),
                        style: FontSystem.KR16SB.copyWith(
                          color: ColorSystem.blue,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangleTextButton(
                          text: "돌아가기",
                          width: double.infinity,
                          height: 60,
                          backgroundColor: ColorSystem.grey.shade200,
                          textStyle: FontSystem.KR16B.copyWith(
                            color: ColorSystem.grey.shade400,
                          ),
                          onPressed: () {
                            viewModel.resetReportOption();
                            Get.back();
                          }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Obx(() {
                      final isDisabled =
                          viewModel.selectedReportOption.value.isEmpty &&
                              viewModel.etcText.value.trim().isEmpty;

                      return RoundedRectangleTextButton(
                        text: "문의하기",
                        width: double.infinity,
                        height: 60,
                        backgroundColor: ColorSystem.blue,
                        textStyle: FontSystem.KR16B.copyWith(
                          color: ColorSystem.white,
                        ),
                        onPressed: isDisabled
                            ? null
                            : () async {
                                final questionId = viewModel.currentIndex;

                                await viewModel.sendReport(1, questionId);

                                Get.back();
                                // 바텀시트가 닫힌 뒤 다음 프레임에서 모달 띄우기
                                Future.microtask(() {
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    if (context.mounted) {
                                      _showConfirmBottomSheet(context);
                                    }
                                  });
                                });
                              },
                      );
                    })),
                  ],
                )
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // 바텀시트가 닫히면 호출됨 (뒤로가기, 바깥 터치, Get.back 등 모든 경우)
      viewModel.resetReportOption();
    });
  }

  Widget _buildReportOption(String text) {
    return Obx(() {
      final isSelected = viewModel.selectedReportOption.value == text;
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: double.infinity,
        child: RoundedRectangleTextButton(
          text: text,
          backgroundColor:
              isSelected ? ColorSystem.lightBlue : ColorSystem.white,
          textStyle: FontSystem.KR16SB.copyWith(
            color: isSelected ? ColorSystem.blue : ColorSystem.grey.shade600,
          ),
          borderSide: BorderSide(
            color: isSelected ? ColorSystem.blue : ColorSystem.grey.shade300,
            width: 1,
          ),
          onPressed: () {
            viewModel.selectedReportOption.value = text;
          },
        ),
      );
    });
  }

  void _showConfirmBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: ColorSystem.white,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 34),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ColorSystem.grey.shade200,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 40, bottom: 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/bottom_navigation/mypage.svg",
                            colorFilter: ColorFilter.mode(
                                ColorSystem.blue, BlendMode.srcIn),
                            width: 66,
                          ),
                          SizedBox(height: 36),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "문의 완료",
                                style: FontSystem.KR24EB,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "문의해주셔서 감사합니다.\n빠른 시일 내로 반영되도록 노력하겠습니다.",
                                style: FontSystem.KR16M
                                    .copyWith(color: ColorSystem.grey.shade600),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: RoundedRectangleTextButton(
                      text: "확인",
                      width: double.infinity,
                      height: 60,
                      backgroundColor: ColorSystem.blue,
                      textStyle: FontSystem.KR16B.copyWith(
                        color: ColorSystem.white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              )),
        );
      },
    ).then((_) {
      // 바텀시트가 닫히면 호출됨 (뒤로가기, 바깥 터치, Get.back 등 모든 경우)
      viewModel.resetReportOption();
    });
  }
}
