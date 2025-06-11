import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/mypage/nickname_change_view_model.dart';

class NicknameChangeScreen extends StatelessWidget {
  final NicknameChangeViewModel controller = Get.put(NicknameChangeViewModel());

  NicknameChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('닉네임 수정', style: FontSystem.KR20B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: ColorSystem.back,
      ),
      backgroundColor: ColorSystem.back,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  SizedBox(height: 36),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ),
            const Text(
              '닉네임',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'AppleSDGothicNeo-Medium',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            TextField(
              onChanged: (value) => controller.newNickname.value = value,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'AppleSDGothicNeo',
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '닉네임 입력',
              ),
            ),
            const Spacer(),
            Obx(() {
              bool isButtonEnabled =
                  controller.isChanged && controller.newNickname.isNotEmpty;
              return ElevatedButton(
                onPressed: isButtonEnabled ? controller.changeNickname : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? ColorSystem.blue
                      : ColorSystem.grey[200], // 배경색 변경
                  minimumSize:
                      const Size(double.infinity, 60), // 높이 60, 좌우로 쫙 붙도록
                  shape: RoundedRectangleBorder(
                    // 버튼 모서리 둥글게
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  '수정하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'AppleSDGothicNeo',
                    fontWeight: FontWeight.w600, // SemiBold
                    color: isButtonEnabled
                        ? Colors.white
                        : ColorSystem.grey[400], // 글자 색 변경
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
