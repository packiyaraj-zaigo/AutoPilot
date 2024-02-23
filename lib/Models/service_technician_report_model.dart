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
  String techicianName;
  String date;
  int order;
  String serviceName;

  Datum({
    required this.techicianName,
    required this.date,
    required this.order,
    required this.serviceName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        techicianName: json["techician_name"],
        date: json["date"],
        order: json["order"],
        serviceName: json["service_name"],
      );

  Map<String, dynamic> toJson() => {
        "techician_name": techicianNameValues.reverse[techicianName],
        "date": dateValues.reverse[date],
        "order": order,
        "service_name": serviceName,
      };
}

enum Date { THE_12022024, THE_15022024, THE_22022024 }

final dateValues = EnumValues({
  "12/02/2024": Date.THE_12022024,
  "15/02/2024": Date.THE_15022024,
  "22/02/2024": Date.THE_22022024
});

enum TechicianName { EMPTY, EMP_ONE, TEST_EMP }

final techicianNameValues = EnumValues({
  "-": TechicianName.EMPTY,
  "emp one": TechicianName.EMP_ONE,
  "test emp": TechicianName.TEST_EMP
});

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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
