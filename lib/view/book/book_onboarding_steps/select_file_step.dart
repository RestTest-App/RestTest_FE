import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';

// 파일 선택 페이지
class SelectFileStep extends StatefulWidget {
  final String bookName;
  final ValueChanged<List<XFile>>? onFilesSelected;

  const SelectFileStep({
    super.key,
    required this.bookName,
    this.onFilesSelected,
  });

  @override
  State<SelectFileStep> createState() => _SelectFileStepState();
}

class _SelectFileStepState extends State<SelectFileStep> {
  final List<XFile> _selectedFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _selectedFiles.add(image);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _createStudyBook() async {
    if (_selectedFiles.isEmpty) {
      Get.snackbar('오류', '파일을 선택해주세요.');
      return;
    }

    try {
      final bookViewModel = Get.find<BookViewModel>();
      // 첫 번째 파일로 문제집 생성
      bookViewModel.setSelectedFile(_selectedFiles.first);

      // 정답 목록은 빈 배열로 전달 (AddAnswersStep에서 가져와야 함)
      final success = await bookViewModel.createStudyBook(
        studyBookName: widget.bookName,
        answers: [],
      );

      if (success) {
        widget.onFilesSelected?.call(_selectedFiles);
      }
    } catch (e) {
      Get.snackbar('오류', '문제집 생성에 실패했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          '파일을 선택해주세요',
          style: FontSystem.KR22B,
        ),
        const SizedBox(height: 8),
        Text(
          '이미지를 선택하거나 촬영할 수 있어요',
          style: FontSystem.KR16M.copyWith(color: ColorSystem.grey[600]),
        ),
        const SizedBox(height: 24),
        Text(
          '선택된 파일: ${_selectedFiles.length}개',
          style: FontSystem.KR14M.copyWith(color: ColorSystem.grey[600]),
        ),
        const SizedBox(height: 12),
        if (_selectedFiles.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorSystem.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorSystem.grey[300]!,
                width: 1,
              ),
            ),
            child: Column(
              children: List.generate(
                _selectedFiles.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedFiles[index].name,
                          style: FontSystem.KR14M,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeFile(index),
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: ColorSystem.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: RoundedRectangleTextButton(
            text: '파일 선택',
            textStyle: FontSystem.KR16B.copyWith(color: ColorSystem.white),
            backgroundColor: ColorSystem.blue,
            onPressed: _selectImage,
          ),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: RoundedRectangleTextButton(
              text: '문제집 생성',
              textStyle: FontSystem.KR16B.copyWith(color: ColorSystem.white),
              backgroundColor: ColorSystem.blue,
              onPressed: _createStudyBook,
            ),
          ),
        ],
      ],
    );
  }
}
