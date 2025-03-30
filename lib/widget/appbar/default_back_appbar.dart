import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rest_test/utility/system/color_system.dart';

import '../../utility/system/font_system.dart';
import '../button/custom_icon_button.dart';

class DefaultBackAppBar extends StatelessWidget {
  const DefaultBackAppBar({
    super.key,
    required this.title,
    this.actions = const <CustomIconButton>[],
    this.onBackPress,
    this.showBackButton = true, // 기본값을 true로 설정
    this.centerTitle = false,
    this.backColor,
  });

  final String title;
  final List<CustomIconButton> actions;
  final Function()? onBackPress;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Text(title,
            style: FontSystem.KR16M.copyWith(color: ColorSystem.grey.shade600)),
      ),
      centerTitle: centerTitle,
      surfaceTintColor: backColor,
      backgroundColor: backColor,
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      leadingWidth: 50,
      leading: IconButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          foregroundColor: backColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        icon: SvgPicture.asset(
          "assets/icons/appbar/arrow_back.svg",
          width: 38,
          height: 38,
        ),
        onPressed: onBackPress,
      ),
      actions: actions,
    );
  }
}
