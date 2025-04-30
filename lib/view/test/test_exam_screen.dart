import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:logger/logger.dart';
import 'package:rest_test/utility/function/log_util.dart';
import 'package:rest_test/view/base/base_screen.dart';
import 'package:rest_test/view/home/home_screen.dart';
import 'package:rest_test/view/test/widget/exam_select_dialog.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';
import 'package:rest_test/widget/appbar/default_close_appbar.dart';

import '../../utility/system/color_system.dart';
import '../../utility/system/font_system.dart';
import '../../widget/button/rounded_rectangle_text_button.dart';
import 'component/exam_item.dart';

class TestExamScreen extends BaseScreen<TestViewModel> {
  const TestExamScreen({super.key});

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
    return Obx (() => Column(
      children: [
        _buildPaginationIndicator(viewModel.currentIndex,viewModel.questions.length),
        Expanded(child: ExamItem()),
        _buildBottomBar(),
      ],
    ));
  }

  Widget _buildPaginationIndicator(int step, int total) {
    int totalSteps = total; // 총 단계 수
    return LinearProgressBar(
      maxSteps: totalSteps, // 총 단계 설정
      currentStep: step + 1, // 현재 단계 (0부터 시작하므로 +1)
      progressColor: ColorSystem.blue, // 진행된 부분 색상
      backgroundColor: ColorSystem.grey.shade200, // 배경 색상
      minHeight: 5.0, // ProgressBar의 높이
      valueColor: AlwaysStoppedAnimation<Color>(ColorSystem.blue),
    );
  }

  Widget _buildBottomBar() {
    return Obx(()=> Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorSystem.white,
          border: Border(top: BorderSide(color: ColorSystem.grey.shade300))
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                viewModel.prevQuestion();
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ColorSystem.grey.shade100,
                  border: Border.all(color: ColorSystem.grey.shade200),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(-1, 0),
                    child: SvgPicture.asset(
                      "assets/icons/test/arrowPrev.svg",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                width: 50,
                child: Text("${viewModel.currentIndex+1} / ${viewModel.questions.length}", style: FontSystem.KR24B,)
            ),
            viewModel.canSubmit
                ? _buildConfrimBtn()
                : const ExamSelectDialog(),
            GestureDetector(
              onTap: (){
                viewModel.nextQuestion();
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ColorSystem.grey.shade100,
                  border: Border.all(color: ColorSystem.grey.shade200),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: Offset(1, 0),
                    child: SvgPicture.asset(
                      "assets/icons/test/arrowNext.svg",
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildConfrimBtn() {
    return Transform.translate(
        offset: Offset(0, 2),
        child: RoundedRectangleTextButton(
          text: "제출하기",
          height : 48,
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          backgroundColor: ColorSystem.blue,
          textStyle: FontSystem.KR16B.copyWith(color: ColorSystem.white, height: 1.2, ),
          onPressed: () {
            Get.to(
                  ()=> const HomeScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 300),
            );
          },
        )
    );
  }
}

