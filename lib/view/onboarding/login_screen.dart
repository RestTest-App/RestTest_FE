import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';

class LoginScreen extends BaseScreen<OnboardingViewModel> {
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
                  onTap: () {},
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
