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

class AddEstimateNoteErrorState extends EstimateState {}

class CreateAppointmentEstimateState extends EstimateState {}

class CreateAppointmentEstimateErrorState extends EstimateState {
  final String errorMessage;
  CreateAppointmentEstimateErrorState({required this.errorMessage});
}

class GetSingleEstimateState extends EstimateState {
  final CreateEstimateModel createEstimateModel;
  GetSingleEstimateState({required this.createEstimateModel});
}

class GetEstimateNoteState extends EstimateState {
  final EstimateNoteModel estimateNoteModel;
  GetEstimateNoteState({required this.estimateNoteModel});
}

class GetEstimateAppointmentState extends EstimateState {
  final AppointmentDetailsModel estimateAppointmentModel;
  GetEstimateAppointmentState({required this.estimateAppointmentModel});
}
