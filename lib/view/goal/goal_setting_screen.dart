import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/goal/goal_setting_view_model.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/utility/static/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return AppBar(
      title: const Text(
        '목표 설정',
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
        onPressed: () => _handleBackPress(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: ColorSystem.blue,
            size: 28,
          ),
          onPressed: () {
            Get.toNamed(Routes.ADD_GOAL);
          },
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            final viewModel = Get.find<GoalSettingViewModel>();
            final goals = viewModel.selectedGoals;

            if (goals.isEmpty) {
              return _buildEmptyState(context);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ...goals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final goal = entry.value;
                    return Column(
                      children: [
                        if (index > 0) const SizedBox(height: 4),
                        _buildGoalItem(context, goal, viewModel),
                      ],
                    );
                  }),
                ],
              ),
            );
          }),
        ),
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/logo_blue.svg',
            width: 64,
            height: 64,
            colorFilter: ColorFilter.mode(
              ColorSystem.grey[400]!,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '설정된 목표가 없습니다',
            style: FontSystem.KR16M.copyWith(color: ColorSystem.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            '+ 버튼을 눌러 목표를 추가해보세요',
            style: FontSystem.KR14M.copyWith(color: ColorSystem.grey[400]),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(
      BuildContext context, GoalItem goal, GoalSettingViewModel viewModel) {
    // 메인화면과 동일한 디자인으로 표시
    final goalNumber = viewModel.selectedGoals.indexOf(goal) + 1;
    final goalText = _getGoalValueText(goal.type, goal.value);
    final double barWidth =
        MediaQuery.of(context).size.width - 64; // padding 고려

    // 개별 목표 진행도 조회
    final goalProgress = viewModel.getGoalProgress(goal.goalId);
    final progress = goalProgress != null
        ? (goalProgress.achievementRate / 100.0).clamp(0.0, 1.0)
        : 0.0;

    // 진행 상황 텍스트 생성
    String progressText = '';
    if (goalProgress != null) {
      if (goal.type == GoalType.dailyProblem) {
        progressText =
            '${goalProgress.currentValue.toInt()}/${goal.value.toInt()} 문제';
      } else if (goal.type == GoalType.dailyAccuracy) {
        progressText =
            '${goalProgress.achievementRate.toStringAsFixed(1)}% / ${goal.value.toInt()}%';
      } else if (goal.type == GoalType.consecutiveStudyDays) {
        progressText =
            '${goalProgress.currentValue.toInt()}/${goal.value.toInt()}일';
      }
    } else {
      if (goal.type == GoalType.dailyProblem) {
        progressText = '0/${goal.value.toInt()} 문제';
      } else if (goal.type == GoalType.dailyAccuracy) {
        progressText = '0.0% / ${goal.value.toInt()}%';
      } else if (goal.type == GoalType.consecutiveStudyDays) {
        progressText = '0/${goal.value.toInt()}일';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorSystem.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '목표$goalNumber',
                  style:
                      FontSystem.KR10SB.copyWith(color: ColorSystem.grey[600]),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  goalText,
                  style:
                      FontSystem.KR16B.copyWith(color: ColorSystem.grey[800]),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.edit,
                  size: 18,
                  color: ColorSystem.grey[400],
                ),
                onPressed: () {
                  _showEditGoalDialog(context, goal, viewModel);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: barWidth,
            height: 22,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorSystem.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorSystem.blue.withAlpha(128),
                          ColorSystem.blue.withAlpha(255),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: barWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progressText,
                  style:
                      FontSystem.KR10M.copyWith(color: ColorSystem.grey[600]),
                ),
                Text(
                  goalProgress != null
                      ? '${goalProgress.achievementRate.toStringAsFixed(1)}%'
                      : '0.0%',
                  style: FontSystem.KR10M.copyWith(
                    color: ColorSystem.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGoalTitle(GoalType type) {
    switch (type) {
      case GoalType.dailyProblem:
        return '일일 문제 풀기';
      case GoalType.dailyAccuracy:
        return '정답률 목표';
      case GoalType.consecutiveStudyDays:
        return '연속 학습';
    }
  }

  String _getGoalValueText(GoalType type, double value) {
    switch (type) {
      case GoalType.dailyProblem:
        return '하루에 ${value.toInt()}문제';
      case GoalType.dailyAccuracy:
        return '정답률 ${value.toInt()}% 이상';
      case GoalType.consecutiveStudyDays:
        return '연속 ${value.toInt()}일 학습';
    }
  }

  void _showEditGoalDialog(
      BuildContext context, GoalItem goal, GoalSettingViewModel viewModel) {
    final title = _getGoalTitle(goal.type);
    final availableValues = _getAvailableValues(goal.type);
    int selectedValue = goal.value.toInt();
    // 현재 값이 availableValues에 없으면 첫 번째 값으로 설정
    if (!availableValues.contains(selectedValue)) {
      selectedValue = availableValues.first;
    }

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
                      _getInputHint(goal.type),
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
                            _getValueText(goal.type, selectedValue),
                            style: FontSystem.KR24B,
                            textAlign: TextAlign.center,
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
                            text: '삭제',
                            textStyle: FontSystem.KR16M.copyWith(
                              color: ColorSystem.red,
                            ),
                            backgroundColor: const Color(0xFFF5EBEB),
                            borderSide: BorderSide(
                              color: ColorSystem.red,
                              width: 1,
                            ),
                            onPressed: () {
                              viewModel.removeGoal(goal.id);
                              Get.back();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: RoundedRectangleTextButton(
                            text: '수정',
                            textStyle: FontSystem.KR16M.copyWith(
                              color: ColorSystem.white,
                            ),
                            backgroundColor: ColorSystem.blue,
                            onPressed: () {
                              // 기존 목표 제거 후 새 값으로 추가
                              viewModel.removeGoal(goal.id);
                              viewModel.addGoal(
                                  goal.type, selectedValue.toDouble());
                              Get.back();
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

  void _handleBackPress(BuildContext context) {
    final viewModel = Get.find<GoalSettingViewModel>();
    if (viewModel.hasChanges && viewModel.selectedGoals.isNotEmpty) {
      _showSaveConfirmDialog(context);
    } else {
      Get.back();
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
                          final success = await viewModel.saveGoals();
                          if (success) {
                            viewModel.refreshHomeGoals();
                            Get.back(); // 다이얼로그 닫기
                            Get.back(); // 목표 설정 화면 닫기
                          } else {
                            Get.back(); // 다이얼로그만 닫기 (저장 실패 시)
                          }
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
            text: '목표 설정하기',
            height: 56,
            backgroundColor: canSave ? ColorSystem.blue : ColorSystem.grey[400],
            textStyle: FontSystem.KR16B.copyWith(color: ColorSystem.white),
            onPressed: canSave
                ? () async {
                    final success = await viewModel.saveGoals();
                    if (success) {
                      viewModel.refreshHomeGoals();
                      Get.back();
                    }
                  }
                : null,
          ),
        ),
      );
    });
  }
}
