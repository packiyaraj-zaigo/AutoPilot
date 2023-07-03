part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
}

class customerDetails extends CustomerEvent {
  final String query;
  customerDetails({required this.query});

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
      pinCode;

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
      required this.pinCode});

  @override
  List<Object?> get props => [];
}


class GetCustomerMessageEvent extends CustomerEvent{
 
  @override
  List<Object?> get props => [];
}


class SendCustomerMessageEvent extends CustomerEvent{
  final String customerId,messageBody;
  SendCustomerMessageEvent({required this.customerId,required this.messageBody});
  

  @override
  List<Object?> get props=>[];
}
