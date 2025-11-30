import 'package:rest_test/provider/base/base_connect.dart';
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
        print('⚠️ 사용자 정보 API 서버 오류 (${response.statusCode})');
        return null;
      }
      return null;
    } catch (e) {
      print('⚠️ 사용자 정보 조회 실패: $e');
      return null;
    }
  }

  @override
  Future<bool> updateUserInfo(Map<String, dynamic> data) async {
    final response = await patch('/api/v1/user/update-user-info', data);
    return response.status.isOk;
  }

  @override
  Future<bool> deleteAccount() async {
    final response = await delete('/api/v1/auth/delete_account');
    return response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;
  }
}
