import 'dart:convert';

WorkflowStatusModel workflowStatusModelFromJson(String str) =>
    WorkflowStatusModel.fromJson(json.decode(str));

String workflowStatusModelToJson(WorkflowStatusModel data) =>
    json.encode(data.toJson());

class WorkflowStatusModel {
  int id;
  String title;
  List<ChildBucket> childBuckets;

  WorkflowStatusModel({
    required this.id,
    required this.title,
    required this.childBuckets,
  });

  factory WorkflowStatusModel.fromJson(Map<String, dynamic> json) =>
      WorkflowStatusModel(
        id: json["id"],
        title: json["title"],
        childBuckets: List<ChildBucket>.from(
            json["child_buckets"].map((x) => ChildBucket.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "child_buckets":
            List<dynamic>.from(childBuckets.map((x) => x.toJson())),
      };
}

class ChildBucket {
  int id;
  String title;
  int parentId;
  String color;

  ChildBucket({
    required this.id,
    required this.title,
    required this.parentId,
    required this.color,
  });

  factory ChildBucket.fromJson(Map<String, dynamic> json) => ChildBucket(
        id: json["id"],
        title: json["title"],
        parentId: json["parent_id"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "parent_id": parentId,
        "color": color,
      };
}
