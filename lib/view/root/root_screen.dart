import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/book/book_screen.dart';
import 'package:rest_test/view/mypage/mypage_screen.dart';
import 'package:rest_test/view/review/review_screen.dart';
import 'package:rest_test/view/test/test_screen.dart';
import 'package:rest_test/viewmodel/root/root_view_model.dart';

import '../home/home_screen.dart';
import 'widget/custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class RootScreen extends BaseScreen<RootViewModel> {
  const RootScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setTopInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      return IndexedStack(
        index: viewModel.selectedIndex,
        children:  [
          HomeScreen(),
          ReviewScreen(),
          BookScreen(),
          MyPageScreen(),
//           TestScreen()
        ],
      );
    });
  }

  @override
  bool get extendBodyBehindAppBar => true;

  @override
  Widget? buildBottomNavigationBar(BuildContext context) =>
      const CustomBottomNavigationBar();
}