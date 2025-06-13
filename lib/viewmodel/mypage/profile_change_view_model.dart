import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileChangeViewModel extends GetxController {
  var currentNickname = '쉬엄시험해'.obs;
  var newNickname = ''.obs;

  var profileImage = Rxn<File>();

  bool get isChanged =>
      (newNickname.value != currentNickname.value &&
          newNickname.value.isNotEmpty) ||
      profileImage.value != null;

  void changeNickname() {
    if (isChanged) {
      currentNickname.value = newNickname.value;
      Get.back();
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
