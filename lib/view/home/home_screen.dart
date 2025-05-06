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

    final mockExams = [
      Exam(
        examId: '9309281038',
        examName: '2024년 3회 정보처리기사',
        questionCount: 50,
        examTime: 80,
        passRate: 55.79,
      ),
      Exam(
        examId: '92774282362',
        examName: '2024년 2회 정보처리기사',
        questionCount: 50,
        examTime: 80,
        passRate: 62.82,
      ),
    ];

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
          const GoalCard(),
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
                  Row(
                    children: [
                      _buildModeButton("쉬엄 모드", true, isRestMode),
                      _buildModeButton("시험 모드", false, isRestMode),
                    ],
                  ),
                  const SizedBox(height: 24),
                  isRestMode.value
                      ? _buildRestMode(questionCount)
                      : _buildExamMode(mockExams),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildModeButton(String text, bool value, RxBool group) {
    final isSelected = group.value == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => group.value = value,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? ColorSystem.white : ColorSystem.back,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: FontSystem.KR18B.copyWith(
              color: isSelected ? ColorSystem.deepBlue : ColorSystem.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconCounterButton(IconData icon, VoidCallback onPressed) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 32,
      onPressed: onPressed,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSystem.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: ColorSystem.black,
        ),
      ),
    );
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
            // 수정 끝

            const SizedBox(width: 16),

            IconButton(
              onPressed: count.value < 20 ? () => count.value += 5 : null,
              icon: const Icon(Icons.arrow_right),
              color:
                  count.value < 20 ? ColorSystem.blue : ColorSystem.grey[400],
              iconSize: 28,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: ColorSystem.blue,
              borderRadius: BorderRadius.circular(10),
              child: const Text("학습 시작", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Get.snackbar("시작", "${count.value}문제 학습 시작!",
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
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
                onTap: () => Get.snackbar("시험 선택됨", exam.examName,
                    snackPosition: SnackPosition.BOTTOM),
              ))
          .toList(),
    );
  }
}
