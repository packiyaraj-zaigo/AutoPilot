class SingleVehicleResponseModel {
  int? id;
  int? customerId;
  String? vehicleType;
  String? vehicleYear;
  String? vehicleMake;
  String? vehicleModel;
  String? kilometers;
  String? vehicleColor;
  String? licencePlate;
  String? unit;
  String? vin;
  String? notes;
  String? subModel;
  String? engineSize;
  DateTime? productionDate;
  String? transmission;
  String? drivetrain;
  CreatedBy? createdBy;
  int? clientId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? email;
  String? firstName;
  String? lastName;
  int? countOrderCount;
  CreatedBy? customer;

  SingleVehicleResponseModel({
    required this.id,
    required this.customerId,
    required this.vehicleType,
    required this.vehicleYear,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.kilometers,
    required this.vehicleColor,
    required this.licencePlate,
    required this.unit,
    required this.vin,
    required this.notes,
    required this.subModel,
    required this.engineSize,
    required this.productionDate,
    required this.transmission,
    required this.drivetrain,
    required this.createdBy,
    required this.clientId,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.countOrderCount,
    required this.customer,
  });

  factory SingleVehicleResponseModel.fromJson(Map<String, dynamic> json) =>
      SingleVehicleResponseModel(
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
        productionDate: DateTime.parse(json["production_date"]),
        transmission: json["transmission"],
        drivetrain: json["drivetrain"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        clientId: json["client_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        countOrderCount: json["count_order_count"],
        customer: CreatedBy.fromJson(json["customer"]),
      );
}

class CreatedBy {
  int? id;
  String? email;
  String? firstName;
  String? lastName;

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
}
