// To parse this JSON data, do
//
//     final profitablityReportModel = profitablityReportModelFromJson(jsonString);

import 'dart:convert';

ProfitablityReportModel profitablityReportModelFromJson(String str) =>
    ProfitablityReportModel.fromJson(json.decode(str));

class ProfitablityReportModel {
  Data data;
  String message;

  ProfitablityReportModel({
    required this.data,
    required this.message,
  });

  factory ProfitablityReportModel.fromJson(Map<String, dynamic> json) =>
      ProfitablityReportModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );
}

class Data {
  Paginator paginator;
  Range range;

  Data({
    required this.paginator,
    required this.range,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        paginator: Paginator.fromJson(json["paginator"]),
        range: Range.fromJson(json["range"]),
      );
}

class Paginator {
  int currentPage;
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Paginator({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Paginator.fromJson(Map<String, dynamic> json) => Paginator(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class Datum {
  int orderNumber;
  String firstName;
  String partRetail;
  String partCost;
  String laborRetail;
  String laborCost;
  String materialRetail;
  String materialCost;
  String subContractRetail;
  String subContractCost;
  String fees;
  String feeCost;
  String partProfit;
  String laborProfit;
  String materialProfit;
  String discount;
  String profit;
  String totalProfit;
  String subContractProfit;

  Datum({
    required this.orderNumber,
    required this.firstName,
    required this.partRetail,
    required this.partCost,
    required this.laborRetail,
    required this.laborCost,
    required this.materialRetail,
    required this.materialCost,
    required this.subContractRetail,
    required this.subContractCost,
    required this.fees,
    required this.feeCost,
    required this.partProfit,
    required this.laborProfit,
    required this.subContractProfit,
    required this.materialProfit,
    required this.discount,
    required this.profit,
    required this.totalProfit,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderNumber: json["order_number"],
        firstName: json["first_name"],
        partRetail: json["part_retail"],
        partCost: json["part_cost"],
        laborRetail: json["labor_retail"],
        laborCost: json["labor_cost"],
        materialRetail: json["material_retail"],
        materialCost: json["material_cost"],
        subContractRetail: json["subContract_retail"],
        subContractCost: json["subContract_cost"],
        fees: json["fees"],
        feeCost: json["fee_cost"],
        partProfit: json["part_profit"],
        laborProfit: json["labor_profit"],
        subContractProfit: json["subContract_profit"],
        materialProfit: json["material_profit"],
        discount: json["discount"],
        profit: json["profit"],
        totalProfit: json["total_profit"],
      );
}

class Range {
  int from;
  int to;
  int total;

  Range({
    required this.from,
    required this.to,
    required this.total,
  });

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        from: json["from"],
        to: json["to"],
        total: json["total"],
      );
}
