// To parse this JSON data, do
//
//     final cannedServiceItemCreateModel = cannedServiceItemCreateModelFromJson(jsonString);

import 'dart:convert';

CannedServiceCreateModel cannedServiceItemCreateModelFromJson(String str) =>
    CannedServiceCreateModel.fromJson(json.decode(str));

String cannedServiceItemCreateModelToJson(CannedServiceCreateModel data) =>
    json.encode(data.toJson());

class CannedServiceCreateModel {
  int clientId;
  String serviceName;
  String recommendedService;
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
  String serviceNote;

  CannedServiceCreateModel({
    required this.clientId,
    required this.serviceName,
    required this.servicePrice,
    required this.discount,
    required this.tax,
    required this.subTotal,
    required this.serviceNote,
    this.recommendedService = 'Y',
    this.isAuthorized = 'N',
    this.priceType = 'Fixed',
    this.discountType = 'Percentage',
    this.serviceEpa = '0',
    this.epaType = 'Percentage',
    this.shopSupplies = '0',
    this.shopSuppliesType = 'Percentage',
    this.taxType = 'Percentage',
  });

  factory CannedServiceCreateModel.fromJson(Map<String, dynamic> json) =>
      CannedServiceCreateModel(
        clientId: json["client_id"],
        serviceName: json["service_name"],
        serviceNote: json["service_note"],
        recommendedService: json["recommended_service"],
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
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "service_name": serviceName,
        "recommended_service": recommendedService,
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
        "service_note": serviceNote
      };
}
