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
  final Data customer;
  CustomerReady({required this.customer});
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


class GetCustomerMessageState extends CustomerState{
  final cm.CustomerMessageModel messageModel;
  const GetCustomerMessageState({required this.messageModel});

     @override
  List<Object> get props => [messageModel];
}

class GetCustomerMessageLoadingState extends CustomerState{}
class GetCustomerMessageErrorState extends CustomerState{
  final String errorMsg;
 const GetCustomerMessageErrorState({required this.errorMsg});
}


class SendCustomerMessageState extends CustomerState{}
class SendCustomerMessageLoadingState extends CustomerState{}
class SendCustomerMessageErrorState extends CustomerState{
  final String errorMsg;
  SendCustomerMessageErrorState({required this.errorMsg});
}



class GetCustomerMessagePaginationState extends CustomerState{
   final cm.CustomerMessageModel messageModel;
   const GetCustomerMessagePaginationState({required this.messageModel});

     @override
  List<Object> get props => [messageModel];


}

class GetCustomerMessagePaginationLoadingState extends CustomerState{}
