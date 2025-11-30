import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/book/subscribe_screen.dart';
import 'package:rest_test/view/book/book_creation_complete_screen.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

class AddFileModal extends StatefulWidget {
  final BookViewModel controller;
  const AddFileModal({super.key, required this.controller});

  @override
  State<AddFileModal> createState() => _AddFileModalState();
}

class _AddFileModalState extends State<AddFileModal> {
  late BuildContext _loadingDialogContext;
  bool _isLoadingDialogShown = false;

  /// 선택된 파일들 (XFile 그대로 사용)
  final List<Map<String, dynamic>> _selectedFiles = [];

  bool get _hasFile => _selectedFiles.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _setupLoadingListener();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _setupLoadingListener() {
    widget.controller.isLoading.listen((isLoading) {
      if (isLoading && !_isLoadingDialogShown && mounted) {
        _isLoadingDialogShown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            _loadingDialogContext = context;
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: ColorSystem.blue,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '문제집 생성 중...',
                    style: FontSystem.KR16M.copyWith(
                      color: ColorSystem.white,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else if (!isLoading && _isLoadingDialogShown && mounted) {
        _isLoadingDialogShown = false;
        try {
          Navigator.of(_loadingDialogContext).pop();
        } catch (_) {}
      }
    });
  }

  Future<void> _selectFileFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null && mounted) {
      setState(() {
        _selectedFiles.add({
          'name': image.name,
          'file': image,
        });
      });
    }
  }

  Future<void> _takePhoto(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (image != null && mounted) {
      setState(() {
        _selectedFiles.add({
          'name': image.name,
          'file': image,
        });
      });
    }
  }

  Future<void> _createStudyBook() async {
    if (_selectedFiles.isEmpty) {
      Get.snackbar('오류', '파일을 선택해주세요.');
      return;
    }

    final bookName = widget.controller.getStudyBookName();
    if (bookName == null || bookName.trim().isEmpty) {
      Get.snackbar('오류', '문제집 이름을 입력해주세요.');
      return;
    }

    // 마지막 선택된 파일로 문제집 생성
    widget.controller.setSelectedFile(_selectedFiles.last['file']);
    final success = await widget.controller.createStudyBook(
      studyBookName: bookName,
      answers: [],
    );

    if (success && mounted) {
      Navigator.of(context).pop(); // 모달 닫기

      // 가장 최근에 생성된 문제집 찾기
      await widget.controller.fetchBooks();
      final books = widget.controller.files;
      int? studybookId;
      String? createdDate;

      if (books.isNotEmpty) {
        // 이름이 일치하는 가장 최근 문제집 찾기
        final matchingBooks = books
            .where((book) => (book['name'] as String?) == bookName)
            .toList();

        if (matchingBooks.isNotEmpty) {
          // 가장 최근 것 (첫 번째) 선택
          final latestBook = matchingBooks.first;
          studybookId = latestBook['id'] as int?;
          createdDate = latestBook['date'] as String?;
        }
      }

      // 완료 화면으로 이동
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookCreationCompleteScreen(
            bookName: bookName,
            studybookId: studybookId,
            createdDate: createdDate,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLimit = widget.controller.remainingCount.value == 0;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const SizedBox(height: 16),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: ColorSystem.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(height: 16),
                if (!_hasFile) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: SvgPicture.asset(
                      'assets/images/logo_blue.svg',
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                    child: Text(
                      isLimit
                          ? '이번달 문제 만들기를 모두 사용하셨어요!'
                          : '이번달 문제 만들기 ${widget.controller.remainingCount.value}회 남았습니다',
                      style: FontSystem.KR20B,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      isLimit
                          ? '구독제를 결제하시거나\n다음달까지 기다려주세요^0^'
                          : '이미지 업로드나 문제를 촬영하시면\n나의 문제집에 문제가 저장됩니다!',
                      textAlign: TextAlign.center,
                      style: FontSystem.KR16M.copyWith(
                        color: ColorSystem.grey[600],
                      ),
                    ),
                  ),
                ],
                if (_hasFile) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '선택된 파일: ${_selectedFiles.length}개',
                      style: FontSystem.KR14M.copyWith(
                        color: ColorSystem.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorSystem.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: _selectedFiles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedFiles[index]['name'],
                                  style: FontSystem.KR12M,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFiles.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: ColorSystem.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RoundedRectangleTextButton(
                          text: _hasFile
                              ? '파일 추가'
                              : (isLimit ? '돌아가기' : '파일 업로드'),
                          textStyle: FontSystem.KR16B.copyWith(
                            color: _hasFile
                                ? ColorSystem.white
                                : isLimit
                                    ? ColorSystem.grey[400]
                                    : ColorSystem.white,
                          ),
                          onPressed: widget.controller.isLoading.value
                              ? null
                              : () {
                                  if (_hasFile) {
                                    // 추가 파일 선택 (갤러리)
                                    _selectFileFromGallery(context);
                                  } else {
                                    if (isLimit) {
                                      Navigator.of(context).pop();
                                    } else {
                                      _selectFileFromGallery(context);
                                    }
                                  }
                                },
                          backgroundColor: _hasFile
                              ? ColorSystem.blue
                              : isLimit
                                  ? ColorSystem.grey[200]
                                  : ColorSystem.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RoundedRectangleTextButton(
                          text: _hasFile
                              ? '문제집 생성'
                              : (isLimit ? '구독제 보러가기' : '촬영하기'),
                          textStyle: FontSystem.KR16B.copyWith(
                            color: ColorSystem.white,
                          ),
                          onPressed: widget.controller.isLoading.value
                              ? null
                              : () {
                                  if (_hasFile) {
                                    _createStudyBook();
                                  } else {
                                    if (isLimit) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const SubscribeScreen(),
                                        ),
                                      );
                                    } else {
                                      _takePhoto(context);
                                    }
                                  }
                                },
                          backgroundColor: ColorSystem.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
