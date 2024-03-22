// To parse this JSON data, do
//
//     final shopPerformanceReportModel = shopPerformanceReportModelFromJson(jsonString);

import 'dart:convert';

ShopPerformanceReportModel shopPerformanceReportModelFromJson(String str) =>
    ShopPerformanceReportModel.fromJson(json.decode(str));

String shopPerformanceReportModelToJson(ShopPerformanceReportModel data) =>
    json.encode(data.toJson());

class ShopPerformanceReportModel {
  Data data;
  int invoiced;
  int paymentCollected;
  String profit;
  String profitPercentage;
  String message;

  ShopPerformanceReportModel({
    required this.data,
    required this.invoiced,
    required this.paymentCollected,
    required this.profit,
    required this.profitPercentage,
    required this.message,
  });

  factory ShopPerformanceReportModel.fromJson(Map<String, dynamic> json) =>
      ShopPerformanceReportModel(
        data: Data.fromJson(json["data"]),
        invoiced: json["invoiced"],
        paymentCollected: json["paymentCollected"],
        profit: json["profit"],
        profitPercentage: json["profitPercentage"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "invoiced": invoiced,
        "paymentCollected": paymentCollected,
        "profit": profit,
        "profitPercentage": profitPercentage,
        "message": message,
      };
}

class Data {
  List<Service> service;

  Data({
    required this.service,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        service:
            List<Service>.from(json["service"].map((x) => Service.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "service": List<dynamic>.from(service.map((x) => x.toJson())),
      };
}

class Service {
  String type;
  String percentage;
  String service;

  Service({
    required this.type,
    required this.percentage,
    required this.service,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        type: json["type"],
        percentage: json["percentage"],
        service: json["service"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "percentage": percentage,
        "service": service,
      };
}
