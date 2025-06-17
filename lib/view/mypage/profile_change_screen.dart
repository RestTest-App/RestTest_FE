import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/mypage/profile_change_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class ProfileChangeScreen extends StatefulWidget {
  const ProfileChangeScreen({super.key});

  @override
  State<ProfileChangeScreen> createState() => _ProfileChangeScreenState();
}

class _ProfileChangeScreenState extends State<ProfileChangeScreen> {
  final ProfileChangeViewModel controller = Get.put(ProfileChangeViewModel());

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    // 닉네임이 로드되면 TextField 업데이트
    ever(controller.currentNickname, (nickname) {
      if (nickname.isNotEmpty) {
        _textController.text = nickname;
        controller.newNickname.value = nickname;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정', style: FontSystem.KR20B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: ColorSystem.back,
      ),
      backgroundColor: ColorSystem.back,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Obx(() => GestureDetector(
                  onTap: controller.pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                  ),
                )),
            const SizedBox(height: 36),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '닉네임',
                style: FontSystem.KR14M.copyWith(color: ColorSystem.grey[600]),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  onChanged: (value) => controller.newNickname.value = value,
                  style: FontSystem.KR16M.copyWith(color: ColorSystem.black),
                  decoration: InputDecoration(
                    hintText: '닉네임 입력',
                    filled: true,
                    fillColor:
                        _isFocused ? ColorSystem.lightBlue : ColorSystem.back,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: controller.isChanged
                              ? ColorSystem.blue
                              : ColorSystem.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: ColorSystem.blue, width: 1.5),
                    ),
                  ),
                )),
            const Spacer(),
            Obx(() => RoundedRectangleTextButton(
                  width: screenWidth,
                  height: 60,
                  text: '수정하기',
                  onPressed: controller.isChanged
                      ? () async => await controller.changeNickname()
                      : null,
                  backgroundColor: controller.isChanged
                      ? ColorSystem.blue
                      : ColorSystem.grey[200],
                  foregroundColor: controller.isChanged
                      ? ColorSystem.white
                      : ColorSystem.grey[400],
                  textStyle: FontSystem.KR16SB.copyWith(
                    color: controller.isChanged
                        ? ColorSystem.white
                        : ColorSystem.grey[400],
                  ),
                  borderSide: BorderSide.none,
                )),
          ],
        ),
      ),
    );
  }
}
