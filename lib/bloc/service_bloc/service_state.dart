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

class CreateCannedOrderServiceSuccessState extends ServiceState {
  final String message;
  const CreateCannedOrderServiceSuccessState({required this.message});
}

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

  @override
  List<Object> get props => [cannedServiceModel];
}

class GetAllCannedServiceLoadingState extends ServiceState {}

class GetAllCannedServiceErrorState extends ServiceState {}

class DeleteCannedServiceLoadingState extends ServiceState {}

class DeleteCannedServiceErrorState extends ServiceState {
  final String message;
  const DeleteCannedServiceErrorState({required this.message});
}

class DeleteCannedServiceSuccessState extends ServiceState {}

class EditCannedServiceLoadingState extends ServiceState {}

class EditCannedServiceErrorState extends ServiceState {
  final String message;
  const EditCannedServiceErrorState({required this.message});
}

class EditCannedServiceSuccessState extends ServiceState {
  final String message;
  const EditCannedServiceSuccessState({required this.message});
}

class EditOrderServiceSuccessState extends ServiceState {
  final String message;
  const EditOrderServiceSuccessState({required this.message});
}

class GetClientLoadingState extends ServiceState {}

class GetClientErrorState extends ServiceState {
  final String message;
  const GetClientErrorState({required this.message});
}

class GetClientSuccessState extends ServiceState {
  final ClientModel client;
  const GetClientSuccessState({required this.client});
}
