// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

ClientModel clientModelFromJson(String str) =>
    ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  int? id;
  String? email;
  String? companyName;
  String? companyLogo;
  String? phone;
  String? website;
  String? units;
  String? address1;
  String? address2;
  String? townCity;
  int? provinceId;
  String? zipcode;
  String? employeeCount;
  String? serviceType;
  String? timeZone;
  String? salesTaxRate;
  String? materialTaxRate;
  String? laborTaxRate;
  String? baseLaborCost;
  String? taxOnParts;
  String? taxOnMaterial;
  String? taxOnLabors;
  dynamic notes;
  int? active;
  int? detConfirm;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProvinceName? provinceName;

  ClientModel({
    this.id,
    this.email,
    this.companyName,
    this.companyLogo,
    this.phone,
    this.website,
    this.units,
    this.address1,
    this.address2,
    this.townCity,
    this.provinceId,
    this.zipcode,
    this.employeeCount,
    this.serviceType,
    this.timeZone,
    this.salesTaxRate,
    this.materialTaxRate,
    this.laborTaxRate,
    this.baseLaborCost,
    this.taxOnParts,
    this.taxOnMaterial,
    this.taxOnLabors,
    this.notes,
    this.active,
    this.detConfirm,
    this.createdAt,
    this.updatedAt,
    this.provinceName,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json["id"],
        email: json["email"],
        companyName: json["company_name"],
        companyLogo: json["company_logo"],
        phone: json["phone"],
        website: json["website"],
        units: json["units"],
        address1: json["address_1"],
        address2: json["address_2"],
        townCity: json["town_city"],
        provinceId: json["province_id"],
        zipcode: json["zipcode"],
        employeeCount: json["employee_count"],
        serviceType: json["service_type"],
        timeZone: json["time_zone"],
        salesTaxRate: json["sales_tax_rate"],
        materialTaxRate: json["material_tax_rate"],
        laborTaxRate: json["labor_tax_rate"],
        baseLaborCost: json["base_labor_cost"],
        taxOnParts: json["tax_on_parts"],
        taxOnMaterial: json["tax_on_material"],
        taxOnLabors: json["tax_on_labors"],
        notes: json["notes"],
        active: json["active"],
        detConfirm: json["det_confirm"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        provinceName: json["province_name"] == null
            ? null
            : ProvinceName.fromJson(json["province_name"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "company_name": companyName,
        "company_logo": companyLogo,
        "phone": phone,
        "website": website,
        "units": units,
        "address_1": address1,
        "address_2": address2,
        "town_city": townCity,
        "province_id": provinceId,
        "zipcode": zipcode,
        "employee_count": employeeCount,
        "service_type": serviceType,
        "time_zone": timeZone,
        "sales_tax_rate": salesTaxRate,
        "material_tax_rate": materialTaxRate,
        "labor_tax_rate": laborTaxRate,
        "base_labor_cost": baseLaborCost,
        "tax_on_parts": taxOnParts,
        "tax_on_material": taxOnMaterial,
        "tax_on_labors": taxOnLabors,
        "notes": notes,
        "active": active,
        "det_confirm": detConfirm,
        "created_at": createdAt.toString(),
        "updated_at": updatedAt.toString(),
        "province_name": provinceName == null ? {} : provinceName?.toJson(),
      };
}

class ProvinceName {
  int? id;
  String? provinceName;
  String? provinceCode;

  ProvinceName({
    this.id,
    this.provinceName,
    this.provinceCode,
  });

  factory ProvinceName.fromJson(Map<String, dynamic> json) => ProvinceName(
        id: json["id"],
        provinceName: json["province_name"],
        provinceCode: json["province_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_name": provinceName,
        "province_code": provinceCode,
      };
}
