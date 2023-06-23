part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  @override
  List<Object> get props => [];
  const CustomerState();
}

class CustomerInitial extends CustomerState {
  @override
  List<Object> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerReady extends CustomerState {
  final CustomerModel data;
  CustomerReady({required this.data});
}

class CustomerError extends CustomerState {
  final String message;
  CustomerError({required this.message});
}

class AddCustomerInitial extends CustomerState {
  @override
  List<Object> get props => [];
}

class AddCustomerLoading extends CustomerState {
  AddCustomerLoading();
}

class AddCustomerError extends CustomerState {
  var message;
  AddCustomerError({required this.message});
  @override
  List<Object> get props => [message];
}
