// To parse this JSON data, do
//
//     final createEstimateModel = createEstimateModelFromJson(jsonString);

import 'dart:convert';

CreateEstimateModel createEstimateModelFromJson(String str) =>
    CreateEstimateModel.fromJson(json.decode(str));

String createEstimateModelToJson(CreateEstimateModel data) =>
    json.encode(data.toJson());

class CreateEstimateModel {
  Data data;
  String message;

  CreateEstimateModel({
    required this.data,
    required this.message,
  });

  factory CreateEstimateModel.fromJson(Map<String, dynamic> json) =>
      CreateEstimateModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
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
  List<OrderService>? orderService;
  List<AssignedTech>? assignedTech;
  List<AuthorizatedItem>? authorizatedItems;
  Createdby? customer;
  Vehicle? vehicle;
  Servicewriter? servicewriter;
  List<dynamic>? getAuthorize;
  Createdby createdby;
  List<InspectionNote>? inspectionNotes;

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
    this.orderService,
    this.assignedTech,
    this.authorizatedItems,
    this.customer,
    this.vehicle,
    this.servicewriter,
    this.getAuthorize,
    required this.createdby,
    this.inspectionNotes,
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
        orderService:
            json["order_service"] != null && json["order_service"] != []
                ? List<OrderService>.from(
                    json["order_service"].map((x) => OrderService.fromJson(x)))
                : null,
        assignedTech:
            json["assigned_tech"] != null && json["assigned_tech"] != []
                ? List<AssignedTech>.from(
                    json["assigned_tech"].map((x) => AssignedTech.fromJson(x)))
                : null,
        authorizatedItems: json["authorizated_items"] != [] &&
                json["authorizated_items"] != null
            ? List<AuthorizatedItem>.from(json["authorizated_items"]
                .map((x) => AuthorizatedItem.fromJson(x)))
            : null,
        customer: json["customer"] != [] && json["customer"] != null
            ? Createdby.fromJson(json["customer"])
            : null,
        vehicle: json["vehicle"] != null && json["vehicle"] != []
            ? Vehicle.fromJson(json["vehicle"])
            : null,
        servicewriter:
            json["servicewriter"] != null && json["servicewriter"] != []
                ? Servicewriter.fromJson(json["servicewriter"])
                : null,
        getAuthorize:
            json["get_authorize"] != null && json["get_authorize"] != []
                ? List<dynamic>.from(json["get_authorize"].map((x) => x))
                : null,
        createdby: Createdby.fromJson(json["createdby"]),
        inspectionNotes: json["inspection_notes"] != null &&
                json["inspection_notes"] != []
            ? List<InspectionNote>.from(
                json["inspection_notes"].map((x) => InspectionNote.fromJson(x)))
            : null,
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
        "order_service":
            List<dynamic>.from(orderService!.map((x) => x.toJson())),
        "assigned_tech":
            List<dynamic>.from(assignedTech!.map((x) => x.toJson())),
        "authorizated_items":
            List<dynamic>.from(authorizatedItems!.map((x) => x.toJson())),
        "customer": customer!.toJson(),
        "vehicle": vehicle!.toJson(),
        "servicewriter": servicewriter!.toJson(),
        "get_authorize": List<dynamic>.from(getAuthorize!.map((x) => x)),
        "createdby": createdby.toJson(),
        "inspection_notes":
            List<dynamic>.from(inspectionNotes!.map((x) => x.toJson())),
      };
}

class AssignedTech {
  int technicianId;
  dynamic technician;

  AssignedTech({
    required this.technicianId,
    this.technician,
  });

  factory AssignedTech.fromJson(Map<String, dynamic> json) => AssignedTech(
        technicianId: json["technician_id"],
        technician: json["technician"],
      );

  Map<String, dynamic> toJson() => {
        "technician_id": technicianId,
        "technician": technician,
      };
}

class AuthorizatedItem {
  String serviceName;
  String isAuthorizedCustomer;

  AuthorizatedItem({
    required this.serviceName,
    required this.isAuthorizedCustomer,
  });

  factory AuthorizatedItem.fromJson(Map<String, dynamic> json) =>
      AuthorizatedItem(
        serviceName: json["service_name"],
        isAuthorizedCustomer: json["is_authorized_customer"],
      );

  Map<String, dynamic> toJson() => {
        "service_name": serviceName,
        "is_authorized_customer": isAuthorizedCustomer,
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

class InspectionNote {
  int id;
  int orderId;
  String inspectionArea;
  dynamic imagePosition;
  String comments;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> images;

  InspectionNote({
    required this.id,
    required this.orderId,
    required this.inspectionArea,
    this.imagePosition,
    required this.comments,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory InspectionNote.fromJson(Map<String, dynamic> json) => InspectionNote(
        id: json["id"],
        orderId: json["order_id"],
        inspectionArea: json["inspection_area"],
        imagePosition: json["image_position"],
        comments: json["comments"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        images: List<dynamic>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "inspection_area": inspectionArea,
        "image_position": imagePosition,
        "comments": comments,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}

class OrderService {
  int id;
  int orderId;
  int technicianId;
  String serviceName;
  String serviceNote;
  String recommendedService;
  String isVisible;
  String isAuthorized;
  String isAuthorizedCustomer;
  String servicePrice;
  String priceType;
  String discount;
  String discountType;
  String serviceEpa;
  String epaType;
  String shopSupplies;
  String shopSuppliesType;
  String tax;
  String taxType;
  String subTotal;
  int position;
  String isMaintenance;
  String isServiceReminder;
  int maintenancePeriod;
  String maintenancePeriodType;
  String communicationChannel;
  dynamic reminderTrigger;
  dynamic customMessage;
  int cannedServiceId;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<OrderServiceItem>? orderServiceItems;

  OrderService({
    required this.id,
    required this.orderId,
    required this.technicianId,
    required this.serviceName,
    required this.serviceNote,
    required this.recommendedService,
    required this.isVisible,
    required this.isAuthorized,
    required this.isAuthorizedCustomer,
    required this.servicePrice,
    required this.priceType,
    required this.discount,
    required this.discountType,
    required this.serviceEpa,
    required this.epaType,
    required this.shopSupplies,
    required this.shopSuppliesType,
    required this.tax,
    required this.taxType,
    required this.subTotal,
    required this.position,
    required this.isMaintenance,
    required this.isServiceReminder,
    required this.maintenancePeriod,
    required this.maintenancePeriodType,
    required this.communicationChannel,
    this.reminderTrigger,
    this.customMessage,
    required this.cannedServiceId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.orderServiceItems,
  });

  factory OrderService.fromJson(Map<String, dynamic> json) => OrderService(
        id: json["id"],
        orderId: json["order_id"],
        technicianId: json["technician_id"],
        serviceName: json["service_name"],
        serviceNote: json["service_note"],
        recommendedService: json["recommended_service"],
        isVisible: json["is_visible"],
        isAuthorized: json["is_authorized"],
        isAuthorizedCustomer: json["is_authorized_customer"],
        servicePrice: json["service_price"],
        priceType: json["price_type"],
        discount: json["discount"],
        discountType: json["discount_type"],
        serviceEpa: json["service_epa"],
        epaType: json["epa_type"],
        shopSupplies: json["shop_supplies"],
        shopSuppliesType: json["shop_supplies_type"],
        tax: json["tax"],
        taxType: json["tax_type"],
        subTotal: json["sub_total"],
        position: json["position"],
        isMaintenance: json["is_maintenance"],
        isServiceReminder: json["is_service_reminder"],
        maintenancePeriod: json["maintenance_period"],
        maintenancePeriodType: json["maintenance_period_type"],
        communicationChannel: json["communication_channel"],
        reminderTrigger: json["reminder_trigger"],
        customMessage: json["custom_message"],
        cannedServiceId: json["canned_service_id"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        orderServiceItems: json["order_service_items"] != null &&
                json["order_service_items"] != []
            ? List<OrderServiceItem>.from(json["order_service_items"]
                .map((x) => OrderServiceItem.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "technician_id": technicianId,
        "service_name": serviceName,
        "service_note": serviceNote,
        "recommended_service": recommendedService,
        "is_visible": isVisible,
        "is_authorized": isAuthorized,
        "is_authorized_customer": isAuthorizedCustomer,
        "service_price": servicePrice,
        "price_type": priceType,
        "discount": discount,
        "discount_type": discountType,
        "service_epa": serviceEpa,
        "epa_type": epaType,
        "shop_supplies": shopSupplies,
        "shop_supplies_type": shopSuppliesType,
        "tax": tax,
        "tax_type": taxType,
        "sub_total": subTotal,
        "position": position,
        "is_maintenance": isMaintenance,
        "is_service_reminder": isServiceReminder,
        "maintenance_period": maintenancePeriod,
        "maintenance_period_type": maintenancePeriodType,
        "communication_channel": communicationChannel,
        "reminder_trigger": reminderTrigger,
        "custom_message": customMessage,
        "canned_service_id": cannedServiceId,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "order_service_items":
            List<dynamic>.from(orderServiceItems!.map((x) => x)),
      };
}

class OrderServiceItem {
  int id;
  int orderServiceId;
  String itemType;
  String itemName;
  dynamic itemServiceNote;
  String unitPrice;
  String quanityHours;
  String serviceEpa;
  String epaType;
  String tax;
  String taxType;
  String discount;
  String discountType;
  dynamic statusLabels;
  String subTotal;
  dynamic partName;
  int relativeParts;
  int technicianId;
  int vendorId;
  int categoryId;
  dynamic tireBrand;
  dynamic tireModel;
  dynamic seasonality;
  dynamic binLocation;
  dynamic size;
  String markup;
  String margin;
  int laborMatrixId;
  int pricingMatrixId;
  String hoursMultiplier;
  String rateMultiplier;
  String feeLine;
  int feeAppliedItem;
  String feePercentage;
  String chargeCustomer;
  String isWarranty;
  String isWarrantyClaim;
  int warrantyPeriod;
  String warrantyPeriodType;
  String isTax;
  String isDisplayPartNumber;
  String isDisplayPriceQuantity;
  String isDisplayNote;
  int position;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  OrderServiceItem({
    required this.id,
    required this.orderServiceId,
    required this.itemType,
    required this.itemName,
    this.itemServiceNote,
    required this.unitPrice,
    required this.quanityHours,
    required this.serviceEpa,
    required this.epaType,
    required this.tax,
    required this.taxType,
    required this.discount,
    required this.discountType,
    this.statusLabels,
    required this.subTotal,
    this.partName,
    required this.relativeParts,
    required this.technicianId,
    required this.vendorId,
    required this.categoryId,
    this.tireBrand,
    this.tireModel,
    this.seasonality,
    this.binLocation,
    this.size,
    required this.markup,
    required this.margin,
    required this.laborMatrixId,
    required this.pricingMatrixId,
    required this.hoursMultiplier,
    required this.rateMultiplier,
    required this.feeLine,
    required this.feeAppliedItem,
    required this.feePercentage,
    required this.chargeCustomer,
    required this.isWarranty,
    required this.isWarrantyClaim,
    required this.warrantyPeriod,
    required this.warrantyPeriodType,
    required this.isTax,
    required this.isDisplayPartNumber,
    required this.isDisplayPriceQuantity,
    required this.isDisplayNote,
    required this.position,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderServiceItem.fromJson(Map<String, dynamic> json) =>
      OrderServiceItem(
        id: json["id"],
        orderServiceId: json["order_service_id"],
        itemType: json["item_type"],
        itemName: json["item_name"],
        itemServiceNote: json["item_service_note"],
        unitPrice: json["unit_price"],
        quanityHours: json["quanity_hours"],
        serviceEpa: json["service_epa"],
        epaType: json["epa_type"],
        tax: json["tax"],
        taxType: json["tax_type"],
        discount: json["discount"],
        discountType: json["discount_type"],
        statusLabels: json["status_labels"],
        subTotal: json["sub_total"],
        partName: json["part_name"],
        relativeParts: json["relative_parts"],
        technicianId: json["technician_id"],
        vendorId: json["vendor_id"],
        categoryId: json["category_id"],
        tireBrand: json["tire_brand"],
        tireModel: json["tire_model"],
        seasonality: json["seasonality"],
        binLocation: json["bin_location"],
        size: json["size"],
        markup: json["markup"],
        margin: json["margin"],
        laborMatrixId: json["labor_matrix_id"],
        pricingMatrixId: json["pricing_matrix_id"],
        hoursMultiplier: json["hours_multiplier"],
        rateMultiplier: json["rate_multiplier"],
        feeLine: json["fee_line"],
        feeAppliedItem: json["fee_applied_item"],
        feePercentage: json["fee_percentage"],
        chargeCustomer: json["charge_customer"],
        isWarranty: json["is_warranty"],
        isWarrantyClaim: json["is_warranty_claim"],
        warrantyPeriod: json["warranty_period"],
        warrantyPeriodType: json["warranty_period_type"],
        isTax: json["is_tax"],
        isDisplayPartNumber: json["is_display_part_number"],
        isDisplayPriceQuantity: json["is_display_price_quantity"],
        isDisplayNote: json["is_display_note"],
        position: json["position"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_service_id": orderServiceId,
        "item_type": itemType,
        "item_name": itemName,
        "item_service_note": itemServiceNote,
        "unit_price": unitPrice,
        "quanity_hours": quanityHours,
        "service_epa": serviceEpa,
        "epa_type": epaType,
        "tax": tax,
        "tax_type": taxType,
        "discount": discount,
        "discount_type": discountType,
        "status_labels": statusLabels,
        "sub_total": subTotal,
        "part_name": partName,
        "relative_parts": relativeParts,
        "technician_id": technicianId,
        "vendor_id": vendorId,
        "category_id": categoryId,
        "tire_brand": tireBrand,
        "tire_model": tireModel,
        "seasonality": seasonality,
        "bin_location": binLocation,
        "size": size,
        "markup": markup,
        "margin": margin,
        "labor_matrix_id": laborMatrixId,
        "pricing_matrix_id": pricingMatrixId,
        "hours_multiplier": hoursMultiplier,
        "rate_multiplier": rateMultiplier,
        "fee_line": feeLine,
        "fee_applied_item": feeAppliedItem,
        "fee_percentage": feePercentage,
        "charge_customer": chargeCustomer,
        "is_warranty": isWarranty,
        "is_warranty_claim": isWarrantyClaim,
        "warranty_period": warrantyPeriod,
        "warranty_period_type": warrantyPeriodType,
        "is_tax": isTax,
        "is_display_part_number": isDisplayPartNumber,
        "is_display_price_quantity": isDisplayPriceQuantity,
        "is_display_note": isDisplayNote,
        "position": position,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Servicewriter {
  int id;
  String email;
  String firstName;
  String lastName;
  String profileImage;
  int commissionStructureId;

  Servicewriter({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.commissionStructureId,
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
