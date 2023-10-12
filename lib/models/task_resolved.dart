import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/phoneme_model.dart';

import '../domain/entities/phoneme.dart';

class TaskResolvedModel {
  final PhonemeModel phonemeModel;
  final List<CategoryModel> categoriesModel;

  TaskResolvedModel({required this.phonemeModel, required this.categoriesModel});

  factory TaskResolvedModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> categoriesList = json['tasks'];

    final phoneme = PhonemeModel(namePhoneme: json['name'], idPhoneme: json['idPhoneme']);
    final categoriesModel = categoriesList
        .map((categoryJson) => CategoryModel.fromJson(categoryJson))
        .toList();

    return TaskResolvedModel(phonemeModel: phoneme, categoriesModel: categoriesModel);
  }

}
