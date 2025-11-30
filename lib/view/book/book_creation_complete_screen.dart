import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/viewmodel/root/root_view_model.dart';
import 'package:rest_test/view/book/book_detail_screen.dart';

class BookCreationCompleteScreen extends StatelessWidget {
  final String bookName;
  final int? studybookId;
  final String? createdDate;

  const BookCreationCompleteScreen({
    super.key,
    required this.bookName,
    this.studybookId,
    this.createdDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/zshape.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/images/logo_blue.svg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '$bookName이 만들어졌어요!',
                    textAlign: TextAlign.center,
                    style: FontSystem.KR22B.copyWith(
                      color: ColorSystem.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '함께 문제를 풀어볼까요?',
                    textAlign: TextAlign.center,
                    style: FontSystem.KR16M.copyWith(
                      color: ColorSystem.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: RoundedRectangleTextButton(
                        text: '나의 문제집으로 이동',
                        textStyle: FontSystem.KR16B.copyWith(
                          color: ColorSystem.white,
                        ),
                        backgroundColor: ColorSystem.blue,
                        onPressed: () {
                          if (studybookId != null && createdDate != null) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => BookDetailScreen(
                                  studybookId: studybookId!,
                                  studybookName: bookName,
                                  createdDate: createdDate!,
                                ),
                              ),
                              (route) => route.isFirst,
                            );
                          } else {
                            // 문제집 ID가 없으면 루트 화면으로 이동
                            Get.offAllNamed('/');
                            try {
                              final rootViewModel = Get.find<RootViewModel>();
                              rootViewModel.fetchIndex(2);
                            } catch (e) {
                              // ViewModel을 찾을 수 없으면 무시
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
