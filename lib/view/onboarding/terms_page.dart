import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  final VoidCallback onAgree;

  const TermsPage({
    super.key,
    required this.onAgree,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("이용약관 상세"),
        backgroundColor: const Color(0xFFFFFFFF),
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
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onAgree,
                child: const Text("동의하기"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
