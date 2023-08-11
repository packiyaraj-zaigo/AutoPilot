// To parse this JSON data, do
//
//     final paymentHistoryModel = paymentHistoryModelFromJson(jsonString);

import 'dart:convert';

PaymentHistoryModel paymentHistoryModelFromJson(String str) =>
    PaymentHistoryModel.fromJson(json.decode(str));

String paymentHistoryModelToJson(PaymentHistoryModel data) =>
    json.encode(data.toJson());

class PaymentHistoryModel {
  Data data;
  int count;
  String message;

  PaymentHistoryModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaymentHistoryModel(
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
  int? from;
  int? lastPage;
  String? lastPageUrl;
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
    this.lastPageUrl,
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
  int orderId;
  int clientId;
  int customerId;
  String paymentMode;
  DateTime paymentDate;
  String note;
  dynamic transactionId;
  String paidAmount;
  int paymentConfirmationBy;
  DateTime createdAt;
  DateTime updatedAt;
  GetClientInfo getClientInfo;
  Get getCustomerInfo;
  Get getUserConfirmedBy;

  Datum({
    required this.id,
    required this.orderId,
    required this.clientId,
    required this.customerId,
    required this.paymentMode,
    required this.paymentDate,
    required this.note,
    this.transactionId,
    required this.paidAmount,
    required this.paymentConfirmationBy,
    required this.createdAt,
    required this.updatedAt,
    required this.getClientInfo,
    required this.getCustomerInfo,
    required this.getUserConfirmedBy,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderId: json["order_id"],
        clientId: json["client_id"],
        customerId: json["customer_id"],
        paymentMode: json["payment_mode"],
        paymentDate: DateTime.parse(json["payment_date"]),
        note: json["note"],
        transactionId: json["transaction_id"],
        paidAmount: json["paid_amount"],
        paymentConfirmationBy: json["payment_confirmation_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        getClientInfo: GetClientInfo.fromJson(json["get_client_info"]),
        getCustomerInfo: Get.fromJson(json["get_customer_info"]),
        getUserConfirmedBy: Get.fromJson(json["get_user_confirmed_by"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "client_id": clientId,
        "customer_id": customerId,
        "payment_mode": paymentMode,
        "payment_date":
            "${paymentDate.year.toString().padLeft(4, '0')}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}",
        "note": note,
        "transaction_id": transactionId,
        "paid_amount": paidAmount,
        "payment_confirmation_by": paymentConfirmationBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "get_client_info": getClientInfo.toJson(),
        "get_customer_info": getCustomerInfo.toJson(),
        "get_user_confirmed_by": getUserConfirmedBy.toJson(),
      };
}

class GetClientInfo {
  int id;
  String email;
  String companyName;

  GetClientInfo({
    required this.id,
    required this.email,
    required this.companyName,
  });

  factory GetClientInfo.fromJson(Map<String, dynamic> json) => GetClientInfo(
        id: json["id"],
        email: json["email"],
        companyName: json["company_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "company_name": companyName,
      };
}

class Get {
  int id;
  String email;
  String firstName;
  String lastName;

  Get({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory Get.fromJson(Map<String, dynamic> json) => Get(
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
