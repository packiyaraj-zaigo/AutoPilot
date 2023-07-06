import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/service_model.dart';
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
  bool isFetching = false;
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
    ServiceModel serviceModel;
    try {
      if (currentPage == 1) {
        emit(GetServiceLoadingState());
      }

      final token = await AppUtils.getToken();
      Response serviceResponse =
          await apiRepo.getServices(token, currentPage, event.query);
      if (serviceResponse.statusCode == 200) {
        serviceModel = serviceModelFromJson(serviceResponse.body);
        final responseBody = jsonDecode(serviceResponse.body);
        isFetching = false;
        emit(GetServiceSucessState(serviceModel: serviceModel));
        currentPage = serviceModel.data.currentPage;
        totalPages = serviceModel.data.lastPage;

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
        print(serviceResponse.body.toString());
      } else {
        log(serviceResponse.body.toString());
        final body = jsonDecode(serviceResponse.body);
        emit(GetServiceErrorState(errorMessage: body['message']));
      }
    } catch (e) {
      print(e.toString() + "bloc error");
      emit(GetServiceErrorState(errorMessage: e.toString()));
    }
  }
}
