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
  String message;

  ShopPerformanceReportModel({
    required this.data,
    required this.message,
  });

  factory ShopPerformanceReportModel.fromJson(Map<String, dynamic> json) =>
      ShopPerformanceReportModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
      };
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

  Map<String, dynamic> toJson() => {
        "paginator": paginator.toJson(),
        "range": range.toJson(),
      };
}

class Paginator {
  int currentPage;
  SalesSummary salesSummary;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Paginator({
    required this.currentPage,
    required this.salesSummary,
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
        salesSummary: SalesSummary.fromJson(json["sales_summary"]),
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

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "sales_summary": salesSummary.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  String type;
  String percent;
  String revenue;

  Datum({
    required this.type,
    required this.percent,
    required this.revenue,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["Type"],
        percent: json["percent"],
        revenue: json["revenue"],
      );

  Map<String, dynamic> toJson() => {
        "Type": type,
        "percent": percent,
        "revenue": revenue,
      };
}

class SalesSummary {
  String invoiced;
  String paymentsCollected;
  String payingCustomers;
  String profit;
  String profitPercent;

  SalesSummary({
    required this.invoiced,
    required this.paymentsCollected,
    required this.payingCustomers,
    required this.profit,
    required this.profitPercent,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> json) => SalesSummary(
        invoiced: json["invoiced"],
        paymentsCollected: json["payments_collected"],
        payingCustomers: json["paying_customers"],
        profit: json["profit"],
        profitPercent: json["profit_percent"],
      );

  Map<String, dynamic> toJson() => {
        "invoiced": invoiced,
        "payments_collected": paymentsCollected,
        "paying_customers": payingCustomers,
        "profit": profit,
        "profit_percent": profitPercent,
      };
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

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "total": total,
      };
}
