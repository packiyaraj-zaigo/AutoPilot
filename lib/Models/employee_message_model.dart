// To parse this JSON data, do
//
//     final employeeMessageModel = employeeMessageModelFromJson(jsonString);

import 'dart:convert';

EmployeeMessageModel employeeMessageModelFromJson(String str) =>
    EmployeeMessageModel.fromJson(json.decode(str));

String employeeMessageModelToJson(EmployeeMessageModel data) =>
    json.encode(data.toJson());

class EmployeeMessageModel {
  Data data;
  int count;
  String message;

  EmployeeMessageModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory EmployeeMessageModel.fromJson(Map<String, dynamic> json) =>
      EmployeeMessageModel(
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
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  String perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    required this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
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
  int? id;
  int? clientId;
  String title;
  String message;
  int? isRead;
  int? senderUserId;
  int? receivedUserId;
  DateTime createdAt;
  DateTime updatedAt;
  ErUser senderUser;
  ErUser receiverUser;

  Datum({
    this.id,
    this.clientId,
    required this.title,
    required this.message,
    this.isRead,
    this.senderUserId,
    this.receivedUserId,
    required this.createdAt,
    required this.updatedAt,
    required this.senderUser,
    required this.receiverUser,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientId: json["client_id"],
        title: json["title"],
        message: json["message"],
        isRead: json["is_read"],
        senderUserId: json["sender_user_id"],
        receivedUserId: json["received_user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        senderUser: ErUser.fromJson(json["sender_user"]),
        receiverUser: ErUser.fromJson(json["receiver_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "title": title,
        "message": message,
        "is_read": isRead,
        "sender_user_id": senderUserId,
        "received_user_id": receivedUserId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sender_user": senderUser.toJson(),
        "receiver_user": receiverUser.toJson(),
      };
}

class ErUser {
  int? id;
  String email;
  String firstName;
  String lastName;

  ErUser({
    this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory ErUser.fromJson(Map<String, dynamic> json) => ErUser(
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
