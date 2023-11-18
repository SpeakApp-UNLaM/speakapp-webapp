import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/contact_model.dart';

class MessageProvider extends ChangeNotifier {
  List<types.Message> _messages = [];
  List<ContactModel> _contacts = [];
  List<Image?> _contactsImages = [];

  int _userTo = 0;
  int _userToSelected = 0;

  String _userToFirstName = "";
  String _userToLastName = "";
  Image? _userToImageData;
  List<types.Message> get messages => _messages;
  List<ContactModel> get contacts => _contacts;
  List<Image?> get contactsImages => _contactsImages;

  int get userTo => _userTo;
  int get userToSelected => _userToSelected;
  String get userToFirstName => _userToFirstName;
  String get userToLastName => _userToLastName;
  Image? get userToImageData => _userToImageData;

  void updateUserTo(
      int userId, int userSelected, String firstName, String lastName, String? imageData) {
    _userTo = userId;
    _userToSelected = userSelected;
    _userToFirstName = firstName;
    _userToLastName = lastName;
    _userToImageData = imageData != null
        ? Image.memory(base64.decode(imageData), fit: BoxFit.cover)
        : null;
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

  void updateContacts() async {
    List<ContactModel> contacts = [];
    List<Image?> contactsImages = [];

    final response = await Api.get(Param.getContacts);

    for (var element in response.data) {
      contacts.add(ContactModel.fromJson(element));
    }

    contacts.sort((a, b) => (b.lastDateMessage ?? DateTime(0))
        .compareTo(a.lastDateMessage ?? DateTime(0)));


    for (var element in contacts) {
      contactsImages.add(element.author.imageData == null
          ? null
          : Image.memory(base64.decode(element.author.imageData as String),
              fit: BoxFit.cover));
    }

    _userToSelected = contacts.indexWhere((element) =>  element.author.id == _userTo);
    _contacts = contacts;
    _contactsImages = contactsImages;

    notifyListeners();
    
  }
}
