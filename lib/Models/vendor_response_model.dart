// To parse this JSON data, do
//
//     final vendorResponseModel = vendorResponseModelFromJson(jsonString?);

import 'dart:convert';

VendorResponseModel vendorResponseModelFromJson(String str) =>
    VendorResponseModel.fromJson(json.decode(str));

String vendorResponseModelToJson(VendorResponseModel data) =>
    json.encode(data.toJson());

class VendorResponseModel {
  int? id;
  int? clientId;
  String? vendorName;
  dynamic website;
  String? email;
  dynamic accountNumber;
  String? contactPerson;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic townCity;
  int? provinceId;
  dynamic zipcode;
  dynamic phone;
  dynamic notes;
  CreatedBy? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic provinceName;

  VendorResponseModel({
    this.id,
    this.clientId,
    this.vendorName,
    this.website,
    this.email,
    this.accountNumber,
    this.contactPerson,
    this.addressLine1,
    this.addressLine2,
    this.townCity,
    this.provinceId,
    this.zipcode,
    this.phone,
    this.notes,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.provinceName,
  });

  factory VendorResponseModel.fromJson(Map<String, dynamic> json) =>
      VendorResponseModel(
        id: json["id"],
        clientId: json["client_id"],
        vendorName: json["vendor_name"],
        website: json["website"],
        email: json["email"],
        accountNumber: json["account_number"],
        contactPerson: json["contact_person"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        townCity: json["town_city"],
        provinceId: json["province_id"],
        zipcode: json["zipcode"],
        phone: json["phone"],
        notes: json["notes"],
        createdBy: json['created_by'] == null
            ? null
            : CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        provinceName: json["province_name"],
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "vendor_name": vendorName,
        "website": website,
        "email": email,
        "account_number": accountNumber,
        "contact_person": contactPerson,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "town_city": townCity,
        "province_id": provinceId,
        "zipcode": zipcode,
        "phone": phone,
        "notes": notes,
        "created_by": createdBy == null ? {} : createdBy!.toJson(),
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "province_name": provinceName,
      };
}

class CreatedBy {
  int? id;
  String? email;
  String? firstName;
  String? lastName;

  CreatedBy({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
      };
}
