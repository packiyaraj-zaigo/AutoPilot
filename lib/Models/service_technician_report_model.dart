// To parse this JSON data, do
//
//     final serviceByTechReportModel = serviceByTechReportModelFromJson(jsonString);

import 'dart:convert';

List<ServiceByTechReportModel> serviceByTechReportModelFromJson(String str) =>
    List<ServiceByTechReportModel>.from(
        json.decode(str).map((x) => ServiceByTechReportModel.fromJson(x)));

String serviceByTechReportModelToJson(List<ServiceByTechReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceByTechReportModel {
  String tech;
  DateTime date;
  String order;
  String service;
  double invoicedHour;

  ServiceByTechReportModel({
    required this.tech,
    required this.date,
    required this.order,
    required this.service,
    required this.invoicedHour,
  });

  factory ServiceByTechReportModel.fromJson(Map<String, dynamic> json) =>
      ServiceByTechReportModel(
        tech: json["tech"],
        date: DateTime.parse(json["date"]),
        order: json["order"],
        service: json["service"],
        invoicedHour: json["invoiced_hour"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "tech": tech,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "order": order,
        "service": service,
        "invoiced_hour": invoicedHour,
      };
}
