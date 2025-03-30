import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/root/root_view_model.dart';

import 'component/custom_bottom_navigation_item.dart';

class CustomBottomNavigationBar extends BaseWidget<RootViewModel> {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(
          () => Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: ColorSystem.grey.shade300, width: 0.5))
          ),
          child: BottomNavigationBar(
            // State Management
            currentIndex: viewModel.selectedIndex,
            onTap: viewModel.fetchIndex,

            // Design
            backgroundColor: ColorSystem.back,
            type: BottomNavigationBarType.fixed,

            // When not selected
            unselectedItemColor: ColorSystem.grey.shade300,
            unselectedLabelStyle: FontSystem.KR12B,

            // When selected
            selectedItemColor: ColorSystem.blue,
            selectedLabelStyle: FontSystem.KR12B,

            // Items
            items: [
              BottomNavigationBarItem(
                icon: CustomBottomNavigationItem(
                  isActive: viewModel.selectedIndex == 0,
                  assetPath: "assets/icons/bottom_navigation/home.svg",
                ),
                label: "홈",
              ),
              BottomNavigationBarItem(
                icon: CustomBottomNavigationItem(
                  isActive: viewModel.selectedIndex == 1,
                  assetPath: "assets/icons/bottom_navigation/review.svg",
                ),
                label: "복습하기",
              ),
              BottomNavigationBarItem(
                icon: CustomBottomNavigationItem(
                  isActive: viewModel.selectedIndex == 2,
                  assetPath: "assets/icons/bottom_navigation/book.svg",
                ),
                label: "나의문제집",
              ),
              BottomNavigationBarItem(
                icon: CustomBottomNavigationItem(
                  isActive: viewModel.selectedIndex == 3,
                  assetPath: "assets/icons/bottom_navigation/mypage.svg",
                ),
                label: "마이페이지",
              ),
            ],
          ),
        ),
      ),
    );
  }
}