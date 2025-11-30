import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';

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
      centerTitle: false,
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMoreOptions(context),
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
              // 문제집 정보
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: ColorSystem.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studybookName,
                              style: FontSystem.KR18B,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '생성일: $createdDate',
                              style: FontSystem.KR12M.copyWith(
                                color: ColorSystem.grey[600],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '문제: ${questions.length}개',
                              style: FontSystem.KR12M.copyWith(
                                color: ColorSystem.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/book_file.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 문제 목록 섹션
              Text(
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
                      return _buildQuestionCard(question, index);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, int index) {
    final description = question['description'] ?? '문제 없음';
    final options = (question['options'] as List?) ?? [];
    final answer = question['answer'] ?? 0;
    final explanation = question['explanation'] ?? '';

    // 상태 관리 변수 추가
    final RxBool showAnswer = false.obs; // true: 정답 공개됨

    return Obx(() => Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: ColorSystem.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorSystem.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 문제 번호
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: ColorSystem.blue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    topRight: Radius.circular(11),
                  ),
                ),
                child: Text(
                  '문제 ${index + 1}',
                  style: FontSystem.KR14B.copyWith(
                    color: ColorSystem.white,
                  ),
                ),
              ),
              // 문제 내용
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: FontSystem.KR14M,
                    ),
                    if (options.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          options.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: showAnswer.value && i + 1 == answer
                                        ? ColorSystem.blue
                                        : ColorSystem.grey[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: FontSystem.KR12B.copyWith(
                                        color: showAnswer.value && i + 1 == answer
                                            ? ColorSystem.white
                                            : ColorSystem.grey[600],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      options[i],
                                      style: FontSystem.KR12M.copyWith(
                                        color: ColorSystem.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // 버튼
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: ColorSystem.grey[200]!,
                      width: 1,
                    ),
                  ),
                ),
                child: Builder(
                  builder: (context) => TextButton(
                    onPressed: () {
                      if (!showAnswer.value) {
                        // 정답 보기 클릭
                        showAnswer.value = true;
                      } else {
                        // 해설 보기 클릭
                        _showExplanation(context, description, explanation);
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: ColorSystem.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      showAnswer.value ? '해설 보기' : '정답 보기',
                      style: FontSystem.KR12B.copyWith(
                        color: ColorSystem.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _showExplanation(BuildContext context, String description, String explanation) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
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
              const Text(
                '해설',
                style: FontSystem.KR18B,
              ),
              const SizedBox(height: 20),
              Text(
                '문제',
                style: FontSystem.KR14B.copyWith(
                  color: ColorSystem.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: FontSystem.KR14M,
              ),
              const SizedBox(height: 24),
              Text(
                '해설',
                style: FontSystem.KR14B.copyWith(
                  color: ColorSystem.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                explanation,
                style: FontSystem.KR14M,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () => Navigator.pop(dialogContext),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: ColorSystem.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '닫기',
                        style: FontSystem.KR16M.copyWith(
                          color: ColorSystem.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    // ... 기존 코드 ...
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    // ... 기존 코드 ...
  }

  void _deleteStudyBook(BuildContext context) async {
    // ... 기존 코드 ...
  }
}