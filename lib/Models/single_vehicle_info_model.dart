// To parse this JSON data, do
//
//     final singleVehicleInfoModel = singleVehicleInfoModelFromJson(jsonString);

import 'dart:convert';

SingleVehicleInfoModel singleVehicleInfoModelFromJson(String str) =>
    SingleVehicleInfoModel.fromJson(json.decode(str));

String singleVehicleInfoModelToJson(SingleVehicleInfoModel data) =>
    json.encode(data.toJson());

class SingleVehicleInfoModel {
  Vehicle vehicle;
  String message;

  SingleVehicleInfoModel({
    required this.vehicle,
    required this.message,
  });

  factory SingleVehicleInfoModel.fromJson(Map<String, dynamic> json) =>
      SingleVehicleInfoModel(
        vehicle: Vehicle.fromJson(json["vehicle"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle": vehicle.toJson(),
        "message": message,
      };
}

class Vehicle {
  int id;
  int customerId;
  String vehicleType;
  String vehicleYear;
  String vehicleMake;
  String vehicleModel;
  String kilometers;
  String vehicleColor;
  String licencePlate;
  dynamic unit;
  String vin;
  dynamic notes;
  String subModel;
  String engineSize;
  dynamic productionDate;
  dynamic transmission;
  dynamic drivetrain;
  CreatedBy createdBy;
  int clientId;
  DateTime createdAt;
  DateTime updatedAt;
  int countOrderCount;
  CreatedBy? customer;

  Vehicle({
    required this.id,
    required this.customerId,
    required this.vehicleType,
    required this.vehicleYear,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.kilometers,
    required this.vehicleColor,
    required this.licencePlate,
    this.unit,
    required this.vin,
    this.notes,
    required this.subModel,
    required this.engineSize,
    this.productionDate,
    this.transmission,
    this.drivetrain,
    required this.createdBy,
    required this.clientId,
    required this.createdAt,
    required this.updatedAt,
    required this.countOrderCount,
    this.customer,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        customerId: json["customer_id"],
        vehicleType: json["vehicle_type"],
        vehicleYear: json["vehicle_year"],
        vehicleMake: json["vehicle_make"],
        vehicleModel: json["vehicle_model"],
        kilometers: json["kilometers"],
        vehicleColor: json["vehicle_color"],
        licencePlate: json["licence_plate"],
        unit: json["unit"],
        vin: json["vin"],
        notes: json["notes"],
        subModel: json["sub_model"],
        engineSize: json["engine_size"],
        productionDate: json["production_date"],
        transmission: json["transmission"],
        drivetrain: json["drivetrain"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        clientId: json["client_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        countOrderCount: json["count_order_count"],
        customer: json["customer"] != null
            ? CreatedBy.fromJson(json["customer"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "vehicle_type": vehicleType,
        "vehicle_year": vehicleYear,
        "vehicle_make": vehicleMake,
        "vehicle_model": vehicleModel,
        "kilometers": kilometers,
        "vehicle_color": vehicleColor,
        "licence_plate": licencePlate,
        "unit": unit,
        "vin": vin,
        "notes": notes,
        "sub_model": subModel,
        "engine_size": engineSize,
        "production_date": productionDate,
        "transmission": transmission,
        "drivetrain": drivetrain,
        "created_by": createdBy.toJson(),
        "client_id": clientId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "count_order_count": countOrderCount,
        "customer": customer!.toJson(),
      };
}

class CreatedBy {
  int id;
  String email;
  String firstName;
  String lastName;

  CreatedBy({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
      };
}
