import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldWidget extends StatefulWidget {
  final String? title;
  final String? placeHolder;
  final SvgPicture? icon;
  final String? unit;
  final bool showTitle;
  final bool showPlaceHolder;
  final bool showIcon;
  final bool showUnit;
  final Color typingStateColor;
  final Color errorStateColor;
  final Color emptyStateColor;
  final VoidCallback? onSuffixIconPressed;
  final TextInputFormatter? inputFormatter;
  final TextEditingController? controller;
  final bool hasError;
  final TextInputType? keyboard;

  const TextFieldWidget(
      {super.key,
      this.title,
      this.showTitle = false,
      this.placeHolder,
      this.showPlaceHolder = true,
      this.icon,
      this.showIcon = false,
      this.unit,
      this.showUnit = false,
      this.hasError = false,
      this.typingStateColor = const Color(0xFF006FFD),
      this.emptyStateColor = const Color(0xFFC5C6CC),
      this.errorStateColor = const Color(0xFFFFE2E5),
      this.onSuffixIconPressed,
      this.inputFormatter,
      this.controller,
      this.keyboard});

  @override
  State<TextFieldWidget> createState() =>
      TextFieldWidgetState(emptyPasswordFocusNode: FocusNode());
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  bool emptyShowPussword = false;
  late bool _hasError;

  late FocusNode emptyPasswordFocusNode;

  String errorText = '';

  TextFieldWidgetState({
    required this.emptyPasswordFocusNode,
  });

  @override
  void initState() {
    super.initState();
    _hasError = widget.hasError;
    emptyPasswordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    emptyPasswordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _emptyTextField();
  }

  Widget _emptyTextField() {
    const emptyStateColor = Color(0xFFC5C6CC);

    return TextField(
      onChanged: (value) {
        setState(() {
          if (value.length > 15) {
            errorText = 'Error';
          } else {
            errorText = '';
          }
        });
      },
      controller: widget.controller,
      keyboardType: widget.keyboard,
      focusNode: emptyPasswordFocusNode,
      enabled: true, //если установить false , то будет состояние inactive
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(emptyPasswordFocusNode);
        });
      },
      style: textStyle(),
      obscureText: emptyShowPussword,
      inputFormatters:
          widget.inputFormatter != null ? [widget.inputFormatter!] : [],
      decoration: InputDecoration(
        prefixIcon: widget.showUnit && widget.unit != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 4, 16),
                child: Text(
                  widget.unit!,
                  style: textStyle(),
                ))
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorText: errorText.isEmpty ? null : errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: _hasError
                    ? widget.errorStateColor
                    : widget.typingStateColor,
                width: 2)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: _hasError ? widget.errorStateColor : emptyStateColor,
                width: 1)),
        suffixIcon: widget.showIcon && widget.icon != null
            ? IconButton(
                icon: widget.icon!,
                onPressed: () {
                  if (widget.onSuffixIconPressed != null) {
                    widget.onSuffixIconPressed!();
                  }
                },
              )
            : null,
        hintText: widget.showPlaceHolder && widget.placeHolder != null
            ? widget.placeHolder
            : null,
      ),
    );
  }

  TextStyle textStyle() {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Colors.black,
    );
  }

  void enableErrorState() {
    setState(() {
      _hasError = true;
    });
  }

  void disableErrorState() {
    setState(() {
      _hasError = false;
    });
  }
}
