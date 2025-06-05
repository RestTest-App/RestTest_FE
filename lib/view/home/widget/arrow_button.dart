import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rest_test/utility/system/color_system.dart';

class ArrowButton extends StatelessWidget {
  final bool isLeft;
  final bool enabled;
  final VoidCallback onPressed;

  const ArrowButton({
    super.key,
    required this.isLeft,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget arrow = SvgPicture.asset(
      'icons/common/arrow.svg',
      colorFilter: ColorFilter.mode(
        enabled ? ColorSystem.blue : ColorSystem.grey[400]!,
        BlendMode.srcIn,
      ),
    );

    if (!isLeft) {
      arrow = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0),
        child: arrow,
      );
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 32,
      onPressed: enabled ? onPressed : null,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ColorSystem.grey[200],
          shape: BoxShape.circle,
        ),
        child: arrow,
      ),
    );
  }
}
