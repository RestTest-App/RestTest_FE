import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/model/home/exam_model.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
    this.onTap,
  });

  final Exam exam;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(minHeight: 100),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: ColorSystem.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorSystem.grey[200]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exam.examName,
                    style: FontSystem.KR18B,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _infoBadge(
                          text: '${exam.questionCount}문항',
                          color: ColorSystem.lightBlue,
                          textColor: ColorSystem.blue),
                      _infoBadge(
                          text: '${exam.examTime}분',
                          color: ColorSystem.lightBlue,
                          textColor: ColorSystem.blue),
              _infoBadge(
                  text: '${exam.passRate.toStringAsFixed(2)}%',
                  color: exam.passRate >= 80.0
                      ? ColorSystem.lightBlue
                      : exam.passRate >= 60.0
                      ? ColorSystem.lightGreen
                      : ColorSystem.lightRed,
                  textColor: exam.passRate >= 80.0
                      ? ColorSystem.blue
                      : exam.passRate >= 60.0
                      ? ColorSystem.green
                      : ColorSystem.red),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ColorSystem.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: ColorSystem.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBadge({
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: FontSystem.KR12SB.copyWith(
          color: textColor,
        ),
      ),
    );
  }
}
