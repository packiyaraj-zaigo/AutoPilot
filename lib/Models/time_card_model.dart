class TimeCardModel {
  int? technicianId;
  String? dayTotal;
  String? weekTotal;
  String? monthTatal;
  String? employeeName;
  int? employeeId;
  String? position;

  TimeCardModel({
    required this.technicianId,
    required this.dayTotal,
    required this.weekTotal,
    required this.monthTatal,
    required this.employeeName,
    required this.employeeId,
    required this.position,
  });

  factory TimeCardModel.fromJson(Map<String, dynamic> json) => TimeCardModel(
        technicianId: json["technician_id"],
        dayTotal: json["day_total"],
        weekTotal: json["week_total"],
        monthTatal: json["month_tatal"],
        employeeName: json["employee_name"],
        employeeId: json["employee_id"],
        position: json["position"],
      );
}
