import 'package:get/get.dart';
import 'package:flutter/material.dart';

class CalendarDay {
  final DateTime date;
  final bool isInCurrentMonth;
  final bool isAttended;

  CalendarDay({
    required this.date,
    required this.isInCurrentMonth,
    this.isAttended = false,
  });
}

class MyPageViewModel extends GetxController {
  var nickname = '시엄시험해'.obs;

  var currentMonth = 4.obs;
  var currentYear = 2025.obs;

  var attendanceCount = 12.obs;

  // 출석한 날짜 (이번달 기준)
  var attendedDays = <int>[1, 2, 3, 5, 7, 9, 11, 13, 15].obs;

  // 전체 날짜 리스트 (42개 고정)
  var calendarDays = <CalendarDay>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateCalendar(currentYear.value, currentMonth.value);
  }

  void generateCalendar(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final startWeekday = firstDay.weekday; // 1 (Mon) ~ 7 (Sun)
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    final prevMonth = month == 1 ? 12 : month - 1;
    final prevYear = month == 1 ? year - 1 : year;
    final daysInPrevMonth = DateUtils.getDaysInMonth(prevYear, prevMonth);

    List<CalendarDay> days = [];

    // 이전달 날짜
    for (int i = startWeekday - 1; i > 0; i--) {
      days.add(CalendarDay(
        date: DateTime(prevYear, prevMonth, daysInPrevMonth - i + 1),
        isInCurrentMonth: false,
      ));
    }

    // 이번달 날짜
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(CalendarDay(
        date: DateTime(year, month, i),
        isInCurrentMonth: true,
        isAttended: attendedDays.contains(i),
      ));
    }

    // 다음달 날짜로 42개 채우기
    while (days.length < 35) {
      final last = days.last.date;
      final next = last.add(Duration(days: 1));
      days.add(CalendarDay(date: next, isInCurrentMonth: false));
    }
  
    calendarDays.value = days;
    attendanceCount.value = attendedDays.length;
  }
  void logout() {
  // 실제 로그아웃 처리
  // 예: SharedPreferences.clear(), API 호출, 상태 초기화 등
    print('✅ 로그아웃 처리됨');
    Get.offAllNamed('/login'); // 로그인 화면으로 이동
  }

}
