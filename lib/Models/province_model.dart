// To parse this JSON data, do
//
//     final provinceModel = provinceModelFromJson(jsonString);

import 'dart:convert';

ProvinceModel provinceModelFromJson(String str) => ProvinceModel.fromJson(json.decode(str));

String provinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
    Data data;
    int count;
    String message;

    ProvinceModel({
        required this.data,
        required this.count,
        required this.message,
    });

    factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
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
    List<ProvinceData> data;
    String? firstPageUrl;
    int? from;
    int? lastPage;
    String? lastPageUrl;
    String? nextPageUrl;
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
        required this.nextPageUrl,
        required this.path,
        required this.perPage,
        this.prevPageUrl,
        required this.to,
        required this.total,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<ProvinceData>.from(json["data"].map((x) => ProvinceData.fromJson(x))),
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

class ProvinceData {
    int id;
    String provinceName;
    String provinceCode;
    Status status;
    DateTime createdAt;
    DateTime updatedAt;

    ProvinceData({
        required this.id,
        required this.provinceName,
        required this.provinceCode,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ProvinceData.fromJson(Map<String, dynamic> json) => ProvinceData(
        id: json["id"],
        provinceName: json["province_name"],
        provinceCode: json["province_code"],
        status: statusValues.map[json["status"]]!,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "province_name": provinceName,
        "province_code": provinceCode,
        "status": statusValues.reverse[status],
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

enum Status { ACTIVE }

final statusValues = EnumValues({
    "Active": Status.ACTIVE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
