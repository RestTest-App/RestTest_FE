import 'package:flutter/material.dart';
import '../../utility/system/font_system.dart';
import '../button/custom_icon_button.dart';

class DefaultAppBar extends StatelessWidget {
  const DefaultAppBar({
    super.key,
    required this.title,
    this.actions = const <CustomIconButton>[],
    this.backColor,
  });

  final String title;
  final List<CustomIconButton> actions;
  final Color? backColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title,
          style: FontSystem.KR20SB,
        ),
      ),
      surfaceTintColor: backColor,
      backgroundColor:backColor,
      automaticallyImplyLeading: false,
      centerTitle: false,
      actions: actions,
    );
  }
}
