import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  bool isEmployeesLoading = false;
  bool isPagenationLoading = false;
  final apiRepo = ApiRepository();
  int currentPage = 1;
  int totalPages = 1;
  ServiceBloc() : super(ServiceInitial()) {
    on<GetAllServicess>(getAllServices);
    // on<CreateEmployee>(createEmployee);
  }

  // createEmployee(
  //   CreateEmployee event,
  //   Emitter<ServiceState> emit,
  // ) async {
  //   try {
  //     emit(EmployeeCreateLoadingState());
  //     final token = await AppUtils.getToken();
  //     final Response response = await apiRepo.createEmployee(token);
  //     log(response.statusCode.toString() + "Status code");
  //     log(jsonDecode(response.body).toString() + "BODY");
  //     if (response.statusCode == 201) {
  //       emit(EmployeeCreateSuccessState());
  //     } else {
  //       final body = jsonDecode(response.body);
  //       if (body.containsKey('error')) {
  //         emit(EmployeeCreateErrorState(message: body['error']));
  //       } else if (body.containsKey('email')) {
  //         emit(EmployeeCreateErrorState(message: body['email'][0]));
  //       } else {
  //         throw 'Something went wrong';
  //       }
  //     }
  //   } catch (e) {
  //     log(e.toString() + 'Create employee bloc error');
  //     emit(EmployeeCreateErrorState(message: "Something went wrong"));
  //   }
  // }

  getAllServices(
    GetAllServicess event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(ServiceDetailsLoadingState());
      if (currentPage == 1) {
        isEmployeesLoading = true;
      }

      final token = await AppUtils.getToken();
      await apiRepo.getEmployees(token, currentPage, event.query).then((value) {
        if (value.statusCode == 200) {
          final responseBody = jsonDecode(value.body);
          emit(
            ServiceDetailsSuccessState(
                // employees: AllEmployeeResponse.fromJson(
                //   responseBody['data'],
                // ),
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
          emit(ServiceDetailsErrorState(message: body['message']));
        }
        isEmployeesLoading = false;
        isPagenationLoading = false;
      });
    } catch (e) {
      emit(ServiceDetailsErrorState(message: e.toString()));
      isEmployeesLoading = false;
      isPagenationLoading = false;
    }
  }
}
