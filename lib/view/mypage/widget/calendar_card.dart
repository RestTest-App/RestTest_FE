import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';

class CalendarSection extends StatelessWidget {
  final MyPageViewModel controller;
  const CalendarSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 40;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 16),
          decoration: BoxDecoration(
              color: ColorSystem.white,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CalendarHeader(controller: controller),
              const SizedBox(height: 16),
              _CalendarGrid(controller: controller),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Positioned(
          top: -8,
          child: SvgPicture.asset(
            'assets/images/spring.svg',
          ),
        ),
      ],
    );
  }
}

// 캘린더 헤더
class _CalendarHeader extends StatelessWidget {
  final MyPageViewModel controller;
  const _CalendarHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              '${controller.currentMonth.value}월',
              style: FontSystem.KR20B,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 24,
            decoration: BoxDecoration(
                color: ColorSystem.back,
                borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: Obx(() => RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '이번달 출석 ',
                          style: FontSystem.KR12SB.copyWith(
                            color: ColorSystem.grey[800],
                          ),
                        ),
                        TextSpan(
                          text: '${controller.attendanceCount.value}일',
                          style: FontSystem.KR12SB.copyWith(
                            color: ColorSystem.blue,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ],
      );
}

// 캘린더 그리드
class _CalendarGrid extends StatelessWidget {
  final MyPageViewModel controller;
  const _CalendarGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, crossAxisSpacing: 6, mainAxisSpacing: 6),
          itemCount: controller.calendarDates.length,
          itemBuilder: (_, i) {
            final date = controller.calendarDates[i];

            final isInCurrentMonth =
                date.month == controller.currentMonth.value;
            final isAttended = isInCurrentMonth &&
                controller.monthlyStudyDate.contains(date.day);
            final isPastDay = date.isBefore(today);
            final isToday = date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;

            if (isInCurrentMonth) {
              if (isAttended && !isToday) {
                return const _AttendanceCheckedDay();
              } else if (isPastDay && !isToday) {
                return const _AttendanceUncheckedDay();
              }
            }

            return _NormalDay(
                date: date,
                isInCurrentMonth: isInCurrentMonth,
                isToday: isToday);
          },
        ));
  }
}

// ✅ 출석한 날
class _AttendanceCheckedDay extends StatelessWidget {
  const _AttendanceCheckedDay({super.key});

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints.tightFor(width: 34, height: 34),
        decoration: BoxDecoration(
          color: ColorSystem.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(7),
        child: SvgPicture.asset(
          'assets/icons/mypage/check_yes.svg',
          fit: BoxFit.contain,
        ),
      );
}

// ❌ 미출석한 날
class _AttendanceUncheckedDay extends StatelessWidget {
  const _AttendanceUncheckedDay({super.key});

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints.tightFor(width: 34, height: 34),
        decoration: BoxDecoration(
          color: ColorSystem.white,
          border: Border.all(color: ColorSystem.red, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(7),
        child: SvgPicture.asset(
          'assets/icons/mypage/check_no.svg',
          fit: BoxFit.contain,
        ),
      );
}

// 📅 일반 날짜
class _NormalDay extends StatelessWidget {
  final DateTime date;
  final bool isInCurrentMonth;
  final bool isToday;

  const _NormalDay({
    super.key,
    required this.date,
    required this.isInCurrentMonth,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    Color borderColor;
    if (isToday) {
      borderColor = ColorSystem.grey[600]!;
    } else if (isInCurrentMonth) {
      borderColor =
          date.isAfter(now) ? ColorSystem.grey[400]! : ColorSystem.grey[200]!;
    } else {
      borderColor = ColorSystem.grey[200]!;
    }

    Color textColor;
    if (isToday) {
      textColor = ColorSystem.grey[600]!;
    } else if (!isInCurrentMonth) {
      textColor = ColorSystem.grey[200]!;
    } else {
      textColor = ColorSystem.grey[400]!;
    }

    return Container(
      constraints: const BoxConstraints.tightFor(width: 34, height: 34),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorSystem.white,
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(7),
      child: Text(
        '${date.day}',
        style: FontSystem.KR14SB.copyWith(color: textColor),
      ),
    );
  }
}
