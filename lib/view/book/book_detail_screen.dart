import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/view/book/widget/question_card.dart';
import 'package:rest_test/view/book/widget/more_options_bottom_sheet.dart';

class BookDetailScreen extends BaseScreen<BookViewModel> {
  final int studybookId;
  final String studybookName;
  final String createdDate;

  const BookDetailScreen({
    super.key,
    required this.studybookId,
    required this.studybookName,
    required this.createdDate,
  });

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.back;

  @override
  Color? get screenBackgroundColor => ColorSystem.back;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        studybookName,
        style: FontSystem.KR20SB,
      ),
      backgroundColor: ColorSystem.back,
      surfaceTintColor: ColorSystem.back,
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => MoreOptionsBottomSheet.show(
            context,
            studybookId: studybookId,
            studybookName: studybookName,
            createdDate: createdDate,
            controller: controller,
            onDelete: () => controller.deleteStudyBook(studybookId),
          ),
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: controller.fetchStudyBookDetail(studybookId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              '문제집 정보를 불러올 수 없습니다',
              style: FontSystem.KR14M.copyWith(
                color: ColorSystem.grey[600],
              ),
            ),
          );
        }

        final data = snapshot.data ?? {};
        final questions = (data['questions'] as List?) ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 문제 목록 섹션
              const Text(
                '문제 목록',
                style: FontSystem.KR16B,
              ),
              const SizedBox(height: 12),

              // 문제 목록 표시
              if (questions.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      '아직 문제가 없습니다',
                      style: FontSystem.KR14M.copyWith(
                        color: ColorSystem.grey[600],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return QuestionCard(
                        question: question,
                        index: index,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
