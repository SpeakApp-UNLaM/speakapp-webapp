import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';

class MessageProvider extends ChangeNotifier {
  List<types.Message> _messages = [];
  int _userTo = 0;
  String _userToFirstName = "";
  String _userToLastName = "";
  Image? _userToImageData;
  List<types.Message> get messages => _messages;

  int get userTo => _userTo;
  String get userToFirstName => _userToFirstName;
  String get userToLastName => _userToLastName;
  Image? get userToImageData => _userToImageData;



  void updateUserTo(int userId, String firstName, String lastName, String? imageData) {
    _userTo = userId;
    _userToFirstName = firstName;
    _userToLastName = lastName;
    _userToImageData = imageData != null ? Image.memory(base64.decode(imageData),
                                                fit: BoxFit.cover) : null;
    notifyListeners();
  }

  void updateMessages() async {
    if (_userTo != 0) {
      final response = await Api.get("${Param.getMessages}/$_userTo",
          queryParameters: {"limit": 20});
      _messages.clear();
      response.data.forEach((e) {
        e['id'] = e['id'].toString();
        e['author']['id'] = e['author']['id'].toString();

        _messages.add(types.Message.fromJson(e));
      });
      notifyListeners();
    }
  }
}
