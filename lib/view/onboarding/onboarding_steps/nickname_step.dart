import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/utility/system/color_system.dart';

class NicknameStep extends StatelessWidget {
  final controller = Get.find<OnboardingViewModel>();

  NicknameStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError = controller.nickNameError.value.isNotEmpty;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '안녕하세요!\n사용할 닉네임을 적어주세요.',
            style: FontSystem.KR28B,
          ),
          const SizedBox(height: 24),
          const Text('닉네임'),
          const SizedBox(height: 8),
          TextField(
            onChanged: controller.validateNickname,
            style: FontSystem.KR16M.copyWith(
              color: hasError ? ColorSystem.red : ColorSystem.black,
            ),
            decoration: InputDecoration(
              hintText: '닉네임을 입력해주세요',
              filled: hasError,
              fillColor:
                  hasError ? const Color(0xFFFFF0F0) : null, // ColorSystem에 없음
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError
                      ? ColorSystem.red
                      : const Color(0xFFE0E0E0), // ColorSystem에 없음
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: hasError ? ColorSystem.red : ColorSystem.grey[400]!,
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          if (hasError)
            Text(
              controller.nickNameError.value,
              style: TextStyle(
                color: ColorSystem.red,
                fontSize: 12,
              ),
            ),
        ],
      );
    });
  }
}
