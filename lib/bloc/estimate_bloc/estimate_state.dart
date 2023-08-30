part of 'estimate_bloc.dart';

abstract class EstimateState extends Equatable {
  const EstimateState();

  @override
  List<Object> get props => [];
}

class EstimateInitial extends EstimateState {}

class GetEstimateState extends EstimateState {
  final EstimateModel estimateData;
  const GetEstimateState({required this.estimateData});

  @override
  List<Object> get props => [estimateData];
}

class GetEstimateLoadingState extends EstimateState {}

class GetEstimateErrorState extends EstimateState {
  final String errorMsg;
  const GetEstimateErrorState({required this.errorMsg});
}

class CreateEstimateState extends EstimateState {
  final CreateEstimateModel createEstimateModel;
  CreateEstimateState({required this.createEstimateModel});
}

class CreateEstimateLoadingState extends EstimateState {}

class CreateEstimateErrorState extends EstimateState {
  final String errorMessage;
  const CreateEstimateErrorState({required this.errorMessage});
}

class EditEstimateState extends EstimateState {
  final CreateEstimateModel createEstimateModel;
  EditEstimateState({required this.createEstimateModel});
}

class AddEstimateNoteState extends EstimateState {}

class AddEstimateNoteErrorState extends EstimateState {
  final String errorMessage;
  AddEstimateNoteErrorState({required this.errorMessage});
}

class CreateAppointmentEstimateState extends EstimateState {}

class EditAppointmentEstimateState extends EstimateState {}

class EditEstimateNoteState extends EstimateState {}

class EditEstimateNoteErrorState extends EstimateState {
  final String errorMessage;
  EditEstimateNoteErrorState({required this.errorMessage});
}

class DeleteEstimateNoteState extends EstimateState {}

class CreateAppointmentEstimateErrorState extends EstimateState {
  final String errorMessage;
  CreateAppointmentEstimateErrorState({required this.errorMessage});
}

class GetSingleEstimateState extends EstimateState {
  final CreateEstimateModel createEstimateModel;
  GetSingleEstimateState({required this.createEstimateModel});
}

class GetSingleEstimateLoadingState extends EstimateState {}

class GetEstimateNoteState extends EstimateState {
  final EstimateNoteModel estimateNoteModel;
  GetEstimateNoteState({required this.estimateNoteModel});
}

class GetEstimateAppointmentState extends EstimateState {
  final AppointmentDetailsModel estimateAppointmentModel;
  GetEstimateAppointmentState({required this.estimateAppointmentModel});
}

class EstimateUploadImageState extends EstimateState {
  final String imagePath;
  final int index;
  EstimateUploadImageState({required this.imagePath, required this.index});

  @override
  List<Object> get props => [imagePath, index];
}

class FirstOrderImageLoadingState extends EstimateState {}

class EstimateCreateOrderImageState extends EstimateState {}

class GetOrderImageState extends EstimateState {
  OrderImageModel orderImageModel;
  GetOrderImageState({required this.orderImageModel});
}

class DeleteImageState extends EstimateState {}

class CreateOrderServiceState extends EstimateState {
  final String orderServiceId;
  CreateOrderServiceState({required this.orderServiceId});
}

class CreateOrderServiceLoadingState extends EstimateState {}

class CreateOrderServiceItemState extends EstimateState {}

class CreateOrderServiceItemLoadingState extends EstimateState {}

class DeleteOrderServiceState extends EstimateState {}

class DeleteOrderServiceErrorState extends EstimateState {
  final String errorMessage;
  DeleteOrderServiceErrorState({required this.errorMessage});
}

class SendEstimateToCustomerState extends EstimateState {}

class SendEstimateToCustomerErrorState extends EstimateState {
  final String errorMsg;
  SendEstimateToCustomerErrorState({required this.errorMsg});
}

class SendEstimateToCustomerLoadingState extends EstimateState {}

class DeleteAppointmentEstimateState extends EstimateState {}

class DeleteAppointmentEstimateErrorState extends EstimateState {
  final String errorMessage;
  DeleteAppointmentEstimateErrorState({required this.errorMessage});
}

class CollectPaymentEstimateState extends EstimateState {}

class CollectPaymentEstimateLoadingState extends EstimateState {}

class CollectPaymentEstimateErrorState extends EstimateState {
  final String errorMessage;
  CollectPaymentEstimateErrorState({required this.errorMessage});
}

class DeleteEstimateState extends EstimateState {}

class DeleteEstimateLoadingState extends EstimateState {}

class DeleteEstimateErrorState extends EstimateState {
  final String errorMessage;

  DeleteEstimateErrorState({required this.errorMessage});
}

class GetPaymentHistoryState extends EstimateState {
  final PaymentHistoryModel paymentHistoryModel;
  GetPaymentHistoryState({required this.paymentHistoryModel});

  @override
  List<Object> get props => [paymentHistoryModel];
}

class GetPaymentHistoryLoadingState extends EstimateState {}

class GetPaymentHistoryErrorState extends EstimateState {
  final String errorMessage;
  GetPaymentHistoryErrorState({required this.errorMessage});
}

class AuthServiceByTechnicianState extends EstimateState {}

class AuthServiceByTechnicianLoadingState extends EstimateState {}

class AuthServiceByTechnicianErrorState extends EstimateState {
  final String errorMessage;
  AuthServiceByTechnicianErrorState({required this.errorMessage});
}

class ChangeEstimateStatusState extends EstimateState {}

class ChangeEstimateStausLoadingState extends EstimateState {}

class ChangeEstimateStatusErrorState extends EstimateState {
  final String errorMessage;
  ChangeEstimateStatusErrorState({required this.errorMessage});
}

class GetEventDetailsByIdState extends EstimateState {
  final String orderId, notes, appointmentId;
  final DateTime beginDate, endDate;

  GetEventDetailsByIdState({
    required this.orderId,
    required this.notes,
    required this.beginDate,
    required this.endDate,
    required this.appointmentId,
  });
}

class GetEventDetailsByIdErrorState extends EstimateState {
  final String errorMessage;
  GetEventDetailsByIdErrorState({required this.errorMessage});
}

class AppointmentDetailsLoadingState extends EstimateState {}

class GetClientByIdInEstimateState extends EstimateState {
  final ClientModel clientModel;
  GetClientByIdInEstimateState({required this.clientModel});
}

class GetClientByIdInEstimateErrorState extends EstimateState {
  final String errorMessage;
  GetClientByIdInEstimateErrorState({required this.errorMessage});
}
