import 'package:meta/meta.dart';
import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

Datum datumFromJson(String str) => Datum.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  Data data;
  int count;
  String message;

  CustomerModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
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
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
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
  String email;
  String firstName;
  String lastName;
  dynamic notes;
  dynamic companyName;
  dynamic referralSource;
  dynamic fleet;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic townCity;
  int provinceId;
  dynamic zipcode;
  String phone;
  dynamic labels;
  int isTax;
  String tax;
  int isDiscount;
  String discountPercentge;
  String discountType;
  int isLaborMatrix;
  int laborMatrixId;
  int pricingMatrixId;
  int isLaborRate;
  String laborRate;
  int periodicalMaintenanceNotifications;
  CreatedBy? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic provinceName;
  dynamic pricingMatrix;
  dynamic laborMatrix;

  Datum({
    required this.id,
    required this.clientId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.notes,
    required this.companyName,
    required this.referralSource,
    required this.fleet,
    required this.addressLine1,
    required this.addressLine2,
    required this.townCity,
    required this.provinceId,
    required this.zipcode,
    required this.phone,
    required this.labels,
    required this.isTax,
    required this.tax,
    required this.isDiscount,
    required this.discountPercentge,
    required this.discountType,
    required this.isLaborMatrix,
    required this.laborMatrixId,
    required this.pricingMatrixId,
    required this.isLaborRate,
    required this.laborRate,
    required this.periodicalMaintenanceNotifications,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    required this.provinceName,
    required this.pricingMatrix,
    required this.laborMatrix,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientId: json["client_id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        notes: json["notes"],
        companyName: json["company_name"],
        referralSource: json["referral_source"],
        fleet: json["fleet"],
        addressLine1: json["address_line_1"],
        addressLine2: json["address_line_2"],
        townCity: json["town_city"],
        provinceId: json["province_id"],
        zipcode: json["zipcode"],
        phone: json["phone"],
        labels: json["labels"],
        isTax: json["is_tax"],
        tax: json["tax"],
        isDiscount: json["is_discount"],
        discountPercentge: json["discount_percentge"],
        discountType: json["discount_type"],
        isLaborMatrix: json["is_labor_matrix"],
        laborMatrixId: json["labor_matrix_id"],
        pricingMatrixId: json["pricing_matrix_id"],
        isLaborRate: json["is_labor_rate"],
        laborRate: json["labor_rate"],
        periodicalMaintenanceNotifications:
            json["periodical_maintenance_notifications"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        provinceName: json["province_name"],
        pricingMatrix: json["pricing_matrix"],
        laborMatrix: json["labor_matrix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "notes": notes,
        "company_name": companyName,
        "referral_source": referralSource,
        "fleet": fleet,
        "address_line_1": addressLine1,
        "address_line_2": addressLine2,
        "town_city": townCity,
        "province_id": provinceId,
        "zipcode": zipcode,
        "phone": phone,
        "labels": labels,
        "is_tax": isTax,
        "tax": tax,
        "is_discount": isDiscount,
        "discount_percentge": discountPercentge,
        "discount_type": discountType,
        "is_labor_matrix": isLaborMatrix,
        "labor_matrix_id": laborMatrixId,
        "pricing_matrix_id": pricingMatrixId,
        "is_labor_rate": isLaborRate,
        "labor_rate": laborRate,
        "periodical_maintenance_notifications":
            periodicalMaintenanceNotifications,
        "created_by": createdBy?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "province_name": provinceName,
        "pricing_matrix": pricingMatrix,
        "labor_matrix": laborMatrix,
      };
}

class CreatedBy {
  int id;
  String firstName;
  String lastName;

  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
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
