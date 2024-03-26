// To parse this JSON data, do
//
//     final lineItemDetailReportModel = lineItemDetailReportModelFromJson(jsonString);

import 'dart:convert';

LineItemDetailReportModel lineItemDetailReportModelFromJson(String str) =>
    LineItemDetailReportModel.fromJson(json.decode(str));

String lineItemDetailReportModelToJson(LineItemDetailReportModel data) =>
    json.encode(data.toJson());

class LineItemDetailReportModel {
  Data data;
  String message;

  LineItemDetailReportModel({
    required this.data,
    required this.message,
  });

  factory LineItemDetailReportModel.fromJson(Map<String, dynamic> json) =>
      LineItemDetailReportModel(
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
  int orderNumber;
  String invoicedDate;
  String vehicle;
  String type;
  String itemDescription;
  String technician;
  String note;
  String vendor;
  String cost;
  String price;
  String quantity;

  Datum({
    required this.orderNumber,
    required this.invoicedDate,
    required this.vehicle,
    required this.type,
    required this.itemDescription,
    required this.technician,
    required this.note,
    required this.vendor,
    required this.cost,
    required this.price,
    required this.quantity,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderNumber: json["order_number"],
        invoicedDate: json["invoiced_date"],
        vehicle: json["vehicle"],
        type: json["type"],
        itemDescription: json["item_description"],
        technician: json["technician"],
        note: json["note"],
        vendor: json["vendor"],
        cost: json["cost"],
        price: json["price"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "invoiced_date": invoicedDate,
        "vehicle": vehicle,
        "type": type,
        "item_description": itemDescription,
        "technician": technician,
        "note": note,
        "vendor": vendor,
        "cost": cost,
        "price": price,
        "quantity": quantity,
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
