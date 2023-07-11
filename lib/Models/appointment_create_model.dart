import 'dart:convert';

AppointmentCreateModel appointmentCreateModelFromJson(String str) =>
    AppointmentCreateModel.fromJson(json.decode(str));

String appointmentCreateModelToJson(AppointmentCreateModel data) =>
    json.encode(data.toJson());

class AppointmentCreateModel {
  String appointmentTitle;
  int customerId;
  int vehicleId;
  String notes;
  DateTime startOn;
  DateTime endOn;
  int createdBy;

  AppointmentCreateModel({
    required this.appointmentTitle,
    required this.customerId,
    required this.vehicleId,
    required this.notes,
    required this.startOn,
    required this.endOn,
    required this.createdBy,
  });

  factory AppointmentCreateModel.fromJson(Map<String, dynamic> json) =>
      AppointmentCreateModel(
        appointmentTitle: json["appointment_title"],
        customerId: json["customer_id"],
        vehicleId: json["vehicle_id"],
        notes: json["notes"],
        startOn: DateTime.parse(json["start_on"]),
        endOn: DateTime.parse(json["end_on"]),
        createdBy: json["created_by"],
      );

  Map<String, dynamic> toJson() => {
        "appointment_title": appointmentTitle,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "notes": notes,
        "start_on": startOn.toIso8601String(),
        "end_on": endOn.toIso8601String(),
        "created_by": createdBy,
      };
}
