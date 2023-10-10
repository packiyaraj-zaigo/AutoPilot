part of 'workflow_bloc.dart';

abstract class WorkflowState extends Equatable {
  const WorkflowState();

  @override
  List<Object> get props => [];
}

class WorkflowInitial extends WorkflowState {}

class GetAllWorkflowSuccessState extends WorkflowState {
  final List<WorkflowModel> workflows;
  final List<WorkflowStatusModel> statuses;
  const GetAllWorkflowSuccessState({
    required this.workflows,
    required this.statuses,
  });

  @override
  List<Object> get props => [workflows];
}

class GetAllWorkflowErrorState extends WorkflowState {
  final String message;
  const GetAllWorkflowErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetAllWorkflowLoadingState extends WorkflowState {
  const GetAllWorkflowLoadingState();
}

class CreateWorkflowLoadingState extends WorkflowState {}

class CreateWorkflowErrorState extends WorkflowState {
  final String message;
  const CreateWorkflowErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class CreateWorkflowSuccessState extends WorkflowState {
  @override
  List<Object> get props => [];
}

class EditWorkflowLoadingState extends WorkflowState {}

class EditWorkflowErrorState extends WorkflowState {
  final String message;
  const EditWorkflowErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class EditWorkflowSuccessState extends WorkflowState {}

class GetSingleBucketLoadingState extends WorkflowState {}

class GetSingleBucketErrorState extends WorkflowState {
  final String message;
  const GetSingleBucketErrorState({required this.message});
  @override
  List<Object> get props => [message];
}

class GetSingleBucketSuccessState extends WorkflowState {}

class DeleteWorkFlowBucketState extends WorkflowState {}

class DeleteWorkFlowBucketLoadingState extends WorkflowState {}

class DeleteWorkflowBucketErrorState extends WorkflowState {
  final String errorMessage;
  DeleteWorkflowBucketErrorState({required this.errorMessage});
}
