import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';
import '../../widget/appbar/default_appbar.dart';
import 'package:rest_test/view/mypage/nickname_change_screen.dart';

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
        title: '마이페이지',
        backColor: ColorSystem.back,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => NicknameChangeScreen());
              },
              child: _buildProfileSection(),
            ),
            SizedBox(height: 20),
            _buildCalendarSection(context),
            SizedBox(height: 20),
            _buildSettingsSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('images/profile.png'),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '닉네임',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'AppleSDGothicNeo',
                    fontWeight: FontWeight.w500,
                    color: ColorSystem.grey[600] ?? Colors.grey,
                  ),
                ),
                Obx(() => Text(
                      controller.nickname.value,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'AppleSDGothicNeo',
                        fontWeight: FontWeight.bold,
                        color: ColorSystem.grey[800] ?? Colors.black,
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
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = 40.0; // 좌우 20 + 20
    double springWidth = screenWidth - padding;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: ColorSystem.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        '${controller.currentMonth.value}월',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'AppleSDGothicNeo',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    height: 24,
                    decoration: BoxDecoration(
                      color: ColorSystem.back,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Obx(() => RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: '이번달 출석 ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'AppleSDGothicNeo',
                                    fontWeight: FontWeight.w600,
                                    color: ColorSystem.grey[600] ?? Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: '${controller.attendanceCount.value}일',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'AppleSDGothicNeo',
                                    fontWeight: FontWeight.w600,
                                    color: ColorSystem.blue ?? Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0,
                    ),
                    itemCount: controller.calendarDays.length,
                    itemBuilder: (context, index) {
                      final day = controller.calendarDays[index];
                      final isToday = DateTime.now().day == day.date.day &&
                          DateTime.now().month == day.date.month &&
                          DateTime.now().year == day.date.year;

                      if (day.isAttended) {
                        return Container(
                          decoration: BoxDecoration(
                            color: ColorSystem.blue ?? Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo_white.png',
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      } else if (day.isInCurrentMonth && day.date.isBefore(DateTime.now())) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: ColorSystem.red ?? Colors.red,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'icons/mypage/x.svg',
                              width: 16,
                              height: 16,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      }

                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: day.isInCurrentMonth ? Colors.white : ColorSystem.white,
                          border: isToday
                              ? Border.all(color: ColorSystem.green ?? Colors.green, width: 1.5)
                              : Border.all(color: ColorSystem.grey[200] ?? Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${day.date.day}',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'AppleSDGothicNeo',
                            fontWeight: FontWeight.w600,
                            color: day.isInCurrentMonth ? Colors.black : ColorSystem.grey[200],
                          ),
                        ),
                      );
                    },
                  )),
              SizedBox(height: 16),
            ],
          ),
        ),
        Positioned(
          top: -8,
          child: Image.asset(
            'images/spring.png',
            width: springWidth,
            height: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingItem('알림 설정'),
          SizedBox(height: 32),
          _buildSettingItem('약관 및 정책'),
          SizedBox(height: 32),
          _buildSettingItem('로그아웃'),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title) {
    return GestureDetector(
      onTap: () {
        if (title == '로그아웃') {
          _showFullWidthLogoutDialog(Get.context!);
        } else {
            _showSimpleConfirmDialog(Get.context!, '준비중입니다.');
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'AppleSDGothicNeo',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          SvgPicture.asset(
            'icons/mypage/right_arrow.svg',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }

  void _showFullWidthLogoutDialog(BuildContext context) {
    final double modalWidth = MediaQuery.of(context).size.width - 40;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
          color: Colors.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: modalWidth,
              padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '정말 로그아웃 하시겠습니까?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                                            TextButton(
                        onPressed: () {
                          entry.remove();
                          controller.logout();
                        },
                        child: Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ColorSystem.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      SizedBox(
                        width: 110,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => entry.remove(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSystem.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            '유지하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Navigator.of(context).overlay!.insert(entry);
  }

  void _showSimpleConfirmDialog(BuildContext context, String message) {
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: 110,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => entry.remove(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorSystem.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Navigator.of(context).overlay!.insert(entry);
}

}
