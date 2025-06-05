import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(100), // 패딩 키워줌
      decoration: BoxDecoration(
        color: ColorSystem.white, // 배경 White
        borderRadius: BorderRadius.circular(16),
      ),
      child: const SizedBox(), // 내용 비워둠
    );
  }
}
