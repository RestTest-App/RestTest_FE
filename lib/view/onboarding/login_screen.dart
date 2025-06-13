import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/auth/auth_view_model.dart';

class LoginScreen extends BaseScreen<AuthViewModel> {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 100,
              ),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: GestureDetector(
                  onTap: () async {
                    bool ok = await viewModel.loginWithKakao();
                    if (!ok) {
                      Get.snackbar("로그인 실패", "카카오 로그인에 실패했습니다.\n다시 시도해주세요.",
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  child: Image.asset(
                    'assets/images/kakao_login_button.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    throw UnimplementedError();
  }
}
