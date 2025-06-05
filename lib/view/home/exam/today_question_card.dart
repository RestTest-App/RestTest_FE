import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

class TodayQuestion extends StatelessWidget {
  const TodayQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorSystem.blue[400]!,
            ColorSystem.blue[500]!,
          ],
        ),
  borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('오늘의 문제', style: FontSystem.KR18B),
                SizedBox(height: 4),
                Text('AI가 만든 오늘의 문제 풀러가기', style: FontSystem.KR14R),
              ],
            ),
          ),
          Icon(Icons.settings_suggest, size: 36, color: ColorSystem.blue),
        ],
      ),
    );
  }
}
