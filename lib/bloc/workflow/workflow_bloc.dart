import 'dart:convert';
import 'dart:developer';

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
        currentPage = data['current_page'] ?? 1;
        totalPages = data['last_page'] ?? 1;
        List<WorkflowBucketModel> workflows = [];
        if (data['data'] != null && data['data'].isNotEmpty) {
          data['data'].forEach((workflow) {
            workflows.add(WorkflowBucketModel.fromJson(workflow));
          });
        }
        emit(GetAllWorkflowSuccessState(workflows: workflows));
      } else {
        emit(GetAllWorkflowErrorState(message: body[body.keys.first]));
      }
    } catch (e) {
      log("${e}Workflow get bloc error");
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
}
