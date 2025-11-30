import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/widget/appbar/default_appbar.dart';
import 'package:rest_test/view/book/widget/banner.dart';
import 'package:rest_test/view/book/widget/filter_row.dart';
import 'package:rest_test/view/book/widget/file_grid.dart';

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
      child: SizedBox(
        height: 58,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: DefaultAppBar(
            title: '나의 문제집',
            backColor: ColorSystem.back,
            actions: const [],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    final controller = this.controller;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const BookBanner(),
            FilterRow(controller: controller),
            Expanded(child: FileGrid(controller: controller)),
          ],
        ),
      );
    });
  }
}
