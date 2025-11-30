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
    final RxInt step = 0.obs; // 0: 초기 상태, 1: 정답 공개, 2: 해설 공개

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
                                    color: step.value >= 1 && i + 1 == answer
                                        ? ColorSystem.blue
                                        : ColorSystem.grey[200],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: FontSystem.KR12B.copyWith(
                                        color: step.value >= 1 && i + 1 == answer
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
                                        color: step.value >= 1 && i + 1 == answer
                                            ? ColorSystem.blue
                                            : ColorSystem.black,
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
              // 해설 및 버튼
              if (step.value == 2)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    explanation,
                    style: FontSystem.KR12M.copyWith(color: ColorSystem.grey[800]),
                  ),
                ),
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
                child: TextButton(
                  onPressed: () {
                    if (step.value == 0) {
                      step.value = 1; // 정답 공개
                    } else if (step.value == 1) {
                      step.value = 2; // 해설 공개
                    } else {
                      step.value = 0; // 초기 상태로
                    }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: ColorSystem.blue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    step.value == 0
                        ? '정답 보기'
                        : step.value == 1
                            ? '해설 보기'
                            : '해설 접기',
                    style: FontSystem.KR12B.copyWith(
                      color: ColorSystem.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
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