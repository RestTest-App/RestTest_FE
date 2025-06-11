import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';
import 'package:rest_test/widget/appbar/default_appbar.dart';
import 'package:rest_test/widget/button/custom_icon_button.dart';
import 'package:rest_test/view/mypage/widget/profile_card.dart';
import 'package:rest_test/view/mypage/widget/calendar_card.dart';
import 'package:rest_test/view/mypage/widget/settings_card.dart';

class MyPageScreen extends BaseScreen<MyPageViewModel> {
  const MyPageScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;
  @override
  bool get setBottomInnerSafeArea => true;
  @override
  Color? get unSafeAreaColor => ColorSystem.back;
  @override
  Color? get screenBackgroundColor => ColorSystem.back;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(58),
      child: DefaultAppBar(
        title: '내 프로필',
        backColor: ColorSystem.back,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final ctrl = controller;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSection(controller: ctrl),
          const SizedBox(height: 20),
          CalendarSection(controller: ctrl),
          const SizedBox(height: 20),
          SettingsSection(controller: ctrl),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
