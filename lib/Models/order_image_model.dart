// To parse this JSON data, do
//
//     final orderImageModel = orderImageModelFromJson(jsonString);

import 'dart:convert';

OrderImageModel orderImageModelFromJson(String str) =>
    OrderImageModel.fromJson(json.decode(str));

String orderImageModelToJson(OrderImageModel data) =>
    json.encode(data.toJson());

class OrderImageModel {
  List<Datum> data;
  int count;
  String message;

  OrderImageModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory OrderImageModel.fromJson(Map<String, dynamic> json) =>
      OrderImageModel(
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
  int inspectionId;
  String fileName;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.orderId,
    required this.inspectionId,
    required this.fileName,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderId: json["order_id"],
        inspectionId: json["inspection_id"],
        fileName: json["file_name"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "inspection_id": inspectionId,
        "file_name": fileName,
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
        "first_name": firstNameValues.reverse[firstName],
        "last_name": lastNameValues.reverse[lastName],
      };
}

enum FirstName { SANJAY }

final firstNameValues = EnumValues({"sanjay": FirstName.SANJAY});

enum LastName { GGGG }

final lastNameValues = EnumValues({"gggg": LastName.GGGG});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
