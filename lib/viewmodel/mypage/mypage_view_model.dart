import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MyPageViewModel extends GetxController {
  var nickname = '쉬엄시험해'.obs;

  var currentYear = DateTime.now().year.obs;
  var currentMonth = DateTime.now().month.obs;

  var calendarDates = <DateTime>[].obs;
  var monthlyStudyDate = <int>[].obs; // 1~31
  var attendanceCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
    generateCalendar(currentYear.value, currentMonth.value);
  }

  void loadMockData() {
    // API 응답 기반
    monthlyStudyDate.value = [1, 2, 3, 4, 5, 7, 9, 11, 13];
  }

  void generateCalendar(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    final startOffset = firstDayOfMonth.weekday % 7;
    final startDay = firstDayOfMonth.subtract(Duration(days: startOffset));

    List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(startDay.add(Duration(days: i)));
    }

    calendarDates.value = days;
    attendanceCount.value = monthlyStudyDate.length;
  }

  void logout() {
    print('로그아웃 처리됨');
    Get.offAllNamed('/login');
  }
}
