import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum ToastVariant { informative, success, warning, error }

enum ToastSide { bottom, top }

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
  ToastManager._internal();

  static final ToastManager _instance = ToastManager._internal();
  static ToastManager get instance => _instance;

  OverlayEntry? _overlayEntry;

  factory ToastManager() {
    return _instance;
  }

  static void showToast(BuildContext context, ToastWidget toast, ToastSide side,
      {double left = 32,
      double right = 32,
      double top = 16,
      double bottom = 16}) {
    instance._showToast(context, toast, side,
        left: left, right: right, top: top, bottom: bottom);
  }

  void _showToast(BuildContext context, ToastWidget toast, ToastSide side,
      {double left = 32,
      double right = 32,
      double top = 16,
      double bottom = 16}) {
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: side == ToastSide.top
            ? MediaQuery.of(context).padding.top + top
            : null,
        left: left,
        right: right,
        bottom: side == ToastSide.bottom
            ? MediaQuery.of(context).padding.bottom + bottom
            : null,
        child: Material(
          color: Colors.transparent,
          child: toast,
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hideToast() => instance._hideToast();

  void _hideToast() {
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

  final double? width;
  final double? height;

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
    this.width,
    this.height,
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
        ToastManager.hideToast();
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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showTitle && widget.title != null)
                  Text(
                    widget.title!,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 14 / 12,
                    ),
                  ),
                if (widget.showDescription && widget.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.description!,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 16 / 12,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
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
              ToastManager.hideToast();
            },
            child: SvgPicture.asset("assets/svgs/close.svg"),
          ),
        ],
      ),
    );
  }
}
