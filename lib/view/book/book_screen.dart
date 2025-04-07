import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:dotted_border/dotted_border.dart';

class BookScreen extends BaseScreen<BookViewModel> {
  const BookScreen({super.key});

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: AppBar(
          title: Center(
            child: Text(
              '나의 문제집',
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'AppleSDGothicNeo',
                fontWeight: FontWeight.w600, // SemiBold
              ),
            ),
          ),
          backgroundColor: ColorSystem.back,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // 배너 광고 영역
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 150.0,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                '배너 광고 영역',
                style: TextStyle(color: ColorSystem.grey[700]),
              ),
            ),
          ),
          // 드롭박스와 total 4 텍스트를 양쪽 끝에 배치
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 23.0), // 위아래 패딩 23pt
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 왼쪽 드롭박스
                Container(
                  height: 24,
                  width: 110,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorSystem.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: Obx(() => DropdownButton<String>(
                          isExpanded: true,
                          value: controller.selectedValue.value,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'AppleSDGothicNeo',
                            fontWeight: FontWeight.w600, // SemiBold
                          ),
                          items: controller.dropdownItems.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(item),
                              ),
                            );
                          }).toList(),
                          onChanged: controller.updateSelectedValue,
                        )),
                  ),
                ),
                // 오른쪽 total 텍스트
                Container(
                  height: 24,
                  width: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Obx(() => RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'total ',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'AppleSDGothicNeo',
                              fontWeight: FontWeight.w600, // SemiBold
                              color: ColorSystem.grey[600],
                            ),
                          ),
                          TextSpan(
                            text: '${controller.total.value}',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'AppleSDGothicNeo',
                              fontWeight: FontWeight.w600, // SemiBold
                              color: ColorSystem.deepBlue, // DeepBlue 색상 적용
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          // 파일 내용들 그리드
          Expanded(
            child: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 한 줄에 3개 아이템
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 93 / 101, // 파일 공간의 비율
              ),
              itemCount: controller.files.length, // 총 파일의 수
              itemBuilder: (context, index) {
                if (index == controller.files.length - 1) { // 마지막 아이템에 점선 박스 추가
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 생성박스 눌렀을 때 호출
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                height: 393,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                                      child: Image.asset(
                                        'assets/images/logo.png', // 이미지 경로
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                                      child: Obx(() => Text(
                                        '이번달 문제 만들기 ${controller.remainingCount.value}회 남았습니다',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'AppleSDGothicNeo',
                                          fontWeight: FontWeight.bold, // Bold
                                        ),
                                      )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 38.0),
                                      child: Text(
                                        'pdf 업로드나 문제를 촬영하시면\n나의 문제집에 문제가 저장됩니다!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'AppleSDGothicNeo',
                                          fontWeight: FontWeight.w500, // Medium
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 174,
                                          height: 60,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // PDF 업로드 로직
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF0B60B0), // 버튼 색상
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Text(
                                              'PDF 업로드',
                                              style: TextStyle(color: Colors.white), // 글자 색상
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6), // 버튼 사이의 패딩
                                        SizedBox(
                                          width: 174,
                                          height: 60,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // 촬영하기 로직
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF0B60B0), // 버튼 색상
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Text(
                                              '촬영하기',
                                              style: TextStyle(color: Colors.white), // 글자 색상
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 90,
                          padding: const EdgeInsets.all(4.0),
                          child: DottedBorder(
                            color: ColorSystem.blue,
                            strokeWidth: 1,
                            dashPattern: [4, 4],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(16),
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyle(fontSize: 24.0, color: ColorSystem.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0), // 추가박스 아래의 여백
                      ),
                    ],
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: ColorSystem.back, // 박스의 배경색 설정
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Image.asset(
                          'assets/images/book_file.png', // 변경된 이미지 경로
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Obx(() => Text(
                              controller.files[index]['name'] ?? '',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontFamily: 'AppleSDGothicNeo',
                                fontWeight: FontWeight.w600, // SemiBold
                              ),
                              overflow: TextOverflow.ellipsis,
                            )),
                            Obx(() => Text(
                              controller.files[index]['date'] ?? '',
                              style: TextStyle(
                                fontSize: 8.0,
                                fontFamily: 'AppleSDGothicNeo',
                                fontWeight: FontWeight.normal, // Regular
                                color: Colors.grey,
                              ),
                            )),
                          ],
                        ),
                      ),  
                    ],
                  ),
                );
              },
            )),
          )
          // 네브바 자리
          // 네브바 구현 필요 시 여기에 추가
        ],
      ),
    );
  }
}
