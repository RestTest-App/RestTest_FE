abstract class AuthProvider {
  Future<bool> signInWithKakao(String kakaoToken);

  Future<bool> signUpWithKakao(
      {required String kakaoToken,
      required String email,
      required String nickname,
      required String gender,
      required String birthday,
      required String job,
      required List<int> certificates,
      required bool agreeToTerms});
}
