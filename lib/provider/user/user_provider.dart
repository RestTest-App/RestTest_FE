import 'dart:io';

abstract class UserProvider {
  Future<Map<String, dynamic>?> getUserInfo();
  Future<bool> updateUserInfo(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> updateUserProfile({
    String? nickname,
    File? profileImage,
    bool? deleteImage,
  });
  Future<bool> deleteAccount();
}
 