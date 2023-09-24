import 'package:flutter/material.dart';

class Exercise {
  late Image img;
  String letra;
  String resultExpected = "";
  int idGroup;
  int level = 1;
  int id;
  Exercise(
      {required this.id,
      required pathImg,
      required this.letra,
      resultExpected,
      required this.idGroup,
      level}) {
    img = Image.asset(pathImg, width: 200, height: 200);
    resultExpected = resultExpected;
    level = level;
  }

  Image getImage() => img;
  String getLetra() => letra;
  int getIdGroup() => idGroup;
}
