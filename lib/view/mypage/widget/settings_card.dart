import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';

class SettingsSection extends StatelessWidget {
  final MyPageViewModel controller;
  const SettingsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 알림 설정
          GestureDetector(
            onTap: () => _showSimpleConfirmDialog(context, '준비중입니다.'),
            child: _buildSettingRow('알림 설정'),
          ),
          const SizedBox(height: 32),

          // 약관 및 정책
          GestureDetector(
            onTap: () => _showSimpleConfirmDialog(context, '준비중입니다.'),
            child: _buildSettingRow('약관 및 정책'),
          ),
          const SizedBox(height: 32),

          // 로그아웃
          GestureDetector(
            onTap: () => _showFullWidthLogoutDialog(context),
            child: _buildSettingRow('로그아웃'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: FontSystem.KR16M.copyWith(
            color: ColorSystem.grey[800],
          ),
        ),
        SvgPicture.asset('icons/mypage/right_arrow.svg', width: 20, height: 20),
      ],
    );
  }

  void _showFullWidthLogoutDialog(BuildContext context) {
    final modalWidth = MediaQuery.of(context).size.width - 40;
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
          color: ColorSystem.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: modalWidth,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: ColorSystem.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '정말 로그아웃 하시겠습니까?',
                    style: FontSystem.KR18B,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
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
                          style: FontSystem.KR16B.copyWith(
                            color: ColorSystem.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            style: FontSystem.KR16B.copyWith(
                              color: ColorSystem.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ],
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

  void _showSimpleConfirmDialog(BuildContext context, String message) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Material(
          color: ColorSystem.black.withOpacity(0.5),
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              decoration: BoxDecoration(
                color: ColorSystem.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: FontSystem.KR18B,
                  ),
                  const SizedBox(height: 32),
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
                        style: FontSystem.KR16B.copyWith(
                          color: ColorSystem.white,
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
