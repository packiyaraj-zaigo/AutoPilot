import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/Models/employee_message_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/Models/employee_creation_model.dart';
import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Models/role_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  bool isEmployeesLoading = false;
  bool isPagenationLoading = false;
  final apiRepo = ApiRepository();
  int currentPage = 1;
  int totalPages = 0;

  int messageCurrentPage = 1;
  int messageTotalPage = 1;
  bool messageIsFetching = false;
  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetAllEmployees>(getAllEmployee);
    on<CreateEmployee>(createEmployee);
    on<GetAllRoles>(getAllRoles);
    on<DeleteEmployee>(deleteEmployee);
    on<EditEmployee>(editEmployee);
    on<GetEmployeeMessageEvent>(getEmployeeMessageBloc);
    on<SendEmployeeMessageEvent>(sendEmployeeMessage);
  }

  sendEmployeeMessage(
    SendEmployeeMessageEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final response = await apiRepo.sendEmployeeMessage(
          token, event.receiverUserId, event.message);
      log(response.body.toString() + "Send message reponse");
    } catch (e) {
      log(e.toString() + "Send bloc message error");
    }
  }

  editEmployee(
    EditEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EditEmployeeLoadingState());
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.editEmployee(token, event.employee, event.id);
      log(response.statusCode.toString() + "Status code");
      log(jsonDecode(response.body).toString() + "BODY");
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(EditEmployeeSuccessState());
      } else {
        final body = jsonDecode(response.body);
        log(body.toString());
        if (body.keys.isNotEmpty) {
          if (body.containsKey('error')) {
            emit(EditEmployeeErrorState(message: body['error']));
          } else if (body.containsKey('message')) {
            emit(EditEmployeeErrorState(message: body['message']));
          } else {
            emit(EditEmployeeErrorState(message: body[body.keys.first][0]));
          }
        } else {
          throw 'Something went wrong';
        }
      }
    } catch (e) {
      log(e.toString() + 'Edit employee bloc error');
      emit(EditEmployeeErrorState(message: "Something went wrong"));
    }
  }

  deleteEmployee(
    DeleteEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(DeleteEmployeeLoadingState());
      final token = await AppUtils.getToken();
      final reponse = await apiRepo.deleteEmployee(token, event.id);
      if (reponse.statusCode == 200) {
        emit(DeleteEmployeeSuccessState());
      } else {
        emit(DeleteEmployeeErrorState());
      }
    } catch (e) {
      emit(DeleteEmployeeErrorState());
      log(e.toString() + " Delete employee bloc error");
    }
  }

  getAllRoles(
    GetAllRoles event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeRolesLoadingState());
      final token = await AppUtils.getToken();
      final Response response = await apiRepo.getAllRoles(token);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final List<RoleModel> roles = [];
        responseBody['roles']
            .forEach((element) => roles.add(RoleModel.fromJson(element)));
        print(RoleModel.fromJson(responseBody['roles'][0]).toString() +
            "::::::::::::::::::::::::::;");
        emit(EmployeeRolesSuccessState(roles: roles));
      } else {
        emit(EmployeeRolesErrorState(message: 'Something went wrong'));
      }
    } catch (e) {
      log(e.toString() + 'Create employee bloc error');
      emit(EmployeeCreateErrorState(message: "Something went wrong"));
    }
  }

  createEmployee(
    CreateEmployee event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeCreateLoadingState());
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.createEmployee(token, event.model);
      log(response.statusCode.toString() + "Status code");
      log(jsonDecode(response.body).toString() + "BODY");
      if (response.statusCode == 201) {
        emit(EmployeeCreateSuccessState());
      } else {
        final body = jsonDecode(response.body);
        log(body.toString());
        if (body.keys.isNotEmpty) {
          if (body.containsKey('error')) {
            emit(EmployeeCreateErrorState(message: body['error']));
          } else if (body.containsKey('message')) {
            emit(EmployeeCreateErrorState(message: body['message']));
          } else {
            emit(EmployeeCreateErrorState(message: body[body.keys.first][0]));
          }
        } else {
          throw 'Something went wrong';
        }
        if (body.containsKey('error')) {
          emit(EmployeeCreateErrorState(message: body['error']));
        } else if (body.containsKey('email')) {
          emit(EmployeeCreateErrorState(message: body['email'][0]));
        } else {}
      }
    } catch (e) {
      log(e.toString() + 'Create employee bloc error');
      emit(EmployeeCreateErrorState(message: "Something went wrong"));
    }
  }

  getAllEmployee(
    GetAllEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeDetailsLoadingState());
      if (currentPage == 1) {
        isEmployeesLoading = true;
      }

      final token = await AppUtils.getToken();
      await apiRepo.getEmployees(token, currentPage, event.query).then((value) {
        if (value.statusCode == 200) {
          final responseBody = jsonDecode(value.body);
          emit(
            EmployeeDetailsSuccessState(
              employees: AllEmployeeResponse.fromJson(
                responseBody['data'],
              ),
            ),
          );
          final data = responseBody['data'];
          currentPage = data['current_page'] ?? 1;
          totalPages = data['last_page'] ?? 1;
          if (currentPage <= totalPages) {
            currentPage++;
          }
          print(value.body.toString());
        } else {
          log(value.body.toString());
          final body = jsonDecode(value.body);
          emit(EmployeeDetailsErrorState(message: body['message']));
        }
        isEmployeesLoading = false;
        isPagenationLoading = false;
      });
    } catch (e) {
      emit(EmployeeDetailsErrorState(message: e.toString()));
      isEmployeesLoading = false;
      isPagenationLoading = false;
    }
  }

  Future<void> getEmployeeMessageBloc(
    GetEmployeeMessageEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      final userId = await AppUtils.geCurrenttUserID();
      if (messageCurrentPage == 1) {
        emit(GetEmployeeMessageLoadingState());
      }

      final Response response = await apiRepo.getEmployeeMessage(
          token!, messageCurrentPage, event.receiverUserId, userId);

      // log("first response ${response.body}");

      if (response.statusCode == 200) {
        final List<MessageModel> messages = [];
        final body = await jsonDecode(response.body);
        messageTotalPage = body['data']['last_page'] ?? 1;
        if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
          body['data']['data'].forEach((message) {
            messages.add(MessageModel.fromJson(message));
          });
        }
        if (userId == event.receiverUserId) {
          emit(GetEmployeeMessageState(messages: messages));

          return;
        }
        final Response secondResponse = await apiRepo.getEmployeeMessage(
            token, messageCurrentPage, userId, event.receiverUserId);

        // log("second response ${secondResponse.body}");
        if (secondResponse.statusCode == 200) {
          final secondBody = await jsonDecode(secondResponse.body);
          messageTotalPage =
              (secondBody['data']['last_page'] ?? 1) > messageTotalPage
                  ? (secondBody['data']['last_page'] ?? 1)
                  : messageTotalPage;
          messageIsFetching = false;
          if (secondBody['data']['data'] != null &&
              secondBody['data']['data'].isNotEmpty) {
            secondBody['data']['data'].forEach((secondMessage) {
              messages.add(MessageModel.fromJson(secondMessage));
            });
          }
          messages.sort(
            (a, b) {
              return a.createdAt.compareTo(b.createdAt);
            },
          );
          emit(GetEmployeeMessageState(messages: messages));
        } else {
          emit(GetEmployeeMessageErrorState(
              errorMessage: "Something went wrong"));
        }
        // log(messageTotalPage.toString());
        // log(messageCurrentPage.toString());
        if (messageTotalPage >= messageCurrentPage) {
          messageCurrentPage++;
        }
      } else {
        emit(
            GetEmployeeMessageErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      emit(GetEmployeeMessageErrorState(errorMessage: "Something went wrong"));
      log(e.toString() + " GET MESSAGES BLOC ERROR");
    }
  }
}
