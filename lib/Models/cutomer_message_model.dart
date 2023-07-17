// To parse this JSON data, do
//
//     final customerMessageModel = customerMessageModelFromJson(jsonString);

import 'dart:convert';

CustomerMessageModel customerMessageModelFromJson(String str) =>
    CustomerMessageModel.fromJson(json.decode(str));

//String customerMessageModelToJson(CustomerMessageModel data) => json.encode(data.toJson());

class CustomerMessageModel {
  Data data;
  int count;
  String message;

  CustomerMessageModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory CustomerMessageModel.fromJson(Map<String, dynamic> json) =>
      CustomerMessageModel(
        data: Data.fromJson(json["data"]),
        count: json["count"],
        message: json["message"],
      );

  // Map<String, dynamic> toJson() => {
  //     "data": data.toJson(),
  //     "count": count,
  //     "message": message,
  // };
}

class Data {
  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  int? from;
  int? lastPage;
  String lastPageUrl;
  dynamic nextPageUrl;
  String path;
  String perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    this.from,
    this.lastPage,
    required this.lastPageUrl,
    this.nextPageUrl,
    required this.path,
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

  // Map<String, dynamic> toJson() => {
  //     "current_page": currentPage,
  //     "data": List<dynamic>.from(data.map((x) => x.toJson())),
  //     "first_page_url": firstPageUrl,
  //     "from": from,
  //     "last_page": lastPage,
  //     "last_page_url": lastPageUrl,
  //     "next_page_url": nextPageUrl,
  //     "path": path,
  //     "per_page": perPage,
  //     "prev_page_url": prevPageUrl,
  //     "to": to,
  //     "total": total,
  // };
}

class Datum {
  int id;
  int clientId;
  ErId? senderUserId;
  ErId? receiverCustomerId;
  String messageType;
  String messageBody;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic sendCustomer;

  Datum({
    required this.id,
    required this.clientId,
    this.senderUserId,
    this.receiverCustomerId,
    required this.messageType,
    required this.messageBody,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.sendCustomer,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientId: json["client_id"],
        senderUserId: json["sender_user_id"] != null
            ? ErId.fromJson(json["sender_user_id"])
            : null,
        receiverCustomerId: json["receiver_customer_id"] != null
            ? ErId.fromJson(json["receiver_customer_id"])
            : null,
        messageType: json["message_type"],
        messageBody: json["message_body"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sendCustomer: json["send_customer"],
      );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "client_id": clientId,
  //     "sender_user_id": senderUserId.toJson(),
  //     "receiver_customer_id": receiverCustomerId.toJson(),
  //     "message_type": messageType,
  //     "message_body": messageBody,
  //     "status": status,
  //     "created_at": createdAt.toIso8601String(),
  //     "updated_at": updatedAt.toIso8601String(),
  //     "send_customer": sendCustomer,
  // };
}

class ErId {
  int id;
  String email;
  String firstName;
  String lastName;

  ErId({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory ErId.fromJson(Map<String, dynamic> json) => ErId(
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
