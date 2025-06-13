import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/book/subscribe_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 배너 광고
class BookBanner extends StatelessWidget {
  const BookBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SubscribeScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        height: 60,
        color: ColorSystem.blue.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: SvgPicture.asset(
                'assets/images/logo_white.svg',
                height: 25,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '(광고) 구독하고 문제집 더 생성하기 (광고)',
                  style: FontSystem.KR12B.copyWith(color: ColorSystem.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: SvgPicture.asset(
                'assets/images/logo_white.svg',
                height: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
