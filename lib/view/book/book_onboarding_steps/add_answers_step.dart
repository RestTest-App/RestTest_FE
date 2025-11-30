import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

// 5. 답 추가 페이지
class AddAnswersStep extends StatefulWidget {
  final ValueChanged<bool>? onValidationChanged;

  const AddAnswersStep({super.key, this.onValidationChanged});

  @override
  State<AddAnswersStep> createState() => _AddAnswersStepState();
}

class _AnswerInputPair {
  final TextEditingController problemNumberController;
  final TextEditingController answerController;
  final FocusNode problemNumberFocus;
  final FocusNode answerFocus;

  _AnswerInputPair()
      : problemNumberController = TextEditingController(),
        answerController = TextEditingController(),
        problemNumberFocus = FocusNode(),
        answerFocus = FocusNode();

  void dispose() {
    problemNumberController.dispose();
    answerController.dispose();
    problemNumberFocus.dispose();
    answerFocus.dispose();
  }

  bool isValid() {
    final problemNumberText = problemNumberController.text;
    final answerText = answerController.text;

    // 문제 번호와 정답이 모두 입력되어야 유효
    if (problemNumberText.isEmpty || answerText.isEmpty) return false;

    final problemNumberValue = int.tryParse(problemNumberText);
    final answerValue = int.tryParse(answerText);

    // 문제 번호는 양수여야 하고, 정답은 1~10 사이여야 함
    return problemNumberValue != null &&
        problemNumberValue >= 1 &&
        answerValue != null &&
        answerValue >= 1 &&
        answerValue <= 10;
  }
}

class _AddAnswersStepState extends State<AddAnswersStep> {
  final List<_AnswerInputPair> _inputPairs = [];

  @override
  void initState() {
    super.initState();
    final firstPair = _AnswerInputPair();
    firstPair.problemNumberController.addListener(_validateAll);
    firstPair.answerController.addListener(_validateAll);
    _inputPairs.add(firstPair);
    // 초기 상태는 비활성화 - 빌드 완료 후 콜백 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateAll();
    });
  }

  void _addInputPair() {
    final pair = _AnswerInputPair();
    pair.problemNumberController.addListener(_validateAll);
    pair.answerController.addListener(_validateAll);
    setState(() {
      _inputPairs.add(pair);
    });
    // 추가 버튼을 누르면 비활성화 상태로 변경
    widget.onValidationChanged?.call(false);
    _validateAll();
  }

  void _validateAll() {
    final allValid = _inputPairs.every((pair) => pair.isValid());
    widget.onValidationChanged?.call(allValid);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final pair in _inputPairs) {
      pair.problemNumberController.removeListener(_validateAll);
      pair.answerController.removeListener(_validateAll);
      pair.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          '문제에 따라 답을 추가해 주세요!',
          style: FontSystem.KR22B.copyWith(height: 1.5),
        ),
        const SizedBox(height: 24),
        ...List.generate(_inputPairs.length, (index) {
          final pair = _inputPairs[index];
          final hasError =
              !pair.isValid() && pair.answerController.text.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      controller: pair.problemNumberController,
                      focusNode: pair.problemNumberFocus,
                      placeholder: '문제 번호',
                      isError: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInputField(
                      controller: pair.answerController,
                      focusNode: pair.answerFocus,
                      placeholder: '정답',
                      isError: hasError,
                    ),
                  ),
                ],
              ),
              if (hasError) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/test/reportIcon.svg',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '1~10 사이의 숫자입니다',
                      style: FontSystem.KR14M.copyWith(
                        color: ColorSystem.red,
                      ),
                    ),
                  ],
                ),
              ],
              if (index < _inputPairs.length - 1) const SizedBox(height: 24),
            ],
          );
        }),
        const SizedBox(height: 24),
        Center(
          child: GestureDetector(
            onTap: _addInputPair,
            child: Text(
              '+추가',
              style: FontSystem.KR16SB.copyWith(
                color: ColorSystem.grey[600],
                decoration: TextDecoration.underline,
                decorationColor: ColorSystem.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String placeholder,
    required bool isError,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final isFocused = focusNode.hasFocus;
        final hasText = value.text.isNotEmpty;

        Color borderColor;
        if (isError) {
          borderColor = ColorSystem.red;
        } else if (isFocused || hasText) {
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
                hintText: placeholder,
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
    );
  }
}
