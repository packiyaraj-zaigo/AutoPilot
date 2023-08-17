import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/workflow_bucket_model.dart';
import 'package:auto_pilot/Models/workflow_status_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/Models/workflow_model.dart';
import 'package:http/http.dart';

part 'workflow_event.dart';
part 'workflow_state.dart';

class WorkflowBloc extends Bloc<WorkflowEvent, WorkflowState> {
  final apiRepo = ApiRepository();

  WorkflowBloc() : super(WorkflowInitial()) {
    on<GetAllWorkflows>(getAllWorkflows);
    on<CreateWorkflowBucketEvent>(createWorkflowBucket);
    on<EditWorkflowBucketEvent>(editWorkflowBucket);
    on<EditWorkflow>(editWorkflow);
  }

  Future<void> editWorkflow(
    EditWorkflow event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final userId = await AppUtils.geCurrenttUserID();
      final response = await apiRepo.editWorkflows(token, event.clientBucketId,
          event.orderId, userId, event.oldBucketId, event.workflowId);
      log(response.body.toString());
      if (response.statusCode == 200) {
        emit(EditWorkflowSuccessState());
      } else {
        emit(EditWorkflowErrorState(message: "Something went wrong"));
      }
    } catch (e) {
      emit(EditWorkflowErrorState(message: "Something went wrong"));
      log(e.toString() + " edit workflow bloc error");
    }
  }

  getAllWorkflows(
    GetAllWorkflows event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      emit(const GetAllWorkflowLoadingState());

      final token = await AppUtils.getToken();
      final Response response = await apiRepo.getAllWorkflows(token);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'];
        log(data.toString());
        List<WorkflowModel> workflows = [];
        List<WorkflowStatusModel> statuses = [];
        if (data != null && data.isNotEmpty) {
          data.forEach((workflow) {
            workflows.add(WorkflowModel.fromJson(workflow));
          });
          try {
            final statusResponse = await apiRepo.getAllStatus(token);
            log(statusResponse.body.toString() + "Status body");
            if (statusResponse.statusCode == 200) {
              final statusBody = await jsonDecode(statusResponse.body);
              if (statusBody['data'] != null && statusBody['data'].isNotEmpty) {
                statusBody['data'].forEach((status) {
                  statuses.add(WorkflowStatusModel.fromJson(status));
                });
              }
            } else {
              // emit(GetAllWorkflowErrorState(message: body[body.keys.first][0]));
              log("somethign went wrong");
            }
          } catch (e) {
            log(e.toString() + " Status bloc error");
          }
        }

        emit(GetAllWorkflowSuccessState(
            workflows: workflows, statuses: statuses));
      } else {
        emit(GetAllWorkflowErrorState(message: body[body.keys.first][0]));
      }
    } catch (e, s) {
      log("$e ${s}Workflow get bloc error");
      emit(const GetAllWorkflowErrorState(message: 'Something went wrong'));
    }
  }

  getSingleWorkflowBucket(
    GetSingleWorkflowEvent event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      emit(GetSingleBucketLoadingState());
      final token = await AppUtils.getToken();
      final response = await apiRepo.getSingleWorkflowBucket(token, event.id);
      if (response.statusCode == 200) {
        log(response.body.toString());
        emit(GetSingleBucketSuccessState());
      } else {
        emit(GetSingleBucketErrorState(message: 'Something went wrong'));
      }
    } catch (e) {
      log(e.toString() + " Get single error");
      emit(GetSingleBucketErrorState(message: 'Something went wrong'));
    }
  }

  editWorkflowBucket(
    EditWorkflowBucketEvent event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.editWorkflowBucket(token, event.json, event.id);
      log(response.body.toString());
      final body = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateWorkflowSuccessState());
      } else {
        if (body.containsKey('error')) {
          emit(CreateWorkflowErrorState(message: body['error']));
        } else if (body.containsKey('message')) {
          emit(CreateWorkflowErrorState(message: body['message']));
        } else {
          emit(CreateWorkflowErrorState(
              message: body[body.keys.first][0].toString()));
        }
      }
    } catch (e) {
      log("$e Worfflow create bloc error");
      emit(const CreateWorkflowErrorState(message: 'Something went wrong'));
    }
  }

  createWorkflowBucket(
    CreateWorkflowBucketEvent event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.addWorkflowBucket(token, event.json);
      log(response.body.toString());
      final body = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateWorkflowSuccessState());
      } else {
        if (body.containsKey('error')) {
          emit(CreateWorkflowErrorState(message: body['error']));
        } else if (body.containsKey('message')) {
          emit(CreateWorkflowErrorState(message: body['message']));
        } else {
          emit(CreateWorkflowErrorState(
              message: body[body.keys.first][0].toString()));
        }
      }
    } catch (e) {
      log("$e Worfflow create bloc error");
      emit(const CreateWorkflowErrorState(message: 'Something went wrong'));
    }
  }
}
