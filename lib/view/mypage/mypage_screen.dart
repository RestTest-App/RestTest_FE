import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';
import 'package:rest_test/viewmodel/mypage/mypage_view_model.dart';

import '../../utility/system/color_system.dart';
import '../../widget/appbar/default_appbar.dart';

class MyPageScreen extends BaseScreen<MyPageViewModel>{
  const MyPageScreen({super.key});

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
        child: DefaultAppBar(
          title: '마이페이지',
          backColor : ColorSystem.back,
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    // return Obx((){
      return const Column(
        children: [
          Text("mypage")
        ],
      );
    }
    // );
}
