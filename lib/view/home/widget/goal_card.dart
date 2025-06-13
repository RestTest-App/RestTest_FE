import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: FontSystem.KR18B,
                    children: [
                      TextSpan(
                        text: '쉬엄시험해',
                        style:
                            FontSystem.KR18B.copyWith(color: ColorSystem.blue),
                      ),
                      TextSpan(
                        text: '님의 목표',
                        style: FontSystem.KR18B
                            .copyWith(color: ColorSystem.grey[800]),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(Icons.arrow_forward_ios,
                    size: 16, color: ColorSystem.grey[400]),
                onPressed: () {
                  Navigator.pushNamed(context, '/mypage');
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildGoalRow('목표1', '일주일에 모의고사 4회 풀기', 0.6, context),
          const SizedBox(height: 24),
          _buildGoalRow('목표2', '일주일에 100문제 풀기', 0.9, context),
        ],
      ),
    );
  }

  Widget _buildGoalRow(
      String label, String goalText, double progress, BuildContext context) {
    final double barWidth = MediaQuery.of(context).size.width - 32;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorSystem.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: FontSystem.KR10SB.copyWith(color: ColorSystem.grey[600]),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                goalText,
                style: FontSystem.KR12SB.copyWith(color: ColorSystem.grey[800]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: barWidth,
          height: 22,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorSystem.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorSystem.blue.withAlpha(128),
                        ColorSystem.blue.withAlpha(255),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: barWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0%',
                  style:
                      FontSystem.KR10M.copyWith(color: ColorSystem.grey[400])),
              Text('100%',
                  style:
                      FontSystem.KR10M.copyWith(color: ColorSystem.grey[400])),
            ],
          ),
        ),
      ],
    );
  }
}
