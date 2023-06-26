// To parse this JSON data, do
//
//     final estimateModel = estimateModelFromJson(jsonString);

import 'dart:convert';

EstimateModel estimateModelFromJson(String str) => EstimateModel.fromJson(json.decode(str));

String estimateModelToJson(EstimateModel data) => json.encode(data.toJson());

class EstimateModel {
    Data data;
    int count;
    String message;

    EstimateModel({
        required this.data,
        required this.count,
        required this.message,
    });

    factory EstimateModel.fromJson(Map<String, dynamic> json) => EstimateModel(
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
    int? from;
    int? lastPage;
    String lastPageUrl;
    dynamic nextPageUrl;
    String path;
    String perPage;
    dynamic prevPageUrl;
    int? to;
    int? total;

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
        data:json["data"]!=[]? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))):[],
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
    int? id;
    int? clientId;
    int? customerId;
    int? vehicleId;
    int? serviceWriterId;
    int? orderNumber;
    String? estimationName;
    String poNumber;
    String orderStatus;
    String priorityDelivery;
    String tags;
    String customerNote;
    String recomendation;
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
    int? leadStatusId;
    int? createdBy;
    DateTime createdAt;
    DateTime updatedAt;
    Createdby? customer;
    Vehicle vehicle;
    Createdby? createdby;
    List<dynamic> getOrderPayment;
    List<dynamic> getAuthorize;
    dynamic assignedtech;
    List<dynamic> inspectionNotes;

    Datum({
        required this.id,
        required this.clientId,
        required this.customerId,
        required this.vehicleId,
        required this.serviceWriterId,
        required this.orderNumber,
        this.estimationName,
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
        this.customer,
        required this.vehicle,
        required this.createdby,
        required this.getOrderPayment,
        required this.getAuthorize,
        this.assignedtech,
        required this.inspectionNotes,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        customer: json["customer"] == null ? null : Createdby.fromJson(json["customer"]),
        vehicle: Vehicle.fromJson(json["vehicle"]),
        createdby:json["createdby"]!=null? Createdby.fromJson(json["createdby"]): null,
        getOrderPayment: List<dynamic>.from(json["get_order_payment"].map((x) => x)),
        getAuthorize: List<dynamic>.from(json["get_authorize"].map((x) => x)),
        assignedtech: json["assignedtech"],
        inspectionNotes: List<dynamic>.from(json["inspection_notes"].map((x) => x)),
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
        "customer": customer?.toJson(),
        "vehicle": vehicle.toJson(),
        "createdby": createdby!.toJson(),
        "get_order_payment": List<dynamic>.from(getOrderPayment.map((x) => x)),
        "get_authorize": List<dynamic>.from(getAuthorize.map((x) => x)),
        "assignedtech": assignedtech,
        "inspection_notes": List<dynamic>.from(inspectionNotes.map((x) => x)),
    };
}

class Createdby {
    int? id;
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
    int? id;
    String vehicleType;
    String vehicleYear;
    String vehicleMake;
    String vehicleModel;
    String vehicleColor;
    String? licencePlate;
    String? vin;
    String kilometers;

    Vehicle({
        required this.id,
        required this.vehicleType,
        required this.vehicleYear,
        required this.vehicleMake,
        required this.vehicleModel,
        required this.vehicleColor,
        this.licencePlate,
        this.vin,
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
