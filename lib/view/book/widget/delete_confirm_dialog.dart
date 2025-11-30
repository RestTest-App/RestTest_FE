import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class DeleteConfirmDialog extends StatelessWidget {
  final Future<void> Function() onDelete;

  const DeleteConfirmDialog({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              '문제집을 삭제하시겠어요?',
              textAlign: TextAlign.center,
              style: FontSystem.KR18B.copyWith(color: ColorSystem.black),
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedRectangleTextButton(
                    text: '삭제',
                    textStyle: FontSystem.KR16M.copyWith(
                      color: ColorSystem.white,
                    ),
                    backgroundColor: ColorSystem.red,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await onDelete();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required Future<void> Function() onDelete,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DeleteConfirmDialog(onDelete: onDelete);
      },
    );
  }
}
