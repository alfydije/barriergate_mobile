import 'package:flutter/material.dart';

class QButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double minWidth;
  final double height;
  final double borderRadius;

  const QButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = const Color.fromARGB(255, 189, 217, 239),
    this.textColor = const Color.fromARGB(255, 44, 64, 79),
    this.minWidth = 250,
    this.height = 40,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: minWidth,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
