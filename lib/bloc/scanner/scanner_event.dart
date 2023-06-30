part of 'scanner_bloc.dart';

abstract class ScannerEvent extends Equatable {
  const ScannerEvent();

  @override
  List<Object> get props => [];
}

class GetVehiclesFromVin extends ScannerEvent {
  final String vin;
  const GetVehiclesFromVin({required this.vin});
}

class EstimatePageNation extends ScannerEvent {}

class GetVehiclesFromLic extends ScannerEvent {
  final String lic;
  const GetVehiclesFromLic({required this.lic});
}

class LicEstimatePageNation extends ScannerEvent {}
