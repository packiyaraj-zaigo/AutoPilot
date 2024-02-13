// To parse this JSON data, do
//
//     final allInvoiceReportModel = allInvoiceReportModelFromJson(jsonString);

import 'dart:convert';

List<AllInvoiceReportModel> allInvoiceReportModelFromJson(String str) => List<AllInvoiceReportModel>.from(json.decode(str).map((x) => AllInvoiceReportModel.fromJson(x)));

String allInvoiceReportModelToJson(List<AllInvoiceReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllInvoiceReportModel {
    String firstName;
    String lastName;
    String vehicle;
    String order;
    String orderName;
    DateTime paymentDate;
    String note;
    String paymentType;
    String cardType;
    int totalOrderAmount;
    int remainingAmount;
    int paymentAmount;

    AllInvoiceReportModel({
        required this.firstName,
        required this.lastName,
        required this.vehicle,
        required this.order,
        required this.orderName,
        required this.paymentDate,
        required this.note,
        required this.paymentType,
        required this.cardType,
        required this.totalOrderAmount,
        required this.remainingAmount,
        required this.paymentAmount,
    });

    factory AllInvoiceReportModel.fromJson(Map<String, dynamic> json) => AllInvoiceReportModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        vehicle: json["vehicle"],
        order: json["order"],
        orderName: json["order_name"],
        paymentDate: DateTime.parse(json["payment_date"]),
        note: json["note"],
        paymentType: json["payment_type"],
        cardType: json["card_type"],
        totalOrderAmount: json["total_order_amount"],
        remainingAmount: json["remaining_amount"],
        paymentAmount: json["payment_amount"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "vehicle": vehicle,
        "order": order,
        "order_name": orderName,
        "payment_date": "${paymentDate.year.toString().padLeft(4, '0')}-${paymentDate.month.toString().padLeft(2, '0')}-${paymentDate.day.toString().padLeft(2, '0')}",
        "note": note,
        "payment_type": paymentType,
        "card_type": cardType,
        "total_order_amount": totalOrderAmount,
        "remaining_amount": remainingAmount,
        "payment_amount": paymentAmount,
    };
}

