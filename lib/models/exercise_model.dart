import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:speak_app_web/config/param.dart';
import 'image_model.dart';

List<ExerciseModel> exerciseModelFromJson(String str) =>
    List<ExerciseModel>.from(
        json.decode(str).map((x) => ExerciseModel.fromJson(x)));

class ExerciseModel {
  int idTaskItem;
  TypeExercise type;
  String result;
  List<ImageExerciseModel> images;

  ExerciseModel({
    required this.idTaskItem,
    required this.type,
    required this.result,
    required this.images,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      idTaskItem: json["idTaskItem"], // Valor predeterminado si es nulo
      type: Param.stringToEnumTypeExercise(json["type"]),
      result: json["result"] ?? "", // Valor predeterminado si es nulo
      images: (json["images"] as List<dynamic>?)
              ?.map((x) => ImageExerciseModel.fromJson(x))
              .toList() ??
          [],
    );
  }

  get category => null;

  Map<String, dynamic> toJson() => {
        "exerciseId": idTaskItem,
        "type": type,
        "result": result,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };

/*
  StatefulWidget fromEntity(String letra) {
    switch (type) {
      case TypeExercise.speak:
        return PageExerciseSpeak(
          images,
          result,
          namePhoneme: letra,
          idTaskItem: idTaskItem,
        );
      case TypeExercise.multiple_match_selection:
        return PageExerciseMultipleMatchSel(
          images: images,
          namePhoneme: letra,
          idTaskItem: idTaskItem,
        );
      case TypeExercise.order_syllable:
        return PageExerciseOrderSyllabe(
          img: images.first,
          namePhoneme: letra,
          idTaskItem: idTaskItem,
          syllables: images.first.dividedName,
        );
      case TypeExercise.minimum_pairs_selection:
        return PageExerciseMinimumPairsSel(
            images: images, namePhoneme: letra, idTaskItem: idTaskItem);
      case TypeExercise.multiple_selection:
        return PageExerciseMultipleSelection(
            images: images,
            namePhoneme: letra,
            idTaskItem: idTaskItem,
            syllable: result);
      case TypeExercise.single_selection_syllable:
        return PageExerciseSingleSelectionSyllable(
            images: images,
            namePhoneme: letra,
            idTaskItem: idTaskItem,
            syllable: result);
      case TypeExercise.single_selection_word:
        return PageExerciseSingleSelectionWord(
            images: images,
            namePhoneme: letra,
            idTaskItem: idTaskItem,
            syllable: result);
      case TypeExercise.consonantal_syllable:
        return PageExerciseConsonantalSyllable(
          images: images,
          namePhoneme: letra,
          idTaskItem: idTaskItem,
        );
      default:
        return PageExerciseSpeak(
          images,
          result,
          namePhoneme: letra,
          idTaskItem: idTaskItem,
        );
    }
  }*/
}
