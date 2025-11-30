import 'dart:convert';
import 'package:dio/dio.dart';
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
      print('로그인 요청 - kakaoToken: ${kakaoToken.substring(0, 10)}...');
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
        print('로그인 실패 - Status: $code, Body: ${response.body}');
        if (response.statusCode != null && response.statusCode! >= 500) {
          return false;
        }
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
    try {
      // birthday 형식 변환: "YYYY.MM.DD" -> "YYYY-MM-DD" (ISO 8601)
      String formattedBirthday = birthday;
      if (birthday.contains('.')) {
        formattedBirthday = birthday.replaceAll('.', '-');
      }

      final body = {
        'kakao_token': kakaoToken,
        'email': email,
        'nickname': nickname,
        'gender': gender,
        'birthday': formattedBirthday,
        'job': job,
        'certificates': certificates,
        'agree_to_terms': agreeToTerms,
      };

      print('회원가입 요청 데이터: ${body.toString().replaceAll(kakaoToken, '***')}');

      final response = await post("/api/v1/auth/sign-up", body);

      if (response.status.hasError) {
        print(
            '회원가입 실패 - Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }

      // 응답 body 처리 - String 또는 Map 모두 처리
      dynamic resBody = response.body;

      // body가 String인 경우 JSON으로 파싱 시도
      if (resBody is String) {
        try {
          resBody = jsonDecode(resBody);
        } catch (e) {
          print('회원가입 응답 파싱 실패: $e');
          return false;
        }
      }

      if (resBody is! Map<String, dynamic>) {
        print('회원가입 응답 형식 오류: ${resBody.runtimeType}');
        return false;
      }

      print('회원가입 응답 구조: $resBody');

      final tokenMap = resBody["data"] as Map<String, dynamic>?;
      if (tokenMap == null) {
        print('회원가입 응답에 data 필드가 없습니다. 전체 응답: $resBody');
        return false;
      }

      final access = tokenMap["access_token"] as String?;
      final refresh = tokenMap["refresh_token"] as String?;
      if (access == null || refresh == null) {
        print('회원가입 응답에 토큰이 없습니다. tokenMap: $tokenMap');
        return false;
      }

      await _tokenProvider.setAccessToken(access);
      await _tokenProvider.setRefreshToken(refresh);

      return true;
    } catch (e) {
      print('회원가입 오류: $e');
      return false;
    }
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
