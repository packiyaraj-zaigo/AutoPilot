part of 'service_bloc.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object> get props => [];
}

class ServiceInitial extends ServiceState {}

class CreateCannedOrderServiceSuccessState extends ServiceState {}

class CreateCannedOrderServiceLoadingState extends ServiceState {}

class CreateCannedOrderServiceErrorState extends ServiceState {
  final String message;
  const CreateCannedOrderServiceErrorState({required this.message});
}
