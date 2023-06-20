import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/Models/employee_creation_model.dart';
import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Models/role_model.dart';
import 'package:http/http.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  bool isEmployeesLoading = false;
  bool isPagenationLoading = false;
  final apiRepo = ApiRepository();
  int currentPage = 1;
  int totalPages = 1;
  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetAllEmployees>(getAllEmployee);
    on<CreateEmployee>(createEmployee);
    on<GetAllRoles>(getAllRoles);
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
        if (body.containsKey('error')) {
          emit(EmployeeCreateErrorState(message: body['error']));
        } else if (body.containsKey('email')) {
          emit(EmployeeCreateErrorState(message: body['email'][0]));
        } else {
          throw 'Something went wrong';
        }
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
      await apiRepo.getEmployees(token, currentPage).then((value) {
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
}
