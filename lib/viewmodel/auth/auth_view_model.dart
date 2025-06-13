import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:rest_test/provider/auth/auth_provider.dart';
import 'package:rest_test/utility/static/app_routes.dart';

class AuthViewModel extends GetxController {
  late final AuthProvider _authProvider = Get.find();

  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */

  // 로그인 요청 (404 - 회원가입 이동)
  Future<bool> loginWithKakao() async {
    late OAuthToken token;

    if (await isKakaoTalkInstalled()) {
      try {
        // 카카오톡 앱으로 로그인
        token = await UserApi.instance.loginWithKakaoTalk();
        print("카카오톡 로그인 성공");
      } catch (error) {
        print("카카오톡으로 로그인 실패 $error");
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }
        try {
          // 카카오 계정으로 로그인
          token = await UserApi.instance.loginWithKakaoAccount();
          print("카카오계정으로 로그인 성공");
        } catch (error) {
          print("카카오계정으로 로그인 실패 $error");
          return false;
        }
      }
    } else {
      try {
        // 카카오 계정으로 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
        print("카카오계정으로 로그인 성공");
      } catch (error) {
        print("카카오계정으로 로그인 실패 $error");
        return false;
      }
    }

    final kakaoToken = token.accessToken;

    final isExisting = await _authProvider.signInWithKakao(kakaoToken);
    // 등록된 사용자인 경우 로그인 후 ROOT로 이동
    if (isExisting) {
      Get.offAllNamed(Routes.ROOT);
      return true;
    } else {
      // 등록되지 않은 경우 로그인 후 ON_BOARDING으로 이동 (로그인 시도한 사용자의 email, kakao_token 유지)
      final account = await UserApi.instance.me();
      final email = account.kakaoAccount?.email ?? '';
      Get.toNamed(Routes.ON_BOARDING, arguments: {
        'email': email,
        'kakao_token': kakaoToken,
      });
    }
    return true;
  }

  // 회원가입 제출
  Future<void> submitSignUp(
      {required String kakaoToken,
      required String email,
      required String nickname,
      required String gender,
      required String birthday,
      required String job,
      required List<int> certificates,
      required bool agreeToTerms}) async {
    bool result = await _authProvider.signUpWithKakao(
      kakaoToken: kakaoToken,
      email: email,
      nickname: nickname,
      gender: gender,
      birthday: birthday,
      job: job,
      certificates: certificates,
      agreeToTerms: agreeToTerms,
    );

    if (result) {
      Get.offAllNamed(Routes.ROOT);
    } else {
      Get.snackbar("회원가입 실패", "회원가입에 실패했습니다.");
    }
  }
}
