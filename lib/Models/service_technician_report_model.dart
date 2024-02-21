// To parse this JSON data, do
//
//     final serviceByTechReportModel = serviceByTechReportModelFromJson(jsonString);

import 'dart:convert';

ServiceByTechReportModel serviceByTechReportModelFromJson(String str) =>
    ServiceByTechReportModel.fromJson(json.decode(str));

String serviceByTechReportModelToJson(ServiceByTechReportModel data) =>
    json.encode(data.toJson());

class ServiceByTechReportModel {
  Data data;
  String message;

  ServiceByTechReportModel({
    required this.data,
    required this.message,
  });

  factory ServiceByTechReportModel.fromJson(Map<String, dynamic> json) =>
      ServiceByTechReportModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  String nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  dynamic techicianId;
  String techicianName;
  String date;
  int order;
  String serviceName;
  String invoicedHours;

  Datum({
    required this.techicianId,
    required this.techicianName,
    required this.date,
    required this.order,
    required this.serviceName,
    required this.invoicedHours,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        techicianId: json["techician_id"],
        techicianName: json["techician_name"],
        date: json["date"],
        order: json["order"],
        serviceName: json["service_name"],
        invoicedHours: json["invoiced_hours"],
      );

  Map<String, dynamic> toJson() => {
        "techician_id": techicianId,
        "techician_name": techicianName,
        "date": date,
        "order": order,
        "service_name": serviceName,
        "invoiced_hours": invoicedHours,
      };
}
