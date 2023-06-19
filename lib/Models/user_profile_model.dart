// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    List<User> user;

    UserProfileModel({
        required this.user,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "user": List<dynamic>.from(user.map((x) => x.toJson())),
    };
}

class User {
    int id;
    int clientId;
    String email;
    dynamic emailVerifiedAt;
    String firstName;
    String lastName;
    String phone;
    String profileImage;
    int active;
    int taskId;
    String laborCost;
    int commissionStructureId;
    int salesTargetId;
    String activationToken;
    DateTime createdAt;
    DateTime updatedAt;
    List<Role> roles;

    User({
        required this.id,
        required this.clientId,
        required this.email,
        this.emailVerifiedAt,
        required this.firstName,
        required this.lastName,
        required this.phone,
        required this.profileImage,
        required this.active,
        required this.taskId,
        required this.laborCost,
        required this.commissionStructureId,
        required this.salesTargetId,
        required this.activationToken,
        required this.createdAt,
        required this.updatedAt,
        required this.roles,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        clientId: json["client_id"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        profileImage: json["profile_image"],
        active: json["active"],
        taskId: json["task_id"],
        laborCost: json["labor_cost"],
        commissionStructureId: json["commission_structure_id"],
        salesTargetId: json["sales_target_id"],
        activationToken: json["activation_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "profile_image": profileImage,
        "active": active,
        "task_id": taskId,
        "labor_cost": laborCost,
        "commission_structure_id": commissionStructureId,
        "sales_target_id": salesTargetId,
        "activation_token": activationToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
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
