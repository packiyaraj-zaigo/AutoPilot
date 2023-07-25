// To parse this JSON data, do
//
//     final estimateNoteModel = estimateNoteModelFromJson(jsonString);

import 'dart:convert';

EstimateNoteModel estimateNoteModelFromJson(String str) =>
    EstimateNoteModel.fromJson(json.decode(str));

String estimateNoteModelToJson(EstimateNoteModel data) =>
    json.encode(data.toJson());

class EstimateNoteModel {
  List<Datum> data;
  int count;
  String message;

  EstimateNoteModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory EstimateNoteModel.fromJson(Map<String, dynamic> json) =>
      EstimateNoteModel(
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
  int orderId;
  String comments;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.orderId,
    required this.comments,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderId: json["order_id"],
        comments: json["comments"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "comments": comments,
        "created_by": createdBy.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class CreatedBy {
  int id;
  String firstName;
  String lastName;

  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
      };
}
