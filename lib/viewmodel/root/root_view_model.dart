import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rest_test/model/root/CustomBottomNavigationItemState.dart';
import 'package:rest_test/view/root/widget/custom_bottom_navigation_bar/component/custom_bottom_navigation_item.dart';

class RootViewModel extends GetxController {
  /* ------------------------------------------------------ */
  /* ----------------- Static Fields ---------------------- */
  /* ------------------------------------------------------ */
  static const duration = Duration(milliseconds: 200);

  /* ------------------------------------------------------ */
  /* -------------------- DI Fields ----------------------- */
  /* ------------------------------------------------------ */
  // late final UserRepository _userRepository;

  /* ------------------------------------------------------ */
  /* ----------------- Private Fields --------------------- */
  /* ------------------------------------------------------ */
  late final RxInt _selectedIndex;

  /* ------------------------------------------------------ */
  /* ----------------- Public Fields ---------------------- */
  /* ------------------------------------------------------ */
  late final List<CustomBottomNavigationItemState> bottomNavItems;

  int get selectedIndex => _selectedIndex.value;

  @override
  void onInit() {
    super.onInit();
    // Dependency Injection

    // _userRepository = Get.find<UserRepository>();

    // Initialize private fields
    _selectedIndex = 0.obs;

    //   bottomNavItems = [
    //     CustomBottomNavigationItemState(
    //         src: "assets/rivs/bottom_navigation_bar_icons.riv",
    //         artBoard: "CROWN",
    //         stateMachineName: "CROWN_Interactivity"),
    //     CustomBottomNavigationItemState(
    //         src: "assets/rivs/bottom_navigation_bar_icons.riv",
    //         artBoard: "HOME",
    //         stateMachineName: "HOME_Interactivity"),
    //     CustomBottomNavigationItemState(
    //         src: "assets/rivs/bottom_navigation_bar_icons.riv",
    //         artBoard: "USER",
    //         stateMachineName: "USER_Interactivity"),
    //   ];
    // }
  }

  void fetchIndex(int index) {
    _selectedIndex.value = index;
  }
}
