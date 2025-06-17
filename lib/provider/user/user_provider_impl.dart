import 'package:rest_test/provider/base/base_connect.dart';
import 'user_provider.dart';

class UserProviderImpl extends BaseConnect implements UserProvider {
  @override
  Future<Map<String, dynamic>?> getUserInfo() async {
    final response = await get('/api/v1/user/get-user-info');
    if (response.status.isOk) {
      return response.body['data'];
    }
    return null;
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
