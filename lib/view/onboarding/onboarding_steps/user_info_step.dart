import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/viewmodel/onboarding/onboarding_view_model.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/utility/system/color_system.dart';

class UserInfoStep extends StatelessWidget {
  final controller = Get.find<OnboardingViewModel>();

  UserInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // final isValid = controller.isUserInfoValid;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '당신이 궁금해요!\n필요한 정보를 입력해주세요.',
              style: FontSystem.KR28B,
            ),
            const SizedBox(height: 24),

            // 성별 선택
            const Text("성별"),
            const SizedBox(height: 8),
            Row(
              children: ['여자', '남자', '선택안함'].asMap().entries.map((entry) {
                final index = entry.key;
                final gender = entry.value;
                final isSelected = controller.gender.value == gender;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index < 2 ? 8.0 : 0),
                    child: GestureDetector(
                      onTap: () => controller.gender.value = gender,
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEAF2FF) // ColorSystem에 없음
                              : ColorSystem.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? ColorSystem.blue
                                : ColorSystem.grey[400]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          gender,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected
                                ? ColorSystem.blue
                                : ColorSystem.grey[600]!,
                          ),
                        ),
                      ),
                    ),
                    // child: SizedBox(
                    //   height: 60,
                    //   child: ChoiceChip(
                    //     selected: isSelected,
                    //     showCheckmark: false,
                    //     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //     labelPadding: EdgeInsets.zero,
                    //     label: Container(
                    //       width: double.infinity,
                    //       height: double.infinity,
                    //       alignment: Alignment.center,
                    //       child: Text(
                    //         gender,
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //           height: 1.0,
                    //           color: isSelected
                    //               ? const Color(0xFF0B60B0)
                    //               : const Color(0xFF676767),
                    //         ),
                    //       ),
                    //     ),
                    //     backgroundColor: const Color(0xFFFFFFFF),
                    //     selectedColor: const Color(0xFFEAF2FF),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       side: BorderSide(
                    //         width: 0.5,
                    //         color: isSelected
                    //             ? const Color(0xFF0B60B0)
                    //             : const Color(0xFF676767),
                    //       ),
                    //     ),
                    //     onSelected: (_) => controller.gender.value = gender,
                    //   ),
                    // ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // 생년월일
            const Text("생년월일", style: FontSystem.KR28B),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  final formatted =
                      "${picked.year}.${picked.month.toString().padLeft(2, '0')}.${picked.day.toString().padLeft(2, '0')}";
                  controller.birth.value = formatted;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller:
                      TextEditingController(text: controller.birth.value),
                  readOnly: true,
                  style: TextStyle(
                    color: ColorSystem.grey[800],
                  ),
                  decoration: InputDecoration(
                    hintText: "YYYY.MM.DD",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: ColorSystem.grey[400]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: ColorSystem.grey[400]!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // 직업 입력
            Text(
              "직업",
              style: FontSystem.KR28B.copyWith(),
            ),
            const SizedBox(height: 8),
            TextField(
              style: FontSystem.KR16M.copyWith(
                color: ColorSystem.grey[800],
              ),
              decoration: InputDecoration(
                hintText: "직업을 적어주세요 (ex - 학생, 무직, 공시생 등)",
                enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0), // ColorSystem에 없음
                            width: 1,
                          ),
                        ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ColorSystem.grey[400]!,
                    width: 1,
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
