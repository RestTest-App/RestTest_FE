import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_test/repository/user/user_repository.dart';

class ProfileChangeViewModel extends GetxController {
  late final UserRepository _userRepository = Get.find();

  var currentNickname = ''.obs;
  var newNickname = ''.obs;
  var profileImageUrl = ''.obs;
  var profileImage = Rxn<File>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserNickname();
  }

  Future<void> _loadUserNickname() async {
    try {
      final userInfo = await _userRepository.fetchUserInfo();
      if (userInfo != null) {
        final nickname = userInfo['nickname'] as String?;
        if (nickname != null && nickname.isNotEmpty) {
          currentNickname.value = nickname;
          newNickname.value = nickname;
        }
        final img = userInfo['profile_image'];
        if (img != null && img.toString().isNotEmpty) {
          // 서버에서 받은 프로필 이미지 URL (상대 경로)
          profileImageUrl.value = img;
        }
        // img가 없으면 profileImageUrl은 빈 문자열로 유지 (화면에서 기본 이미지 표시)
      }
    } catch (e) {
      Get.snackbar('오류', '사용자 정보를 불러오는데 실패했습니다.');
    }
  }

  bool get isChanged =>
      (newNickname.value != currentNickname.value &&
          newNickname.value.isNotEmpty) ||
      profileImage.value != null;

  Future<void> updateProfile() async {
    if (!isChanged) {
      Get.snackbar('알림', '변경된 내용이 없습니다.');
      return;
    }

    try {
      isLoading.value = true;

      // 닉네임 또는 이미지 변경
      final result = await _userRepository.updateUserProfile(
        nickname: newNickname.value != currentNickname.value
            ? newNickname.value
            : null,
        profileImage: profileImage.value,
      );

      if (result != null) {
        currentNickname.value = newNickname.value;
        profileImage.value = null;
        Get.back();
        Get.snackbar('성공', '프로필이 수정되었습니다.');
      } else {
        Get.snackbar('실패', '프로필 수정에 실패했습니다.');
      }
    } catch (e) {
      Get.snackbar('오류', '프로필 수정 중 오류가 발생했습니다.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage.value = File(picked.path);
    }
  }
}
