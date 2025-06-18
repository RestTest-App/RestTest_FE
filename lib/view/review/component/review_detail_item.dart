import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';
import 'package:rest_test/model/review/ReviewDetailModel.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

class ReviewDetailItem extends BaseWidget<ReviewViewModel> {
  const ReviewDetailItem({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        // questions가 비어있을 때 안내 메시지 표시
        if (viewModel.questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 64,
                  color: ColorSystem.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  '복습할 문제가 없습니다',
                  style: FontSystem.KR18B.copyWith(
                    color: ColorSystem.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '다른 복습노트를 선택해주세요',
                  style: FontSystem.KR14M.copyWith(
                    color: ColorSystem.grey.shade500,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorSystem.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      '복습노트 목록으로',
                      style: FontSystem.KR14SB.copyWith(
                        color: ColorSystem.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // 질문 헤더 부분
            _buildQuestionHeader(),
            // 질문 본문 부분 - Expanded로 감싸서 오버플로우 방지
            Expanded(
              child: SingleChildScrollView(
                child: _buildQuestionBody(),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildQuestionHeader() {
    return Obx(() {
      final q = viewModel.currentQuestion;
      final currentIndex = viewModel.currentIndex; // 명시적으로 관찰 변수 참조

      if (q == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${currentIndex + 1}. ", style: FontSystem.KR22B),
            Expanded(child: Text(q.description, style: FontSystem.KR22B)),
          ],
        ),
      );
    });
  }

  Widget _buildQuestionBody() {
    return Obx(() {
      final q = viewModel.currentQuestion;
      if (q == null) return const SizedBox.shrink();

      return Column(
        children: [
          // 설명 이미지가 있는 경우
          if (q.descriptionImage?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Image.asset(
                q.descriptionImage!,
                width: double.infinity,
                // fit: BoxFit.contain, // 이미지 크기 조절
                // errorBuilder: (context, error, stackTrace) {
                //   return Container(
                //     height: 200,
                //     width: double.infinity,
                //     color: ColorSystem.grey.shade100,
                //     child: Icon(
                //       CupertinoIcons.photo,
                //       size: 50,
                //       color: ColorSystem.grey.shade400,
                //     ),
                //   );
                // },
              ),
            ),
          // 옵션들
          ...q.options.asMap().entries.map((entry) {
            final index = entry.key;
            return _buildOptionTile(index, q);
          }),
          // 하단 여백 추가 (버튼과 겹치지 않도록)
          const SizedBox(height: 100),
        ],
      );
    });
  }

  Widget _buildOptionTile(int index, QuestionInfomation q) {
    // 안전한 배열 접근
    if (index >= q.options.length) return const SizedBox.shrink();

    final option = q.options[index];
    final isCorrect = (index + 1) == q.answer;
    final isSelected = q.selectedAnswer == (index + 1);
    final explanationText = (q.optionExplanations.length > index)
        ? (q.optionExplanations[index])
        : '';

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isSelected && isCorrect) {
      bgColor = ColorSystem.lightGreen;
      borderColor = ColorSystem.green;
      textColor = ColorSystem.deepBlue;
    } else if (isSelected && !isCorrect) {
      bgColor = ColorSystem.lightRed;
      borderColor = ColorSystem.red;
      textColor = ColorSystem.red;
    } else if (isCorrect) {
      bgColor = ColorSystem.lightGreen;
      borderColor = ColorSystem.green;
      textColor = ColorSystem.deepBlue;
    } else {
      bgColor = ColorSystem.white;
      borderColor = ColorSystem.grey.shade300;
      textColor = ColorSystem.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style:
                      FontSystem.KR14B.copyWith(color: textColor, height: 1.5),
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                isSelected && isCorrect || isCorrect
                    ? "assets/icons/test/radioBtnSelectedGreen.svg"
                    : isSelected
                        ? "assets/icons/test/radioBtnSelectedRed.svg"
                        : "assets/icons/test/radioBtn.svg",
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                    ),
                  );
                },
              ),
            ],
          ),
          // 해설이 있는 경우
          if (explanationText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.only(top: 12),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                    decoration: BoxDecoration(
                      color: ColorSystem.lightBrown,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text("해설",
                        style: FontSystem.KR12SB
                            .copyWith(color: ColorSystem.brown, height: 1.2)),
                  ),
                  Expanded(
                    child: Text(
                      explanationText,
                      style: FontSystem.KR12M.copyWith(
                        color: isCorrect
                            ? ColorSystem.deepBlue
                            : ColorSystem.grey.shade600,
                        height: 1.5,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
