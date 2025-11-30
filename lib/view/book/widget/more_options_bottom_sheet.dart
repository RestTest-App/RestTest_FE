import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/utility/static/app_routes.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/viewmodel/root/root_view_model.dart';
import 'package:rest_test/view/book/widget/book_info_dialog.dart';
import 'package:rest_test/view/book/widget/delete_confirm_dialog.dart';

class MoreOptionsBottomSheet extends StatelessWidget {
  final int studybookId;
  final String studybookName;
  final String createdDate;
  final BookViewModel controller;
  final Future<bool> Function() onDelete;
  final BuildContext? parentContext;

  const MoreOptionsBottomSheet({
    super.key,
    required this.studybookId,
    required this.studybookName,
    required this.createdDate,
    required this.controller,
    required this.onDelete,
    this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorSystem.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                BookInfoDialog.show(
                  context,
                  studybookId: studybookId,
                  studybookName: studybookName,
                  createdDate: createdDate,
                  controller: controller,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: ColorSystem.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ColorSystem.grey[800],
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '문제집 정보 보기',
                      style: FontSystem.KR16M.copyWith(
                        color: ColorSystem.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                final navigatorContext = parentContext ?? context;
                DeleteConfirmDialog.show(
                  navigatorContext,
                  onDelete: () async {
                    final success = await onDelete();
                    if (success) {
                      // 다이얼로그가 닫힌 후 네비게이션 수행
                      await Future.delayed(const Duration(milliseconds: 100));
                      // 모든 화면을 닫고 RootScreen으로 이동한 후 BookScreen 탭 선택
                      Get.offAllNamed(Routes.ROOT);
                      // 문제집 탭(인덱스 2)으로 이동
                      Future.microtask(() {
                        try {
                          final rootViewModel = Get.find<RootViewModel>();
                          rootViewModel.fetchIndex(2);
                        } catch (e) {
                          // ViewModel을 찾을 수 없으면 무시
                        }
                      });
                    }
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: ColorSystem.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      color: ColorSystem.red,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '문제집 삭제',
                      style: FontSystem.KR16M.copyWith(
                        color: ColorSystem.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required int studybookId,
    required String studybookName,
    required String createdDate,
    required BookViewModel controller,
    required Future<bool> Function() onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return MoreOptionsBottomSheet(
          studybookId: studybookId,
          studybookName: studybookName,
          createdDate: createdDate,
          controller: controller,
          onDelete: onDelete,
          parentContext: context, // 원본 context 전달
        );
      },
    );
  }
}
