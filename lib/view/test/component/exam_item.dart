import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/test/test_view_model.dart';

class ExamItem extends BaseWidget<TestViewModel>{
  const ExamItem ({
    super.key
  });

  @override
  Widget buildView(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 문제
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 20),
            child: Text(viewModel.currentQuestion.description, style: FontSystem.KR22B.copyWith(height: 1.3),),
          ),
          // 스크롤뷰 (사진 + 보기)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
              children : [
                if (viewModel.currentQuestion.descriptionImage != null &&
                    viewModel.currentQuestion.descriptionImage!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Image.asset(
                      viewModel.currentQuestion.descriptionImage!,
                      width: double.infinity,
                    ),
                  ),
                // 보기 (옵션 리스트)
                ...viewModel.currentQuestion.options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final isSelected = viewModel.selectedOption == index;

                  return GestureDetector(
                    onTap: () => viewModel.selectOption(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorSystem.selectedBlue
                            : ColorSystem.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: isSelected ? ColorSystem.blue : ColorSystem.grey.shade300)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 280,
                            child: Text(
                              option,
                              style:
                                  isSelected
                                      ? FontSystem.KR14B.copyWith(color: ColorSystem.deepBlue, height: 1.5)
                                  : FontSystem.KR14M.copyWith(color: ColorSystem.grey.shade800, height: 1.5),
                              softWrap: true,
                            ),
                          ),
                          SvgPicture.asset(
                            isSelected ? "assets/icons/test/radioBtnSelected.svg"
                            : "assets/icons/test/radioBtn.svg"
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

}