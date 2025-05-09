import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';

class NicknameStep extends StatelessWidget {
  final controller = Get.find<OnboardingViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError = controller.nickNameError.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '안녕하세요!\n사용할 닉네임을 적어주세요.',
            style: TextStyle(
              fontFamily: 'AppleSDGothicNeo-Bold',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.5,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          const Text('닉네임'),
          const SizedBox(height: 8),
          TextField(
            onChanged: controller.validateNickname,
            style: TextStyle(
              color: hasError ? const Color(0xFFF05454) : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: '닉네임을 입력해주세요',
              filled: hasError,
              fillColor: hasError ? const Color(0xFFFFF0F0) : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError
                      ? const Color(0xFFF05454)
                      : const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError
                      ? const Color(0xFFF05454)
                      : const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (hasError)
            Text(
              controller.nickNameError.value,
              style: const TextStyle(
                color: Color(0xFFF05454),
                fontSize: 12,
              ),
            ),
        ],
      );
    });
  }
}
