import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  final int codeLength;
  final ValueChanged<String> onCodeEntered;
  final Color? accentColor;

  const CodeInputWidget({
    super.key,
    this.codeLength = 5,
    required this.onCodeEntered,
    this.accentColor,
  });

  @override
  CodeInputWidgetState createState() => CodeInputWidgetState();
}

class CodeInputWidgetState extends State<CodeInputWidget> {
  late List<FocusNode> focusNodes;
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(widget.codeLength, (_) => FocusNode());
    controllers =
        List.generate(widget.codeLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void clearCode() {
    for (var controller in controllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  void nextField(String value, int index) {
    if (value.length == 1) {
      if (index < widget.codeLength - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
        final code = controllers.map((controller) => controller.text).join();
        widget.onCodeEntered(code);
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.codeLength, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: SizedBox(
            width: 50,
            height: 60,
            child: TextField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: widget.accentColor ?? const Color(0xFFF1EDF5),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                      //борт в typing состоянии
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFFA03FFF), width: 2))),
              onChanged: (value) => nextField(value, index),
            ),
          ),
        );
      }),
    );
  }
}
