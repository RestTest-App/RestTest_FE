import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

// 3. 문제 유형 선택 페이지
enum QuestionType { multipleChoice, shortAnswer, essay }

class QuestionTypeStep extends StatelessWidget {
  final QuestionType? selectedType;
  final ValueChanged<QuestionType> onSelectType;

  const QuestionTypeStep({
    super.key,
    required this.selectedType,
    required this.onSelectType,
  });

  bool get _isBlocked =>
      selectedType != null && selectedType != QuestionType.multipleChoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          '문제 유형을 알려주세요',
          style: FontSystem.KR22B.copyWith(height: 1.5),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildOption(
                  label: '객관식',
                  questionType: QuestionType.multipleChoice,
                  selected: selectedType == QuestionType.multipleChoice,
                  onTap: () => onSelectType(QuestionType.multipleChoice),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildOption(
                  label: '단답형',
                  questionType: QuestionType.shortAnswer,
                  selected: selectedType == QuestionType.shortAnswer,
                  onTap: () => onSelectType(QuestionType.shortAnswer),
                ),
              ),
            ),
            Expanded(
              child: _buildOption(
                label: '서술형',
                questionType: QuestionType.essay,
                selected: selectedType == QuestionType.essay,
                onTap: () => onSelectType(QuestionType.essay),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isBlocked)
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/test/reportIcon.svg',
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '현재 개발 중이에요!',
                style: FontSystem.KR14M.copyWith(color: ColorSystem.red),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildOption({
    required String label,
    required QuestionType questionType,
    required bool selected,
    required VoidCallback onTap,
  }) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    TextStyle textStyle;

    if (selected) {
      if (questionType == QuestionType.multipleChoice) {
        backgroundColor = ColorSystem.selectedBlue;
        borderColor = ColorSystem.blue;
        textColor = ColorSystem.blue;
      } else {
        backgroundColor = ColorSystem.lightRed;
        borderColor = ColorSystem.red;
        textColor = ColorSystem.red;
      }
      textStyle = FontSystem.KR16M.copyWith(color: textColor);
    } else {
      backgroundColor = ColorSystem.back;
      borderColor = ColorSystem.grey[300]!;
      textColor = ColorSystem.grey[600]!;
      textStyle = FontSystem.KR16M.copyWith(color: textColor);
    }

    return RoundedRectangleTextButton(
      height: 60,
      text: label,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      borderSide: BorderSide(color: borderColor, width: 1),
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
