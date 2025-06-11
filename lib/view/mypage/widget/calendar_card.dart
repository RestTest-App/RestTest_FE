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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
              color: ColorSystem.white, borderRadius: BorderRadius.circular(8)),
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
          child:
              Image.asset('assets/images/spring.png', width: width, height: 16),
        ),
      ],
    );
  }
}

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
          itemCount: controller.calendarDays.length,
          itemBuilder: (_, i) {
            final day = controller.calendarDays[i];
            if (day.isAttended) return const _AttendedDay();
            if (day.isInCurrentMonth && day.date.isBefore(today)) {
              return const _MissedDay();
            }
            final isToday = day.date.year == today.year &&
                day.date.month == today.month &&
                day.date.day == today.day;
            return _NormalDay(day: day, isToday: isToday);
          },
        ));
  }
}

class _AttendedDay extends StatelessWidget {
  const _AttendedDay({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: ColorSystem.blue, borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Image.asset('assets/images/logo_white.png',
                width: 20, height: 20)),
      );
}

class _MissedDay extends StatelessWidget {
  const _MissedDay({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: ColorSystem.white,
            border: Border.all(color: ColorSystem.red, width: 1.5),
            borderRadius: BorderRadius.circular(12)),
        child: Center(
            child:
                SvgPicture.asset('icons/mypage/x.svg', width: 16, height: 16)),
      );
}

class _NormalDay extends StatelessWidget {
  final dynamic day;
  final bool isToday;
  const _NormalDay({super.key, required this.day, required this.isToday});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: day.isInCurrentMonth ? Colors.white : ColorSystem.white,
          border: isToday
              ? Border.all(color: ColorSystem.grey[600]!, width: 1.5)
              : Border.all(color: ColorSystem.grey[200]!, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${day.date.day}',
          style: FontSystem.KR14SB.copyWith(
            color: day.isInCurrentMonth
                ? ColorSystem.black
                : ColorSystem.grey[200]!,
          ),
        ),
      );
}
