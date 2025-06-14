import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/onboarding/onboarding_steps/certificate_step.dart';
import 'package:rest_test/view/onboarding/onboarding_steps/nickname_step.dart';
import 'package:rest_test/view/onboarding/onboarding_steps/terms_step.dart';
import 'package:rest_test/view/onboarding/onboarding_steps/user_info_step.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class OnboardingScreen extends BaseScreen<OnboardingViewModel> {
  OnboardingScreen({super.key});

  final List<Widget> steps = [
    NicknameStep(),
    UserInfoStep(),
    CertificateStep(),
    TermsStep(),
  ];

  @override
  final OnboardingViewModel viewModel = Get.put(OnboardingViewModel());

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.back;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      appBar: AppBar(
        backgroundColor: ColorSystem.white,
        toolbarHeight: 58,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushNamed(context, '/splash');
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: ColorSystem.grey[200],
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor:
                          (viewModel.currentStep.value + 1) / steps.length,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: ColorSystem.blue,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ),
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: PageView(
                  controller: viewModel.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    NicknameStep(),
                    UserInfoStep(),
                    CertificateStep(),
                    TermsStep(),
                  ],
                ),
              ),
            ),
            buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButtons() {
    return Obx(
      () {
        final currentStep = viewModel.currentStep.value;
        final isLastStep = currentStep == viewModel.maxStep;
        final isValid = _isCurrentStepValid(currentStep);

        List<Widget> buttons = [];

        if (currentStep > 0) {
          buttons.add(
            Expanded(
              child: RoundedRectangleTextButton(
                text: '이전',
                textStyle: FontSystem.KR16SB.copyWith(
                  color: ColorSystem.grey[400],
                ),
                backgroundColor: ColorSystem.grey[200],
                onPressed: viewModel.previousStep,
              ),
            ),
          );
          buttons.add(
            const SizedBox(
              width: 12,
            ),
          );
        }

        buttons.add(
          Expanded(
            child: RoundedRectangleTextButton(
              text: isLastStep ? '제출' : '다음',
              textStyle: FontSystem.KR16SB.copyWith(
                color: isValid ? ColorSystem.white : ColorSystem.grey[400],
              ),
              backgroundColor:
                  isValid ? ColorSystem.blue : ColorSystem.grey[200],
              onPressed: isValid
                  ? (isLastStep ? viewModel.submit : viewModel.nextStep)
                  : null,
            ),
          ),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: buttons,
          ),
        );
      },
    );
  }

  bool _isCurrentStepValid(int step) {
    if (step == 0) return viewModel.isNickNameValid;
    if (step == 1) return viewModel.isUserInfoValid;
    if (step == 3) return viewModel.agreeToTerms.value;
    return true;
  }

  @override
  Widget buildBody(BuildContext context) {
    // todo
    throw UnimplementedError();
  }
}
