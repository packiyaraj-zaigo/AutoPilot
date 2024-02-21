// To parse this JSON data, do
//
//     final timeLogReportModel = timeLogReportModelFromJson(jsonString);

import 'dart:convert';

TimeLogReportModel timeLogReportModelFromJson(String str) =>
    TimeLogReportModel.fromJson(json.decode(str));

String timeLogReportModelToJson(TimeLogReportModel data) =>
    json.encode(data.toJson());

class TimeLogReportModel {
  Data data;
  String hoursTracked;
  String averageHours;
  String message;

  TimeLogReportModel({
    required this.data,
    required this.hoursTracked,
    required this.averageHours,
    required this.message,
  });

  factory TimeLogReportModel.fromJson(Map<String, dynamic> json) =>
      TimeLogReportModel(
        data: Data.fromJson(json["data"]),
        hoursTracked: json["hours_tracked"],
        averageHours: json["average_hours"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "hours_tracked": hoursTracked,
        "average_hours": averageHours,
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
  String entry;
  String type;
  int techicianId;
  Techician techician;
  FirstName firstName;
  LastName lastName;
  VehicleName vehicleName;
  String fndEndDate;
  Activity activityType;
  Activity activityName;
  String note;
  String techRate;
  String duration;
  String total;
  DateTime createdAt;

  Datum({
    required this.entry,
    required this.type,
    required this.techicianId,
    required this.techician,
    required this.firstName,
    required this.lastName,
    required this.vehicleName,
    required this.fndEndDate,
    required this.activityType,
    required this.activityName,
    required this.note,
    required this.techRate,
    required this.duration,
    required this.total,
    required this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        entry: json["entry"],
        type: json["type"],
        techicianId: json["techician_id"],
        techician: techicianValues.map[json["techician"]]!,
        firstName: firstNameValues.map[json["first_name"]]!,
        lastName: lastNameValues.map[json["last_name"]]!,
        vehicleName: vehicleNameValues.map[json["vehicle_name"]]!,
        fndEndDate: json["fnd_end_date"],
        activityType: activityValues.map[json["activity_type"]]!,
        activityName: activityValues.map[json["activity_name"]]!,
        note: json["note"],
        techRate: json["tech_rate"],
        duration: json["duration"],
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "entry": entry,
        "type": type,
        "techician_id": techicianId,
        "techician": techicianValues.reverse[techician],
        "first_name": firstNameValues.reverse[firstName],
        "last_name": lastNameValues.reverse[lastName],
        "vehicle_name": vehicleNameValues.reverse[vehicleName],
        "fnd_end_date": fndEndDate,
        "activity_type": activityValues.reverse[activityType],
        "activity_name": activityValues.reverse[activityName],
        "note": note,
        "tech_rate": techRate,
        "duration": duration,
        "total": total,
        "created_at": createdAt.toIso8601String(),
      };
}

enum Activity { ORDER }

final activityValues = EnumValues({"Order": Activity.ORDER});

enum FirstName { ADAM, EMPTY, SANTU }

final firstNameValues = EnumValues(
    {"Adam": FirstName.ADAM, "": FirstName.EMPTY, "Santu": FirstName.SANTU});

enum LastName { EMPTY, JONES, SAHA_123 }

final lastNameValues = EnumValues({
  "": LastName.EMPTY,
  "Jones": LastName.JONES,
  "Saha 123": LastName.SAHA_123
});

enum Techician { SANTU_SAHA_SS }

final techicianValues = EnumValues({"Santu Saha ss": Techician.SANTU_SAHA_SS});

enum VehicleName { FFFF, HONDA, HUNDAI }

final vehicleNameValues = EnumValues({
  "Ffff": VehicleName.FFFF,
  "Honda": VehicleName.HONDA,
  "Hundai": VehicleName.HUNDAI
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
