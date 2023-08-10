// To parse this JSON data, do
//
//     final vehicleNoteModel = vehicleNoteModelFromJson(jsonString);

import 'dart:convert';

VehicleNoteModel vehicleNoteModelFromJson(String str) =>
    VehicleNoteModel.fromJson(json.decode(str));

String vehicleNoteModelToJson(VehicleNoteModel data) =>
    json.encode(data.toJson());

class VehicleNoteModel {
  List<Datum> data;
  int count;
  String message;

  VehicleNoteModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory VehicleNoteModel.fromJson(Map<String, dynamic> json) =>
      VehicleNoteModel(
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
  int clientId;
  int vehicleId;
  String notes;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  Createdby createdby;

  Datum({
    required this.id,
    required this.clientId,
    required this.vehicleId,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.createdby,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientId: json["client_id"],
        vehicleId: json["vehicle_id"],
        notes: json["notes"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdby: Createdby.fromJson(json["createdby"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "vehicle_id": vehicleId,
        "notes": notes,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "createdby": createdby.toJson(),
      };
}

class Createdby {
  int id;
  String firstName;
  String lastName;

  Createdby({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory Createdby.fromJson(Map<String, dynamic> json) => Createdby(
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
