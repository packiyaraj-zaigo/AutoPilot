class TimeCardCreateModel {
  int clientId;
  int technicianId;
  String task;
  String notes;
  DateTime clockInTime;
  DateTime clockOutTime;
  String totalTime;

  TimeCardCreateModel({
    required this.clientId,
    required this.technicianId,
    required this.task,
    required this.notes,
    required this.clockInTime,
    required this.clockOutTime,
    required this.totalTime,
  });

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "technician_id": technicianId,
        "activity_type": task,
        "notes": notes,
        "clock_in_time": clockInTime.toIso8601String(),
        "clock_out_time": clockOutTime.toIso8601String(),
        "total_time": totalTime,
      };

  factory TimeCardCreateModel.fromJson(Map<String, dynamic> json) =>
      TimeCardCreateModel(
        clientId: json["client_id"],
        technicianId: json["technician_id"],
        task: json["activity_type"],
        notes: json["notes"],
        clockInTime: DateTime.parse(json["clock_in_time"]),
        clockOutTime: DateTime.parse(json["clock_out_time"]),
        totalTime: json["total_time"],
      );
}
