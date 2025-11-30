import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class BookInfoDialog extends StatelessWidget {
  final int studybookId;
  final String studybookName;
  final String createdDate;
  final BookViewModel controller;

  const BookInfoDialog({
    super.key,
    required this.studybookId,
    required this.studybookName,
    required this.createdDate,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: controller.fetchStudyBookDetail(studybookId),
      builder: (context, snapshot) {
        final questions = (snapshot.data?['questions'] as List?) ?? [];

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
                  '문제집 정보',
                  style: FontSystem.KR20B.copyWith(
                    color: ColorSystem.black,
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoRow('문제집 이름', studybookName),
                const SizedBox(height: 16),
                _buildInfoRow('생성일', createdDate),
                const SizedBox(height: 16),
                _buildInfoRow('문제 개수', '${questions.length}개'),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: RoundedRectangleTextButton(
                    text: '확인',
                    textStyle: FontSystem.KR16M.copyWith(
                      color: ColorSystem.white,
                    ),
                    backgroundColor: ColorSystem.blue,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: FontSystem.KR14M.copyWith(
              color: ColorSystem.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: FontSystem.KR14M.copyWith(
              color: ColorSystem.black,
            ),
          ),
        ),
      ],
    );
  }

  static void show(
    BuildContext context, {
    required int studybookId,
    required String studybookName,
    required String createdDate,
    required BookViewModel controller,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BookInfoDialog(
          studybookId: studybookId,
          studybookName: studybookName,
          createdDate: createdDate,
          controller: controller,
        );
      },
    );
  }
}
