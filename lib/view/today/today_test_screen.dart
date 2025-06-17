import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_test/model/today/TodayTestState.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/test/widget/random_banner.dart';
import 'package:rest_test/widget/appbar/default_close_appbar.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';
import 'package:rest_test/widget/tag/custom_tag.dart';
import '../../utility/static/app_routes.dart';
import '../../utility/system/color_system.dart';
import '../../viewmodel/today/today_test_view_model.dart';

class TodayTestScreen extends BaseScreen<TodayTestViewModel>{
  const TodayTestScreen({super.key});

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
      final state = viewModel.todayTestState;

      // 데이터가 아직 로딩 중일 경우
      if (state?.questionCount == 0) {
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
                  child: _buildInfo(),
                ),
                SizedBox(height: 16,),
                _buildTitle(),
                SizedBox(height: 8,),
                _buildTags(state!),
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

  Widget _buildInfo() {
    return Text("AI가 만든", style: FontSystem.KR16B.copyWith(color: ColorSystem.blue),);
  }

  Widget _buildTitle() {
    return Text("오늘의 문제!", style: FontSystem.KR24EB);
  }

  Widget _buildTags(TodayTestState testInfo) {
    return Row(
      children: [
        CustomTag(text: "${testInfo.questionCount}문항", color: ColorSystem.lightBlue, textColor: ColorSystem.blue),
      ],
    );
  }

  Widget _buildTestInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("오늘의 문제는?", style: FontSystem.KR16B.copyWith(color: ColorSystem.grey.shade800),),
          SizedBox(
            height: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" • 오늘의 문제는 AI가 자격증별로 생성한 문제를 푸는 모드입니다.", style: FontSystem.KR14M.copyWith(color: ColorSystem.grey.shade600, height: 1.5)),
              Text(" • 문제는 총 10문제입니다. 문제를 풀고 난 후 해설이 표시됩니다.", style: FontSystem.KR14M.copyWith(color: ColorSystem.grey.shade600, height: 1.5))
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
          onPressed: () async{
            await viewModel.resetExamState(); // 내부에서 questions도 다시 불러옴
            Get.toNamed(
                Routes.TODAY_EXAM
            );
          },
        ),
      ),
    );
  }
}
