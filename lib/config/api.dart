import 'dart:io';
import 'package:dio/dio.dart';
import 'package:speak_app_web/config/param.dart';

class Api {
  static final Dio _dio = Dio();

  static void configureDio() {
    ///Base url
    _dio.options.baseUrl = Param.urlServer;
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  static Future get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      Response<dynamic> resp;
      if (queryParameters != null) {
        resp = await _dio.get(path, queryParameters: queryParameters);
      } else {
        resp = await _dio.get(path);
      }

      return resp;
    } on DioException catch (e) {
      Param.showToast('Error en el GET: $e');
    }
    return null;
  }

  static Future post(String path, Map<String, dynamic> data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      print('Error en el POST: $e');
      Param.showToast('Error en el POST: $e');
    }
    return null;
  }

  static Future put(String path, [Map<String, dynamic>? data, Map<String, dynamic>? queryParameters]) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters);
    } catch (e) {
      throw ('Error en el PUT');
    }
  }

  static Future delete(String path) async {
    try {
      final resp = await _dio.delete(path);
      return resp;
    } catch (e) {
      throw ('Error en el delete');
    }
  }

  static void setToken(String token) {
    if (token != "") {
      _dio.options.headers[HttpHeaders.authorizationHeader] = "Bearer $token";
    }
  }
}
