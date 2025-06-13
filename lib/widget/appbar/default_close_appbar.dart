import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rest_test/utility/system/color_system.dart';
import 'package:rest_test/utility/system/font_system.dart';
import '../button/custom_icon_button.dart';

class DefaultCloseAppbar extends StatelessWidget {
  const DefaultCloseAppbar({
    super.key,
    required this.title,
    this.actions = const <CustomIconButton>[],
    this.onBackPress,
    this.showBackButton = true, // 기본값을 true로 설정
    this.centerTitle = true,
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
      title: Text(title,
          style: FontSystem.KR20SB.copyWith(color: ColorSystem.black)),
      centerTitle: centerTitle,
      surfaceTintColor: ColorSystem.white,
      backgroundColor: ColorSystem.white,
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      leadingWidth: 50,
      leading: IconButton(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          foregroundColor: ColorSystem.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        icon: SvgPicture.asset(
          "assets/icons/appbar/arrow_close.svg",
          width: 38,
          height: 38,
        ),
        onPressed: onBackPress,
      ),
      actions: actions,
    );
  }
}
