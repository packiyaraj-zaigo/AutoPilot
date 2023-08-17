part of 'workflow_bloc.dart';

abstract class WorkflowEvent extends Equatable {
  const WorkflowEvent();

  @override
  List<Object> get props => [];
}

class GetAllWorkflows extends WorkflowEvent {}

class CreateWorkflow extends WorkflowEvent {
  final Map<String, dynamic> json;
  const CreateWorkflow({required this.json});
}

class EditWorkflow extends WorkflowEvent {
  final String workflowId;
  final String clientBucketId;
  final String orderId;
  final String oldBucketId;
  const EditWorkflow({
    required this.workflowId,
    required this.clientBucketId,
    required this.orderId,
    required this.oldBucketId,
  });
}
