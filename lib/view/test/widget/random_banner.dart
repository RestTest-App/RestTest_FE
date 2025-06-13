import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

class RandomBanner extends StatelessWidget {
  const RandomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 36.0),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: ColorSystem.blue,
        ),
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(-60, -50), // 위로 이동 → 위쪽 잘리게
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(250, 70), // 위로 이동 → 위쪽 잘리게
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "오늘도 힘내서 좋은 결과가 있기를!",
                      style:
                          FontSystem.KR16B.copyWith(color: ColorSystem.white),
                    ),
                    SvgPicture.asset(
                      "assets/icons/bottom_navigation/mypage.svg",
                      width: 88,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
