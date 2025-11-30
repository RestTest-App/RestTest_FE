import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import '../../../utility/system/color_system.dart';
import '../../../utility/system/font_system.dart';

class ExamItem extends BaseWidget<TestViewModel> {
  const ExamItem({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // 1. 문제 설명
              Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      viewModel.currentQuestion.description,
                      style: FontSystem.KR22B.copyWith(height: 1.3),
                    ),
                  )),

              // 2. 스크롤 영역
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // 이미지 표시
                      if (viewModel.currentQuestion.descriptionImage != null &&
                          viewModel
                              .currentQuestion.descriptionImage!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Image.asset(
                            viewModel.currentQuestion.descriptionImage!,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),

                      // 3. 보기 리스트
                      ...viewModel.currentQuestion.options.entries.map((entry) {
                        final int optionId = int.parse(entry.key);
                        final String optionText = entry.value;

                        // 선택 여부 확인
                        final bool isSelected =
                            viewModel.selectedOption == optionId;

                        // 배경 및 테두리 색상 설정
                        Color bgColor;
                        Color borderColor;
                        Color textColor;

                        if (isSelected) {
                          bgColor = ColorSystem.lightBlue; // 선택됨: 연한 파랑 배경
                          borderColor = ColorSystem.blue; // 선택됨: 진한 파랑 테두리
                          textColor = ColorSystem.blue;
                        } else {
                          bgColor = ColorSystem.white; // 미선택: 흰 배경
                          borderColor = ColorSystem.grey.shade300;
                          textColor = ColorSystem.grey.shade800;
                        }

                        return GestureDetector(
                          onTap: () {
                            viewModel.selectOption(optionId);
                          },
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
                                // 보기 텍스트
                                Expanded(
                                  child: Text(
                                    optionText,
                                    style: FontSystem.KR14B.copyWith(
                                      color: textColor,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                // [수정된 부분] 라디오 버튼 직접 그리기 (점 생성 로직)
                                _buildRadioButton(isSelected),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // 라디오 버튼 UI를 그리는 함수
  Widget _buildRadioButton(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(4), // 테두리와 내부 점 사이의 간격
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // 내부 배경은 항상 흰색
        border: Border.all(
          // 선택되면 파란색, 아니면 회색 테두리
          color: isSelected ? ColorSystem.blue : ColorSystem.grey.shade300,
          width: 2,
        ),
      ),
      child: isSelected
          ? Container(
              // 선택되었을 때만 내부에 파란 점이 생김
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorSystem.blue, // 점 색상
              ),
            )
          : null, // 선택 안 되면 내부 비움
    );
  }
}
