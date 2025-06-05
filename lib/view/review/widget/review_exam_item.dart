import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/model/review/ReviewListModel.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/view/base/base_widget.dart';
import 'package:rest_test/viewmodel/review/review_view_model.dart';

class ReviewExamItem extends BaseWidget<ReviewViewModel> {
  final ReviewListModel review;

  const ReviewExamItem({super.key, required this.review});


  @override
  Widget buildView(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin:const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
            color: ColorSystem.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorSystem.grey.shade200, style: BorderStyle.solid)
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitle(review.name),
                _buildPassTag(review.is_passed),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTagWrap(),
                _buildButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(title, style: FontSystem.KR18B);
  }

  Widget _buildTag(String label, Color color, Color textColor){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label, style: FontSystem.KR12SB.copyWith(height: 1.3, color: textColor),
      ),
    );
  }

  Widget _buildPassTag(bool pass){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      height: 20,
      decoration: BoxDecoration(
        color: pass ? ColorSystem.lightBlue : ColorSystem.lightRed,
        borderRadius: BorderRadius.circular(4),
      ),
      child:  Text(pass ? "합격" : "불합격", style: FontSystem.KR12SB.copyWith(height: 1.3, color: pass ? ColorSystem.blue : ColorSystem.red)
      ),
    );
  }

  Widget _buildTagWrap() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: [
              _buildTag(review.certificate, ColorSystem.lightBlue, ColorSystem.blue),
              _buildTag("${review.read_count}회독", ColorSystem.lightGreen, ColorSystem.green),
            ],
          ),
          const SizedBox(height: 4), // 간격 조절
          Wrap(
            spacing: 4.0,
            children: [
              _buildTag(
                "${review.pass_rate}%",
                review.pass_rate >= 80.0
                    ? ColorSystem.lightBlue
                    : review.pass_rate >= 60.0
                    ? ColorSystem.lightGreen
                    : ColorSystem.lightRed,
                review.pass_rate >= 80.0
                    ? ColorSystem.blue
                    : review.pass_rate >= 60.0
                    ? ColorSystem.green
                    : ColorSystem.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: () {
        //분석보기
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ColorSystem.grey.shade300, width: 1.0)
        ),
        child: Center(
          child: Text("분석보기", style: FontSystem.KR12M.copyWith(color: ColorSystem.grey.shade600),),
        ),
      )
    );
  }


}

