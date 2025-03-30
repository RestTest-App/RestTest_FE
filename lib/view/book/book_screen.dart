import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/viewmodel/book/book_view_model.dart';
import 'package:rest_test/viewmodel/home/home_view_model.dart';
import 'package:rest_test/widget/appbar/default_back_appbar.dart';

import '../../widget/appbar/default_appbar.dart';

class BookScreen extends BaseScreen<BookViewModel>{
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
        child: DefaultAppBar(
          title: '나의 문제집',
          backColor : ColorSystem.back,
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    // return Obx((){
      return const Column(
        children: [
          Text("book")
        ],
      );
    }
    // );
}
