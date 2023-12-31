import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  int userId;
  String username;
  String firstName;
  String lastName;

  String email;
  String phone;
  String type;
  String token;
  String renewalToken;
  String? imageData;

  User(
      {required this.userId,
      required this.username,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.type,
      required this.token,
      required this.renewalToken,
      this.imageData});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        username: responseData['username'],
        firstName: responseData['firstName'],
        lastName: responseData['lastName'],
        email: responseData['email'],
        phone: responseData['phone'],
        type: responseData['type'],
        token: responseData['access_token'],
        renewalToken: responseData['renewal_token'], 
        imageData: responseData["imageData"]);
  }
}
