import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/goal/goal_setting_view_model.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/model/goal/goal_progress.dart';

class AddGoalScreen extends StatelessWidget {
  const AddGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSystem.white,
      appBar: AppBar(
        title: const Text(
          '목표 추가',
          style: FontSystem.KR20SB,
        ),
        backgroundColor: ColorSystem.white,
        surfaceTintColor: ColorSystem.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: ColorSystem.grey[600],
            size: 28,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '학습 목표를 설정해보세요',
              style: FontSystem.KR22M.copyWith(color: ColorSystem.grey[800]),
            ),
            const SizedBox(height: 8),
            Text(
              '목표를 정하면 공부가 훨씬 쉬워져요',
              style: FontSystem.KR16M.copyWith(color: ColorSystem.grey[600]),
            ),
            const SizedBox(height: 32),
            _buildGoalTypeOption(
              context,
              GoalType.dailyProblem,
              '일일 문제 풀기',
              '하루에 몇 문제를 풀지 목표를 설정하세요',
            ),
            const SizedBox(height: 12),
            _buildGoalTypeOption(
              context,
              GoalType.dailyAccuracy,
              '정답률 목표',
              '하루 정답률 목표를 설정하세요',
            ),
            const SizedBox(height: 12),
            _buildGoalTypeOption(
              context,
              GoalType.consecutiveStudyDays,
              '연속 학습',
              '연속으로 며칠 학습할지 목표를 설정하세요',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalTypeOption(
    BuildContext context,
    GoalType type,
    String title,
    String description,
  ) {
    return GestureDetector(
      onTap: () {
        _showGoalValueDialog(context, type, title);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorSystem.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorSystem.grey[400]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FontSystem.KR16B.copyWith(
                      color: ColorSystem.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: FontSystem.KR12M.copyWith(
                      color: ColorSystem.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ColorSystem.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalValueDialog(BuildContext context, GoalType type, String title) {
    final viewModel = Get.find<GoalSettingViewModel>();
    final availableValues = _getAvailableValues(type);
    int selectedValue = availableValues.first;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final currentIndex = availableValues.indexOf(selectedValue);
            final canGoLeft = currentIndex > 0;
            final canGoRight = currentIndex < availableValues.length - 1;

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          FontSystem.KR18B.copyWith(color: ColorSystem.black),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getInputHint(type),
                      style: FontSystem.KR14M
                          .copyWith(color: ColorSystem.grey[600]),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: canGoLeft
                              ? () {
                                  setState(() {
                                    final newIndex = currentIndex - 1;
                                    selectedValue = availableValues[newIndex];
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.arrow_left),
                          color: canGoLeft
                              ? ColorSystem.blue
                              : ColorSystem.grey[400],
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: ColorSystem.white,
                            border: Border.all(color: ColorSystem.grey[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getValueText(type, selectedValue),
                            style: FontSystem.KR24B,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: canGoRight
                              ? () {
                                  setState(() {
                                    final newIndex = currentIndex + 1;
                                    selectedValue = availableValues[newIndex];
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.arrow_right),
                          color: canGoRight
                              ? ColorSystem.blue
                              : ColorSystem.grey[400],
                          iconSize: 28,
                          splashColor: ColorSystem.transparent,
                          highlightColor: ColorSystem.transparent,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
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
                            onPressed: () => Get.back(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RoundedRectangleTextButton(
                            text: '확인',
                            textStyle: FontSystem.KR16M.copyWith(
                              color: ColorSystem.white,
                            ),
                            backgroundColor: ColorSystem.blue,
                            onPressed: () {
                              viewModel.addGoal(type, selectedValue.toDouble());
                              Get.back(); // 다이얼로그 닫기
                              Get.back(); // 목표 추가 스크린 닫기
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
      },
    );
  }

  List<int> _getAvailableValues(GoalType type) {
    switch (type) {
      case GoalType.dailyProblem:
        return [10, 15, 20];
      case GoalType.dailyAccuracy:
        return [70, 80, 90];
      case GoalType.consecutiveStudyDays:
        return [3, 5, 7];
    }
  }

  String _getValueText(GoalType type, int value) {
    switch (type) {
      case GoalType.dailyProblem:
        return '$value';
      case GoalType.dailyAccuracy:
        return '$value';
      case GoalType.consecutiveStudyDays:
        return '$value';
    }
  }

  String _getInputHint(GoalType type) {
    switch (type) {
      case GoalType.dailyProblem:
        return '하루에 풀 문제 수를 입력하세요';
      case GoalType.dailyAccuracy:
        return '목표 정답률을 입력하세요 (1-100)';
      case GoalType.consecutiveStudyDays:
        return '연속 학습 일수를 입력하세요';
    }
  }
}
