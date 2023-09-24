import 'phoneme.dart';
import 'category.dart';

class Task {
  final Phoneme phoneme;
  final List<Category> categories;
  Task({required this.phoneme, required this.categories});
}
