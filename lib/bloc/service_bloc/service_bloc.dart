import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/vendor_response_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  bool isEmployeesLoading = false;
  bool isPagenationLoading = false;
  bool isVendorsPagenationLoading = false;
  int serviceId = 0;
  final apiRepo = ApiRepository();
  int currentPage = 1;
  int totalPages = 1;
  ServiceBloc() : super(ServiceInitial()) {
    on<GetAllServicess>(getAllServices);
    on<GetTechnicianEvent>(getAllTechnicianBloc);
    on<CreateCannedOrderServiceEvent>(createCannedOrderService);
    on<GetAllVendorsEvent>(getAllVendors);
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

  Future<void> getAllVendors(
    GetAllVendorsEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      Response getProvinceRes =
          await apiRepo.getAllVendors(token!, currentPage);
      log("res${getProvinceRes.body}");
      final body = jsonDecode(getProvinceRes.body);
      if (getProvinceRes.statusCode == 200) {
        List<VendorResponseModel> vendors = [];

        totalPages = body['data']['last_page'] ?? 1;
        isVendorsPagenationLoading = false;
        if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
          body['data']['data'].forEach((vendor) {
            vendors.add(VendorResponseModel.fromJson(vendor));
          });
        }
        emit(GetAllVendorsSuccessState(vendors: vendors));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      }
    } catch (e) {
      log(e.toString() + " Vendors pagenation bloc error");
    }
  }

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
      await apiRepo.getServices(token, currentPage, event.query).then((value) {
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

  getAllTechnicianBloc(
    GetTechnicianEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(GetTechnicianLoadingState());
      TechnicianOnlyModel technicianModel;

      final token = await AppUtils.getToken();
      Response getTechnicianResponse = await apiRepo.getTechniciansOnly(token);
      if (getTechnicianResponse.statusCode == 200) {
        technicianModel =
            technicianOnlyModelFromJson(getTechnicianResponse.body);
        emit(GetTechnicianState(technicianModel: technicianModel));
      } else {
        emit(GetTechnicianErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e) {
      emit(GetTechnicianErrorState(errorMsg: e.toString()));
    }
  }

  Future<void> createCannedOrderService(
    CreateCannedOrderServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      bool materialDone = true;
      bool partDone = true;
      bool laborDone = true;
      bool subcontractDone = true;
      bool feeDone = true;
      emit(CreateCannedOrderServiceLoadingState());
      final token = await AppUtils.getToken();
      final Response serviceCreateResponse =
          await apiRepo.createCannedOrderService(token, event.service);

      log(serviceCreateResponse.body.toString());

      if (serviceCreateResponse.statusCode == 200 ||
          serviceCreateResponse.statusCode == 201) {
        final body = jsonDecode(serviceCreateResponse.body);
        serviceId = body['created_id'];
        if (event.material != null) {
          final Response materialResponse = await apiRepo
              .createCannedOrderServiceItem(token, event.material!, serviceId);
          log(materialResponse.body.toString());
          if (materialResponse.statusCode == 200 ||
              materialResponse.statusCode == 201) {
          } else {
            materialDone = false;
          }
        }
        if (event.part != null) {
          final Response partResponse = await apiRepo
              .createCannedOrderServiceItem(token, event.part!, serviceId);
          if (partResponse.statusCode == 200 ||
              partResponse.statusCode == 201) {
          } else {
            partDone = false;
          }
        }
        if (event.labor != null) {
          final Response laborResponse = await apiRepo
              .createCannedOrderServiceItem(token, event.labor!, serviceId);
          if (laborResponse.statusCode == 200 ||
              laborResponse.statusCode == 201) {
          } else {
            laborDone = false;
          }
        }
        if (event.subcontract != null) {
          final Response subcontractResponse =
              await apiRepo.createCannedOrderServiceItem(
                  token, event.subcontract!, serviceId);
          if (subcontractResponse.statusCode == 200 ||
              subcontractResponse.statusCode == 201) {
          } else {
            subcontractDone = false;
          }
        }
        if (event.fee != null) {
          final Response feeResponse = await apiRepo
              .createCannedOrderServiceItem(token, event.fee!, serviceId);
          if (feeResponse.statusCode == 200 || feeResponse.statusCode == 201) {
          } else {
            feeDone = false;
          }
        }
        String message = 'Service Created Successfully';
        String errorMessage =
            'Service Created\nBut Something Went Wrong with\n';

        if (!materialDone) {
          errorMessage += ' Material';
        }
        if (!partDone) {
          if (errorMessage !=
              'Service Created But Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Part';
        }
        if (!laborDone) {
          if (errorMessage !=
              'Service Created But Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Labor';
        }
        if (!subcontractDone) {
          if (errorMessage !=
              'Service Created But Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Sub Contract';
        }
        if (!feeDone) {
          if (errorMessage !=
              'Service Created But Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Fee';
        }
        if (errorMessage != 'Service Created But Something Went Wrong with\n') {
          message = errorMessage;
        }

        emit(CreateCannedOrderServiceSuccessState(message: message));
      } else {
        emit(const CreateCannedOrderServiceErrorState(
            message: 'Something went wrong'));
      }
    } catch (e) {
      log("$e Create service bloc error");
      emit(const CreateCannedOrderServiceErrorState(
          message: "Something went wrong"));
    }
  }
}
