class VehicleEstimateResponseModel {
  int? id;
  int? clientId;
  int? customerId;
  int? vehicleId;
  int? serviceWriterId;
  int? orderNumber;
  String? estimationName;
  String? poNumber;
  String? orderStatus;
  String? priorityDelivery;
  String? tags;
  String? customerNote;
  String? recomendation;
  String? totalPartsCost;
  String? totalLaborCost;
  String? totalOtherCost;
  String? subTotal;
  String? totalTax;
  String? totalDiscount;
  String? grandTotal;
  String? paidAmount;
  dynamic promiseDate;
  dynamic completionDate;
  dynamic dropSchedule;
  dynamic vehicleCheckin;
  dynamic shopStart;
  dynamic shopFinish;
  int? leadStatusId;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  Createdby? customer;
  Vehicle? vehicle;
  Createdby? createdby;
  List<dynamic> getOrderPayment;
  List<dynamic> getAuthorize;
  dynamic assignedtech;
  List<dynamic> inspectionNotes;

  VehicleEstimateResponseModel({
    required this.id,
    required this.clientId,
    required this.customerId,
    required this.vehicleId,
    required this.serviceWriterId,
    required this.orderNumber,
    required this.estimationName,
    required this.poNumber,
    required this.orderStatus,
    required this.priorityDelivery,
    required this.tags,
    required this.customerNote,
    required this.recomendation,
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
    required this.customer,
    required this.vehicle,
    required this.createdby,
    required this.getOrderPayment,
    required this.getAuthorize,
    this.assignedtech,
    required this.inspectionNotes,
  });

  factory VehicleEstimateResponseModel.fromJson(json) =>
      VehicleEstimateResponseModel(
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
        customer: json["customer"] == null
            ? null
            : Createdby.fromJson(json["customer"]),
        vehicle:
            json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
        createdby: json["createdBy"] == null
            ? null
            : Createdby.fromJson(json["createdby"]),
        getOrderPayment:
            List<dynamic>.from(json["get_order_payment"].map((x) => x)),
        getAuthorize: List<dynamic>.from(json["get_authorize"].map((x) => x)),
        assignedtech: json["assignedtech"],
        inspectionNotes:
            List<dynamic>.from(json["inspection_notes"].map((x) => x)),
      );
}

class Createdby {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? phone;

  Createdby({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
  });

  factory Createdby.fromJson(json) => Createdby(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
      );
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

  factory Vehicle.fromJson(json) => Vehicle(
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
}
