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
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int perPage;
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
  String customerFirstName;
  String customerLastName;
  String vehicleName;
  int orderNumber;
  dynamic orderName;
  dynamic paymentDate;
  String note;
  String paymentType;
  String totalOrderAmount;
  String remainingAmount;
  String paymentAmount;

  Datum({
    required this.customerFirstName,
    required this.customerLastName,
    required this.vehicleName,
    required this.orderNumber,
    required this.orderName,
    required this.paymentDate,
    required this.note,
    required this.paymentType,
    required this.totalOrderAmount,
    required this.remainingAmount,
    required this.paymentAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        customerFirstName: json["customer_first_name"],
        customerLastName: json["customer_last_name"],
        vehicleName: json["vehicle_name"],
        orderNumber: json["order_number"],
        orderName: json["order_name"],
        paymentDate: json["payment_date"],
        note: json["note"],
        paymentType: json["payment_type"],
        totalOrderAmount: json["total_order_amount"],
        remainingAmount: json["remaining_amount"],
        paymentAmount: json["payment_amount"],
      );

  Map<String, dynamic> toJson() => {
        "customer_first_name":
            customerFirstNameValues.reverse[customerFirstName],
        "customer_last_name": customerLastNameValues.reverse[customerLastName],
        "vehicle_name": vehicleName,
        "order_number": orderNumber,
        "order_name": orderName,
        "payment_date": paymentDate,
        "note": noteValues.reverse[note],
        "payment_type": paymentTypeValues.reverse[paymentType],
        "total_order_amount": amountValues.reverse[totalOrderAmount],
        "remaining_amount": remainingAmountValues.reverse[remainingAmount],
        "payment_amount": amountValues.reverse[paymentAmount],
      };
}

enum CustomerFirstName { CUSTOMER, CUSTOMER_NAME_ONE, FAZIL }

final customerFirstNameValues = EnumValues({
  "customer": CustomerFirstName.CUSTOMER,
  "Customer name one": CustomerFirstName.CUSTOMER_NAME_ONE,
  "Fazil": CustomerFirstName.FAZIL
});

enum CustomerLastName { JJH, ONE, SREE }

final customerLastNameValues = EnumValues({
  "Jjh": CustomerLastName.JJH,
  "one": CustomerLastName.ONE,
  "Sree": CustomerLastName.SREE
});

enum Note { EMPTY, TESTING_PAYMENT }

final noteValues =
    EnumValues({"-": Note.EMPTY, "testing payment ": Note.TESTING_PAYMENT});

enum Amount { THE_000, THE_52000 }

final amountValues = EnumValues(
    {"\u00240.00": Amount.THE_000, "\u0024520.00": Amount.THE_52000});

enum PaymentType { CASH, EMPTY }

final paymentTypeValues =
    EnumValues({"Cash": PaymentType.CASH, "-": PaymentType.EMPTY});

enum RemainingAmount { THE_0, THE_520 }

final remainingAmountValues = EnumValues(
    {"\u00240": RemainingAmount.THE_0, "\u0024520": RemainingAmount.THE_520});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
