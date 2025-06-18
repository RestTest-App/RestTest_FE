import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/utility/system/color_system.dart';

class CertificateStep extends StatelessWidget {
  final controller = Get.find<OnboardingViewModel>();

  CertificateStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('자격증을 선택해주세요.\n(최대 3개)', style: FontSystem.KR28B),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.5,
          children: controller.certificateOptions.map((option) {
            final id = option['id'] as int;
            final label = option['name'] as String;
            return _buildCertificateChip(id, label);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCertificateChip(int id, String label) {
    return Obx(
      () {
        final isSelected = controller.certificates.contains(id);
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              controller.certificates.remove(id);
            } else if (controller.certificates.length < 3) {
              controller.certificates.add(id);
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? ColorSystem.lightBlue : ColorSystem.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: isSelected ? ColorSystem.blue : ColorSystem.grey[400]!,
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color:
                    isSelected ? ColorSystem.blue : ColorSystem.grey[400],
              ),
            ),
          ),
        );
        // return ChoiceChip(
        //   selected: isSelected,
        //   showCheckmark: false,
        //   labelPadding: EdgeInsets.zero,
        //   label: Container(
        //     width: double.infinity,
        //     height: double.infinity,
        //     alignment: Alignment.center,
        //     child: Text(label, textAlign: TextAlign.center),
        //   ),
        //   backgroundColor: ColorSystem.white,
        //   selectedColor: ColorSystem.blue[500],
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //     side: BorderSide(
        //       width: 1,
        //       color: isSelected ? ColorSystem.blue[500] : ColorSystem.grey[400],
        //     ),
        //   ),
        //   onSelected: (_) {
        //     if (isSelected) {
        //       controller.certificates.remove(id);
        //     } else if (controller.certificates.length < 3) {
        //       controller.certificates.add(id);
        //     }
        //   },
        // );
      },
    );
  }
}
