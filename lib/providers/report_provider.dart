import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:speak_app_web/config/api.dart';
import 'package:speak_app_web/config/param.dart';
import 'package:speak_app_web/models/category_model.dart';
import 'package:speak_app_web/models/report_model.dart';


class ReportProvider extends ChangeNotifier {
  late ReportModel data = ReportModel(id: 0, title: "", body: "", createdAt: "");

  set setId(int id) {
    data.id = id;
  }

  set setTitle(String title) {
    data.title = title;
  }

  set setBody(String body) {
    data.body = body;
  }

  void refreshData() {
    data = ReportModel(id: 0, title: "", body: "", createdAt: "");
  }

  Future<Response> sendReport(int idPatient) async {
    Response response =
        await Api.post("${Param.getReports}/$idPatient", data.toJson());

    refreshData();

    return response;
  }

  Future<Response> removeReport(int id) async {
    Response response = await Api.delete("${Param.getReports}/$id");

    return response;
  }

  
  Future<Response> updateReport(int id) async {
    Response response = await Api.put("${Param.getReports}/$id", data.toJson());

    return response;
  }
}
