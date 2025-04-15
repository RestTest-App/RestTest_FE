import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/onboarding/terms_page.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class TermsStep extends StatelessWidget {
  final controller = Get.find<OnboardingViewModel>();

  TermsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isAgree = controller.agreeToTerms.value; // 현재 약관 동의 상태
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "쉬엄시험 서비스 이용약관에\n동의해주세요.",
            style: TextStyle(
              fontFamily: 'AppleSDGothicNeo-Bold',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              if (!isAgree) {
                // 약관 페이지로 이동
                Get.to(
                  () => TermsPage(
                    onAgree: () {
                      // 동의 -> 페이지 닫고 버튼 활성화
                      controller.agreeToTerms.value = true;
                      Get.back();
                    },
                  ),
                );
              } else {
                controller.agreeToTerms.value = false;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: isAgree ? const Color(0xFFEAF2FF) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isAgree
                      ? const Color(0xFF0B60B0)
                      : const Color(0xFFB5B5B5),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    isAgree ? Icons.check : Icons.check,
                    color: isAgree
                        ? const Color(0xFF0B60B0)
                        : const Color(0xFFB5B5B5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "서비스 이용약관 전체 동의",
                    style: TextStyle(
                      fontSize: 16,
                      color: isAgree
                          ? const Color(0xFF0B60B0)
                          : const Color(0xFFB5B5B5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
