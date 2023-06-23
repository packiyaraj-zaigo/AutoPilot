class VinGlobalSearchResponseModel {
  String? bodyClass;
  String? displacementCc;
  String? driveType;
  String? make;
  String? manufacturer;
  String? model;
  String? modelYear;
  String? transmissionStyle;
  String? vehicleType;

  VinGlobalSearchResponseModel({
    required this.bodyClass,
    required this.displacementCc,
    required this.driveType,
    required this.make,
    required this.manufacturer,
    required this.model,
    required this.modelYear,
    required this.transmissionStyle,
    required this.vehicleType,
  });

  factory VinGlobalSearchResponseModel.fromJson(Map<String, dynamic> json) =>
      VinGlobalSearchResponseModel(
        bodyClass: json["BodyClass"],
        displacementCc: json["DisplacementCC"],
        driveType: json["DriveType"],
        make: json["Make"],
        manufacturer: json["Manufacturer"],
        model: json["Model"],
        modelYear: json["ModelYear"],
        transmissionStyle: json["TransmissionStyle"],
        vehicleType: json["VehicleType"],
      );
}
