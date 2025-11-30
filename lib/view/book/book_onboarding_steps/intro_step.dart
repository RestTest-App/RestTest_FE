import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

// 1. 사전 질문 페이지
class IntroStep extends StatelessWidget {
  const IntroStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(-8, 0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '나의 문제집을 만들기 전,\n',
                    style: FontSystem.KR24B.copyWith(height: 1.5),
                  ),
                  TextSpan(
                    text: '쉬엄시험',
                    style: FontSystem.KR24B.copyWith(
                      color: ColorSystem.blue,
                      height: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: '에 몇 가지\n물어보고 싶은게 있어요!',
                    style: FontSystem.KR24B.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '문제집을 더 정확하게 만들기 위한 과정이에요',
              textAlign: TextAlign.left,
              style: FontSystem.KR16M.copyWith(
                color: ColorSystem.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 250),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/subscribe_logo.png',
                width: 200,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
