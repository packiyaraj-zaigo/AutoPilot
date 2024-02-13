// To parse this JSON data, do
//
//     final salesTaxReportModel = salesTaxReportModelFromJson(jsonString);

import 'dart:convert';

List<SalesTaxReportModel> salesTaxReportModelFromJson(String str) =>
    List<SalesTaxReportModel>.from(
        json.decode(str).map((x) => SalesTaxReportModel.fromJson(x)));

String salesTaxReportModelToJson(List<SalesTaxReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalesTaxReportModel {
  String type;
  int taxable;
  int nonTaxable;
  int taxExempt;
  int discounts;
  int total;

  SalesTaxReportModel({
    required this.type,
    required this.taxable,
    required this.nonTaxable,
    required this.taxExempt,
    required this.discounts,
    required this.total,
  });

  factory SalesTaxReportModel.fromJson(Map<String, dynamic> json) =>
      SalesTaxReportModel(
        type: json["type"],
        taxable: json["taxable"],
        nonTaxable: json["non_taxable"],
        taxExempt: json["tax_exempt"],
        discounts: json["discounts"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "taxable": taxable,
        "non_taxable": nonTaxable,
        "tax_exempt": taxExempt,
        "discounts": discounts,
        "total": total,
      };
}
