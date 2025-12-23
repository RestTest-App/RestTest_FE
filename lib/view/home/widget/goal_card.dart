import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';
import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/utility/static/app_routes.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<HomeViewModel>();

    return Obx(() {
      final hasGoals = viewModel.hasGoals;
      final goals = viewModel.goals;
      final isLoading = viewModel.isLoadingGoals;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorSystem.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isLoading
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              )
            : hasGoals
                ? _buildGoalsList(context, goals, viewModel)
                : _buildEmptyState(context),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.GOAL_SETTING);
      },
      child: Container(
        constraints: const BoxConstraints(minHeight: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo_blue.svg',
              width: 31,
              height: 31,
              colorFilter: ColorFilter.mode(
                ColorSystem.grey[400]!,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '목표가 있으면 공부가 더 쉬워져요.\n함께 학습 목표를 설정해볼까요?',
              textAlign: TextAlign.center,
              style: FontSystem.KR14M.copyWith(
                color: ColorSystem.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList(
      BuildContext context, List<GoalProgress> goals, HomeViewModel viewModel) {
    final nickname = viewModel.nickname.value;
    final displayName =
        nickname.isNotEmpty && nickname.trim().isNotEmpty ? nickname : '쉬엄시험해';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: FontSystem.KR18B,
                  children: [
                    TextSpan(
                      text: displayName,
                      style: FontSystem.KR18B.copyWith(color: ColorSystem.blue),
                    ),
                    TextSpan(
                      text: '님의 목표',
                      style: FontSystem.KR18B
                          .copyWith(color: ColorSystem.grey[800]),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.arrow_forward_ios,
                  size: 16, color: ColorSystem.grey[400]),
              onPressed: () {
                Get.toNamed(Routes.GOAL_SETTING);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...goals.asMap().entries.map((entry) {
          final index = entry.key;
          final goal = entry.value;
          return Column(
            children: [
              if (index > 0) const SizedBox(height: 24),
              _buildGoalRow(goal, context, index + 1),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildGoalRow(
      GoalProgress goal, BuildContext context, int goalNumber) {
    final double barWidth = MediaQuery.of(context).size.width - 32;
    final progress = (goal.achievementRate / 100.0).clamp(0.0, 1.0);
    final goalText = _getDefaultGoalText(goal);
    final targetValue = goal.targetValue.toInt();

    String progressText = '';
    if (goal.type == GoalType.dailyProblem) {
      progressText = '${goal.currentValue.toInt()}/$targetValue 문제';
    } else if (goal.type == GoalType.dailyAccuracy) {
      progressText = '${goal.currentValue.toStringAsFixed(1)}% / $targetValue%';
    } else if (goal.type == GoalType.consecutiveStudyDays) {
      progressText = '${goal.currentValue.toInt()}/$targetValue일';
    }

    return Column(
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
                style: FontSystem.KR10SB.copyWith(color: ColorSystem.grey[600]),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                goalText,
                style: FontSystem.KR12SB.copyWith(color: ColorSystem.grey[800]),
              ),
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
                style: FontSystem.KR10M.copyWith(color: ColorSystem.grey[600]),
              ),
              Text(
                '${goal.achievementRate.toStringAsFixed(1)}%',
                style: FontSystem.KR10M.copyWith(
                  color: goal.status == GoalStatus.achieved
                      ? ColorSystem.blue
                      : ColorSystem.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getDefaultGoalText(GoalProgress goal) {
    final displayValue = goal.targetValue.toInt();

    if (goal.type == GoalType.dailyProblem) {
      return '하루에 $displayValue문제';
    } else if (goal.type == GoalType.dailyAccuracy) {
      return '정답률 $displayValue% 이상';
    } else if (goal.type == GoalType.consecutiveStudyDays) {
      return '연속 $displayValue일 학습';
    }
    return goal.name;
  }
}
