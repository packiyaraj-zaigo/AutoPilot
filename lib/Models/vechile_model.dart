import 'dart:convert';

VechileResponse temperaturesFromJson(String str) =>
    VechileResponse.fromJson(json.decode(str));

String temperaturesToJson(VechileResponse data) => json.encode(data.toJson());

class VechileResponse {
  Data data;
  int count;
  String message;

  VechileResponse({
    required this.data,
    required this.count,
    required this.message,
  });

  factory VechileResponse.fromJson(Map<String, dynamic> json) =>
      VechileResponse(
        data: Data.fromJson(json["data"]),
        count: json["count"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "count": count,
        "message": message,
      };
}

class Data {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int to;
  int total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  int id;
  int customerId;
  String vehicleType;
  String vehicleYear;
  String vehicleMake;
  String vehicleModel;
  String kilometers;
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
  CreatedBy createdBy;
  dynamic clientId;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic email;
  dynamic firstName;
  dynamic lastName;
  int countOrderCount;
  dynamic customer;

  Datum({
    required this.id,
    required this.customerId,
    required this.vehicleType,
    required this.vehicleYear,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.kilometers,
    this.vehicleColor,
    this.licencePlate,
    this.unit,
    this.vin,
    this.notes,
    this.subModel,
    this.engineSize,
    this.productionDate,
    this.transmission,
    this.drivetrain,
    required this.createdBy,
    this.clientId,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.firstName,
    this.lastName,
    required this.countOrderCount,
    this.customer,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        productionDate: json["production_date"] == null
            ? null
            : DateTime.parse(json["production_date"]),
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
        customer: json["customer"],
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
        "production_date":
            "${productionDate!.year.toString().padLeft(4, '0')}-${productionDate!.month.toString().padLeft(2, '0')}-${productionDate!.day.toString().padLeft(2, '0')}",
        "transmission": transmission,
        "drivetrain": drivetrain,
        "created_by": createdBy.toJson(),
        "client_id": clientId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "count_order_count": countOrderCount,
        "customer": customer,
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
