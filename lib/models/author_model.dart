import 'dart:convert';

List<AuthorModel> AuthorModelFromJson(String str) => List<AuthorModel>.from(
    json.decode(str).map((x) => AuthorModel.fromJson(x)));

class AuthorModel {
  int id;
  String firstName;
  String lastName;
  String? imageData;

  AuthorModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.imageData});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      imageData: json["imageData"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "imageData": imageData
  };
}
