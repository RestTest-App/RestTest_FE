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
    // 기본 자산은 왼쪽 화살표
    Widget arrow = SvgPicture.asset(
      'icons/common/arrow.svg',
      // color 대신 colorFilter 사용
      colorFilter: ColorFilter.mode(
        enabled ? ColorSystem.blue : ColorSystem.grey[400]!,
        BlendMode.srcIn,
      ),
    );

    // 오른쪽 버튼인 경우 좌우 반전
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
