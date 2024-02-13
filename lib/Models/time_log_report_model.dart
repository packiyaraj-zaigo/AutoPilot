// To parse this JSON data, do
//
//     final timeLogReportModel = timeLogReportModelFromJson(jsonString);

import 'dart:convert';

List<TimeLogReportModel> timeLogReportModelFromJson(String str) =>
    List<TimeLogReportModel>.from(
        json.decode(str).map((x) => TimeLogReportModel.fromJson(x)));

String timeLogReportModelToJson(List<TimeLogReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TimeLogReportModel {
  int entry;
  String type;
  String technician;
  String firstName;
  String lastName;
  String vehicle;
  DateTime fndDatetime;
  String activityType;
  String activityName;
  String note;
  double techRate;
  double duration;
  double total;

  TimeLogReportModel({
    required this.entry,
    required this.type,
    required this.technician,
    required this.firstName,
    required this.lastName,
    required this.vehicle,
    required this.fndDatetime,
    required this.activityType,
    required this.activityName,
    required this.note,
    required this.techRate,
    required this.duration,
    required this.total,
  });

  factory TimeLogReportModel.fromJson(Map<String, dynamic> json) =>
      TimeLogReportModel(
        entry: json["entry"],
        type: json["type"],
        technician: json["technician"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        vehicle: json["vehicle"],
        fndDatetime: DateTime.parse(json["fnd_datetime"]),
        activityType: json["activity_type"],
        activityName: json["activity_name"],
        note: json["note"],
        techRate: json["tech_rate"],
        duration: json["duration"]?.toDouble(),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "entry": entry,
        "type": type,
        "technician": technician,
        "first_name": firstName,
        "last_name": lastName,
        "vehicle": vehicle,
        "fnd_datetime": fndDatetime.toIso8601String(),
        "activity_type": activityType,
        "activity_name": activityName,
        "note": note,
        "tech_rate": techRate,
        "duration": duration,
        "total": total,
      };
}
