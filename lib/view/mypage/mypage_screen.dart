import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';
import 'package:rest_test/widget/appbar/default_appbar.dart';
import 'package:rest_test/widget/button/custom_icon_button.dart';
import 'package:rest_test/view/mypage/nickname_change_screen.dart';

class MyPageScreen extends BaseScreen<MyPageViewModel> {
  const MyPageScreen({Key? key}) : super(key: key);

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
        title: '마이페이지',
        backColor: ColorSystem.back,
        actions: [
          CustomIconButton(
            onPressed: () => Get.back(), assetPath: 'assets/icons/mypage/right_arrow.svg',
          ),
        ],
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

// 프로필 영역
class ProfileSection extends StatelessWidget {
  final MyPageViewModel controller;
  const ProfileSection({Key? key, required this.controller}) : super(key: key);

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
            CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/images/profile.png')),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '닉네임',
                    style: TextStyle(fontSize: 10, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.w500, color: ColorSystem.grey[600]),
                  ),
                  Obx(() => Text(
                        controller.nickname.value,
                        style: TextStyle(fontSize: 16, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.bold, color: ColorSystem.grey[800]),
                      )),
                ],
              ),
            ),
            SvgPicture.asset('icons/mypage/right_arrow.svg', width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}

// 캘린더 영역
class CalendarSection extends StatelessWidget {
  final MyPageViewModel controller;
  const CalendarSection({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: ColorSystem.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CalendarHeader(controller: controller),
              const SizedBox(height: 16),
              _CalendarGrid(controller: controller),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Positioned(
          top: -8,
          child: Image.asset('assets/images/spring.png', width: width, height: 16),
        ),
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final MyPageViewModel controller;
  const _CalendarHeader({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
                '${controller.currentMonth.value}월',
                style: TextStyle(fontSize: 20, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.bold),
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 24,
            decoration: BoxDecoration(color: ColorSystem.back, borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Obx(() => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '이번달 출석 ',
                            style: TextStyle(fontSize: 12, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.w600, color: ColorSystem.grey[600])),
                        TextSpan(
                            text: '${controller.attendanceCount.value}일',
                            style: TextStyle(fontSize: 12, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.w600, color: ColorSystem.blue)),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      );
}

class _CalendarGrid extends StatelessWidget {
  final MyPageViewModel controller;
  const _CalendarGrid({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, crossAxisSpacing: 6, mainAxisSpacing: 6),
          itemCount: controller.calendarDays.length,
          itemBuilder: (_, i) {
            final day = controller.calendarDays[i];
            if (day.isAttended) return _AttendedDay();
            if (day.isInCurrentMonth && day.date.isBefore(today)) return _MissedDay();
            final isToday = day.date.year == today.year && day.date.month == today.month && day.date.day == today.day;
            return _NormalDay(day: day, isToday: isToday);
          },
        ));
  }
}

class _AttendedDay extends StatelessWidget {
  @override Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: ColorSystem.blue, borderRadius: BorderRadius.circular(12)),
        child: Center(child: Image.asset('assets/images/logo_white.png', width: 20, height: 20)),
      );
}

class _MissedDay extends StatelessWidget {
  @override Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: ColorSystem.red, width: 1.5), borderRadius: BorderRadius.circular(12)),
        child: Center(child: SvgPicture.asset('icons/mypage/x.svg', width: 16, height: 16)),
      );
}

class _NormalDay extends StatelessWidget {
  final dynamic day;
  final bool isToday;
  const _NormalDay({Key? key, required this.day, required this.isToday}) : super(key: key);

  @override Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: day.isInCurrentMonth ? Colors.white : ColorSystem.white,
          border: isToday
              ? Border.all(color: ColorSystem.green, width: 1.5)
              : Border.all(color: ColorSystem.grey[200]!, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${day.date.day}',
          style: TextStyle(fontSize: 14, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.w600, color: day.isInCurrentMonth ? Colors.black : ColorSystem.grey[200]!),
        ),
      );
}

// 설정 영역
class SettingsSection extends StatelessWidget {
  final MyPageViewModel controller;
  const SettingsSection({Key? key, required this.controller}) : super(key: key);

  @override Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: ColorSystem.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingItem(title: '알림 설정', onTap: () => _showSimpleConfirmDialog(context, '준비중입니다.')),
            const SizedBox(height: 32),
            SettingItem(title: '약관 및 정책', onTap: () => _showSimpleConfirmDialog(context, '준비중입니다.')),
            const SizedBox(height: 32),
            SettingItem(title: '로그아웃', onTap: () => _showFullWidthLogoutDialog(context)),
          ],
        ),
      );

  void _showFullWidthLogoutDialog(BuildContext context) {
    final modalWidth = MediaQuery.of(context).size.width - 40;
    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) => Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: modalWidth,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('정말 로그아웃 하시겠습니까?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () { entry.remove(); controller.logout(); },
                      child: Text('로그아웃', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ColorSystem.blue)),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 110,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => entry.remove(),
                        style: ElevatedButton.styleFrom(backgroundColor: ColorSystem.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: Text('유지하기', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
    Navigator.of(context).overlay!.insert(entry);
  }

  void _showSimpleConfirmDialog(BuildContext context, String message) {
    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) => Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 32),
                SizedBox(
                  width: 110,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => entry.remove(),
                    style: ElevatedButton.styleFrom(backgroundColor: ColorSystem.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    child: Text('확인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
    Navigator.of(context).overlay!.insert(entry);
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingItem({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SvgPicture.asset('icons/mypage/right_arrow.svg', width: 20, height: 20),
          ],
        ),
      );
  }