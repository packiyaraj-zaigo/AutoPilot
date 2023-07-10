import 'package:meta/meta.dart';
import 'dart:convert';

CalendarWeekModel calendarWeekModelFromJson(String str) =>
    CalendarWeekModel.fromJson(json.decode(str));

String calendarWeekModelToJson(CalendarWeekModel data) =>
    json.encode(data.toJson());

class CalendarWeekModel {
  List<Datum> data;
  int count;
  String message;

  CalendarWeekModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory CalendarWeekModel.fromJson(Map<String, dynamic> json) =>
      CalendarWeekModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        count: json["count"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
        "message": message,
      };
}

class Datum {
  DateTime date;
  int eventCount;
  List<dynamic> labels;

  Datum({
    required this.date,
    required this.eventCount,
    required this.labels,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        date: DateTime.parse(json["date"]),
        eventCount: json["event_count"],
        labels: List<dynamic>.from(json["labels"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "event_count": eventCount,
        "labels": List<dynamic>.from(labels.map((x) => x)),
      };
}
