import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/report_model.dart';


class PatientProvider extends ChangeNotifier {


  Future<Response> removePatient(int id) async {
    Response response = await Api.delete("${Param.getPatients}/$id");

    return response;
  }

  

}
