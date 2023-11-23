import 'dart:convert';

import 'package:flutter/material.dart';

List<PatientModel> PatientModelFromJson(String str) => List<PatientModel>.from(
    json.decode(str).map((x) => PatientModel.fromJson(x)));

class PatientModel {
  int idPatient;
  String username;
  String email;
  String firstName;
  String lastName;
  String? tutor;
  String? phone;
  int? age;
  String? gender;
  String? createdAt;
  Image? imageData;

  PatientModel(
      {required this.idPatient,
      required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.tutor,
      required this.phone,
      required this.age,
      required this.gender,
      required this.createdAt,
      this.imageData});

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
        idPatient: json["idPatient"],
        username: json["username"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        tutor: json["tutor"],
        phone: json["phone"],
        age: json["age"],
        gender: json["gender"],
        createdAt: json["createAt"],
        imageData: json["imageData"] != null ? Image.memory(base64.decode(json["imageData"]),
                                                fit: BoxFit.cover) : null);
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
