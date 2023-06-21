// To parse this JSON data, do
//
//     final dropDown = dropDownFromJson(jsonString);

import 'dart:convert';

DropDown dropDownFromJson(String str) => DropDown.fromJson(json.decode(str));

String dropDownToJson(DropDown data) => json.encode(data.toJson());

class DropDown {
  Data data;
  int count;
  String message;

  DropDown({
    required this.data,
    required this.count,
    required this.message,
  });

  factory DropDown.fromJson(Map<String, dynamic> json) => DropDown(
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
  List<DropdownDatum> data;
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
        data: List<DropdownDatum>.from(
            json["data"].map((x) => DropdownDatum.fromJson(x))),
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

class DropdownDatum {
  int id;
  String vehicleTypeName;
  String vehicleTypeImage;
  DateTime createdAt;
  DateTime updatedAt;

  DropdownDatum({
    required this.id,
    required this.vehicleTypeName,
    required this.vehicleTypeImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DropdownDatum.fromJson(Map<String, dynamic> json) => DropdownDatum(
        id: json["id"],
        vehicleTypeName: json["vehicle_type_name"],
        vehicleTypeImage: json["vehicle_type_image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_type_name": vehicleTypeName,
        "vehicle_type_image": vehicleTypeImage,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
