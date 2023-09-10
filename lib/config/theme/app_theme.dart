import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorList = <Color>[
  Color(0xFFffc957),
  Color(0xFFffa834),
  Color(0xFFff8351),
  Color(0xFFd7eb5a),
  Color(0xFF72bb53),
  Color(0xFF91e4fb),
  Color(0xFF008db1),
  Color(0xFFE6EEFE)
];

class AppTheme {
  static ThemeData theme() {
    return ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromRGBO(12, 87, 251, 196),
        textTheme: TextTheme(
            headlineLarge: const TextStyle(
                fontSize: 24.0,
                color: Color(0xFF0277BD),
                fontFamily: 'IkkaRounded'),
            titleLarge: const TextStyle(fontSize: 35),
            titleMedium: const TextStyle(
              fontSize: 15,
              color: Color(0xFF0277BD),
              fontFamily: 'IkkaRounded',
              fontWeight: FontWeight.w400,
            ),
            titleSmall: const TextStyle(
              fontSize: 12,
              color: Color(0xFF0277BD),
              fontFamily: 'IkkaRounded',
              fontWeight: FontWeight.w400,
            ),
            labelSmall: const TextStyle(
                fontSize: 12,
                color: Color(0xFFF5F5F5),
                fontFamily: 'IkkaRounded',
                fontWeight: FontWeight.w400),
            labelMedium: const TextStyle(
                color: Color(0xFFF5F5F5),
                fontFamily: 'IkkaRounded',
                fontWeight: FontWeight.w400),
            labelLarge: const TextStyle(
                color: Color(0xFFF5F5F5),
                fontFamily: 'IkkaRounded',
                fontWeight: FontWeight.w400),
            bodySmall: GoogleFonts.nunito(
                textStyle:
                    const TextStyle(fontSize: 10, color: Color(0xFF4b4b4b))),
            bodyMedium: GoogleFonts.nunito(
                textStyle:
                    const TextStyle(fontSize: 15, color: Color(0xFF4b4b4b))),
            bodyLarge: GoogleFonts.nunito(
                textStyle:
                    const TextStyle(fontSize: 18, color: Color(0xFF4b4b4b)))));
  }
}
