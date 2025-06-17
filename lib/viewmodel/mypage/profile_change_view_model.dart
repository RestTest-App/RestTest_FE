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
          profileImageUrl.value = img;
        } else {
          profileImageUrl.value = 'assets/images/default_profile.png';
        }
      }
    } catch (e) {
      Get.snackbar('오류', '사용자 정보를 불러오는데 실패했습니다.');
    }
  }

  bool get isChanged =>
      (newNickname.value != currentNickname.value &&
          newNickname.value.isNotEmpty) ||
      profileImage.value != null;

  Future<void> changeNickname() async {
    if (isChanged) {
      final data = <String, dynamic>{
        'nickname': newNickname.value,
        // 'profile_image': ... // 이미지 업로드는 별도 처리 필요
      };
      print('업데이트 요청 데이터: $data');
      final result = await _userRepository.updateUserInfo(data);
      if (result) {
        currentNickname.value = newNickname.value;
        Get.back();
        Get.snackbar('성공', '프로필이 수정되었습니다.');
      } else {
        Get.snackbar('실패', '프로필 수정에 실패했습니다.');
      }
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
