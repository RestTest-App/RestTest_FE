import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';

class DonutChart extends BaseWidget<TestViewModel> {
  const DonutChart({super.key});

  @override
  Widget buildView(BuildContext context) {
    return Obx(() {
      // 자동 색상 리스트 정의
      final List<Color> autoColors = [
        ColorSystem.section1,
        ColorSystem.section2,
        ColorSystem.section3,
        ColorSystem.section4,
        ColorSystem.section5,
      ];
      final sectionScores = viewModel.sectionResults;

      final totalScore = sectionScores.fold<double>(
          0, (sum, e) => sum + e.score.toDouble());

      return Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                centerSpaceRadius: 76,
                sectionsSpace: 6,
                sections: List.generate(sectionScores.length, (i) {
                  final section = sectionScores[i];
                  final baseColor = autoColors[i % autoColors.length];

                  return PieChartSectionData(
                    value: section.score.toDouble(),
                    gradient: LinearGradient(
                      colors: [
                        baseColor.withOpacity(0.9),
                        baseColor.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    title: '',
                    radius: 44,
                    borderSide: BorderSide.none,
                    badgeWidget: null,
                    badgePositionPercentageOffset: 0.98,
                  );
                }),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${totalScore.toInt()}점',
                    style: FontSystem.KR36EB,),
                Text(
                  viewModel.isPassed ? '합격' : '불합격',
                  style: FontSystem.KR28EB.copyWith(color: viewModel.isPassed ? ColorSystem.green : ColorSystem.red),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

}