// To parse this JSON data, do
//
//     final technicianOnlyModel = technicianOnlyModelFromJson(jsonString);

import 'dart:convert';

TechnicianOnlyModel technicianOnlyModelFromJson(String str) =>
    TechnicianOnlyModel.fromJson(json.decode(str));

String technicianOnlyModelToJson(TechnicianOnlyModel data) =>
    json.encode(data.toJson());

class TechnicianOnlyModel {
  List<Datum> data;
  int count;
  String message;

  TechnicianOnlyModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory TechnicianOnlyModel.fromJson(Map<String, dynamic> json) =>
      TechnicianOnlyModel(
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
  int id;
  String email;
  String firstName;
  String lastName;

  Datum({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
      };
}
