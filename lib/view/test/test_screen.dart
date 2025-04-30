import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/home/home_screen.dart';
import 'package:rest_test/view/test/test_exam_screen.dart';
import 'package:rest_test/view/test/widget/random_banner.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/widget/appbar/default_close_appbar.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/widget/tag/custom_tag.dart';
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
          title: '',
          backColor : ColorSystem.white,
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Obx(()=> _buildInfo(viewModel.state.year, viewModel.state.month),),
                ),
                SizedBox(height: 16,),
                _buildTitle(),
                SizedBox(height: 8,),
                _buildTags(),
              ],
            ),
        ),
        RandomBanner(),
        _buildTestInfo(),
        Spacer(),
        _buildStartBtn(),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfo(int year, int month) {
     return Text("${year}년 ${month}월", style: FontSystem.KR16B.copyWith(color: ColorSystem.blue),);
  }

  Widget _buildTitle() {
    return Obx((){
      return Text("${viewModel.state.name}", style: FontSystem.KR24EB);
    });
  }
  
  Widget _buildTags() {
    return Obx(() => Row(
      children: [
        CustomTag(text: "${viewModel.state.question_count}문항", color: ColorSystem.lightBlue, textColor: ColorSystem.blue),
        const SizedBox(width: 4),
        CustomTag(text: "${viewModel.state.time}분", color: ColorSystem.lightBlue, textColor: ColorSystem.blue),
        SizedBox(width: 4),
        CustomTag(text: "${viewModel.state.exam_attempt}회독", color: ColorSystem.lightGreen, textColor: ColorSystem.green),
        SizedBox(width: 4),
        CustomTag(text: "${viewModel.state.pass_rate}%", color:
          viewModel.state.pass_rate >= 80.0
            ? ColorSystem.lightBlue
            : viewModel.state.pass_rate >= 60.0
            ? ColorSystem.lightGreen
            : ColorSystem.lightRed,
            textColor: viewModel.state.pass_rate >= 80.0
                ? ColorSystem.blue
                : viewModel.state.pass_rate >= 60.0
                ? ColorSystem.green
                : ColorSystem.red),
      ],
    ));
  }

  Widget _buildTestInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("시험모드는?", style: FontSystem.KR16B.copyWith(color: ColorSystem.grey.shade800),),
          SizedBox(
            height: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" • 시험모드는 시험 시간과 동일합니다.", style: FontSystem.KR14M.copyWith(color: ColorSystem.grey.shade600, height: 1.5)),
              Text(" • 전체 문제를 풀고 난 후 합격/불합격이 표시됩니다.", style: FontSystem.KR14M.copyWith(color: ColorSystem.grey.shade600, height: 1.5))
            ],

          )
        ],
      ),
    );
  }

  Widget _buildStartBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: RoundedRectangleTextButton(
          text: "학습 시작",
          backgroundColor: ColorSystem.blue,
          textStyle: FontSystem.KR16SB.copyWith(color: ColorSystem.white),
          onPressed: (){
            Get.to(
                  ()=> const TestExamScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            );
          },
        ),
      ),
    );
  }
}
