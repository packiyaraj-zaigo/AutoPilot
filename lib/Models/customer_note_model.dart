// To parse this JSON data, do
//
//     final customerNoteModel = customerNoteModelFromJson(jsonString);

import 'dart:convert';

CustomerNoteModel customerNoteModelFromJson(String str) =>
    CustomerNoteModel.fromJson(json.decode(str));

String customerNoteModelToJson(CustomerNoteModel data) =>
    json.encode(data.toJson());

class CustomerNoteModel {
  final int id;
  final int clientId;
  final int customerId;
  final String notes;
  final CreatedBy createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  CustomerNoteModel({
    required this.id,
    required this.clientId,
    required this.customerId,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CustomerNoteModel.fromJson(Map<String, dynamic> json) =>
      CustomerNoteModel(
        id: json["id"],
        clientId: json["client_id"],
        customerId: json["customer_id"],
        notes: json["notes"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "customer_id": customerId,
        "notes": notes,
        "created_by": createdBy.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class CreatedBy {
  final int id;
  final String firstName;
  final String lastName;

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
