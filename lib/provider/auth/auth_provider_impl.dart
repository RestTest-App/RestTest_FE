import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:rest_test/app/factory/secure_storage_factory.dart';
import 'package:rest_test/provider/auth/auth_provider.dart';
import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/provider/token/token_provider.dart';

class AuthProviderImpl extends BaseConnect implements AuthProvider {
  final TokenProvider _tokenProvider = SecureStorageFactory.tokenProvider;

  // sign-in repo
  @override
  Future<bool> signInWithKakao(String kakaoToken) async {
    try {
      final response = await post(
        "/api/v1/auth/sign-in",
        {"kakao_token": kakaoToken},
      );

      // 404 → 신규회원
      if (response.statusCode == 404) {
        return false;
      }

      if (response.status.hasError) {
        final code = response.statusCode?.toString();
        throw Exception("로그인 실패 (status: $code)");
      }

      final body = response.body;
      if (body is! Map<String, dynamic>) {
        throw Exception("응답 포맷 오류");
      }

      final data = body['data'];
      if (data is! Map<String, dynamic>) {
        throw Exception("데이터가 올바르지 않습니다");
      }

      final access = data['access_token'];
      final refresh = data['refresh_token'];
      if (access is! String || refresh is! String) {
        throw Exception("토큰 정보 누락");
      }

      await tokenProvider.setAccessToken(access);
      await tokenProvider.setRefreshToken(refresh);
      return true;
    } on Response catch (error) {
      if (error.statusCode == 404) {
        return false;
      }

      rethrow;
    }
  }

  // sign-up repo
  @override
  Future<void> signUpWithKakao(
      {required String kakaoToken,
      required String email,
      required String nickname,
      required String gender,
      required String birthday,
      required String job,
      required List<int> certificates,
      required bool agreeToTerms}) async {
    final body = {
      'kakao_token': kakaoToken,
      'nickname': nickname,
      'gender': gender,
      'birthday': birthday,
      'job': job,
      'certificates': certificates,
      'agree_to_terms': agreeToTerms,
    };

    final response = await post("/api/v1/auth/sign-up", body);
    final data = response.body as Map<String, dynamic>;
    await _tokenProvider.setAccessToken(data["access_token"] as String);
    await _tokenProvider.setRefreshToken(data["refresh_token"] as String);
  }
}
