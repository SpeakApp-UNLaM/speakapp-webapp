import 'dart:convert';

import 'package:speak_app_web/models/author_model.dart';

List<ContactModel> ContactModelFromJson(String str) => List<ContactModel>.from(
    json.decode(str).map((x) => ContactModel.fromJson(x)));

class ContactModel {
  AuthorModel author;
  String? lastMessage;
  DateTime? lastDateMessage;

  ContactModel({
    required this.author,
    required this.lastMessage,
    required this.lastDateMessage,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      author: AuthorModel.fromJson(json["author"]),
      lastMessage: json["lastMessage"],
      lastDateMessage: json['endDate'] != null ? DateTime.parse(json['lastDateMessage']) : DateTime.now()
    );
  }

}
