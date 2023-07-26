part of 'service_bloc.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceDetailsLoadingState extends ServiceState {
  @override
  List<Object> get props => [];
}

class ServiceDetailsErrorState extends ServiceState {
  final String message;
  const ServiceDetailsErrorState({required this.message});
}

class ServiceDetailsSuccessState extends ServiceState {
  // final AllServiceResponse Services;
  // const ServiceDetailsSuccessState({required this.Services});

  // @override
  // List<Object> get props => [Services];
}

class ServiceCreateLoadingState extends ServiceState {}

class ServiceCreateErrorState extends ServiceState {
  final String message;
  const ServiceCreateErrorState({required this.message});
}

class ServiceCreateSuccessState extends ServiceState {}

class GetTechnicianState extends ServiceState {
  final TechnicianOnlyModel technicianModel;
  GetTechnicianState({required this.technicianModel});
}

class GetTechnicianLoadingState extends ServiceState {}

class GetTechnicianErrorState extends ServiceState {
  final String errorMsg;
  GetTechnicianErrorState({required this.errorMsg});
}

class CreateCannedOrderServiceSuccessState extends ServiceState {}

class CreateCannedOrderServiceLoadingState extends ServiceState {}

class CreateCannedOrderServiceErrorState extends ServiceState {
  final String message;
  const CreateCannedOrderServiceErrorState({required this.message});
}

class GetAllVendorsSuccessState extends ServiceState {
  final List<VendorResponseModel> vendors;
  const GetAllVendorsSuccessState({required this.vendors});

  @override
  List<Object> get props => [vendors];
}

class GetAllVendorsLoadingState extends ServiceState {}

class GetAllVendorsErrorState extends ServiceState {
  final String message;
  const GetAllVendorsErrorState({required this.message});
}

class GetAllCannedServiceState extends ServiceState {
  final CannedServiceModel cannedServiceModel;
  GetAllCannedServiceState({required this.cannedServiceModel});
}

class GetAllCannedServiceLoadingState extends ServiceState {}

class GetAllCannedServiceErrorState extends ServiceState {}
