// To parse this JSON data, do
//
//     final allInvoiceReportModel = allInvoiceReportModelFromJson(jsonString);

import 'dart:convert';

AllInvoiceReportModel allInvoiceReportModelFromJson(String str) =>
    AllInvoiceReportModel.fromJson(json.decode(str));

String allInvoiceReportModelToJson(AllInvoiceReportModel data) =>
    json.encode(data.toJson());

class AllInvoiceReportModel {
  Data data;
  String message;

  AllInvoiceReportModel({
    required this.data,
    required this.message,
  });

  factory AllInvoiceReportModel.fromJson(Map<String, dynamic> json) =>
      AllInvoiceReportModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
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
  String nextPageUrl;
  String path;
  int perPage;
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
  int orderId;
  int orderNumber;
  String? orderName;
  String customerFirstName;
  String customerLastName;
  String vehicleName;
  String? paymentDate;
  String note;
  String paymentType;
  String cardType;
  String totalOrderAmount;
  String remainingAmount;
  String paymentAmount;

  Datum({
    required this.orderId,
    required this.orderNumber,
    required this.orderName,
    required this.customerFirstName,
    required this.customerLastName,
    required this.vehicleName,
    required this.paymentDate,
    required this.note,
    required this.paymentType,
    required this.cardType,
    required this.totalOrderAmount,
    required this.remainingAmount,
    required this.paymentAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderId: json["order_id"],
        orderNumber: json["order_number"],
        orderName: json["order_name"],
        customerFirstName: json["customer_first_name"],
        customerLastName: json["customer_last_name"],
        vehicleName: json["vehicle_name"],
        paymentDate: json["payment_date"],
        note: json['note'],
        paymentType: json["payment_type"],
        cardType: json["card_type"],
        totalOrderAmount: json["total_order_amount"],
        remainingAmount: json["remaining_amount"],
        paymentAmount: json["payment_amount"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "order_number": orderNumber,
        "order_name": orderName,
        "customer_first_name": customerFirstName,
        "customer_last_name": customerLastName,
        "vehicle_name": vehicleName,
        "payment_date": paymentDate,
        "note": noteValues.reverse[note],
        "payment_type": paymentTypeValues.reverse[paymentType],
        "card_type": cardType,
        "total_order_amount": totalOrderAmountValues.reverse[totalOrderAmount],
        "remaining_amount": remainingAmountValues.reverse[remainingAmount],
        "payment_amount": paymentAmountValues.reverse[paymentAmount],
      };
}

enum Note { EMPTY, TEST }

final noteValues = EnumValues({"": Note.EMPTY, "test": Note.TEST});

enum PaymentAmount { THE_000, THE_1889700 }

final paymentAmountValues = EnumValues({
  "\u00240.00": PaymentAmount.THE_000,
  "\u002418897.00": PaymentAmount.THE_1889700
});

enum PaymentType { EMPTY, ONLINE }

final paymentTypeValues =
    EnumValues({"": PaymentType.EMPTY, "Online": PaymentType.ONLINE});

enum RemainingAmount { THE_0, THE_119375 }

final remainingAmountValues = EnumValues({
  "\u00240": RemainingAmount.THE_0,
  "\u002411937.5": RemainingAmount.THE_119375
});

enum TotalOrderAmount { THE_000, THE_695950 }

final totalOrderAmountValues = EnumValues({
  "\u00240.00": TotalOrderAmount.THE_000,
  "\u00246959.50": TotalOrderAmount.THE_695950
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
