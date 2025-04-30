import 'package:flutter/cupertino.dart';

import '../../utility/system/font_system.dart';

class CustomTag extends StatelessWidget{
  const CustomTag ({
      super.key,
      required this.text,
      required this.color,
      required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        height: 20,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text, style: FontSystem.KR12SB.copyWith(height: 1.3, color: textColor),
        ),
      );
  }
}