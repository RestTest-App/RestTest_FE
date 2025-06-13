import 'dart:ui';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';

class BookViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // Dependency Injection Fields, if needed

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  // Private fields for internal logic

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */

  // 파일 목록 관리 (내용 제거)
  var files = List.generate(
      10, (index) => {'name': '파일 이름 $index', 'date': '생성 날짜: 2023-10-01'}).obs;

  // 총 파일 수
  var total = 10.obs;

  // 남은 문제 만들기 횟수
  var remainingCount = 0.obs;

  // 드롭다운 선택 값
  var dropdownItems = ['최근 생성순', '가나다순', '최근 학습순'];
  var selectedValue = '최근 생성순'.obs;

  // 드롭다운 값 업데이트
  void updateSelectedValue(String? newValue) {
    if (newValue != null) {
      selectedValue.value = newValue;
    }
  }

  // 파일 목록에 파일 추가
  void addFile(String name, String date) {
    files.add({'name': name, 'date': date});
    total.value = files.length;
  }

  // 추가적인 로직 및 상태 관리
}
