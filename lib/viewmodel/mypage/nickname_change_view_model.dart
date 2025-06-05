import 'package:get/get.dart';

class NicknameChangeViewModel extends GetxController {
  // 현재 닉네임
  var currentNickname = '시엄시험해'.obs;

  // 입력 중인 닉네임
  var newNickname = ''.obs;

  // 닉네임이 변경되었는지 여부
  bool get isChanged => newNickname.value != currentNickname.value;

  // 닉네임 변경 로직
  void changeNickname() {
    if (isChanged) {
      currentNickname.value = newNickname.value;
      Get.back(); // 변경 후 이전 화면으로 돌아가기
    }
  }
}