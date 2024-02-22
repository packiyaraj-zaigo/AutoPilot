// To parse this JSON data, do
//
//     final salesTaxReportModel = salesTaxReportModelFromJson(jsonString);

import 'dart:convert';

SalesTaxReportModel salesTaxReportModelFromJson(String str) =>
    SalesTaxReportModel.fromJson(json.decode(str));

String salesTaxReportModelToJson(SalesTaxReportModel data) =>
    json.encode(data.toJson());

class SalesTaxReportModel {
  List<Datum> data;
  String total;
  String nonTaxableTotal;
  String taxCollected;
  String message;

  SalesTaxReportModel({
    required this.data,
    required this.total,
    required this.nonTaxableTotal,
    required this.taxCollected,
    required this.message,
  });

  factory SalesTaxReportModel.fromJson(Map<String, dynamic> json) =>
      SalesTaxReportModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        total: json["total"],
        nonTaxableTotal: json["non_taxable_total"],
        taxCollected: json["tax_collected"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
        "non_taxable_total": nonTaxableTotal,
        "tax_collected": taxCollected,
        "message": message,
      };
}

class Datum {
  String type;
  String taxable;
  String nonTaxable;
  String discount;
  String total;

  Datum({
    required this.type,
    required this.taxable,
    required this.nonTaxable,
    required this.discount,
    required this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        taxable: json["taxable"],
        nonTaxable: json["non_taxable"],
        discount: json["discount"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "taxable": taxable,
        "non_taxable": nonTaxable,
        "discount": discount,
        "total": total,
      };
}
