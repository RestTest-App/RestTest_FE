import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/auth/auth_view_model.dart';

class OnboardingViewModel extends GetxController {
  final PageController pageController = PageController();
  late final AuthViewModel _authViewModel;

  var currentStep = 0.obs;
  var nickName = ''.obs;
  var gender = ''.obs;
  var birth = ''.obs;
  var job = ''.obs;
  var certificates = <int>[].obs;
  var agreeToTerms = false.obs;
  var nickNameError = ''.obs;

  int get maxStep => 3;

  @override
  void onInit() {
    super.onInit();
    _authViewModel = Get.find<AuthViewModel>();
  }

  final certificateOptions = [
    {"id": 1, "name": "정보처리기사"},
    {"id": 2, "name": "컴퓨터활용능력1급"},
    {"id": 3, "name": "한국사능력검정시험"},
    {"id": 4, "name": "정보보안기사"},
    {"id": 5, "name": "산업안전기사"}
  ];

  void nextStep() {
    if (currentStep.value < maxStep) {
      currentStep.value++;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.animateToPage(
        currentStep.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void submit() {
    print(">>> Onboarding arguments: ${Get.arguments}");
    final arguments = Get.arguments as Map<String, dynamic>;
    final kakaoToken = arguments['kakaoToken'] as String? ??
        arguments['kakao_token'] as String?;
    final email = arguments['email'] as String?;
    print("email은 이거닷!!! $email");

    if (kakaoToken == null || email == null) {
      Get.snackbar('오류', '카카오 토큰 또는 이메일이 없습니다.');
      return;
    }

    _authViewModel.submitSignUp(
      kakaoToken: kakaoToken,
      email: email,
      nickname: nickName.value,
      gender: gender.value,
      birthday: birth.value,
      job: job.value,
      certificates: certificates.toList(),
      agreeToTerms: agreeToTerms.value,
    );
  }

  void validateNickname(String value) {
    nickName.value = value.trim();

    // 특수문자 포함 검사
    final regex = RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]+$');
    if (!regex.hasMatch(nickName.value)) {
      nickNameError.value = '특수문자를 사용할 수 없습니다.';
      return;
    }

    // 최소 문자 수 검사
    if (nickName.value.runes.length < 2) {
      nickNameError.value = '닉네임은 두 글자 이상이어야 해요.';
      return;
    }

    nickNameError.value = '';
  }

  bool get isNickNameValid =>
      nickName.value.isNotEmpty && nickNameError.value.isEmpty;

  bool get isUserInfoValid =>
      gender.value.isNotEmpty &&
      birth.value.isNotEmpty &&
      job.value.trim().isNotEmpty;
}
