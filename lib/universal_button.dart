import 'dart:math';

import 'package:flutter/material.dart';

enum UniversalButtonState { active, highlight, skeleton }

class UniversalButton extends StatelessWidget {
  final int id;
  final String title;
  final String desc;
  final UniversalButtonState state;
  final VoidCallback onPressed;

  const UniversalButton({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UniversalButtonState.active:
        return buildReal(UniversalButtonState.active);
      case UniversalButtonState.highlight:
        return buildReal(UniversalButtonState.highlight);
      case UniversalButtonState.skeleton:
        return buildSkeleton();
    }
  }

  Widget buildReal(UniversalButtonState state) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 186,
          height: 150,
          decoration: BoxDecoration(
            color: state == UniversalButtonState.active
                ? const Color.fromRGBO(255, 255, 255, 1)
                : const Color.fromRGBO(160, 63, 255, 1),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), blurRadius: 4),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: state == UniversalButtonState.active
                          ? Colors.black
                          : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  Text(
                    desc,
                    maxLines: 4,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: state == UniversalButtonState.active
                          ? const Color.fromRGBO(145, 129, 166, 1)
                          : const Color.fromRGBO(214, 181, 255, 1),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
              Positioned(
                  bottom: 0.14,
                  right: 0,
                  child: Transform.rotate(
                    angle: pi / 12,
                    child: Image.asset(
                      'assets/pngs/rocket.png',
                      width: 66,
                      height: 66,
                    ),
                  )),
            ],
          ),
        ));
  }

  Widget buildSkeleton() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 186,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 166,
            height: 26,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(241, 237, 245, 1),
                borderRadius: BorderRadius.circular(12)),
          ),
          const SizedBox(height: 8),
          Container(
            width: 104,
            height: 15,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(241, 237, 245, 1),
                borderRadius: BorderRadius.circular(12)),
          ),
        ],
      ),
    );
  }
}
