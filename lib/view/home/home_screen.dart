import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';
import 'package:rest_test/view/home/widget/exam_card.dart';
import 'package:rest_test/view/home/widget/today_question_card.dart';
import 'package:rest_test/view/home/widget/goal_card.dart';
import 'package:rest_test/view/home/widget/exam_type_selector.dart';
import 'package:rest_test/model/home/exam_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/utility/static/app_routes.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.back;

  @override
  Color? get screenBackgroundColor => ColorSystem.back;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    final isRestMode = true.obs;
    final questionCount = 5.obs;
    final selectedExamType = '정처기'.obs;

    return Obx(() {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ExamTypeSelector(selectedExamType: selectedExamType),
          ),
          const SizedBox(height: 16),
          Obx(() => GoalCard(nickname: viewModel.nickname.value)),
          const SizedBox(height: 16),
          const TodayQuestion(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorSystem.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildModeSelector(isRestMode),
                  const SizedBox(height: 24),
                  isRestMode.value
                      ? _buildRestMode(questionCount)
                      : _buildExamMode(viewModel.mockExams),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildModeSelector(RxBool isRestMode) {
    return Obx(() {
      return Container(
        height: 56,
        decoration: BoxDecoration(
          color: ColorSystem.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: isRestMode.value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(Get.context!).size.width / 2 - 32,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                decoration: BoxDecoration(
                  color: ColorSystem.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => isRestMode.value = true,
                    behavior: HitTestBehavior.translucent,
                    child: Center(
                      child: Text(
                        "쉬엄 모드",
                        style: FontSystem.KR18B.copyWith(
                          color: isRestMode.value
                              ? ColorSystem.deepBlue
                              : ColorSystem.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => isRestMode.value = false,
                    behavior: HitTestBehavior.translucent,
                    child: Center(
                      child: Text(
                        "시험 모드",
                        style: FontSystem.KR18B.copyWith(
                          color: !isRestMode.value
                              ? ColorSystem.deepBlue
                              : ColorSystem.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRestMode(RxInt count) {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Text("학습할 문제 수를 설정하세요", style: FontSystem.KR18SB),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: count.value > 5 ? () => count.value -= 5 : null,
              icon: const Icon(Icons.arrow_left),
              color: count.value > 5 ? ColorSystem.blue : ColorSystem.grey[400],
              iconSize: 28,
              splashColor: ColorSystem.transparent,
              highlightColor: ColorSystem.transparent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            Container(
              width: 100,
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: ColorSystem.white,
                border: Border.all(color: ColorSystem.grey[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() => Text(
                    '${count.value}',
                    style: FontSystem.KR24B,
                  )),
            ),
            const SizedBox(width: 16),
            IconButton(
              onPressed: count.value < 20 ? () => count.value += 5 : null,
              icon: const Icon(Icons.arrow_right),
              color:
                  count.value < 20 ? ColorSystem.blue : ColorSystem.grey[400],
              iconSize: 28,
              splashColor: ColorSystem.transparent,
              highlightColor: ColorSystem.transparent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 36),
        SizedBox(
          width: double.infinity,
          child: RoundedRectangleTextButton(
            text: '학습 시작',
            width: double.infinity,
            height: 60,
            backgroundColor: ColorSystem.blue,
            textStyle: FontSystem.KR16SB.copyWith(color: ColorSystem.white),
            onPressed: () {
              Get.toNamed(Routes.TEST);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExamMode(List<Exam> exams) {
    return Column(
      children: exams
          .map((exam) => ExamCard(
                exam: exam,
                onTap: () {
                  Get.toNamed(Routes.TEST);
                },
              ))
          .toList(),
    );
  }
}
