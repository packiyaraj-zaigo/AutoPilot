part of 'workflow_bloc.dart';

abstract class WorkflowEvent extends Equatable {
  const WorkflowEvent();

  @override
  List<Object> get props => [];
}

class GetAllWorkflows extends WorkflowEvent {}

class EditWorkflowPosition extends WorkflowEvent {
  final WorkflowBucketModel workflow;
  const EditWorkflowPosition({required this.workflow});
}
