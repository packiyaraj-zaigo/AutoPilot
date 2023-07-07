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

class CreateNewEstimateState extends EstimateState {
  final EstimationDetailsModel estimateDetails;
  CreateNewEstimateState({required this.estimateDetails});

  @override
  List<Object> get props => [estimateDetails];
}

class CreateNewEstimateErrorState extends EstimateState {
  final String errorMessage;
  CreateNewEstimateErrorState({required this.errorMessage});
}

class CreateNewEstimateLoadingState extends EstimateState {}
