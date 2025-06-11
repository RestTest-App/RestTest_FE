import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/mypage/nickname_change_screen.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';

class ProfileSection extends StatelessWidget {
  final MyPageViewModel controller;
  const ProfileSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => NicknameChangeScreen()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: ColorSystem.white,
          borderRadius: BorderRadius.circular(8),
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
            SvgPicture.asset(
              'icons/mypage/right_arrow.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
