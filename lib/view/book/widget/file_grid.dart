import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'dart:math' as math;
import 'package:rest_test/view/book/book_onboarding_screen.dart';
// import 'package:rest_test/view/book/widget/add_file_modal.dart'; // 기존 모달

// 문제집 그리드
class FileGrid extends BaseWidget<BookViewModel> {
  @override
  final BookViewModel controller;
  const FileGrid({super.key, required this.controller});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() {
      final files = List<Map<String, dynamic>>.from(controller.files);
      files.insert(0, {'isNew': true});
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 89 / 120,
        ),
        itemCount: files.length,
        itemBuilder: (context, index) {
          if (files[index]['isNew'] == true) {
            return AddNewFileTile(controller: controller);
          }
          return FileTile(file: files[index]);
        },
      );
    });
  }
}

// 문제집 추가 타일
class AddNewFileTile extends StatelessWidget {
  final BookViewModel controller;
  const AddNewFileTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openCreateProblemPage(context),
      // onTap: () => _showAddModal(context), // 기존 모달 유지 메모
      child: SizedBox(
        width: 89,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DottedBorder(
              color: ColorSystem.blue,
              strokeWidth: 1.5,
              dashPattern: const [8, 6],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: SizedBox(
                width: 89,
                height: 100,
                child: Center(
                  child: Text(
                    '+',
                    style: FontSystem.KR24B.copyWith(
                      color: ColorSystem.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '신규',
                  style: FontSystem.KR12SB.copyWith(
                    color: ColorSystem.blue,
                  ),
                ),
                const SizedBox(width: 2),
                Transform.rotate(
                  angle: math.pi / 2,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: ColorSystem.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openCreateProblemPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CreateMyProblemSetPage(),
      ),
    );
  }

  /*
  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorSystem.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddFileModal(controller: controller),
    );
  }
  */
}

// 문제집 타일
class FileTile extends StatelessWidget {
  final Map<String, dynamic> file;
  const FileTile({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 89,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 89,
            height: 100,
            decoration: BoxDecoration(
              color: ColorSystem.back,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.zero,
            child: Center(
              child: Image.asset(
                'assets/images/book_file.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            file['name'] ?? '',
            style: FontSystem.KR12SB,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            file['date'] ?? '',
            style: FontSystem.KR10SB.copyWith(
              color: ColorSystem.grey[400],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
