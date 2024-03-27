// To parse this JSON data, do
//
//     final transactionReportModel = transactionReportModelFromJson(jsonString);

import 'dart:convert';

TransactionReportModel transactionReportModelFromJson(String str) =>
    TransactionReportModel.fromJson(json.decode(str));

String transactionReportModelToJson(TransactionReportModel data) =>
    json.encode(data.toJson());

class TransactionReportModel {
  Data data;
  String grossRevenue;
  String message;

  TransactionReportModel({
    required this.data,
    required this.grossRevenue,
    required this.message,
  });

  factory TransactionReportModel.fromJson(Map<String, dynamic> json) =>
      TransactionReportModel(
        data: Data.fromJson(json["data"]),
        grossRevenue: json["gross_revenue"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "gross_revenue": grossRevenue,
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
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Paginator({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
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

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
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
  String date;
  int orderNumber;
  String customer;
  String location;
  String total;

  Datum({
    required this.date,
    required this.orderNumber,
    required this.customer,
    required this.location,
    required this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json["date"],
        orderNumber: json["order_number"],
        customer: json["customer"],
        location: json["location"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "order_number": orderNumber,
        "customer": customer,
        "location": location,
        "total": total,
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
