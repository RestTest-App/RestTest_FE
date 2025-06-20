import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/test/widget/donut_chart.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/widget/button/rounded_rectangle_text_button.dart';

import '../../utility/static/app_routes.dart';
import '../../utility/system/color_system.dart';
import '../../widget/appbar/default_close_appbar.dart';

class TestResultScreen extends BaseScreen<TestViewModel> {
  const TestResultScreen({super.key});

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
          title: '시험 결과',
          backColor : ColorSystem.white,
          onBackPress: (){
            Get.toNamed(Routes.ROOT);
          },
        ));
  }

  @override
  Widget buildBody(BuildContext context) {
    final sectionScores = viewModel.sectionResults;

    // sectionScores가 아직 비어 있으면 로딩 중으로 판단
    if (sectionScores.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildDonutChart(),
          _buildTime(),
          _buildTestResult(),
          Spacer(),
          _buildBtn(),
        ],
      ),
    );
  }

  Widget _buildDonutChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: SizedBox(
        height: 232,
        child: DonutChart(), // 도넛 차트 위젯
      ),
    );
  }
  
  Widget _buildTime() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('풀이시간 : ', style: FontSystem.KR20B.copyWith(color: ColorSystem.grey.shade600),),
          Text('103분', style: FontSystem.KR20B.copyWith(color: ColorSystem.grey.shade600),),
        ],
      ),
    );
  }

  Widget _buildTestResult() {
    final sectionScores = viewModel.sectionResults;
    final List<Color> autoColors = [
      ColorSystem.section1,
      ColorSystem.section2,
      ColorSystem.section3,
      ColorSystem.section4,
      ColorSystem.section5,
    ];
    final List<Color> textColors = [
      ColorSystem.blue,
      ColorSystem.deepBlue,
      ColorSystem.brown,
      ColorSystem.green,
      ColorSystem.red,
    ];
    return Column(
      children: List.generate(sectionScores.length, (index) {
        final section = sectionScores[index];
        final color = autoColors[index%autoColors.length];
        final textColor = textColors[index%textColors.length];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  flex: 2,
                  child: Text(section.name, style: FontSystem.KR16SB,)),
              Expanded(
                  flex: 1,
                  child: Text('${section.correctCount}/${section.totalCount}', style: FontSystem.KR16SB,textAlign: TextAlign.right)),
              Expanded(
                  flex: 1,
                  child: Text('${section.score}점', style: FontSystem.KR16B.copyWith(color: textColor),textAlign: TextAlign.right,))
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RoundedRectangleTextButton(
          text: "건너뛰기",
          textStyle: FontSystem.KR16SB.copyWith(color: ColorSystem.grey.shade400, letterSpacing: -0.3),
          width: 120,
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          backgroundColor: ColorSystem.grey.shade200,
          onPressed: (){
            Get.toNamed(Routes.ROOT);
          },
        ),
        RoundedRectangleTextButton(
          text: '해설 보러가기',
          textStyle: FontSystem.KR16SB.copyWith(color: ColorSystem.white, letterSpacing: -0.3),
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          width: 225,
          height: 60,
          backgroundColor: ColorSystem.blue,
          onPressed: (){
            viewModel.goToQuestion(0);
            Get.toNamed(Routes.TEST_COMMENT);
          },
        )
      ],
    );
  }
}