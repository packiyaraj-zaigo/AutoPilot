import 'package:meta/meta.dart';
import 'dart:convert';

CalendarModel calendarModelFromJson(String str) =>
    CalendarModel.fromJson(json.decode(str));

String calendarModelToJson(CalendarModel data) => json.encode(data.toJson());

class CalendarModel {
  List<CalendarModelDatum> data;
  int count;
  String message;

  CalendarModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) => CalendarModel(
        data: List<CalendarModelDatum>.from(
            json["data"].map((x) => CalendarModelDatum.fromJson(x))),
        count: json["count"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
        "message": message,
      };
}

class CalendarModelDatum {
  String title;
  List<DatumDatum> data;

  CalendarModelDatum({
    required this.title,
    required this.data,
  });

  factory CalendarModelDatum.fromJson(Map<String, dynamic> json) =>
      CalendarModelDatum(
        title: json["title"],
        data: List<DatumDatum>.from(
            json["data"].map((x) => DatumDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumDatum {
  int key;
  String text;
  String text2;
  dynamic text3;
  dynamic text4;

  DatumDatum({
    required this.key,
    required this.text,
    required this.text2,
    required this.text3,
    required this.text4,
  });

  factory DatumDatum.fromJson(Map<String, dynamic> json) => DatumDatum(
        key: json["key"],
        text: json["text"],
        text2: json["text_2"],
        text3: json["text_3"],
        text4: json["text_4"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "text": text,
        "text_2": text2,
        "text_3": text3,
        "text_4": text4,
      };
}
