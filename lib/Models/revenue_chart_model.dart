// To parse this JSON data, do
//
//     final revenueChartModel = revenueChartModelFromJson(jsonString);

import 'dart:convert';

RevenueChartModel revenueChartModelFromJson(String str) => RevenueChartModel.fromJson(json.decode(str));

String revenueChartModelToJson(RevenueChartModel data) => json.encode(data.toJson());

class RevenueChartModel {
    String sales;
    int dropoffs;
    int pickups;
    int currentVehicles;
    int staff;
    Graphdata graphdata;

    RevenueChartModel({
        required this.sales,
        required this.dropoffs,
        required this.pickups,
        required this.currentVehicles,
        required this.staff,
        required this.graphdata,
    });

    factory RevenueChartModel.fromJson(Map<String, dynamic> json) => RevenueChartModel(
        sales: json["sales"],
        dropoffs: json["dropoffs"],
        pickups: json["pickups"],
        currentVehicles: json["current_vehicles"],
        staff: json["staff"],
        graphdata: Graphdata.fromJson(json["graphdata"]),
    );

    Map<String, dynamic> toJson() => {
        "sales": sales,
        "dropoffs": dropoffs,
        "pickups": pickups,
        "current_vehicles": currentVehicles,
        "staff": staff,
        "graphdata": graphdata.toJson(),
    };
}

class Graphdata {
    List<Week> week1;
    List<Week> week2;

    Graphdata({
        required this.week1,
        required this.week2,
    });

    factory Graphdata.fromJson(Map<String, dynamic> json) => Graphdata(
        week1: List<Week>.from(json["week1"].map((x) => Week.fromJson(x))),
        week2: List<Week>.from(json["week2"].map((x) => Week.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "week1": List<dynamic>.from(week1.map((x) => x.toJson())),
        "week2": List<dynamic>.from(week2.map((x) => x.toJson())),
    };
}

class Week {
    String x;
    String y;

    Week({
        required this.x,
        required this.y,
    });

    factory Week.fromJson(Map<String, dynamic> json) => Week(
        x: json["x"],
        y: json["y"],
    );

    Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
    };
}
