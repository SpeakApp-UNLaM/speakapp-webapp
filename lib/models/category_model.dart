import 'package:speak_app_web/config/param.dart';

import '../domain/entities/category.dart';

class CategoryModel {
  Categories category;
  int level;

  CategoryModel({
    required this.category,
    required this.level,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        category: Param.stringToEnumCategories(json["category"]),
        level: json["level"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "level": level,
      };

  Category toCategoryEntity() => Category(category: category, level: level);
}
