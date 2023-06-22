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
