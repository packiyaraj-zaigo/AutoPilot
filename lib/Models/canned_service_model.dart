// To parse this JSON data, do
//
//     final cannedServiceModel = cannedServiceModelFromJson(jsonString);

import 'dart:convert';

CannedServiceModel cannedServiceModelFromJson(String str) =>
    CannedServiceModel.fromJson(json.decode(str));

String cannedServiceModelToJson(CannedServiceModel data) =>
    json.encode(data.toJson());

class CannedServiceModel {
  Data data;
  int count;
  String message;

  CannedServiceModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory CannedServiceModel.fromJson(Map<String, dynamic> json) =>
      CannedServiceModel(
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
  String nextPageUrl;
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
    required this.nextPageUrl,
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
  int clientId;
  String serviceName;
  ServiceNote? serviceNote;
  RecommendedService recommendedService;
  Is isVisible;
  Is isAuthorized;
  String servicePrice;
  PriceType priceType;
  String discount;
  Type discountType;
  String serviceEpa;
  Type epaType;
  String shopSupplies;
  Type shopSuppliesType;
  String tax;
  Type taxType;
  String subTotal;
  Is isMaintenance;
  Is isServiceReminder;
  int maintenancePeriod;
  MaintenancePeriodType maintenancePeriodType;
  CommunicationChannel communicationChannel;
  dynamic reminderTrigger;
  dynamic customMessage;
  CreatedBy? createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<CannedServiceItem>? cannedServiceItems;

  Datum({
    required this.id,
    required this.clientId,
    required this.serviceName,
    this.serviceNote,
    required this.recommendedService,
    required this.isVisible,
    required this.isAuthorized,
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
    required this.isMaintenance,
    required this.isServiceReminder,
    required this.maintenancePeriod,
    required this.maintenancePeriodType,
    required this.communicationChannel,
    this.reminderTrigger,
    this.customMessage,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.cannedServiceItems,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientId: json["client_id"],
        serviceName: json["service_name"],
        serviceNote: json["service_note"] != null
            ? serviceNoteValues.map[json["service_note"]]
            : null,
        recommendedService:
            recommendedServiceValues.map[json["recommended_service"]]!,
        isVisible: isValues.map[json["is_visible"]]!,
        isAuthorized: isValues.map[json["is_authorized"]]!,
        servicePrice: json["service_price"],
        priceType: priceTypeValues.map[json["price_type"]]!,
        discount: json["discount"],
        discountType: typeValues.map[json["discount_type"]]!,
        serviceEpa: json["service_epa"],
        epaType: typeValues.map[json["epa_type"]]!,
        shopSupplies: json["shop_supplies"],
        shopSuppliesType: typeValues.map[json["shop_supplies_type"]]!,
        tax: json["tax"],
        taxType: typeValues.map[json["tax_type"]]!,
        subTotal: json["sub_total"],
        isMaintenance: isValues.map[json["is_maintenance"]]!,
        isServiceReminder: isValues.map[json["is_service_reminder"]]!,
        maintenancePeriod: json["maintenance_period"],
        maintenancePeriodType:
            maintenancePeriodTypeValues.map[json["maintenance_period_type"]]!,
        communicationChannel:
            communicationChannelValues.map[json["communication_channel"]]!,
        reminderTrigger: json["reminder_trigger"],
        customMessage: json["custom_message"],
        createdBy: json["created_by"] != null
            ? CreatedBy.fromJson(json["created_by"])
            : null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        cannedServiceItems: json["canned_service_items"] != null &&
                json["canned_service_items"] != []
            ? List<CannedServiceItem>.from(json["canned_service_items"]
                .map((x) => CannedServiceItem.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "service_name": serviceName,
        "service_note": serviceNoteValues.reverse[serviceNote],
        "recommended_service":
            recommendedServiceValues.reverse[recommendedService],
        "is_visible": isValues.reverse[isVisible],
        "is_authorized": isValues.reverse[isAuthorized],
        "service_price": servicePrice,
        "price_type": priceTypeValues.reverse[priceType],
        "discount": discount,
        "discount_type": typeValues.reverse[discountType],
        "service_epa": serviceEpa,
        "epa_type": typeValues.reverse[epaType],
        "shop_supplies": shopSupplies,
        "shop_supplies_type": typeValues.reverse[shopSuppliesType],
        "tax": tax,
        "tax_type": typeValues.reverse[taxType],
        "sub_total": subTotal,
        "is_maintenance": isValues.reverse[isMaintenance],
        "is_service_reminder": isValues.reverse[isServiceReminder],
        "maintenance_period": maintenancePeriod,
        "maintenance_period_type":
            maintenancePeriodTypeValues.reverse[maintenancePeriodType],
        "communication_channel":
            communicationChannelValues.reverse[communicationChannel],
        "reminder_trigger": reminderTrigger,
        "custom_message": customMessage,
        "created_by": createdBy!.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "canned_service_items":
            List<dynamic>.from(cannedServiceItems!.map((x) => x)),
      };
}

class CannedServiceItem {
  int id;
  int cannedServiceId;
  String itemType;
  String itemName;
  String itemServiceNote;
  String unitPrice;
  String quanityHours;
  String discount;
  Type discountType;
  dynamic statusLabels;
  String subTotal;
  String partName;
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
  Is isTax;
  Is isDisplayPartNumber;
  Is isDisplayPriceQuantity;
  Is isDisplayNote;
  int position;
  DateTime createdAt;
  DateTime updatedAt;

  CannedServiceItem({
    required this.id,
    required this.cannedServiceId,
    required this.itemType,
    required this.itemName,
    required this.itemServiceNote,
    required this.unitPrice,
    required this.quanityHours,
    required this.discount,
    required this.discountType,
    this.statusLabels,
    required this.subTotal,
    required this.partName,
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
    required this.isTax,
    required this.isDisplayPartNumber,
    required this.isDisplayPriceQuantity,
    required this.isDisplayNote,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CannedServiceItem.fromJson(Map<String, dynamic> json) =>
      CannedServiceItem(
        id: json["id"],
        cannedServiceId: json["canned_service_id"],
        itemType: json["item_type"],
        itemName: json["item_name"],
        itemServiceNote: json["item_service_note"],
        unitPrice: json["unit_price"],
        quanityHours: json["quanity_hours"],
        discount: json["discount"],
        discountType: typeValues.map[json["discount_type"]]!,
        statusLabels: json["status_labels"],
        subTotal: json["sub_total"],
        partName: json["part_name"],
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
        isTax: isValues.map[json["is_tax"]]!,
        isDisplayPartNumber: isValues.map[json["is_display_part_number"]]!,
        isDisplayPriceQuantity:
            isValues.map[json["is_display_price_quantity"]]!,
        isDisplayNote: isValues.map[json["is_display_note"]]!,
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "canned_service_id": cannedServiceId,
        "item_type": itemType,
        "item_name": itemName,
        "item_service_note": itemServiceNote,
        "unit_price": unitPrice,
        "quanity_hours": quanityHours,
        "discount": discount,
        "discount_type": typeValues.reverse[discountType],
        "status_labels": statusLabels,
        "sub_total": subTotal,
        "part_name": partName,
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
        "is_tax": isValues.reverse[isTax],
        "is_display_part_number": isValues.reverse[isDisplayPartNumber],
        "is_display_price_quantity": isValues.reverse[isDisplayPriceQuantity],
        "is_display_note": isValues.reverse[isDisplayNote],
        "position": position,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum CommunicationChannel { SMS }

final communicationChannelValues =
    EnumValues({"SMS": CommunicationChannel.SMS});

class CreatedBy {
  int? id;
  Email? email;
  FirstName? firstName;
  LastName? lastName;

  CreatedBy({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        email: emailValues.map[json["email"]],
        firstName: firstNameValues.map[json["first_name"]],
        lastName: lastNameValues.map[json["last_name"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": emailValues.reverse[email],
        "first_name": firstNameValues.reverse[firstName],
        "last_name": lastNameValues.reverse[lastName],
      };
}

enum Email { SANJAY_YMAIL_COM }

final emailValues = EnumValues({"sanjay@ymail.com": Email.SANJAY_YMAIL_COM});

enum FirstName { SANJAY }

final firstNameValues = EnumValues({"sanjay": FirstName.SANJAY});

enum LastName { GGGG }

final lastNameValues = EnumValues({"gggg": LastName.GGGG});

enum Type { PERCENTAGE }

final typeValues = EnumValues({"Percentage": Type.PERCENTAGE});

enum Is { N }

final isValues = EnumValues({"N": Is.N});

enum MaintenancePeriodType { DAYS }

final maintenancePeriodTypeValues =
    EnumValues({"Days": MaintenancePeriodType.DAYS});

enum PriceType { FIXED }

final priceTypeValues = EnumValues({"Fixed": PriceType.FIXED});

enum RecommendedService { Y }

final recommendedServiceValues = EnumValues({"Y": RecommendedService.Y});

enum ServiceNote { SERVICE_NOTE }

final serviceNoteValues =
    EnumValues({"service_note": ServiceNote.SERVICE_NOTE});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
