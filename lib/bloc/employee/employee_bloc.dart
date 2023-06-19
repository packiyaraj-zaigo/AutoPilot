import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/api_provider/api_provider.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/models/employee_creation_model.dart';
import 'package:auto_pilot/models/employee_response_model.dart';
import 'package:http/http.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  bool isEmployeesLoading = false;
  final apiRepo = ApiRepository();
  int currentPage = 1;
  int totalPages = 1;
  EmployeeBloc() : super(EmployeeInitial()) {
    on<GetAllEmployees>(getAllEmployee);
  }

  getAllEmployee(
    GetAllEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      if (currentPage != 1) {
        emit(EmployeeDetailsPageNationLoading());
        isEmployeesLoading = true;
      }else{
      emit(EmployeeDetailsLoadingState());

      }

      final token = await AppUtils.getToken();
      final Response response = await apiRepo.getEmployees(token, currentPage);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
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
        isEmployeesLoading = false;
        log(response.body.toString());
      } else {
        log(response.body.toString());
        final body = jsonDecode(response.body);
        emit(EmployeeDetailsErrorState(message: body['message']));
        isEmployeesLoading = false;
      }
    } catch (e) {
      emit(EmployeeDetailsErrorState(message: e.toString()));
      isEmployeesLoading = false;
    }
  }
}
