import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/domain/entities/result_pair_images.dart';

class ResultExercise {
  TypeExercise type;
  String audio;
  int idTaskItem;
  List<ResultPairImages> pairImagesResult;
  ResultExercise(
      {required this.type,
      required this.audio,
      required this.pairImagesResult,
      required this.idTaskItem});
}
