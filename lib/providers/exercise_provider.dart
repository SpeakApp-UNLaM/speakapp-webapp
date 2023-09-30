import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/category_model.dart';

class ExerciseData {
  int phonemeId;
  int? level;
  List<Categories> categories;

  ExerciseData(
      {required this.phonemeId, required this.level, required this.categories});

  Map<String, dynamic> toJson() => {
        "idPhoneme": phonemeId,
        "level": level,
        "categories": categories.map((category) => category.name).toList()
      };
}

class ExerciseProvider extends ChangeNotifier {
  late ExerciseData data =
      ExerciseData(phonemeId: 0, level: null, categories: []);

  set setPhonemeId(int phonemeId) {
    data.phonemeId = phonemeId;
  }

  set setLevel(int level) {
    data.level = level;
  }

  set setCategories(List<Categories> cat) {
    data.categories = cat;
  }

  void refreshData() {
    data = ExerciseData(phonemeId: 0, level: null, categories: []);
  }

  Future<Response> sendExercise(int idPatient) async {
    print(data.toJson());
    Response response =
        await Api.post("${Param.postTasks}/$idPatient", data.toJson());

    refreshData();

    return response;
  }

  Future<Response> removeExercise(int idTask) async {
    Response response = await Api.delete("${Param.postTasks}/$idTask");

    return response;
  }
}
