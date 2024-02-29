// To parse this JSON data, do
//
//     final timeLogReportModel = timeLogReportModelFromJson(jsonString);

import 'dart:convert';

TimeLogReportModel timeLogReportModelFromJson(String str) =>
    TimeLogReportModel.fromJson(json.decode(str));

String timeLogReportModelToJson(TimeLogReportModel data) =>
    json.encode(data.toJson());

class TimeLogReportModel {
  Data data;
  String hoursTracked;
  String message;

  TimeLogReportModel({
    required this.data,
    required this.hoursTracked,
    required this.message,
  });

  factory TimeLogReportModel.fromJson(Map<String, dynamic> json) =>
      TimeLogReportModel(
        data: Data.fromJson(json["data"]),
        hoursTracked: json["hours_tracked"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "hours_tracked": hoursTracked,
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
  int? clientId;
  String techician;
  String? firstName;
  String? lastName;
  String? vehicleName;
  String activityType;
  String activityName;
  String note;
  String? techRate;
  String duration;
  String total;

  Datum({
    required this.clientId,
    required this.techician,
    this.firstName,
    this.lastName,
    this.vehicleName,
    required this.activityType,
    required this.activityName,
    required this.note,
    this.techRate,
    required this.duration,
    required this.total,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        clientId: json["client_id"],
        techician: json["techician"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        vehicleName: json["vehicle_name"],
        activityType: json["activity_type"],
        activityName: json["activity_name"],
        note: json["note"],
        techRate: json["tech_rate"],
        duration: json["duration"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "techician": techician,
        "first_name": firstName,
        "last_name": lastName,
        "vehicle_name": vehicleName,
        "activity_type": activityType,
        "activity_name": activityName,
        "note": note,
        "tech_rate": techRate,
        "duration": duration,
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
