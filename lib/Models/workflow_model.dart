import 'dart:convert';

import 'package:auto_pilot/Models/workflow_bucket_model.dart';

WorkflowModel workflowModelFromJson(String? str) =>
    WorkflowModel.fromJson(json.decode(str!));

String? workflowModelToJson(WorkflowModel data) => json.encode(data.toJson());

class WorkflowModel {
  int? id;
  int? clientId;
  int? clientBucketId;
  int? orderId;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Orders? orders;
  BucketName? bucketName;
  WorkflowBucketModel? bucket;

  WorkflowModel({
    this.id,
    this.clientId,
    this.clientBucketId,
    this.orderId,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.orders,
    this.bucketName,
  });

  factory WorkflowModel.fromJson(Map<String, dynamic> json) => WorkflowModel(
        id: json["id"],
        clientId: json["client_id"],
        clientBucketId: json["client_bucket_id"],
        orderId: json["order_id"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        orders: Orders.fromJson(json["orders"]),
        bucketName: BucketName.fromJson(json["bucket_name"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "client_bucket_id": clientBucketId,
        "order_id": orderId,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "orders": orders?.toJson(),
        "bucket_name": bucketName?.toJson(),
        "bucket": bucket?.toJson(),
      };
}

class BucketName {
  int? id;
  int? clientId;
  int? parentId;
  String? title;
  String? workflowType;
  int? position;
  String? color;
  DateTime? createdAt;
  DateTime? updatedAt;

  BucketName({
    this.id,
    this.clientId,
    this.parentId,
    this.title,
    this.workflowType,
    this.position,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  factory BucketName.fromJson(Map<String, dynamic> json) => BucketName(
        id: json["id"],
        clientId: json["client_id"],
        parentId: json["parent_id"],
        title: json["title"],
        workflowType: json["workflow_type"],
        position: json["position"],
        color: json["color"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "parent_id": parentId,
        "title": title,
        "workflow_type": workflowType,
        "position": position,
        "color": color,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Orders {
  int? id;
  int? customerId;
  int? vehicleId;
  int? orderNumber;
  String? estimationName;
  String? orderStatus;
  dynamic promiseDate;
  int? serviceWriterId;
  dynamic shopStart;
  dynamic shopFinish;
  Customer? customer;
  Vehicle? vehicle;
  Servicewriter? servicewriter;
  List<dynamic>? workOrderNotes;

  Orders({
    this.id,
    this.customerId,
    this.vehicleId,
    this.orderNumber,
    this.estimationName,
    this.orderStatus,
    this.promiseDate,
    this.serviceWriterId,
    this.shopStart,
    this.shopFinish,
    this.customer,
    this.vehicle,
    this.servicewriter,
    this.workOrderNotes,
  });

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
        id: json["id"],
        customerId: json["customer_id"],
        vehicleId: json["vehicle_id"],
        orderNumber: json["order_number"],
        estimationName: json["estimation_name"],
        orderStatus: json["order_status"],
        promiseDate: json["promise_date"],
        serviceWriterId: json["service_writer_id"],
        shopStart: json["shop_start"],
        shopFinish: json["shop_finish"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        servicewriter: json["servicewriter"] == null
            ? null
            : Servicewriter.fromJson(json["servicewriter"]),
        workOrderNotes: json["work_order_notes"] == null
            ? null
            : List<dynamic>.from(json["work_order_notes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "order_number": orderNumber,
        "estimation_name": estimationName,
        "order_status": orderStatus,
        "promise_date": promiseDate,
        "service_writer_id": serviceWriterId,
        "shop_start": shopStart,
        "shop_finish": shopFinish,
        "customer": customer?.toJson(),
        "vehicle": vehicle?.toJson(),
        "servicewriter": servicewriter?.toJson(),
        "work_order_notes": workOrderNotes == null
            ? []
            : List<dynamic>.from(workOrderNotes!.map((x) => x)),
      };
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
      };
}

class Servicewriter {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? profileImage;
  int? commissionStructureId;

  Servicewriter({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profileImage,
    this.commissionStructureId,
  });

  factory Servicewriter.fromJson(Map<String, dynamic> json) => Servicewriter(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        profileImage: json["profile_image"],
        commissionStructureId: json["commission_structure_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "profile_image": profileImage,
        "commission_structure_id": commissionStructureId,
      };
}

class Vehicle {
  int? id;
  String? vehicleType;
  String? vehicleYear;
  String? vehicleMake;
  String? vehicleModel;
  String? vehicleColor;
  String? licencePlate;
  String? vin;
  String? kilometers;

  Vehicle({
    this.id,
    this.vehicleType,
    this.vehicleYear,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleColor,
    this.licencePlate,
    this.vin,
    this.kilometers,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        vehicleType: json["vehicle_type"],
        vehicleYear: json["vehicle_year"],
        vehicleMake: json["vehicle_make"],
        vehicleModel: json["vehicle_model"],
        vehicleColor: json["vehicle_color"],
        licencePlate: json["licence_plate"],
        vin: json["vin"],
        kilometers: json["kilometers"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_type": vehicleType,
        "vehicle_year": vehicleYear,
        "vehicle_make": vehicleMake,
        "vehicle_model": vehicleModel,
        "vehicle_color": vehicleColor,
        "licence_plate": licencePlate,
        "vin": vin,
        "kilometers": kilometers,
      };
}
