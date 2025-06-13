import 'package:flutter/material.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/utility/system/color_system.dart';

class TermsPage extends StatelessWidget {
  final VoidCallback onAgree;

  const TermsPage({
    super.key,
    required this.onAgree,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      appBar: AppBar(
        title: const Text("이용약관 상세"),
        backgroundColor: ColorSystem.white,
      ),
      body: Column(
        children: [
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Text(
                """약관 내용
                """,
              ),
            ),
          ),
          // 맨 아래 "동의하기" 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: RoundedRectangleTextButton(
                padding: const EdgeInsets.symmetric(vertical: 4),
                height: 48,
                text: "동의하기",
                backgroundColor: ColorSystem.blue,
                textStyle: TextStyle(
                  color: ColorSystem.white,
                  fontSize: 16,
                ),
                onPressed: onAgree,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
