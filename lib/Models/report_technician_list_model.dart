// To parse this JSON data, do
//
//     final reportTechnicianListModel = reportTechnicianListModelFromJson(jsonString);

import 'dart:convert';

ReportTechnicianListModel reportTechnicianListModelFromJson(String str) =>
    ReportTechnicianListModel.fromJson(json.decode(str));

String reportTechnicianListModelToJson(ReportTechnicianListModel data) =>
    json.encode(data.toJson());

class ReportTechnicianListModel {
  List<Datum> data;
  String message;

  ReportTechnicianListModel({
    required this.data,
    required this.message,
  });

  factory ReportTechnicianListModel.fromJson(Map<String, dynamic> json) =>
      ReportTechnicianListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  String firstName;
  String lastName;
  int id;

  Datum({
    required this.firstName,
    required this.lastName,
    required this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        firstName: json["first_name"],
        lastName: json["last_name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "id": id,
      };
}
