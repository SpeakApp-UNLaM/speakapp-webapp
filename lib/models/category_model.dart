import 'package:speak_app_web/config/param.dart';

import '../domain/entities/category.dart';

class CategoryModel {
  int? idTask;
  Categories category;
  int level;

  CategoryModel({
    required this.idTask,
    required this.category,
    required this.level,
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
