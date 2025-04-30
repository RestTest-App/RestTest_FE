import 'package:flutter/cupertino.dart';
import '../../utility/system/color_system.dart';
import '../../utility/system/font_system.dart';

class CustomPassTag extends StatelessWidget{
  const CustomPassTag ({
    super.key,
    required this.pass,
  });

  final bool pass;

  @override
  Widget build(BuildContext context) {
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
}