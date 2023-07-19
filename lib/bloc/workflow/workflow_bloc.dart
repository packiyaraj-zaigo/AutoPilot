import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/workflow_bucket_model.dart';
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
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  WorkflowBloc() : super(WorkflowInitial()) {
    on<GetAllWorkflows>(getAllWorkflows);
    on<EditWorkflowPosition>(editWorkflowPosition);
    on<CreateWorkflow>(createWorkflow);
  }

  getAllWorkflows(
    GetAllWorkflows event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      emit(const GetAllWorkflowLoadingState());
      if (currentPage != 1) {
        isLoading = true;
      }
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.getAllWorkflows(token, currentPage);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'];
        log(data.toString());
        List<WorkflowModel> workflows = [];
        if (data != null && data.isNotEmpty) {
          data.forEach((workflow) {
            workflows.add(WorkflowModel.fromJson(workflow));
          });
        }
        final List<WorkflowBucketModel> buckets = [];
        final Response initialResponse =
            await apiRepo.getWorkflowBucket(token, currentPage);

        if (initialResponse.statusCode == 200) {
          final body = jsonDecode(initialResponse.body);
          if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
            body['data']['data'].forEach((json) {
              buckets.add(WorkflowBucketModel.fromJson(json));
            });
          }
          currentPage++;
          totalPages = body['data']['last_page'] ?? 1;
          bool retry = false;
          while (currentPage <= totalPages) {
            final Response nextResponse =
                await apiRepo.getWorkflowBucket(token, currentPage);
            if (nextResponse.statusCode == 200) {
              retry = false;
              final nextBody = jsonDecode(nextResponse.body);
              if (nextBody['data']['data'] != null &&
                  nextBody['data']['data'].isNotEmpty) {
                nextBody['data']['data'].forEach((json) {
                  buckets.add(WorkflowBucketModel.fromJson(json));
                });
              }
              currentPage++;
              totalPages = body['data']['last_page'] ?? 1;
            } else {
              if (retry) {
                break;
              }

              retry = true;
            }
            if (currentPage >= totalPages) {
              break;
            }
            log(currentPage.toString());
          }
        }
        for (var element in workflows) {
          element.bucket = buckets
              .where((bucket) {
                return element.bucketName?.id == bucket.id;
              })
              .toList()
              .last;
        }
        emit(GetAllWorkflowSuccessState(workflows: workflows));
      } else {
        emit(GetAllWorkflowErrorState(message: body[body.keys.first][0]));
      }
    } catch (e, s) {
      log("$e ${s}Workflow get bloc error");
      emit(const GetAllWorkflowErrorState(message: 'Something went wrong'));
    }
  }

  editWorkflowPosition(
    EditWorkflowPosition event,
    Emitter<WorkflowState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.editWorkflowPosition(token, event.workflow);
      log(response.body.toString());
    } catch (e) {
      log("${e}Workflow set bloc error");
    }
  }

  createWorkflow(
    CreateWorkflow event,
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
