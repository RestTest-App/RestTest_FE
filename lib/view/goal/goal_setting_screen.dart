import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/goal/goal_setting_view_model.dart';
import 'package:rest_test/widget/appbar/default_back_appbar.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/view/goal/widget/goal_type_card.dart';
import 'package:rest_test/model/goal/goal_progress.dart';

class GoalSettingScreen extends BaseScreen<GoalSettingViewModel> {
  const GoalSettingScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.white;

  @override
  Color? get screenBackgroundColor => ColorSystem.white;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(58),
      child: DefaultBackAppBar(
        title: '목표 설정',
        backColor: ColorSystem.white,
        titleStyle: FontSystem.KR20SB.copyWith(color: ColorSystem.black),
        backIconColor: ColorSystem.grey[600],
        onBackPress: () {
          _handleBackPress(context);
        },
        centerTitle: true,
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  '학습 목표를 설정해보세요',
                  style:
                      FontSystem.KR20B.copyWith(color: ColorSystem.grey[800]),
                ),
                const SizedBox(height: 8),
                Text(
                  '목표가 있으면 공부가 더 쉬워져요',
                  style:
                      FontSystem.KR16M.copyWith(color: ColorSystem.grey[600]),
                ),
                const SizedBox(height: 32),
                const GoalTypeCard(
                  type: GoalType.dailyProblem,
                  title: '일일 문제 풀기',
                  description: '하루에 몇 문제를 풀지 목표를 설정하세요',
                ),
                const SizedBox(height: 16),
                const GoalTypeCard(
                  type: GoalType.dailyAccuracy,
                  title: '정답률 목표',
                  description: '하루 정답률 목표를 설정하세요',
                ),
                const SizedBox(height: 16),
                const GoalTypeCard(
                  type: GoalType.consecutiveStudyDays,
                  title: '연속 학습',
                  description: '연속으로 며칠 학습할지 목표를 설정하세요',
                ),
              ],
            ),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  void _handleBackPress(BuildContext context) {
    final viewModel = Get.find<GoalSettingViewModel>();
    if (viewModel.hasChanges && viewModel.selectedGoals.isNotEmpty) {
      _showSaveConfirmDialog(context);
    } else {
      Get.back();
    }
  }

  void _showSaveConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorSystem.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '목표를 저장하시겠어요?',
                  textAlign: TextAlign.center,
                  style: FontSystem.KR16B.copyWith(color: ColorSystem.black),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: RoundedRectangleTextButton(
                        text: '취소',
                        textStyle: FontSystem.KR16M.copyWith(
                          color: ColorSystem.grey[600],
                        ),
                        backgroundColor: ColorSystem.back,
                        borderSide: BorderSide(
                          color: ColorSystem.grey[300]!,
                          width: 1,
                        ),
                        onPressed: () {
                          Get.back(); // 다이얼로그 닫기
                          Get.back(); // 목표 설정 화면 닫기
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RoundedRectangleTextButton(
                        text: '저장',
                        textStyle: FontSystem.KR16M.copyWith(
                          color: ColorSystem.white,
                        ),
                        backgroundColor: ColorSystem.blue,
                        onPressed: () async {
                          final viewModel = Get.find<GoalSettingViewModel>();
                          await viewModel.saveGoals();
                          viewModel.refreshHomeGoals();
                          Get.back(); // 다이얼로그 닫기
                          Get.back(); // 목표 설정 화면 닫기
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return Obx(() {
      final viewModel = Get.find<GoalSettingViewModel>();
      final canSave = viewModel.selectedGoals.isNotEmpty;
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: SizedBox(
          width: double.infinity,
          child: RoundedRectangleTextButton(
            text: '목표 저장하기',
            height: 56,
            backgroundColor: canSave ? ColorSystem.blue : ColorSystem.grey[400],
            textStyle: FontSystem.KR16B.copyWith(color: ColorSystem.white),
            onPressed: canSave
                ? () async {
                    await viewModel.saveGoals();
                    viewModel.refreshHomeGoals();
                    Get.back();
                  }
                : null,
          ),
        ),
      );
    });
  }
}
