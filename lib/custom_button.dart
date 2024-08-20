import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomButtonVariants { primary, secondary, terciary }

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final CustomButtonVariants variant;
  final SvgPicture? leftSvg;
  final SvgPicture? rightSvg;
  final Color? accentColor;
  final Color? textColor;
  final bool showText;
  final bool showLeftSvg;
  final bool showRightSvg;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double radius;

  const CustomButtonWidget({
    super.key,
    required this.variant,
    required this.onPressed,
    this.text = '',
    this.leftSvg,
    this.rightSvg,
    this.accentColor,
    this.textColor,
    this.width,
    this.height,
    this.radius = 12,
    this.showText = true,
    this.showLeftSvg = false,
    this.showRightSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = accentColor ?? Theme.of(context).primaryColor;

    Color borderColor;
    Color backgroundColor;
    Color textColor;

    switch (variant) {
      case CustomButtonVariants.primary:
        borderColor = Colors.transparent;
        backgroundColor = primaryColor;
        textColor = Colors.white;
        break;
      case CustomButtonVariants.secondary:
        borderColor = primaryColor;
        backgroundColor = Colors.transparent;
        textColor = primaryColor;
        break;
      case CustomButtonVariants.terciary:
        borderColor = Colors.transparent;
        backgroundColor = Colors.transparent;
        textColor = primaryColor;
        break;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor),
        ),
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(textColor),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(Color colorOfText) {
    List<Widget> children = [];

    if (showLeftSvg && leftSvg != null) {
      children.add(leftSvg!);
      if (showText) children.add(const SizedBox(width: 8));
    }

    if (showText) {
      children.add(
        Text(
          text,
          style: GoogleFonts.inter(
            color: textColor ?? colorOfText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      );
    }

    if (showRightSvg && rightSvg != null) {
      if (showText) {
        children.add(const SizedBox(width: 8));
      }
      children.add(rightSvg!);
    }

    return children;
  }
}
