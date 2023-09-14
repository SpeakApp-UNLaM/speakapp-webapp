import 'package:flutter/material.dart';

import '../../config/theme/app_theme.dart';

class ButtonPhoneme extends StatelessWidget {
  final int idPhoneme;
  final String namePhoneme;

  const ButtonPhoneme({
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
              onPressed: () {},
              backgroundColor: colorList[0],
              elevation: 10.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(namePhoneme.replaceAll("CONSONANTICA", "").trim(),
                      style: TextStyle(
                        fontSize: 36,
                        color: colorList[2],
                        fontFamily: 'IkkaRounded',
                      )),
                  if (namePhoneme.length > 3)
                  Text("Consonántica",
                      style: TextStyle(
                        fontSize: 12,
                        color: colorList[2],
                        fontFamily: 'IkkaRounded',
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
