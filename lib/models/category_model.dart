import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/exercise_model.dart';

import '../domain/entities/category.dart';

class CategoryModel {
  int? idTask;
  Categories category;
  int level;
  List<ExerciseModel>? exercisesResult; 

  CategoryModel({
    required this.idTask,
    required this.category,
    required this.level,
    this.exercisesResult
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        idTask: json["idTask"],
        category: Param.stringToEnumCategories(json["category"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "idTask": idTask,
        "category": category,
        "level": level,
      };

  Category toCategoryEntity() => Category(category: category, level: level, idTask: idTask ?? 0);
}
