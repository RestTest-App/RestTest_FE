import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:rest_test/provider/base/base_connect.dart';
import 'package:rest_test/utility/function/log_util.dart';
import 'user_provider.dart';

class UserProviderImpl extends BaseConnect implements UserProvider {
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final response = await get('/api/v1/user/get-user-info');
      if (response.status.isOk) {
        return response.body['data'];
      }
      // 500 오류 등 서버 오류는 조용히 처리
      if (response.statusCode != null && response.statusCode! >= 500) {
        LogUtil.error('⚠️ 사용자 정보 API 서버 오류 (${response.statusCode})');
        return null;
      }
      return null;
    } catch (e) {
      LogUtil.error('⚠️ 사용자 정보 조회 실패: $e');
      return null;
    }
  }

  @override
  Future<bool> updateUserInfo(Map<String, dynamic> data) async {
    try {
      debugPrint('updateUserInfo request body: $data');
      final response = await patch('/api/v1/user/update-user-info', data);
      if (response.status.isOk) {
        LogUtil.info('✅ 사용자 정보 업데이트 성공');
        return true;
      }
      // 422 에러의 전체 응답 확인
      LogUtil.error(
          '⚠️ 사용자 정보 업데이트 실패 (${response.statusCode}): ${response.body}');
      if (response.statusCode == 422 && response.body is Map) {
        final body = response.body as Map<String, dynamic>;
        if (body.containsKey('detail')) {
          debugPrint('422 에러 detail 전체: ${body['detail']}');
          final detail = body['detail'];
          if (detail is List) {
            for (var item in detail) {
              if (item is Map) {
                debugPrint(
                    '  - loc: ${item['loc']}, msg: ${item['msg']}, type: ${item['type']}');
              }
            }
          }
        }
      }
      return false;
    } catch (e) {
      LogUtil.error('⚠️ 사용자 정보 업데이트 중 오류: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> updateUserProfile({
    String? nickname,
    File? profileImage,
    bool? deleteImage,
  }) async {
    try {
      final formData = FormData({});

      if (nickname != null) {
        formData.fields.add(MapEntry('nickname', nickname));
      }

      if (profileImage != null) {
        formData.files.add(
          MapEntry(
            'profile_image',
            MultipartFile(profileImage,
                filename: profileImage.path.split('/').last),
          ),
        );
      }

      if (deleteImage == true) {
        formData.fields.add(const MapEntry('delete_image', 'true'));
      }

      final response = await patch(
        '/api/v1/user/update-user-profile',
        formData,
      );

      if (response.status.isOk) {
        return response.body['data'];
      }

      LogUtil.error('⚠️ 프로필 수정 실패 (${response.statusCode}): ${response.body}');
      return null;
    } catch (e) {
      LogUtil.error('⚠️ 프로필 수정 중 오류: $e');
      return null;
    }
  }

  @override
  Future<bool> deleteAccount() async {
    final response = await delete('/api/v1/auth/delete_account');
    return response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;
  }
}
