import 'package:flutter/material.dart';

enum CustomTagVariants { disabled, enabled }

class CustomTag extends StatefulWidget {
  final Widget text;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color? enabledBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final CustomTagVariants initialState;
  final bool showText;
  final bool showleftIcon;
  final bool showrightIcon;
  final bool isToggleEnabled;
  final double? radius;

  final double? height;
  final double? width;

  const CustomTag({
    super.key,
    required this.text,
    this.leftIcon,
    this.rightIcon,
    this.initialState = CustomTagVariants.disabled,
    this.showText = true,
    this.showleftIcon = false,
    this.showrightIcon = false,
    this.enabledBackgroundColor,
    this.disabledBackgroundColor,
    this.enabledTextColor,
    this.disabledTextColor,
    this.isToggleEnabled = true,
    this.radius,
    this.height,
    this.width, // По умолчанию toggle включен
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
    if (widget.isToggleEnabled) {
      // Проверка, включен ли toggle
      setState(() {
        _state = _state == CustomTagVariants.disabled
            ? CustomTagVariants.enabled
            : CustomTagVariants.disabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _state == CustomTagVariants.disabled
        ? (widget.disabledBackgroundColor ??
            Colors.grey.shade300) // Дефолтный цвет для disabled
        : (widget.enabledBackgroundColor ??
            Colors.blue.shade300); // Дефолтный цвет для enabled

    final Color textColor = _state == CustomTagVariants.disabled
        ? (widget.disabledTextColor ??
            Colors.black54) // Дефолтный цвет для текста в disabled
        : (widget.enabledTextColor ??
            Colors.white); // Дефолтный цвет для текста в enabled

    return GestureDetector(
      onTap: _toggleState,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.radius ?? 14),
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

    if (widget.showleftIcon && widget.leftIcon != null) {
      children.add(widget.leftIcon!);
      children.add(const SizedBox(width: 4));
    }

    if (widget.showText) {
      children.add(
        Center(child: widget.text),
      );
    }

    if (widget.showrightIcon && widget.rightIcon != null) {
      children.add(widget.rightIcon!);
    }

    return children;
  }
}
