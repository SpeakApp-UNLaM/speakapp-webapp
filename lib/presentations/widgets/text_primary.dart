import 'package:flutter/material.dart';

class TextPrimary extends StatelessWidget {
  final String text;
  final Color color;
  const TextPrimary({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'IkkaRounded',
            fontSize: 20,
            color: color));
  }
}
