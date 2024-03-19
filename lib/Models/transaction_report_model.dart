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
  String message;

  TransactionReportModel({
    required this.data,
    required this.message,
  });

  factory TransactionReportModel.fromJson(Map<String, dynamic> json) =>
      TransactionReportModel(
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
  Transactions transactions;
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
    required this.transactions,
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
        transactions: Transactions.fromJson(json["transactions"]),
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
        "transactions": transactions.toJson(),
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
  String order;
  String customer;
  String location;
  String total;
  String fee;
  String net;

  Datum({
    required this.date,
    required this.order,
    required this.customer,
    required this.location,
    required this.total,
    required this.fee,
    required this.net,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: json["date"],
        order: json["order"],
        customer: json["customer"],
        location: json["location"],
        total: json["total"],
        fee: json["fee"],
        net: json["net"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "order": order,
        "customer": customer,
        "location": location,
        "total": total,
        "fee": fee,
        "net": net,
      };
}

class Transactions {
  String grossRevenue;
  String fee;
  String netRevenue;

  Transactions({
    required this.grossRevenue,
    required this.fee,
    required this.netRevenue,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        grossRevenue: json["gross_revenue"],
        fee: json["fee"],
        netRevenue: json["net_revenue"],
      );

  Map<String, dynamic> toJson() => {
        "gross_revenue": grossRevenue,
        "fee": fee,
        "net_revenue": netRevenue,
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
