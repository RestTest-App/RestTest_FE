import 'dart:io';
import 'package:rest_test/provider/user/user_provider.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserProvider _userProvider;

  UserRepositoryImpl(this._userProvider);

  @override
  Future<Map<String, dynamic>?> fetchUserInfo() {
    return _userProvider.getUserInfo();
  }

  @override
  Future<bool> updateUserInfo(Map<String, dynamic> data) {
    return _userProvider.updateUserInfo(data);
  }

  @override
  Future<Map<String, dynamic>?> updateUserProfile({
    String? nickname,
    File? profileImage,
    bool? deleteImage,
  }) {
    return _userProvider.updateUserProfile(
      nickname: nickname,
      profileImage: profileImage,
      deleteImage: deleteImage,
    );
  }

  @override
  Future<bool> deleteAccount() {
    return _userProvider.deleteAccount();
  }
}
