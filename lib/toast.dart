import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ToastVariant { informative, success, warning, error }

Map<ToastVariant, Color> toastColors = {
  ToastVariant.informative: const Color(0xFFEAF2FF),
  ToastVariant.success: const Color(0xFFE7F4E8),
  ToastVariant.warning: const Color(0xFFFFF4E4),
  ToastVariant.error: const Color(0xFFFFE2E5),
};

Map<ToastVariant, SvgPicture> toastIcons = {
  ToastVariant.informative: svg("assets/svgs/informative.svg"),
  ToastVariant.success: svg("assets/svgs/success.svg"),
  ToastVariant.warning: svg("assets/svgs/warning.svg"),
  ToastVariant.error: svg("assets/svgs/error.svg"),
};

SvgPicture svg(String asset) {
  return SvgPicture.asset(asset);
}

class ToastManager {
  static final ToastManager _instance = ToastManager._internal();

  factory ToastManager() {
    return _instance;
  }

  ToastManager._internal();

  OverlayEntry? _overlayEntry;

  void showToast(BuildContext context, ToastWidget toast) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: toast,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideToast() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class ToastWidget extends StatefulWidget {
  final ToastVariant variant;
  final String? title;
  final String? description;
  final bool showTitle;
  final bool showDescription;
  final VoidCallback? onTapClose;
  final Map<ToastVariant, Color>? colors;
  final Map<ToastVariant, SvgPicture>? icons;
  final Duration duration;

  const ToastWidget({
    super.key,
    required this.variant,
    this.onTapClose,
    this.title,
    this.description,
    this.colors,
    this.icons,
    this.duration = const Duration(seconds: 3),
    this.showTitle = true,
    this.showDescription = true,
  });

  @override
  ToastWidgetState createState() => ToastWidgetState();
}

class ToastWidgetState extends State<ToastWidget> {
  bool _isVisible = true;
  late Map<ToastVariant, Color> _colors;
  late Map<ToastVariant, SvgPicture> _icons;

  @override
  void initState() {
    super.initState();
    _colors = widget.colors ?? toastColors;
    _icons = widget.icons ?? toastIcons;

    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
        if (widget.onTapClose != null) {
          widget.onTapClose!();
        }
        ToastManager().hideToast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: _colors[widget.variant],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _icons[widget.variant]!,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showTitle && widget.title != null)
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 14 / 12,
                    ),
                  ),
                if (widget.showDescription && widget.description != null)
                  const SizedBox(height: 4),
                Text(
                  widget.description!,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 16 / 12,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              if (widget.onTapClose == null) {
                setState(() {
                  _isVisible = false;
                });
              } else {
                widget.onTapClose?.call();
              }
              ToastManager().hideToast();
            },
            child: SvgPicture.asset("assets/svgs/close.svg"),
          ),
        ],
      ),
    );
  }
}
