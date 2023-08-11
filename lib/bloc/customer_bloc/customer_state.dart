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

class EditCustomerLoading extends CustomerState {
  EditCustomerLoading();
}

class DeleteCustomerLoading extends CustomerState {
  DeleteCustomerLoading();
}

class EditCustomerError extends CustomerState {
  var message;
  EditCustomerError({required this.message});
  @override
  List<Object> get props => [message];
}

class CreateCustomerState extends CustomerState {
  final String id;
  const CreateCustomerState({required this.id});
}

class GetCustomerMessageState extends CustomerState {
  final cm.CustomerMessageModel messageModel;
  const GetCustomerMessageState({required this.messageModel});

  @override
  List<Object> get props => [messageModel];
}

class GetCustomerMessageLoadingState extends CustomerState {}

class GetCustomerMessageErrorState extends CustomerState {
  final String errorMsg;
  const GetCustomerMessageErrorState({required this.errorMsg});
}

class SendCustomerMessageState extends CustomerState {}

class SendCustomerMessageLoadingState extends CustomerState {}

class SendCustomerMessageErrorState extends CustomerState {
  final String errorMsg;
  SendCustomerMessageErrorState({required this.errorMsg});
}

class GetProvinceState extends CustomerState {
  final data.ProvinceModel provinceList;
  const GetProvinceState({required this.provinceList});

  @override
  @override
  List<Object> get props => [provinceList];
}

class GetCustomerMessagePaginationState extends CustomerState {
  final cm.CustomerMessageModel messageModel;
  const GetCustomerMessagePaginationState({required this.messageModel});

  @override
  List<Object> get props => [messageModel];
}

class GetCustomerMessagePaginationLoadingState extends CustomerState {}

class DeleteCustomer extends CustomerState {}

class DeleteCustomerErrorState extends CustomerState {
  final String errorMsg;
  const DeleteCustomerErrorState({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class CreateCustomerNoteLoadingState extends CustomerState {}

class CreateCustomerNoteErrorState extends CustomerState {
  final String message;
  const CreateCustomerNoteErrorState({required this.message});
}

class CreateCustomerNoteSuccessState extends CustomerState {}

class DeleteCustomerNoteLoadingState extends CustomerState {}

class DeleteCustomerNoteErrorState extends CustomerState {
  final String message;
  const DeleteCustomerNoteErrorState({required this.message});
}

class DeleteCustomerNoteSuccessState extends CustomerState {}

class GetCustomerNotesLoadingState extends CustomerState {}

class GetCustomerNotesErrorState extends CustomerState {
  final String message;
  const GetCustomerNotesErrorState({required this.message});
}

class GetCustomerNotesSuccessState extends CustomerState {
  final List<CustomerNoteModel> notes;
  const GetCustomerNotesSuccessState({required this.notes});

  @override
  List<Object> get props => [notes];
}

class GetCustomerEstimatesLoadingState extends CustomerState {}

class GetCustomerEstimatesErrorState extends CustomerState {
  final String message;
  const GetCustomerEstimatesErrorState({required this.message});
}

class GetCustomerEstimatesSuccessState extends CustomerState {
  final em.EstimateModel estimateData;
  const GetCustomerEstimatesSuccessState({required this.estimateData});
}

class GetSingleEstimateState extends CustomerState {
  final ce.CreateEstimateModel createEstimateModel;
  GetSingleEstimateState({required this.createEstimateModel});
}

class GetSingleCustomerLoadingState extends CustomerState {}

class GetSingleCustomerErrorState extends CustomerState {
  final String message;
  const GetSingleCustomerErrorState({required this.message});
}

class GetSingleCustomerSuccessState extends CustomerState {
  final Datum customer;
  const GetSingleCustomerSuccessState({required this.customer});
}
