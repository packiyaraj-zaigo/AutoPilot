class RoleModel {
  int id;
  String name;
  int clientId;
  String guardName;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> permissions;

  RoleModel({
    required this.id,
    required this.name,
    required this.clientId,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json["id"],
        name: json["name"],
        clientId: json["client_id"],
        guardName: json["guard_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        permissions: List<dynamic>.from(json["permissions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "client_id": clientId,
        "guard_name": guardName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
      };
}
