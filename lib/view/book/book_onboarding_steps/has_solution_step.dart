import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

// 4. 정답 여부 페이지
class HasSolutionStep extends StatelessWidget {
  final bool? hasSolution;
  final ValueChanged<bool> onSelect;

  const HasSolutionStep({
    super.key,
    required this.hasSolution,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          '문제의 정답이나 해설이 있나요?',
          style: FontSystem.KR22B.copyWith(height: 1.5),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildOption(
                text: '네',
                isYes: true,
                selected: hasSolution == true,
                onTap: () => onSelect(true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOption(
                text: '아니요',
                isYes: false,
                selected: hasSolution == false,
                onTap: () => onSelect(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOption({
    required String text,
    required bool isYes,
    required bool selected,
    required VoidCallback onTap,
  }) {
    Color backgroundColor;
    Color borderColor;
    Color textColor;
    TextStyle textStyle;

    if (selected) {
      backgroundColor = ColorSystem.selectedBlue;
      borderColor = ColorSystem.blue;
      textColor = ColorSystem.blue;
      textStyle = FontSystem.KR16M.copyWith(color: textColor);
    } else {
      // 클릭 전: back 배경, grey[300] border, grey[600] text
      backgroundColor = ColorSystem.back;
      borderColor = ColorSystem.grey[300]!;
      textColor = ColorSystem.grey[600]!;
      textStyle = FontSystem.KR16M.copyWith(color: textColor);
    }

    return RoundedRectangleTextButton(
      height: 60,
      text: text,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      borderSide: BorderSide(color: borderColor, width: 1),
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
