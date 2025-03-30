import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavigationItem extends StatelessWidget {
  const CustomBottomNavigationItem({
    super.key,
    required this.isActive,
    required this.assetPath,
  });

  final bool isActive;
  final String assetPath;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 12),
        _buildImageView(),
        SizedBox(height: 8)
      ],
    );
  }

  Widget _buildImageView() {
    return SvgPicture.asset(
      assetPath,
      colorFilter: isActive
          ? const ColorFilter.mode(
        Color(0xFF0B60B0),
        BlendMode.srcIn,
      )
          : const ColorFilter.mode(
        Color(0xFFD2D2D2),
        BlendMode.srcIn,
      ),
      height: 26,
    );
  }
}