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
