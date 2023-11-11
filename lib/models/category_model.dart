import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/exercise_model.dart';

import '../domain/entities/category.dart';

class CategoryModel {
  int? idTask;
  Categories category;
  int level;
  DateTime endDate;

  List<ExerciseModel>? exercisesResult; 

  CategoryModel({
    required this.idTask,
    required this.category,
    required this.level,
    required this.endDate,
    this.exercisesResult
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        idTask: json["idTask"],
        category: Param.stringToEnumCategories(json["category"]),
        level: json["level"],
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']).subtract(const Duration(hours: 3)) : DateTime.now()
      );

  Map<String, dynamic> toJson() => {
        "idTask": idTask,
        "category": category,
        "level": level,
      };

  Category toCategoryEntity() => Category(category: category, level: level, idTask: idTask ?? 0);
}
