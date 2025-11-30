import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

// 2. 이미지 여부 페이지
class HasImageStep extends StatelessWidget {
  final bool? hasImage;
  final VoidCallback onTapYes;
  final VoidCallback onTapNo;

  const HasImageStep({
    super.key,
    required this.hasImage,
    required this.onTapYes,
    required this.onTapNo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          '문제에 이미지가 있나요?',
          style: FontSystem.KR22B,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildOption(
                text: '네',
                isYes: true,
                selected: hasImage == true,
                onTap: onTapYes,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildOption(
                text: '아니요',
                isYes: false,
                selected: hasImage == false,
                onTap: onTapNo,
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
      if (isYes) {
        backgroundColor = ColorSystem.lightRed;
        borderColor = ColorSystem.red;
        textColor = ColorSystem.red;
      } else {
        backgroundColor = ColorSystem.selectedBlue;
        borderColor = ColorSystem.blue;
        textColor = ColorSystem.blue;
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
      text: text,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      borderSide: BorderSide(color: borderColor, width: 1),
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}
