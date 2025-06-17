import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/book/subscribe_screen.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class AddFileModal extends StatelessWidget {
  final BookViewModel controller;
  const AddFileModal({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLimit = controller.remainingCount.value == 0;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorSystem.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox(height: 16),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: ColorSystem.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28.0),
                  child: SvgPicture.asset('assets/images/logo_blue.svg',
                      height: 60, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Text(
                    isLimit
                        ? '이번달 문제 만들기를 모두 사용하셨어요!'
                        : '이번달 문제 만들기 ${controller.remainingCount.value}회 남았습니다',
                    style: FontSystem.KR20B,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 38.0),
                  child: Text(
                    isLimit
                        ? '구독제를 결제하시거나\n다음달까지 기다려주세요^0^'
                        : 'pdf 업로드나 문제를 촬영하시면\n나의 문제집에 문제가 저장됩니다!',
                    textAlign: TextAlign.center,
                    style:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey[600]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RoundedRectangleTextButton(
                            text: isLimit ? '돌아가기' : 'PDF 업로드',
                            textStyle: FontSystem.KR16B.copyWith(
                            color: isLimit
                                  ? ColorSystem.grey[400]
                                      : ColorSystem.white,
                                  ),
                            onPressed: () async {
                              if (isLimit) {
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pop(); // 먼저 모달 닫고
                                await controller.uploadPdf(1); // PDF 업로드 + 목록 갱신
                              }
                            },
                            backgroundColor: isLimit
                              ? ColorSystem.grey[200]
                                  : ColorSystem.blue,),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RoundedRectangleTextButton(
                          text: isLimit ? '구독제 보러가기' : '촬영하기',
                          textStyle: FontSystem.KR16B.copyWith(
                            color: ColorSystem.white,
                          ),
                          onPressed: (){if (isLimit) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (_) => const SubscribeScreen()),
                            );
                          }},
                          backgroundColor: ColorSystem.blue,),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
