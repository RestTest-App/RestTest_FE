import 'package:rest_test/provider/user/user_provider.dart';

abstract class UserRepository {
  final UserProvider _userProvider;

  UserRepository(this._userProvider);

  Future<Map<String, dynamic>?> fetchUserInfo();

  Future<bool> updateUserInfo(Map<String, dynamic> data);

  Future<bool> deleteAccount();
}
