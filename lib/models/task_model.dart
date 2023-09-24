import 'dart:convert';
import 'package:speak_app_web/domain/entities/category.dart';
import 'package:speak_app_web/domain/entities/task.dart';

import 'phoneme_model.dart';
import 'category_model.dart';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

class TaskModel {
  final PhonemeModel phonemeModel;
  final List<CategoryModel> categoriesModel;

  TaskModel({required this.phonemeModel, required this.categoriesModel});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final phonemeJson = json['phoneme'] as Map<String, dynamic>;
    final List<dynamic> categoriesList = json['categoriesDTO'];

    final phoneme = PhonemeModel.fromJson(phonemeJson);
    final categoriesModel = categoriesList
        .map((categoryJson) => CategoryModel.fromJson(categoryJson))
        .toList();

    return TaskModel(phonemeModel: phoneme, categoriesModel: categoriesModel);
  }
  Task toTaskEntity() {
    List<Category> categories = [];

    for (var element in categoriesModel) {
      categories.add(element.toCategoryEntity());
    }

    return Task(
        phoneme: phonemeModel.toPhonemeEntity(), categories: categories);
  }
}
