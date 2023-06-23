part of 'scanner_bloc.dart';

abstract class ScannerState extends Equatable {
  const ScannerState();

  @override
  List<Object> get props => [];
}

class ScannerInitial extends ScannerState {}

class VinSearchLoadingState extends ScannerState {}

class VinSearchErrorState extends ScannerState {
  final String message;
  const VinSearchErrorState({required this.message});
}

class VinCodeNotInShopState extends ScannerState {
  final VinGlobalSearchResponseModel vehicle;
  const VinCodeNotInShopState({required this.vehicle});
}

class VinCodeInShopState extends ScannerState {
  final SingleVehicleResponseModel vehicle;
  final List<VehicleEstimateResponseModel> estimates;
  const VinCodeInShopState({required this.vehicle, required this.estimates});
}

class VehicleNotFoundState extends ScannerState {}

class PageNationErrorState extends ScannerState {}

class PageNationSucessState extends ScannerState {
  final List<VehicleEstimateResponseModel> estimates;
  const PageNationSucessState({required this.estimates});
}
