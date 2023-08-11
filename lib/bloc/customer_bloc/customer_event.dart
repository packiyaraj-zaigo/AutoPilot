part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class customerDetails extends CustomerEvent {
  final String query;
  const customerDetails({required this.query});
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
}

class GetProvinceEvent extends CustomerEvent {}

class GetCustomerMessageEvent extends CustomerEvent {}

class SendCustomerMessageEvent extends CustomerEvent {
  final String customerId, messageBody;
  const SendCustomerMessageEvent(
      {required this.customerId, required this.messageBody});
}

class GetCustomerMessagePaginationEvent extends CustomerEvent {
  const GetCustomerMessagePaginationEvent();
}

class DeleteCustomerEvent extends CustomerEvent {
  final String customerId;
  final BuildContext context;
  const DeleteCustomerEvent({
    required this.customerId,
    required this.context,
  });
}

class CreateCustomerNoteEvent extends CustomerEvent {
  final String customerId;
  final String notes;
  const CreateCustomerNoteEvent({
    required this.customerId,
    required this.notes,
  });
}

class DeleteCustomerNoteEvent extends CustomerEvent {
  final String id;
  const DeleteCustomerNoteEvent({
    required this.id,
  });
}

class GetAllCustomerNotesEvent extends CustomerEvent {
  final String id;
  const GetAllCustomerNotesEvent({required this.id});
}

class GetCustomerEstimatesEvent extends CustomerEvent {
  final String customerId;
  const GetCustomerEstimatesEvent({required this.customerId});
}

class GetSingleEstimateEvent extends CustomerEvent {
  final String orderId;
  const GetSingleEstimateEvent({required this.orderId});
}
