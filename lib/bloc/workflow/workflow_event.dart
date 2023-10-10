part of 'workflow_bloc.dart';

abstract class WorkflowEvent extends Equatable {
  const WorkflowEvent();

  @override
  List<Object> get props => [];
}

class GetAllWorkflows extends WorkflowEvent {}

class CreateWorkflowBucketEvent extends WorkflowEvent {
  final Map<String, dynamic> json;
  const CreateWorkflowBucketEvent({required this.json});
}

class EditWorkflowBucketEvent extends WorkflowEvent {
  final String id;
  final Map<String, dynamic> json;
  const EditWorkflowBucketEvent({required this.json, required this.id});
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

class GetSingleWorkflowEvent extends WorkflowEvent {
  final String id;
  const GetSingleWorkflowEvent({required this.id});
}

class DeleteWorkFlowBucketEvent extends WorkflowEvent {
  final String id;
  DeleteWorkFlowBucketEvent({required this.id});
}
