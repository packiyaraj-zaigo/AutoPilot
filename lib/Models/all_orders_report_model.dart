// To parse this JSON data, do
//
//     final allOrdersReportModel = allOrdersReportModelFromJson(jsonString);

import 'dart:convert';

AllOrdersReportModel allOrdersReportModelFromJson(String str) =>
    AllOrdersReportModel.fromJson(json.decode(str));

String allOrdersReportModelToJson(AllOrdersReportModel data) =>
    json.encode(data.toJson());

class AllOrdersReportModel {
  Data data;
  String message;

  AllOrdersReportModel({
    required this.data,
    required this.message,
  });

  factory AllOrdersReportModel.fromJson(Map<String, dynamic> json) =>
      AllOrdersReportModel(
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
  List<Datum> data;
  String firstPageUrl;
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
  int orderNumber;
  String orderStatus;
  String firstName;
  String lastName;
  String vehicleName;
  String paidStatus;
  String serviceWriter;
  String dateCreated;
  String dateInvoiced;
  String paymentType;
  String total;

  Datum({
    required this.orderNumber,
    required this.orderStatus,
    required this.firstName,
    required this.lastName,
    required this.vehicleName,
    required this.paidStatus,
    required this.serviceWriter,
    required this.dateCreated,
    required this.dateInvoiced,
    required this.paymentType,
    required this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderNumber: json["order_number"],
        orderStatus: json["order_status"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        vehicleName: json["vehicle_name"],
        paidStatus: json["paid_status"],
        serviceWriter: json["service_writer"],
        dateCreated: json["date_created"],
        dateInvoiced: json["date_invoiced"],
        paymentType: json["payment_type"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "order_status": orderStatus,
        "first_name": firstName,
        "last_name": lastName,
        "vehicle_name": vehicleName,
        "paid_status": paidStatus,
        "service_writer": serviceWriter,
        "date_created": dateCreated,
        "date_invoiced": dateInvoiced,
        "payment_type": paymentType,
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
