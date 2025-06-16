import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/test/widget/random_banner.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/widget/appbar/default_close_appbar.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/widget/tag/custom_tag.dart';
import '../../model/test/TestInfoState.dart';
import '../../utility/static/app_routes.dart';
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
          onBackPress: (){
            Get.back();
          },
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    return Obx(() {
      final testInfo = viewModel.testInfoState;

      // 데이터가 아직 로딩 중일 경우
      if (testInfo.year == 0) {
        return const Center(child: CircularProgressIndicator());
      }

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
                  child: _buildInfo(testInfo.year, testInfo.month),
                ),
                SizedBox(height: 16,),
                _buildTitle(testInfo.name),
                SizedBox(height: 8,),
                _buildTags(testInfo),
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
    });


  }

  Widget _buildInfo(int year, int month) {
     return Text("${year}년 ${month}월", style: FontSystem.KR16B.copyWith(color: ColorSystem.blue),);
  }

  Widget _buildTitle(String name) {
    return Text("${name}", style: FontSystem.KR24EB);
  }
  
  Widget _buildTags(TestInfoState testInfo) {
    return Row(
      children: [
        CustomTag(text: "${testInfo.question_count}문항", color: ColorSystem.lightBlue, textColor: ColorSystem.blue),
        const SizedBox(width: 4),
        CustomTag(text: "${testInfo.time}분", color: ColorSystem.lightBlue, textColor: ColorSystem.blue),
        SizedBox(width: 4),
        CustomTag(text: "${testInfo.exam_attempt}회독", color: ColorSystem.lightGreen, textColor: ColorSystem.green),
        SizedBox(width: 4),
        CustomTag(text: "${testInfo.pass_rate}%", color:
        testInfo.pass_rate >= 80.0
            ? ColorSystem.lightBlue
            : testInfo.pass_rate >= 60.0
            ? ColorSystem.lightGreen
            : ColorSystem.lightRed,
            textColor: testInfo.pass_rate >= 80.0
                ? ColorSystem.blue
                : testInfo.pass_rate >= 60.0
                ? ColorSystem.green
                : ColorSystem.red),
      ],
    );
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
            viewModel.resetExamState();
            Get.toNamed(
              Routes.TEST_EXAM
            );
          },
        ),
      ),
    );
  }
}
