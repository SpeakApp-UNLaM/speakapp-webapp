import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/user.dart';
import '../auth/user_preferences.dart';
import '../config/api.dart';
import '../config/param.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;

  AuthProvider(this.prefs) {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }

  bool get loggedIn => _loggedIn;
  set loggedIn(bool value) {
    _loggedIn = value;
    prefs.setBool('LoggedIn', value);
    notifyListeners();
  }

  void checkLoggedIn() {
    loggedIn = prefs.getBool('LoggedIn') ?? false;
  }

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;

    Map<String, dynamic> data = {'username': username, 'password': password};

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await Api.post(Param.postLogin, data);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;

      var token = responseData['token'];
      loggedIn = true;
      //User authUser = User.fromJson(userData);
      User authUser = User(
          userId: 1,
          username: 'professional',
          email: 'professional',
          phone: '11311984311',
          type: 'professional',
          token: token,
          renewalToken: token);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.data)['error']
      };
    }
    return result;
  }

  logout() {
    UserPreferences().removeUser();
    _loggedIn = false;

    notifyListeners();
  }

/* TODO REGISTER
  Future<Map<String, dynamic>> register(String email, String password, String passwordConfirmation) async {

    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };


    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await post(AppUrl.register,
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {

      var userData = responseData['data'];

      User authUser = User.fromJson(userData);

      UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {

      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }
  */

  static onError(error) {
    print("the error is $error.detail");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
