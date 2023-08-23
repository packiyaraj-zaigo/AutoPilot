// To parse this JSON data, do
//
//     final timeCardUserModel = timeCardUserModelFromJson(jsonString);

import 'dart:convert';

TimeCardUserModel timeCardUserModelFromJson(String str) =>
    TimeCardUserModel.fromJson(json.decode(str));

String timeCardUserModelToJson(TimeCardUserModel data) =>
    json.encode(data.toJson());

class TimeCardUserModel {
  int id;
  int clientId;
  int technicianId;
  int? activityId;
  String activityType;
  DateTime clockInTime;
  DateTime clockOutTime;
  String totalTime;
  String notes;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  String firstName;
  String lastName;
  dynamic order;
  Technician technician;

  TimeCardUserModel({
    required this.id,
    required this.clientId,
    required this.technicianId,
    required this.activityId,
    required this.activityType,
    required this.clockInTime,
    required this.clockOutTime,
    required this.totalTime,
    required this.notes,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.firstName,
    required this.lastName,
    required this.order,
    required this.technician,
  });

  factory TimeCardUserModel.fromJson(Map<String, dynamic> json) =>
      TimeCardUserModel(
        id: json["id"],
        clientId: json["client_id"],
        technicianId: json["technician_id"],
        activityId: json["activity_id"],
        activityType: json["activity_type"] ?? '',
        clockInTime: DateTime.parse(json["clock_in_time"]),
        clockOutTime: DateTime.parse(json["clock_out_time"]),
        totalTime: json["total_time"],
        notes: json["notes"] ?? '',
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        order: json["order"],
        technician: Technician.fromJson(json["technician"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "technician_id": technicianId,
        "activity_id": activityId,
        "activity_type": activityType,
        "clock_in_time": clockInTime.toIso8601String(),
        "clock_out_time": clockOutTime.toIso8601String(),
        "total_time": totalTime,
        "notes": notes,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "order": order,
        "technician": technician.toJson(),
      };
}

class Technician {
  int id;
  String email;
  String firstName;
  String lastName;
  String profileImage;
  List<Role> roles;

  Technician({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.roles,
  });

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profileImage: json["profile_image"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "profile_image": profileImage,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  int id;
  String name;
  int clientId;
  String guardName;
  DateTime createdAt;
  DateTime updatedAt;
  Pivot pivot;

  Role({
    required this.id,
    required this.name,
    required this.clientId,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        clientId: json["client_id"],
        guardName: json["guard_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "client_id": clientId,
        "guard_name": guardName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  int modelId;
  int roleId;
  String modelType;

  Pivot({
    required this.modelId,
    required this.roleId,
    required this.modelType,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        modelId: json["model_id"],
        roleId: json["role_id"],
        modelType: json["model_type"],
      );

  Map<String, dynamic> toJson() => {
        "model_id": modelId,
        "role_id": roleId,
        "model_type": modelType,
      };
}
