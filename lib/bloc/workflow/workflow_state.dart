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
}

class GetAllWorkflowLoadingState extends WorkflowState {
  const GetAllWorkflowLoadingState();
}

class CreateWorkflowLoadingState extends WorkflowState {}

class CreateWorkflowErrorState extends WorkflowState {
  final String message;
  const CreateWorkflowErrorState({required this.message});
}

class CreateWorkflowSuccessState extends WorkflowState {}

class EditWorkflowLoadingState extends WorkflowState {}

class EditWorkflowErrorState extends WorkflowState {
  final String message;
  const EditWorkflowErrorState({required this.message});
}

class EditWorkflowSuccessState extends WorkflowState {}
