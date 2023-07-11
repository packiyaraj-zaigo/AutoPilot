part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
}

class customerDetails extends CustomerEvent {
  final String query;
  const customerDetails({required this.query});

  @override
  List<Object?> get props => [];
}

class AddCustomerDetails extends CustomerEvent {
  final BuildContext context;
  final String firstName,
      lastName,
      email,
      mobileNo,
      customerNotes,
      address,
      state,
      city,
      pinCode,
      stateId;

  const AddCustomerDetails(
      {required this.context,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobileNo,
      required this.customerNotes,
      required this.address,
      required this.state,
      required this.city,
      required this.pinCode,
      required this.stateId});

  @override
  List<Object?> get props => [];
}

class EditCustomerDetails extends CustomerEvent {
  final BuildContext context;
  final String firstName,
      lastName,
      email,
      mobileNo,
      customerNotes,
      address,
      state,
      city,
      pinCode,
      stateId,
      id;

  const EditCustomerDetails(
      {required this.context,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.mobileNo,
      required this.customerNotes,
      required this.address,
      required this.state,
      required this.city,
      required this.pinCode,
      required this.stateId,
      required this.id});

  @override
  List<Object?> get props => [];
}

class GetProvinceEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}

class GetCustomerMessageEvent extends CustomerEvent {
  @override
  List<Object?> get props => [];
}

class SendCustomerMessageEvent extends CustomerEvent {
  final String customerId, messageBody;
  const SendCustomerMessageEvent(
      {required this.customerId, required this.messageBody});

  @override
  List<Object?> get props => [];
}

class GetCustomerMessagePaginationEvent extends CustomerEvent {
  const GetCustomerMessagePaginationEvent();

  @override
  List<Object?> get props => [];
}

class DeleteCustomerEvent extends CustomerEvent {
  final String customerId;
  const DeleteCustomerEvent({required this.customerId});
  @override
  List<Object?> get props => [customerId];
}
