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
  Future<bool> signUpWithKakao(
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
      'email': email,
      'nickname': nickname,
      'gender': gender,
      'birthday': birthday,
      'job': job,
      'certificates': certificates,
      'agree_to_terms': agreeToTerms,
    };

    final response =
        await post<Map<String, dynamic>>("/api/v1/auth/sign-up", body);

    if (response.status.hasError) {
      return false;
    }

    final Map<String, dynamic> resBody = response.body!;

    final tokenMap = resBody["data"] as Map<String, dynamic>?;
    if (tokenMap == null) return false;

    final access = tokenMap["access_token"] as String?;
    final refresh = tokenMap["refresh_token"] as String?;
    if (access == null || refresh == null) return false;

    await _tokenProvider.setAccessToken(access);
    await _tokenProvider.setRefreshToken(refresh);

    return true;
  }

  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final response = await get('/api/v1/user/get-user-info');
      if (response.status.isOk) {
        return response.body['data'];
      }
      return null;
    } catch (e) {
      print('Failed to get user info: $e');
      return null;
    }
  }
}
