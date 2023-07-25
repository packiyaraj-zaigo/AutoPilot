// To parse this JSON data, do
//
//     final createEstimateModel = createEstimateModelFromJson(jsonString);

import 'dart:convert';

CreateEstimateModel createEstimateModelFromJson(String str) =>
    CreateEstimateModel.fromJson(json.decode(str));

String createEstimateModelToJson(CreateEstimateModel data) =>
    json.encode(data.toJson());

class CreateEstimateModel {
  int? createdId;
  Data data;
  Order? order;
  String message;

  CreateEstimateModel({
    this.createdId,
    required this.data,
    this.order,
    required this.message,
  });

  factory CreateEstimateModel.fromJson(Map<String, dynamic> json) =>
      CreateEstimateModel(
        createdId: json["created_id"],
        data: Data.fromJson(json["data"]),
        order: json["order"] != null ? Order.fromJson(json["order"]) : null,
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "created_id": createdId,
        "data": data.toJson(),
        "order": order!.toJson(),
        "message": message,
      };
}

class Data {
  int id;
  int clientId;
  int customerId;
  int vehicleId;
  int serviceWriterId;
  int orderNumber;
  dynamic estimationName;
  dynamic poNumber;
  String orderStatus;
  String priorityDelivery;
  dynamic tags;
  dynamic customerNote;
  dynamic recomendation;
  String totalPartsCost;
  String totalLaborCost;
  String totalOtherCost;
  String subTotal;
  String totalTax;
  String totalDiscount;
  String grandTotal;
  String paidAmount;
  dynamic promiseDate;
  dynamic completionDate;
  dynamic dropSchedule;
  dynamic vehicleCheckin;
  dynamic shopStart;
  dynamic shopFinish;
  int leadStatusId;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  Createdby? customer;
  Vehicle? vehicle;
  Createdby createdby;

  Data({
    required this.id,
    required this.clientId,
    required this.customerId,
    required this.vehicleId,
    required this.serviceWriterId,
    required this.orderNumber,
    this.estimationName,
    this.poNumber,
    required this.orderStatus,
    required this.priorityDelivery,
    this.tags,
    this.customerNote,
    this.recomendation,
    required this.totalPartsCost,
    required this.totalLaborCost,
    required this.totalOtherCost,
    required this.subTotal,
    required this.totalTax,
    required this.totalDiscount,
    required this.grandTotal,
    required this.paidAmount,
    this.promiseDate,
    this.completionDate,
    this.dropSchedule,
    this.vehicleCheckin,
    this.shopStart,
    this.shopFinish,
    required this.leadStatusId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
    this.vehicle,
    required this.createdby,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        clientId: json["client_id"],
        customerId: json["customer_id"],
        vehicleId: json["vehicle_id"],
        serviceWriterId: json["service_writer_id"],
        orderNumber: json["order_number"],
        estimationName: json["estimation_name"],
        poNumber: json["po_number"],
        orderStatus: json["order_status"],
        priorityDelivery: json["priority_delivery"],
        tags: json["tags"],
        customerNote: json["customer_note"],
        recomendation: json["recomendation"],
        totalPartsCost: json["total_parts_cost"],
        totalLaborCost: json["total_labor_cost"],
        totalOtherCost: json["total_other_cost"],
        subTotal: json["sub_total"],
        totalTax: json["total_tax"],
        totalDiscount: json["total_discount"],
        grandTotal: json["grand_total"],
        paidAmount: json["paid_amount"],
        promiseDate: json["promise_date"],
        completionDate: json["completion_date"],
        dropSchedule: json["drop_schedule"],
        vehicleCheckin: json["vehicle_checkin"],
        shopStart: json["shop_start"],
        shopFinish: json["shop_finish"],
        leadStatusId: json["lead_status_id"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customer: json["customer"] != null
            ? Createdby.fromJson(json["customer"])
            : null,
        vehicle:
            json["vehicle"] != null ? Vehicle.fromJson(json["vehicle"]) : null,
        createdby: Createdby.fromJson(json["createdby"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "service_writer_id": serviceWriterId,
        "order_number": orderNumber,
        "estimation_name": estimationName,
        "po_number": poNumber,
        "order_status": orderStatus,
        "priority_delivery": priorityDelivery,
        "tags": tags,
        "customer_note": customerNote,
        "recomendation": recomendation,
        "total_parts_cost": totalPartsCost,
        "total_labor_cost": totalLaborCost,
        "total_other_cost": totalOtherCost,
        "sub_total": subTotal,
        "total_tax": totalTax,
        "total_discount": totalDiscount,
        "grand_total": grandTotal,
        "paid_amount": paidAmount,
        "promise_date": promiseDate,
        "completion_date": completionDate,
        "drop_schedule": dropSchedule,
        "vehicle_checkin": vehicleCheckin,
        "shop_start": shopStart,
        "shop_finish": shopFinish,
        "lead_status_id": leadStatusId,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "customer": customer!.toJson(),
        "vehicle": vehicle!.toJson(),
        "createdby": createdby.toJson(),
      };
}

class Createdby {
  int id;
  String email;
  String firstName;
  String lastName;
  String? phone;

  Createdby({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
  });

  factory Createdby.fromJson(Map<String, dynamic> json) => Createdby(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
      };
}

class Vehicle {
  int id;
  String vehicleType;
  String vehicleYear;
  String vehicleMake;
  String vehicleModel;
  String vehicleColor;
  String licencePlate;
  String vin;
  String kilometers;

  Vehicle({
    required this.id,
    required this.vehicleType,
    required this.vehicleYear,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licencePlate,
    required this.vin,
    required this.kilometers,
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

class Order {
  dynamic clientId;
  dynamic customerId;
  dynamic vehicleId;
  dynamic createdBy;
  dynamic serviceWriterId;
  dynamic orderNumber;

  Order({
    this.clientId,
    this.customerId,
    this.vehicleId,
    this.createdBy,
    this.serviceWriterId,
    this.orderNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        clientId: json["client_id"],
        customerId: json["customer_id"],
        vehicleId: json["vehicle_id"],
        createdBy: json["created_by"],
        serviceWriterId: json["service_writer_id"],
        orderNumber: json["order_number"],
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "created_by": createdBy,
        "service_writer_id": serviceWriterId,
        "order_number": orderNumber,
      };
}
