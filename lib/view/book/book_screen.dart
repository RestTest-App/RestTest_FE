import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/widget/appbar/default_appbar.dart';

class BookScreen extends BaseScreen<BookViewModel> {
  const BookScreen({Key? key}) : super(key: key);

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
    return PreferredSize(
      preferredSize: const Size.fromHeight(58),
      child: SizedBox(
        height: 58,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: DefaultAppBar(
            title: '나의 문제집',
            backColor: ColorSystem.back,
            actions: [],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final controller = this.controller;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const _Banner(),
          _FilterRow(controller: controller),
          Expanded(child: _FileGrid(controller: controller)),
        ],
      ),
    );
  }
}

// 배너 광고 위젯
class _Banner extends StatelessWidget {
  const _Banner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      height: 150.0,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          '배너 광고 영역',
          style: TextStyle(color: ColorSystem.grey[700]),
        ),
      ),
    );
  }
}

// 필터 영역 (드롭다운 + total)
class _FilterRow extends StatelessWidget {
  final BookViewModel controller;
  const _FilterRow({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 23.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Dropdown(controller: controller),
          _TotalBox(controller: controller),
        ],
      ),
    );
  }
}
// 드롭다운 위젯
class _Dropdown extends StatelessWidget {
  final BookViewModel controller;
  const _Dropdown({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 110,
      decoration: BoxDecoration(
        color: ColorSystem.white,              // 배경 흰색
        borderRadius: BorderRadius.circular(4),// 모서리 둥글게 4
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedValue.value,
            style: const TextStyle(
              fontSize: 12.0,
              fontFamily: 'AppleSDGothicNeo',
              fontWeight: FontWeight.w600,
            ),
            items: controller.dropdownItems
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(item),
                      ),
                    ))
                .toList(),
            onChanged: controller.updateSelectedValue,
          ),
        ),
      ),
    );
  }
}

// total 박스 위젯
class _TotalBox extends StatelessWidget {
  final BookViewModel controller;
  const _TotalBox({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 55,
      decoration: BoxDecoration(
        color: ColorSystem.white,              // 배경 흰색
        borderRadius: BorderRadius.circular(4),// 모서리 둥글게 4
      ),
      child: Center(
        child: Obx(
          () => RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'total ',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'AppleSDGothicNeo',
                    fontWeight: FontWeight.w600,
                    color: ColorSystem.grey[600],
                  ),
                ),
                TextSpan(
                  text: '${controller.total.value}',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontFamily: 'AppleSDGothicNeo',
                    fontWeight: FontWeight.w600,
                    color: ColorSystem.deepBlue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// 파일 그리드
class _FileGrid extends StatelessWidget {
  final BookViewModel controller;
  const _FileGrid({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 93 / 101,
        ),
        itemCount: controller.files.length,
        itemBuilder: (context, index) {
          if (index == controller.files.length - 1) {
            return _AddNewFileTile(controller: controller);
          }
          return _FileTile(file: controller.files[index]);
        },
      ),
    );
  }
}

// 새 파일 추가 타일
class _AddNewFileTile extends StatelessWidget {
  final BookViewModel controller;
  const _AddNewFileTile({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showAddModal(context),
          child: Container(
            width: 100,
            height: 90,
            padding: const EdgeInsets.all(4.0),
            child: DottedBorder(
              color: ColorSystem.blue,
              strokeWidth: 1,
              dashPattern: [4, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              child: Center(
                child: Text('+', style: TextStyle(fontSize: 24.0, color: ColorSystem.blue)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: 393,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: Image.asset('assets/images/logo.png', height: 60, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Obx(
                  () => Text(
                    '이번달 문제 만들기 ${controller.remainingCount.value}회 남았습니다',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'AppleSDGothicNeo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 38.0),
                child: Text(
                  'pdf 업로드나 문제를 촬영하시면\n나의 문제집에 문제가 저장됩니다!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 174,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B60B0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('PDF 업로드', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: 174,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B60B0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('촬영하기', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// 파일 타일 위젯
class _FileTile extends StatelessWidget {
  final Map<String, dynamic> file;
  const _FileTile({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: ColorSystem.back),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Image.asset('assets/images/book_file.png', fit: BoxFit.cover, width: double.infinity),
            ),
            const SizedBox(height: 20),
            Text(
              file['name'] ?? '',
              style: const TextStyle(fontSize: 12.0, fontFamily: 'AppleSDGothicNeo', fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              file['date'] ?? '',
              style: const TextStyle(fontSize: 8.0, fontFamily: 'AppleSDGothicNeo', color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
