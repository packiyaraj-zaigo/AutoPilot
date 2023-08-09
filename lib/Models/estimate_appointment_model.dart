// To parse this JSON data, do
//
//     final appointmentDetailsModel = appointmentDetailsModelFromJson(jsonString);

import 'dart:convert';

AppointmentDetailsModel appointmentDetailsModelFromJson(String str) =>
    AppointmentDetailsModel.fromJson(json.decode(str));

String appointmentDetailsModelToJson(AppointmentDetailsModel data) =>
    json.encode(data.toJson());

class AppointmentDetailsModel {
  Data data;
  int count;
  String message;

  AppointmentDetailsModel({
    required this.data,
    required this.count,
    required this.message,
  });

  factory AppointmentDetailsModel.fromJson(Map<String, dynamic> json) =>
      AppointmentDetailsModel(
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

  String path;
  String perPage;

  Data({
    required this.currentPage,
    required this.data,
    required this.path,
    required this.perPage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
      };
}

class Datum {
  int id;
  String appointmentTitle;
  int customerId;
  int vehicleId;
  String notes;
  DateTime startOn;
  DateTime endOn;
  String isReurring;
  dynamic appointmentRepeateRules;
  String notificationEmailStatus;
  String notificationSmsStatus;
  String sendConfirmationStatus;
  String sendReminderStatus;
  dynamic confirmationEmailSubject;
  dynamic confirmationEmailBody;
  dynamic reminderEmailSubject;
  dynamic reminderEmailBody;
  CreatedBy createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> appointmentRepeats;
  CreatedBy? customer;
  Vehicle? vehicle;

  Datum({
    required this.id,
    required this.appointmentTitle,
    required this.customerId,
    required this.vehicleId,
    required this.notes,
    required this.startOn,
    required this.endOn,
    required this.isReurring,
    this.appointmentRepeateRules,
    required this.notificationEmailStatus,
    required this.notificationSmsStatus,
    required this.sendConfirmationStatus,
    required this.sendReminderStatus,
    this.confirmationEmailSubject,
    this.confirmationEmailBody,
    this.reminderEmailSubject,
    this.reminderEmailBody,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.appointmentRepeats,
    required this.customer,
    this.vehicle,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        appointmentTitle: json["appointment_title"],
        customerId: json["customer_id"],
        vehicleId: json["vehicle_id"],
        notes: json["notes"],
        startOn: DateTime.parse(json["start_on"]),
        endOn: DateTime.parse(json["end_on"]),
        isReurring: json["is_reurring"],
        appointmentRepeateRules: json["appointment_repeate_rules"],
        notificationEmailStatus: json["notification_email_status"],
        notificationSmsStatus: json["notification_sms_status"],
        sendConfirmationStatus: json["send_confirmation_status"],
        sendReminderStatus: json["send_reminder_status"],
        confirmationEmailSubject: json["confirmation_email_subject"],
        confirmationEmailBody: json["confirmation_email_body"],
        reminderEmailSubject: json["reminder_email_subject"],
        reminderEmailBody: json["reminder_email_body"],
        createdBy: CreatedBy.fromJson(json["created_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        appointmentRepeats:
            List<dynamic>.from(json["appointment_repeats"].map((x) => x)),
        customer: json["customer"] == null
            ? null
            : CreatedBy.fromJson(json["customer"]),
        vehicle:
            json["vehicle"] != null ? Vehicle.fromJson(json["vehicle"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appointment_title": appointmentTitle,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "notes": notes,
        "start_on": startOn.toIso8601String(),
        "end_on": endOn.toIso8601String(),
        "is_reurring": isReurring,
        "appointment_repeate_rules": appointmentRepeateRules,
        "notification_email_status": notificationEmailStatus,
        "notification_sms_status": notificationSmsStatus,
        "send_confirmation_status": sendConfirmationStatus,
        "send_reminder_status": sendReminderStatus,
        "confirmation_email_subject": confirmationEmailSubject,
        "confirmation_email_body": confirmationEmailBody,
        "reminder_email_subject": reminderEmailSubject,
        "reminder_email_body": reminderEmailBody,
        "created_by": createdBy.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "appointment_repeats":
            List<dynamic>.from(appointmentRepeats.map((x) => x)),
        "customer": customer?.toJson(),
        "vehicle": vehicle!.toJson(),
      };
}

class CreatedBy {
  int id;
  String email;
  String firstName;
  String lastName;

  CreatedBy({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
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

class Vehicle {
  int id;
  String vehicleType;
  String vehicleYear;
  String vehicleMake;
  String vehicleModel;

  Vehicle({
    required this.id,
    required this.vehicleType,
    required this.vehicleYear,
    required this.vehicleMake,
    required this.vehicleModel,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        vehicleType: json["vehicle_type"],
        vehicleYear: json["vehicle_year"],
        vehicleMake: json["vehicle_make"],
        vehicleModel: json["vehicle_model"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vehicle_type": vehicleType,
        "vehicle_year": vehicleYear,
        "vehicle_make": vehicleMake,
        "vehicle_model": vehicleModel,
      };
}
