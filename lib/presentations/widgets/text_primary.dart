import 'package:flutter/material.dart';

class TextPrimary extends StatelessWidget {
  final String text;

  const TextPrimary({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'IkkaRounded',
            fontSize: 20,
            color: Theme.of(context).primaryColorDark));
  }
}
