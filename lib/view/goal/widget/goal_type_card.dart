import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/goal/goal_setting_view_model.dart';
import 'package:rest_test/model/goal/goal_progress.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class GoalTypeCard extends StatelessWidget {
  final GoalType type;
  final String title;
  final String description;

  const GoalTypeCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<GoalSettingViewModel>();

    return Obx(() {
      final isSelected = viewModel.isGoalTypeSelected(type);
      final goalValue = viewModel.getGoalValue(type);

      return GestureDetector(
        onTap: () {
          _showGoalValueDialog(context, type, title, goalValue);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorSystem.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? ColorSystem.blue : ColorSystem.grey[400]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    isSelected
                        ? 'assets/icons/test/radioBtnSelected.svg'
                        : 'assets/icons/test/radioBtn.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
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
                ],
              ),
              if (isSelected && goalValue > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorSystem.lightBlue,
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _getGoalValueText(type, goalValue),
                        style: FontSystem.KR14SB.copyWith(
                          color: ColorSystem.blue,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          viewModel.removeGoal(type);
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: ColorSystem.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  String _getGoalValueText(GoalType type, double value) {
    switch (type) {
      case GoalType.dailyProblem:
        return '하루에 ${value.toInt()}문제';
      case GoalType.dailyAccuracy:
        return '하루 정답률 ${value.toInt()}% 이상';
      case GoalType.consecutiveStudyDays:
        return '연속 ${value.toInt()}일 학습';
    }
  }

  void _showGoalValueDialog(
      BuildContext context, GoalType type, String title, double currentValue) {
    final viewModel = Get.find<GoalSettingViewModel>();
    final controller = TextEditingController(
      text: currentValue > 0 ? currentValue.toInt().toString() : '',
    );
    final focusNode = FocusNode();

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontSystem.KR18B.copyWith(color: ColorSystem.black),
                ),
                const SizedBox(height: 8),
                Text(
                  _getInputHint(type),
                  style:
                      FontSystem.KR14M.copyWith(color: ColorSystem.grey[600]),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (context, value, child) {
                    final isFocused = focusNode.hasFocus;
                    final hasText = value.text.isNotEmpty;

                    Color borderColor;
                    if (isFocused || hasText) {
                      borderColor = ColorSystem.grey[400]!;
                    } else {
                      borderColor = ColorSystem.grey[300]!;
                    }

                    return GestureDetector(
                      onTap: () => focusNode.requestFocus(),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: ColorSystem.back,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: borderColor,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: TextAlign.center,
                          style: FontSystem.KR16M.copyWith(
                            color: isFocused || hasText
                                ? ColorSystem.grey[800]
                                : ColorSystem.grey[400],
                          ),
                          decoration: InputDecoration(
                            hintText: _getPlaceholder(type),
                            hintStyle: FontSystem.KR16M.copyWith(
                              color: ColorSystem.grey[400],
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
                          final value = int.tryParse(controller.text);
                          if (value != null && value > 0) {
                            viewModel.setGoalValue(type, value.toDouble());
                            Get.back();
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

  String _getPlaceholder(GoalType type) {
    switch (type) {
      case GoalType.dailyProblem:
        return '예) 10(문제)';
      case GoalType.dailyAccuracy:
        return '예) 70(%)';
      case GoalType.consecutiveStudyDays:
        return '예) 7(일)';
    }
  }
}
