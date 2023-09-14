import 'dart:convert';

List<PatientModel> PatientModelFromJson(String str) => List<PatientModel>.from(
    json.decode(str).map((x) => PatientModel.fromJson(x)));

class PatientModel {
  int idPatient;
  String username;
  String email;
  String firstName;
  String lastName;
  int? age;
  String? gender;

  PatientModel(
      {required this.idPatient,
      required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.age,
      required this.gender});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      idPatient: json["idPatient"],
      username: json["username"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      age: json["age"],
      gender: json["gender"],
    );
  }

  Map<String, dynamic> toJson() => {
        "idPatient": idPatient,
        "username": username,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "age": age,
        "gender": gender,
  };
}
