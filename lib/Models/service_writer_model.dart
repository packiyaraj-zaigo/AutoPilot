// To parse this JSON data, do
//
//     final serviceWriterModel = serviceWriterModelFromJson(jsonString);

import 'dart:convert';

ServiceWriterModel serviceWriterModelFromJson(String str) =>
    ServiceWriterModel.fromJson(json.decode(str));

String serviceWriterModelToJson(ServiceWriterModel data) =>
    json.encode(data.toJson());

class ServiceWriterModel {
  List<Datum> data;
  String message;

  ServiceWriterModel({
    required this.data,
    required this.message,
  });

  factory ServiceWriterModel.fromJson(Map<String, dynamic> json) =>
      ServiceWriterModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  String name;
  int id;

  Datum({
    required this.name,
    required this.id,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
