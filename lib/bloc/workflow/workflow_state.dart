part of 'workflow_bloc.dart';

abstract class WorkflowState extends Equatable {
  const WorkflowState();

  @override
  List<Object> get props => [];
}

class WorkflowInitial extends WorkflowState {}

class GetAllWorkflowSuccessState extends WorkflowState {
  final List<WorkflowModel> workflows;
  const GetAllWorkflowSuccessState({required this.workflows});

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
