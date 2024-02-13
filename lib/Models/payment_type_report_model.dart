// To parse this JSON data, do
//
//     final paymentTypeReportModel = paymentTypeReportModelFromJson(jsonString);

import 'dart:convert';

List<PaymentTypeReportModel> paymentTypeReportModelFromJson(String str) =>
    List<PaymentTypeReportModel>.from(
        json.decode(str).map((x) => PaymentTypeReportModel.fromJson(x)));

String paymentTypeReportModelToJson(List<PaymentTypeReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentTypeReportModel {
  String paymentType;
  int percentOfTotal;
  double total;

  PaymentTypeReportModel({
    required this.paymentType,
    required this.percentOfTotal,
    required this.total,
  });

  factory PaymentTypeReportModel.fromJson(Map<String, dynamic> json) =>
      PaymentTypeReportModel(
        paymentType: json["payment_type"],
        percentOfTotal: json["percent_of_total"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "payment_type": paymentType,
        "percent_of_total": percentOfTotal,
        "total": total,
      };
}
