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

  static Future get(String path) async {
    try {

/*
      if (authToken != null) {
        _dio.options.headers['Authorization'] =
          authToken; // Agre
      }*/

      final resp = await _dio.get(path);

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

  static Future put(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      throw ('Error en el PUT');
    }
  }

  static Future delete(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.delete(path, data: formData);
      return resp.data;
    } catch (e) {
      throw ('Error en el delete');
    }
  }
}
