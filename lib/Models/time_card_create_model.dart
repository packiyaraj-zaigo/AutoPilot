class TimeCardCreateModel {
  int clientId;
  int technicianId;
  String activityTitle;
  String notes;
  DateTime clockInTime;
  DateTime clockOutTime;
  String totalTime;

  TimeCardCreateModel({
    required this.clientId,
    required this.technicianId,
    required this.activityTitle,
    required this.notes,
    required this.clockInTime,
    required this.clockOutTime,
    required this.totalTime,
  });

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "technician_id": technicianId,
        "activity_title": activityTitle,
        "notes": notes,
        "clock_in_time": clockInTime.toIso8601String(),
        "clock_out_time": clockOutTime.toIso8601String(),
        "total_time": totalTime,
      };
}
