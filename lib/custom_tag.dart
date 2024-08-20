import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTagVariants { disabled, enabled }

class CustomTag extends StatefulWidget {
  final String text;
  final SvgPicture? leftSvg;
  final SvgPicture? rightSvg;
  final CustomTagVariants initialState;
  final bool showText;
  final bool showLeftSvg;
  final bool showRightSvg;

  const CustomTag({
    super.key,
    required this.text,
    this.leftSvg,
    this.rightSvg,
    this.initialState = CustomTagVariants.disabled,
    this.showText = true,
    this.showLeftSvg = false,
    this.showRightSvg = false,
  });

  @override
  CustomTagState createState() => CustomTagState();
}

class CustomTagState extends State<CustomTag> {
  late CustomTagVariants _state;

  @override
  void initState() {
    super.initState();
    _state = widget.initialState;
  }

  void _toggleState() {
    setState(() {
      _state = _state == CustomTagVariants.disabled
          ? CustomTagVariants.enabled
          : CustomTagVariants.disabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _state == CustomTagVariants.disabled
        ? const Color(0xFFEAF2FF)
        : Theme.of(context).primaryColor;
    final Color textColor = _state == CustomTagVariants.disabled
        ? Theme.of(context).primaryColor
        : Colors.white;

    return GestureDetector(
      onTap: _toggleState,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: const BoxConstraints(minHeight: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildChildren(textColor),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(Color textColor) {
    final List<Widget> children = [];

    if (widget.showLeftSvg && widget.leftSvg != null) {
      children.add(widget.leftSvg!);
      children.add(const SizedBox(width: 8));
    }

    if (widget.showText) {
      children.add(
        Center(
          child: Text(
            widget.text,
            style: GoogleFonts.inter(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ),
      );
    }

    if (widget.showRightSvg && widget.rightSvg != null) {
      if (widget.showText) {
        children.add(const SizedBox(width: 8));
      }
      children.add(widget.rightSvg!);
    }

    return children;
  }
}
