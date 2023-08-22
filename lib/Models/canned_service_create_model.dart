// To parse this JSON data, do
//
//     final cannedServiceAddMaterialModel = cannedServiceAddMaterialModelFromJson(jsonString);

import 'dart:convert';

CannedServiceAddModel cannedServiceAddMaterialModelFromJson(String str) =>
    CannedServiceAddModel.fromJson(json.decode(str));

String cannedServiceAddMaterialModelToJson(CannedServiceAddModel data) =>
    json.encode(data.toJson());

class CannedServiceAddModel {
  int cannedServiceId;
  String id;
  String itemName;
  String unitPrice;
  String discount;
  String subTotal;
  String itemType;
  String quanityHours;
  String discountType;
  String note;
  String part;
  String tax;
  int? vendorId;
  int position;

  CannedServiceAddModel({
    required this.cannedServiceId,
    required this.itemName,
    required this.unitPrice,
    required this.discount,
    required this.subTotal,
    required this.note,
    required this.part,
    this.id = '',
    this.itemType = 'Material',
    this.quanityHours = '1',
    this.discountType = 'Percentage',
    this.tax = 'N',
    this.position = 0,
    this.vendorId,
  });

  factory CannedServiceAddModel.fromJson(Map<String, dynamic> json) =>
      CannedServiceAddModel(
        cannedServiceId: json["canned_service_id"],
        itemType: json["item_type"],
        itemName: json["item_name"],
        unitPrice: json["unit_price"],
        quanityHours: json["quanity_hours"],
        discount: json["discount"],
        discountType: json["discount_type"],
        subTotal: json["sub_total"],
        position: json["position"],
        note: json["item_service_note"],
        part: json["part_name"],
        tax: json["is_tax"],
        vendorId: json["vendor_id"],
      );

  Map<String, dynamic> toJson() => {
        "canned_service_id": cannedServiceId,
        "item_type": itemType,
        "item_name": itemName,
        "unit_price": unitPrice,
        "quanity_hours": quanityHours,
        "discount": discount,
        "discount_type": discountType,
        "sub_total": subTotal,
        "position": position,
        "item_service_note": note,
        "part_name": part,
        "is_tax": tax,
        "vendor_id": vendorId,
      };
}
