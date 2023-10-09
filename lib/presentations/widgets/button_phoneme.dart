import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/theme/app_theme.dart';

class ButtonPhoneme extends StatelessWidget {
  final int idPhoneme;
  final String namePhoneme;
  final int idPatient;

  const ButtonPhoneme({
    required this.idPatient,
    required this.idPhoneme,
    required this.namePhoneme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.0,
      width: 120.0,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 136,
              width: 116,
              decoration: BoxDecoration(
                color: colorList[1],
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
          Container(
            height: 135,
            width: 114,
            decoration: BoxDecoration(
              color: colorList[0],
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: FloatingActionButton(
              heroTag: idPhoneme.toString(),
              onPressed: () {
                context.goNamed("manage_phoneme_exercises", pathParameters: {
                  'idPatient': idPatient.toString(),
                  'idPhoneme': idPhoneme.toString(),
                }, extra: namePhoneme);
              },
              backgroundColor: colorList[0],
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(namePhoneme.replaceAll("CONSONANTICA", "").trim(),
                      style: GoogleFonts.nunito(
                          fontSize: 36,
                          color: colorList[2],
                          fontWeight: FontWeight.w900
                        )),
                  if (namePhoneme.length > 3)
                    Text("Consonántica",
                        style: GoogleFonts.nunito(
                          fontSize: 12,
                          color: colorList[2],
                          fontWeight: FontWeight.w700
                        ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
