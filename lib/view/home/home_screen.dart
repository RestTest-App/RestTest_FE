import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';

import '../../utility/system/color_system.dart';

class HomeScreen extends BaseScreen<HomeViewModel>{
  const HomeScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.back;

  @override
  Color? get screenBackgroundColor => ColorSystem.back;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) {
    // return Obx((){
      return const Column(
        children: [
          Text("home")
        ],
      );
    }
    // );
}
