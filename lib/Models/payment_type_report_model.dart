// To parse this JSON data, do
//
//     final paymentTypeReportModel = paymentTypeReportModelFromJson(jsonString);

import 'dart:convert';

PaymentTypeReportModel paymentTypeReportModelFromJson(String str) =>
    PaymentTypeReportModel.fromJson(json.decode(str));

String paymentTypeReportModelToJson(PaymentTypeReportModel data) =>
    json.encode(data.toJson());

class PaymentTypeReportModel {
  Data data;
  String message;

  PaymentTypeReportModel({
    required this.data,
    required this.message,
  });

  factory PaymentTypeReportModel.fromJson(Map<String, dynamic> json) =>
      PaymentTypeReportModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  String totalPercentage;
  String totalAmount;
  List<Total> totals;

  Data({
    required this.totalPercentage,
    required this.totalAmount,
    required this.totals,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalPercentage: json["total_percentage"],
        totalAmount: json["total_amount"],
        totals: List<Total>.from(json["totals"].map((x) => Total.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_percentage": totalPercentage,
        "total_amount": totalAmount,
        "totals": List<dynamic>.from(totals.map((x) => x.toJson())),
      };
}

class Total {
  String type;
  String total;
  String percentage;

  Total({
    required this.type,
    required this.total,
    required this.percentage,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        type: json["type"],
        total: json["total"],
        percentage: json["percentage"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "total": total,
        "percentage": percentage,
      };
}
