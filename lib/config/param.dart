import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speak_app_web/config/theme/app_theme.dart';

enum TypeExercise {
  speak,
  multiple_match_selection, // ignore: constant_identifier_names
  minimum_pairs_selection, // ignore: constant_identifier_names
  multiple_selection, // ignore: constant_identifier_names
  single_selection_syllable, // ignore: constant_identifier_names
  order_syllable, // ignore: constant_identifier_names
  single_selection_word, // ignore: constant_identifier_names
  consonantal_syllable, // ignore: constant_identifier_names
}

enum Categories { syllable, word, phrase }

class Param {
  //10.0.2.2 IP especial para emuladores, que mapea la IP del HOST el cual está ejecutando (equivalente a LOCALHOST)
  static const urlServer = "http://20.228.196.68:9292/speak-app/";
  static const postTranscription = "/speech-recognition/transcription";

  static const getCareers = "/careers";
  static const getExercises = "/tasks/items";
  static const getTasks = "/tasks/";
  static const getTasksByPhoneme = "/tasks/change-url";
  static const getPending = "/pending/1";
  static const getGroupExercises = "/groupExercises";
  static const getPatients = "/patients";
  static const getPhonemes = "/phonemes";
  static const getRfi = "/rfi";
  static const getResolvedExercises = "/resolve-exercises";
  static const modelWhisper = "whisper-1";
  static const postLogin = "/auth/signin";
  static const postTasks = "/tasks";

  static const tamImages = 120.0;

  static void showToast(String response) {
    Fluttertoast.showToast(
      msg: 'Error: $response', // Mensaje de la excepción
      toastLength: Toast
          .LENGTH_LONG, // Duración del toast (Toast.LENGTH_LONG o Toast.LENGTH_SHORT)
      gravity: ToastGravity
          .CENTER, // Posición del toast (ToastGravity.TOP, ToastGravity.CENTER, ToastGravity.BOTTOM)
      backgroundColor: Colors.red, // Color de fondo del toast
      textColor: Colors.white,
      timeInSecForIosWeb: 5 // Color del texto del toast
    );
  }

  static void showSuccessToast(String msg) {
    Fluttertoast.showToast(
      msg: msg, // Mensaje de la excepción
      toastLength: Toast
          .LENGTH_LONG, // Duración del toast (Toast.LENGTH_LONG o Toast.LENGTH_SHORT)
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colorList[4], // Color de fondo del toast
      textColor: Colors.white,
      timeInSecForIosWeb: 3,// Color del texto del toast
      fontSize: 18,
      webPosition: "center",
      webBgColor: "linear-gradient(#72bb53)"
    );
  }

  static TypeExercise stringToEnumTypeExercise(String value) =>
      TypeExercise.values
          .firstWhere((element) => element.toString() == 'TypeExercise.$value');

  static Map<Categories, String> categoriesDescriptions = {
    Categories.syllable: "Silaba",
    Categories.word: "Palabras",
    Categories.phrase: "Frases"
  };

   static Map<TypeExercise, String> typeExercisesDescription = {
    TypeExercise.speak: "Hablar",
    TypeExercise.order_syllable: "Ordenar Sílabas",
    TypeExercise.consonantal_syllable: "Sílaba Consonante",
    TypeExercise.minimum_pairs_selection: "Selección Pares Mínimos",
    TypeExercise.single_selection_syllable: "Selección de Sílaba",
    TypeExercise.multiple_match_selection: "Ordenar Selección Múltiple",
    TypeExercise.single_selection_word: "Selección de Palabra",
    TypeExercise.multiple_selection: "Selección Múltiple"
  };
  
  static Categories getCategoryFromDescription(String description) {
  for (var entry in categoriesDescriptions.entries) {
    if (entry.value == description) {
      return entry.key;
    }
  }
  return Categories.syllable; // Devolver null si no se encuentra ninguna coincidencia.
}

  static Categories stringToEnumCategories(String value) => Categories.values
      .firstWhere((element) => element.toString() == 'Categories.$value');
}
