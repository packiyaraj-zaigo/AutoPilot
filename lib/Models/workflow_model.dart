class WorkflowBucketModel {
  final int? id;
  final int? parentId;
  final int? clientId;
  final String? title;
  final dynamic description;
  final dynamic notificationId;
  final String? workflowType;
  final int? position;
  final String? color;
  final int? defaultBuceket;
  final int? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? parentTitle;

  WorkflowBucketModel({
    this.id,
    this.parentId,
    this.clientId,
    this.title,
    this.description,
    this.notificationId,
    this.workflowType,
    this.position,
    this.color,
    this.defaultBuceket,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.parentTitle,
  });

  factory WorkflowBucketModel.fromJson(Map<String, dynamic> json) =>
      WorkflowBucketModel(
        id: json["id"],
        parentId: json["parent_id"],
        clientId: json["client_id"],
        title: json["title"],
        description: json["description"],
        notificationId: json["notification_id"],
        workflowType: json["workflow_type"],
        position: json["position"],
        color: json["color"],
        defaultBuceket: json["default_buceket"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        parentTitle: json["parent_title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "parent_id": parentId,
        "client_id": clientId,
        "title": title,
        "description": description,
        "notification_id": notificationId,
        "workflow_type": workflowType,
        "position": position,
        "color": color,
        "default_buceket": defaultBuceket,
        "created_by": createdBy,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "parent_title": parentTitle,
      };
}
