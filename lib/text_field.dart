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
  final Color? typingStateColor;
  final VoidCallback? onSuffixIconPressed;
  final TextInputFormatter? inputFormatter;
  final TextEditingController? controller;

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
      this.typingStateColor,
      // this.obscureText = false,
      this.onSuffixIconPressed,
      this.inputFormatter,
      this.controller});

  @override
  State<TextFieldWidget> createState() =>
      _TextFieldWidgetState(emptyPasswordFocusNode: FocusNode());
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool emptyShowPussword = false;

  late FocusNode emptyPasswordFocusNode;

  String errorText = '';

  _TextFieldWidgetState({
    required this.emptyPasswordFocusNode,
  });

  @override
  void initState() {
    super.initState();
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
    final typingStateColor = widget.typingStateColor ?? const Color(0xFF006FFD);
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
        //labelText: 'Title',                   //title
        border: OutlineInputBorder(
          //борт для Error состояния
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
            //борт в typing состоянии
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: typingStateColor, width: 2)),
        enabledBorder: OutlineInputBorder(
            //борт в empty состоянии
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: emptyStateColor, width: 1)),
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
}
