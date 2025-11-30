import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:rest_test/provider/auth/auth_provider.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';
import 'package:rest_test/utility/static/app_routes.dart';

class AuthViewModel extends GetxController {
  late final AuthProvider _authProvider;

  @override
  void onInit() {
    super.onInit();
    _authProvider = Get.find<AuthProvider>();
  }

  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */

  // 로그인 요청 (404 - 회원가입 이동)
  Future<bool> loginWithKakao() async {
    late OAuthToken token;

    bool isKakaoTalkAvailable = false;
    try {
      isKakaoTalkAvailable = await isKakaoTalkInstalled();
    } catch (e) {
      // macOS 등 Kakao SDK를 지원하지 않는 플랫폼에서는 false로 처리
      print("카카오톡 확인 불가: $e");
      isKakaoTalkAvailable = false;
    }

    if (isKakaoTalkAvailable) {
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

    try {
      final isExisting = await _authProvider.signInWithKakao(kakaoToken);
      // 등록된 사용자인 경우 로그인 후 ROOT로 이동
      if (isExisting) {
        Get.offAllNamed(Routes.ROOT);
        // 로그인 성공 후 유저 정보 불러오기
        _loadUserInfoAfterLogin();
        return true;
      } else {
        // 등록되지 않은 경우 로그인 후 ON_BOARDING으로 이동
        final account = await UserApi.instance.me();
        final email = account.kakaoAccount?.email ?? '';
        Get.toNamed(Routes.ON_BOARDING, arguments: {
          'email': email,
          'kakao_token': kakaoToken,
        });
      }
      return true;
    } catch (e) {
      print('로그인 오류: $e');
      Get.snackbar(
          "로그인 실패", "로그인에 실패했습니다.\n서버 오류가 발생했을 수 있습니다.\n잠시 후 다시 시도해주세요.");
      return false;
    }
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
      // 회원가입 성공 후 유저 정보 불러오기
      _loadUserInfoAfterLogin();
    } else {
      Get.snackbar("회원가입 실패", "회원가입에 실패했습니다.");
    }
  }

  // 로그인/회원가입 성공 후 유저 정보 불러오기
  void _loadUserInfoAfterLogin() {
    try {
      // HomeViewModel이 이미 초기화되어 있으면 유저 정보 불러오기
      if (Get.isRegistered<HomeViewModel>()) {
        final homeViewModel = Get.find<HomeViewModel>();
        homeViewModel.loadUserInfo();
        print('✅ 로그인 후 유저 정보 불러오기 완료');
      } else {
        // HomeViewModel이 아직 초기화되지 않았으면 잠시 후 시도
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.isRegistered<HomeViewModel>()) {
            final homeViewModel = Get.find<HomeViewModel>();
            homeViewModel.loadUserInfo();
            print('✅ 로그인 후 유저 정보 불러오기 완료 (지연)');
          }
        });
      }
    } catch (e) {
      print('⚠️ 로그인 후 유저 정보 불러오기 실패: $e');
    }
  }
}
