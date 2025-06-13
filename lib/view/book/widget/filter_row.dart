import 'package:flutter/material.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:get/get.dart';

// 최근 생성, 가나다, 최근 학습순 정렬 드롭다운
class FilterRow extends StatelessWidget {
  final BookViewModel controller;
  const FilterRow({super.key, required this.controller});

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

class _Dropdown extends StatelessWidget {
  final BookViewModel controller;
  const _Dropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 110,
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: Obx(
          () => DropdownButton<String>(
            isExpanded: true,
            value: controller.selectedValue.value,
            style: FontSystem.KR12SB,
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

class _TotalBox extends StatelessWidget {
  final BookViewModel controller;
  const _TotalBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 55,
      decoration: BoxDecoration(
        color: ColorSystem.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Obx(
          () => RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'total ',
                  style: FontSystem.KR12SB.copyWith(
                    color: ColorSystem.grey[600],
                  ),
                ),
                TextSpan(
                  text: '${controller.total.value}',
                  style: FontSystem.KR12SB.copyWith(
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
