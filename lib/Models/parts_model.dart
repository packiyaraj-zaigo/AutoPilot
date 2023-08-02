// To parse this JSON data, do
//
//     final parts = partsFromJson(jsonString);

import 'dart:convert';

Parts partsFromJson(String str) => Parts.fromJson(json.decode(str));

String partsToJson(Parts data) => json.encode(data.toJson());

class Parts {
  Data data;
  int count;
  String message;

  Parts({
    required this.data,
    required this.count,
    required this.message,
  });

  factory Parts.fromJson(Map<String, dynamic> json) => Parts(
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
  int? currentPage;
  List<PartsDatum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  String? perPage;
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
        data: List<PartsDatum>.from(
            json["data"].map((x) => PartsDatum.fromJson(x))),
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

class PartsDatum {
  int id;
  int clientId;
  String itemName;
  String itemServiceNote;
  String partName;
  int vendorId;
  int categoryId;
  String binLocation;
  String unitPrice;
  String subTotal;
  String taxRate;
  int pricingMatrixId;
  int quantityInHand;
  int quantityCritical;
  String markup;
  String margin;
  String isTax;
  String isDisplayPartNumber;
  String isDisplayPriceQuantity;
  String isDisplayNote;
  int createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic categoryInfo;
  CreatedUser? createdUser;
  dynamic vendorInfo;

  PartsDatum({
    required this.id,
    required this.clientId,
    required this.itemName,
    required this.itemServiceNote,
    required this.partName,
    required this.vendorId,
    required this.categoryId,
    required this.binLocation,
    required this.unitPrice,
    required this.subTotal,
    required this.taxRate,
    required this.pricingMatrixId,
    required this.quantityInHand,
    required this.quantityCritical,
    required this.markup,
    required this.margin,
    required this.isTax,
    required this.isDisplayPartNumber,
    required this.isDisplayPriceQuantity,
    required this.isDisplayNote,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.categoryInfo,
    required this.createdUser,
    this.vendorInfo,
  });

  factory PartsDatum.fromJson(Map<String, dynamic> json) => PartsDatum(
        id: json["id"],
        clientId: json["client_id"],
        itemName: json["item_name"],
        itemServiceNote: json["item_service_note"],
        partName: json["part_name"],
        vendorId: json["vendor_id"],
        categoryId: json["category_id"],
        binLocation: json["bin_location"],
        unitPrice: json["unit_price"],
        subTotal: json["sub_total"],
        taxRate: json["tax_rate"],
        pricingMatrixId: json["pricing_matrix_id"],
        quantityInHand: json["quantity_in_hand"],
        quantityCritical: json["quantity_critical"],
        markup: json["markup"],
        margin: json["margin"],
        isTax: json["is_tax"],
        isDisplayPartNumber: json["is_display_part_number"],
        isDisplayPriceQuantity: json["is_display_price_quantity"],
        isDisplayNote: json["is_display_note"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        categoryInfo: json["category_info"],
        createdUser: json["created_user"] == null
            ? null
            : CreatedUser.fromJson(json["created_user"]),
        vendorInfo: json["vendor_info"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "item_name": itemName,
        "item_service_note": itemServiceNote,
        "part_name": partName,
        "vendor_id": vendorId,
        "category_id": categoryId,
        "bin_location": binLocation,
        "unit_price": unitPrice,
        "sub_total": subTotal,
        "tax_rate": taxRate,
        "pricing_matrix_id": pricingMatrixId,
        "quantity_in_hand": quantityInHand,
        "quantity_critical": quantityCritical,
        "markup": markup,
        "margin": margin,
        "is_tax": isTax,
        "is_display_part_number": isDisplayPartNumber,
        "is_display_price_quantity": isDisplayPriceQuantity,
        "is_display_note": isDisplayNote,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "category_info": categoryInfo,
        "created_user": createdUser == null ? {} : createdUser!.toJson(),
        "vendor_info": vendorInfo,
      };
}

class CreatedUser {
  int id;
  String firstName;
  String lastName;

  CreatedUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedUser.fromJson(Map<String, dynamic> json) => CreatedUser(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
      };
}
