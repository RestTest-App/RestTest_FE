import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rest_test/utility/system/font_system.dart';
import 'package:rest_test/utility/system/color_system.dart';

class ExamTypeSelector extends StatefulWidget {
  final RxString selectedExamType;

  const ExamTypeSelector({
    super.key,
    required this.selectedExamType,
  });

  @override
  State<ExamTypeSelector> createState() => _ExamTypeSelectorState();
}

class _ExamTypeSelectorState extends State<ExamTypeSelector> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  final List<String> examTypes = ['정처기', '컴활', '한능검'];

  void _showDropdown() {
    final renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 8,
          width: 100,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: ColorSystem.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: examTypes.map((type) {
                final isSelected = widget.selectedExamType.value == type;
                return InkWell(
                  onTap: () {
                    widget.selectedExamType.value = type;
                    _removeDropdown();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: type != examTypes.last
                              ? ColorSystem.grey[200]!
                              : ColorSystem.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      type,
                      style: FontSystem.KR18B.copyWith(
                        color: isSelected
                            ? ColorSystem.deepBlue
                            : ColorSystem.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _buttonKey,
      onTap: () {
        if (_overlayEntry == null) {
          _showDropdown();
        } else {
          _removeDropdown();
        }
      },
      child: Obx(() => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.rotate(
                angle: -90 * 3.1415926535 / 180,
                child: const Icon(Icons.arrow_back_ios_new, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                widget.selectedExamType.value,
                style: FontSystem.KR18B,
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }
}
