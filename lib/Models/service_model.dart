// To parse this JSON data, do
//
//     final serviceModel = serviceModelFromJson(jsonString);

import 'dart:convert';

ServiceModel serviceModelFromJson(String str) =>
    ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
  Data data;
  int count;
  String message;

  ServiceModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
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
  int clientId;
  String serviceName;
  String serviceNote;
  String recommendedService;
  String isVisible;
  String isAuthorized;
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
  String isMaintenance;
  String isServiceReminder;
  int maintenancePeriod;
  String maintenancePeriodType;
  String communicationChannel;
  dynamic reminderTrigger;
  dynamic customMessage;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> cannedServiceItems;

  Datum({
    required this.id,
    required this.clientId,
    required this.serviceName,
    required this.serviceNote,
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
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.cannedServiceItems,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientId: json["client_id"],
        serviceName: json["service_name"],
        serviceNote: json["service_note"],
        recommendedService: json["recommended_service"],
        isVisible: json["is_visible"],
        isAuthorized: json["is_authorized"],
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
        isMaintenance: json["is_maintenance"],
        isServiceReminder: json["is_service_reminder"],
        maintenancePeriod: json["maintenance_period"],
        maintenancePeriodType: json["maintenance_period_type"],
        communicationChannel: json["communication_channel"],
        reminderTrigger: json["reminder_trigger"],
        customMessage: json["custom_message"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        cannedServiceItems:
            List<dynamic>.from(json["canned_service_items"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "service_name": serviceName,
        "service_note": serviceNote,
        "recommended_service": recommendedService,
        "is_visible": isVisible,
        "is_authorized": isAuthorized,
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
        "is_maintenance": isMaintenance,
        "is_service_reminder": isServiceReminder,
        "maintenance_period": maintenancePeriod,
        "maintenance_period_type": maintenancePeriodType,
        "communication_channel": communicationChannel,
        "reminder_trigger": reminderTrigger,
        "custom_message": customMessage,
        "created_by": createdBy.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "canned_service_items":
            List<dynamic>.from(cannedServiceItems.map((x) => x)),
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
