import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/widget/appbar/default_close_appbar.dart';
import '../../utility/system/color_system.dart';

class TestScreen extends BaseScreen<TestViewModel>{
  const TestScreen({super.key});

  @override
  bool get wrapWithInnerSafeArea => true;

  @override
  bool get setBottomInnerSafeArea => true;

  @override
  Color? get unSafeAreaColor => ColorSystem.white;

  @override
  Color? get screenBackgroundColor => ColorSystem.white;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(58),
        child: DefaultCloseAppbar(
          title: '마이페이지',
          backColor : ColorSystem.white,
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    // return Obx((){
    return const Column(
      children: [
        Text("test")
      ],
    );
  }
// );
}
