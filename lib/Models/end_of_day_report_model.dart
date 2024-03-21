// To parse this JSON data, do
//
//     final endOfDayReportModel = endOfDayReportModelFromJson(jsonString);

import 'dart:convert';

EndOfDayReportModel endOfDayReportModelFromJson(String str) =>
    EndOfDayReportModel.fromJson(json.decode(str));

String endOfDayReportModelToJson(EndOfDayReportModel data) =>
    json.encode(data.toJson());

class EndOfDayReportModel {
  Data data;
  SalesSummary salesSummary;
  String message;

  EndOfDayReportModel({
    required this.data,
    required this.salesSummary,
    required this.message,
  });

  factory EndOfDayReportModel.fromJson(Map<String, dynamic> json) =>
      EndOfDayReportModel(
        data: Data.fromJson(json["data"]),
        salesSummary: SalesSummary.fromJson(json["salesSummary"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "salesSummary": salesSummary.toJson(),
        "message": message,
      };
}

class Data {
  String totalAmount;
  int totalCount;
  List<Type> type;

  Data({
    required this.totalAmount,
    required this.totalCount,
    required this.type,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalAmount: json["totalAmount"],
        totalCount: json["totalCount"],
        type: List<Type>.from(json["type"].map((x) => Type.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "totalCount": totalCount,
        "type": List<dynamic>.from(type.map((x) => x.toJson())),
      };
}

class Type {
  String type;
  String amount;
  int count;

  Type({
    required this.type,
    required this.amount,
    required this.count,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        type: json["type"],
        amount: json["amount"],
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "amount": amount,
        "count": count,
      };
}

class SalesSummary {
  int totalEstimates;
  int totalInvoices;
  int totalOrder;
  int unpaidOrder;
  int fullyPaidOrder;

  SalesSummary({
    required this.totalEstimates,
    required this.totalInvoices,
    required this.totalOrder,
    required this.unpaidOrder,
    required this.fullyPaidOrder,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> json) => SalesSummary(
        totalEstimates: json["total_estimates"],
        totalInvoices: json["total_invoices"],
        totalOrder: json["total_order"],
        unpaidOrder: json["unpaid_order"],
        fullyPaidOrder: json["fully_paid_order"],
      );

  Map<String, dynamic> toJson() => {
        "total_estimates": totalEstimates,
        "total_invoices": totalInvoices,
        "total_order": totalOrder,
        "unpaid_order": unpaidOrder,
        "fully_paid_order": fullyPaidOrder,
      };
}
