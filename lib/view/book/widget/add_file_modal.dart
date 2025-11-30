import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/book/subscribe_screen.dart';
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28.0),
                  child: SvgPicture.asset('assets/images/logo_blue.svg',
                      height: 60, fit: BoxFit.cover),
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
                  padding: const EdgeInsets.only(bottom: 38.0),
                  child: Text(
                    isLimit
                        ? '구독제를 결제하시거나\n다음달까지 기다려주세요^0^'
                        : '이미지 업로드나 문제를 촬영하시면\n나의 문제집에 문제가 저장됩니다!',
                    textAlign: TextAlign.center,
                    style:
                        FontSystem.KR16M.copyWith(color: ColorSystem.grey[600]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RoundedRectangleTextButton(
                          text: isLimit ? '돌아가기' : '파일 선택',
                          textStyle: FontSystem.KR16B.copyWith(
                            color: isLimit
                                ? ColorSystem.grey[400]
                                : ColorSystem.white,
                          ),
                          onPressed: widget.controller.isLoading.value
                              ? null
                              : () {
                                  if (isLimit) {
                                    Navigator.of(context).pop();
                                  } else {
                                    _showFileSelectionDialog(context);
                                  }
                                },
                          backgroundColor: isLimit
                              ? ColorSystem.grey[200]
                              : ColorSystem.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RoundedRectangleTextButton(
                          text: isLimit ? '구독제 보러가기' : '촬영하기',
                          textStyle: FontSystem.KR16B.copyWith(
                            color: ColorSystem.white,
                          ),
                          onPressed: widget.controller.isLoading.value
                              ? null
                              : () {
                                  if (isLimit) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) => const SubscribeScreen()),
                                    );
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

  void _showFileSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _FileSelectionDialog(controller: widget.controller);
      },
    );
  }
}

class _FileSelectionDialog extends StatefulWidget {
  final BookViewModel controller;
  const _FileSelectionDialog({required this.controller});

  @override
  State<_FileSelectionDialog> createState() => _FileSelectionDialogState();
}

class _FileSelectionDialogState extends State<_FileSelectionDialog> {
  late TextEditingController _nameController;
  List<Map<String, dynamic>> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addFile() async {
    final file = await widget.controller.selectImage();
    if (file && mounted) {
      final selectedFile = widget.controller.getSelectedImage();
      if (selectedFile != null) {
        setState(() {
          _selectedFiles.add({
            'name': selectedFile.name,
            'file': selectedFile,
          });
        });
      }
    }
  }

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
              '문제집 설정',
              textAlign: TextAlign.center,
              style: FontSystem.KR18B.copyWith(color: ColorSystem.black),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: '문제집 이름',
                hintStyle: FontSystem.KR14M.copyWith(
                  color: ColorSystem.grey[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ColorSystem.grey[300]!,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: FontSystem.KR14M,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            Text(
              '선택된 파일: ${_selectedFiles.length}개',
              style: FontSystem.KR14M.copyWith(color: ColorSystem.grey[600]),
            ),
            if (_selectedFiles.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorSystem.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '파일 추가',
                  style: FontSystem.KR14M.copyWith(color: ColorSystem.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: ColorSystem.back,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ColorSystem.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '취소',
                          style: FontSystem.KR16M.copyWith(
                            color: ColorSystem.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) {
                        Get.snackbar('오류', '문제집 이름을 입력해주세요.');
                        return;
                      }
                      if (_selectedFiles.isEmpty) {
                        Get.snackbar('오류', '파일을 선택해주세요.');
                        return;
                      }

                      Navigator.of(context).pop();

                      // 마지막 선택된 파일로 문제집 생성
                      widget.controller.setSelectedFile(_selectedFiles.last['file']);
                      await widget.controller.createStudyBook(
                        studyBookName: name,
                        answers: [],
                      );
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: ColorSystem.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '생성',
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
          ],
        ),
      ),
    );
  }
}
