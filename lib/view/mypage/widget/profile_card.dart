import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/mypage/profile_change_screen.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';

class ProfileSection extends StatelessWidget {
  final MyPageViewModel controller;
  const ProfileSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const ProfileChangeScreen()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: ColorSystem.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '닉네임',
                    style: FontSystem.KR10M.copyWith(
                      color: ColorSystem.grey[600],
                    ),
                  ),
                  Obx(() => Text(
                        controller.nickname.value,
                        style: FontSystem.KR16B.copyWith(
                          color: ColorSystem.grey[800],
                        ),
                      )),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: ColorSystem.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
