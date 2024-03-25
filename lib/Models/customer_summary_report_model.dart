// To parse this JSON data, do
//
//     final customerSummaryReportModel = customerSummaryReportModelFromJson(jsonString);

import 'dart:convert';

CustomerSummaryReportModel customerSummaryReportModelFromJson(String str) =>
    CustomerSummaryReportModel.fromJson(json.decode(str));

String customerSummaryReportModelToJson(CustomerSummaryReportModel data) =>
    json.encode(data.toJson());

class CustomerSummaryReportModel {
  Data data;
  List<GraphArr> graphArr;
  String message;

  CustomerSummaryReportModel({
    required this.data,
    required this.graphArr,
    required this.message,
  });

  factory CustomerSummaryReportModel.fromJson(Map<String, dynamic> json) =>
      CustomerSummaryReportModel(
        data: Data.fromJson(json["data"]),
        graphArr: List<GraphArr>.from(
            json["graphArr"].map((x) => GraphArr.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "graphArr": List<dynamic>.from(graphArr.map((x) => x.toJson())),
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
  String firstName;
  String lastName;
  String totalPayments;
  String profitablity;

  Datum({
    required this.firstName,
    required this.lastName,
    required this.totalPayments,
    required this.profitablity,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        firstName: json["first_name"],
        lastName: json["last_name"],
        totalPayments: json["total_payments"],
        profitablity: json["profitablity"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "total_payments": totalPayments,
        "profitablity": profitablity,
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

class GraphArr {
  String firstName;
  String totalPayments;

  GraphArr({
    required this.firstName,
    required this.totalPayments,
  });

  factory GraphArr.fromJson(Map<String, dynamic> json) => GraphArr(
        firstName: json["first_name"],
        totalPayments: json["total_payments"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "total_payments": totalPayments,
      };
}
