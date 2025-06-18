abstract class UserProvider {
  Future<Map<String, dynamic>?> getUserInfo();
  Future<bool> updateUserInfo(Map<String, dynamic> data);
  Future<bool> deleteAccount();
}
 