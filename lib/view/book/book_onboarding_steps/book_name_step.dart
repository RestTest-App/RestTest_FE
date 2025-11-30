import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';

// 6. 문제집 이름 설정 페이지
class BookNameStep extends StatefulWidget {
  final String? initialName;
  final ValueChanged<String>? onNameChanged;

  const BookNameStep({
    super.key,
    this.initialName,
    this.onNameChanged,
  });

  @override
  State<BookNameStep> createState() => _BookNameStepState();
}

class _BookNameStepState extends State<BookNameStep> {
  late TextEditingController _nameController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _nameController.addListener(() {
      widget.onNameChanged?.call(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildInputField() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _nameController,
      builder: (context, value, child) {
        final isFocused = _focusNode.hasFocus;
        final hasText = value.text.isNotEmpty;

        Color borderColor;
        if (isFocused || hasText) {
          borderColor = ColorSystem.grey[400]!;
        } else {
          borderColor = ColorSystem.grey[300]!;
        }

        return GestureDetector(
          onTap: () => _focusNode.requestFocus(),
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
              controller: _nameController,
              focusNode: _focusNode,
              maxLength: 50,
              textAlign: TextAlign.center,
              style: FontSystem.KR16M.copyWith(
                color: isFocused || hasText
                    ? ColorSystem.grey[800]
                    : ColorSystem.grey[400],
              ),
              decoration: InputDecoration(
                hintText: '문제집 이름',
                hintStyle: FontSystem.KR16M.copyWith(
                  color: ColorSystem.grey[400],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                counterText: '',
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          '문제집 이름을 설정해주세요',
          style: FontSystem.KR22B,
        ),
        const SizedBox(height: 24),
        const Text(
          '제목',
          style: FontSystem.KR14M,
        ),
        const SizedBox(height: 8),
        _buildInputField(),
      ],
    );
  }
}
