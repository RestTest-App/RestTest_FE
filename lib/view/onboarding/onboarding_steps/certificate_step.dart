import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';

class CertificateStep extends StatelessWidget {
  final controller = Get.find<OnboardingViewModel>();

  CertificateStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '자격증을 선택해주세요.\n(최대 3개)',
          style: TextStyle(
            fontFamily: 'AppleSDGothicNeo-Bold',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.5,
          ),
        ),
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
        return ChoiceChip(
          selected: isSelected,
          showCheckmark: false,
          labelPadding: EdgeInsets.zero,
          label: Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Text(label, textAlign: TextAlign.center),
          ),
          backgroundColor: Colors.white,
          selectedColor: const Color(0xFFEAF2FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 1,
              color: isSelected ? const Color(0xFF0B60B0) : Colors.grey,
            ),
          ),
          onSelected: (_) {
            if (isSelected) {
              controller.certificates.remove(id);
            } else if (controller.certificates.length < 3) {
              controller.certificates.add(id);
            }
          },
        );
      },
    );
  }
}
