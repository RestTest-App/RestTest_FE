import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';
import 'package:rest_test/widget/appbar/default_appbar.dart';

class ReviewScreen extends BaseScreen<ReviewViewModel> {
  const ReviewScreen({super.key});

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
          title: '나의 복습노트',
          backColor: ColorSystem.back,
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    // return Obx((){
    return const Column(
      children: [Text("review")],
    );
  }
// );
}
