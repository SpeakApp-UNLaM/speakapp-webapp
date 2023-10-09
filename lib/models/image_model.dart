class ImageExerciseModel {
  String name;
  String imageData;
  List<String> dividedName;
  int idImage;

  ImageExerciseModel({
    required this.name,
    required this.imageData,
    required this.dividedName,
    required this.idImage,
  });

  factory ImageExerciseModel.fromJson(Map<String, dynamic> json) {
    return ImageExerciseModel(
        name: json["name"],
        imageData: json["imageData"] ?? "",
        dividedName: (json["dividedName"] as String?)?.split('-') ?? [],
        idImage: json["idImage"]);
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageData": imageData,
        "dividedName": dividedName,
      };

  List<String> getSyllables() {
    return dividedName;
  }
}
