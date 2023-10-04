import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/canned_service_model.dart';
import 'package:auto_pilot/Models/client_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/vendor_response_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    on<EditCannedOrderServiceEvent>(editCannedOrderService);
    on<GetAllVendorsEvent>(getAllVendors);
    on<DeleteCannedServiceEvent>(deleteCannedService);
    on<GetClientByIdEvent>(getClientById);
    on<EditOrderServiceEvent>(editOrderService);
    on<CreateVendorEvent>(createVendorEvent);
  }

  Future<void> createVendorEvent(
    CreateVendorEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(CreateVendorLoadingState());
      final clientId = await AppUtils.getUserID();
      final token = await AppUtils.getToken();
      final response = await apiRepo.createVendor(
          clientId, event.name, event.email, event.contactPerson, token);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decodedBody = json.decode(response.body);
        emit(CreateVendorSuccessState(
            vendorId: decodedBody['created_id'].toString()));
      } else {
        final body = await json.decode(response.body);
        if (body.containsKey('message')) {
          emit(CreateVendorErrorState(message: body['message']));
        } else {
          emit(CreateVendorErrorState(message: body[body.keys.first][0]));
        }
      }
    } catch (e) {
      emit(const CreateVendorErrorState(message: "Something went wrong"));
    }
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

  Future<void> getClientById(
      GetClientByIdEvent event, Emitter<ServiceState> emit) async {
    try {
      final response = await apiRepo.getClientByClientId();
      if (response.statusCode == 200) {
        final body = await jsonDecode(response.body);
        emit(GetClientSuccessState(
            client: ClientModel.fromJson(body['client'])));
      } else {
        emit(const GetClientErrorState(message: 'Something went wrong'));
      }
    } catch (e) {
      emit(const GetClientErrorState(message: 'Something went wrong'));
    }
  }

  Future<void> editCannedOrderService(
    EditCannedOrderServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      bool materialDone = true;
      bool partDone = true;
      bool laborDone = true;
      bool subcontractDone = true;
      bool feeDone = true;
      emit(EditCannedServiceLoadingState());
      final token = await AppUtils.getToken();
      final Response serviceCreateResponse =
          await apiRepo.editCannedOrderService(token, event.service, event.id);

      if (serviceCreateResponse.statusCode == 200 ||
          serviceCreateResponse.statusCode == 201) {
        serviceId = int.parse(event.id);
        if (event.material != null && event.material!.isNotEmpty) {
          // ignore: avoid_function_literals_in_foreach_calls
          event.material!.forEach((material) async {
            final Response materialResponse = await apiRepo
                .createCannedOrderServiceItem(token, material, serviceId);
            if (materialResponse.statusCode == 200 ||
                materialResponse.statusCode == 201) {
            } else {
              materialDone = false;
            }
          });
        }
        if (event.part != null && event.part!.isNotEmpty) {
          for (var part in event.part!) {
            final Response partResponse = await apiRepo
                .createCannedOrderServiceItem(token, part, serviceId);
            if (partResponse.statusCode == 200 ||
                partResponse.statusCode == 201) {
            } else {
              partDone = false;
            }
          }
        }
        if (event.labor != null && event.labor!.isNotEmpty) {
          for (var labor in event.labor!) {
            final Response laborResponse = await apiRepo
                .createCannedOrderServiceItem(token, labor, serviceId);
            if (laborResponse.statusCode == 200 ||
                laborResponse.statusCode == 201) {
            } else {
              laborDone = false;
            }
          }
        }
        if (event.subcontract != null && event.subcontract!.isNotEmpty) {
          for (var subcontract in event.subcontract!) {
            final Response subcontractResponse = await apiRepo
                .createCannedOrderServiceItem(token, subcontract, serviceId);
            if (subcontractResponse.statusCode == 200 ||
                subcontractResponse.statusCode == 201) {
            } else {
              subcontractDone = false;
            }
          }
        }
        if (event.fee != null && event.fee!.isNotEmpty) {
          for (var fee in event.fee!) {
            final Response feeResponse = await apiRepo
                .createCannedOrderServiceItem(token, fee, serviceId);
            if (feeResponse.statusCode == 200 ||
                feeResponse.statusCode == 201) {
            } else {
              feeDone = false;
            }
          }
        }
        if ((event.deletedItems ?? []).isNotEmpty) {
          for (var element in event.deletedItems!) {
            await apiRepo.deleteCannedServiceItem(token, element);
          }
        }
        if ((event.editedItems ?? []).isNotEmpty) {
          for (var element in event.editedItems!) {
            try {
              final Response editResponse =
                  await apiRepo.editCannedOrderServiceItems(
                      token, element, element.id, event.id);
              if (editResponse.statusCode != 200) {
                if (element.itemType == "Material") {
                  materialDone = false;
                } else if (element.itemType == 'Part') {
                  partDone = false;
                } else if (element.itemType == 'Labor') {
                  laborDone = false;
                } else if (element.itemType == "Fee") {
                  feeDone = false;
                } else if (element.itemType == 'SubContract') {
                  subcontractDone = false;
                }
              }
            } catch (e) {
              if (element.itemType == "Material") {
                materialDone = false;
              } else if (element.itemType == 'Part') {
                partDone = false;
              } else if (element.itemType == 'Labor') {
                laborDone = false;
              } else if (element.itemType == "Fee") {
                feeDone = false;
              } else if (element.itemType == 'SubContract') {
                subcontractDone = false;
              }
            }
          }
        }
        String message = 'Service Updated Successfully';
        String errorMessage =
            'Service Updated\nBut Something Went Wrong with\n';

        if (!materialDone) {
          errorMessage += ' Material';
        }
        if (!partDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Part';
        }
        if (!laborDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Labor';
        }
        if (!subcontractDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Sub Contract';
        }
        if (!feeDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Fee';
        }
        if (errorMessage !=
            'Service Updated\nBut Something Went Wrong with\n') {
          message = errorMessage;
        }

        emit(EditCannedServiceSuccessState(message: message));
      } else {
        final decodedBody = await jsonDecode(serviceCreateResponse.body);
        if (decodedBody.containsKey('service_note')) {
          emit(CreateCannedOrderServiceErrorState(
              message: decodedBody['service_note'][0]));
        } else {
          emit(const CreateCannedOrderServiceErrorState(
              message: "Something went wrong"));
        }
      }
    } catch (e) {
      emit(const EditCannedServiceErrorState(message: "Something went wrong"));
    }
  }

  Future<void> editOrderService(
    EditOrderServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      bool materialDone = true;
      bool partDone = true;
      bool laborDone = true;
      bool subcontractDone = true;
      bool feeDone = true;
      emit(EditCannedServiceLoadingState());
      final token = await AppUtils.getToken();
      final Response serviceCreateResponse = await apiRepo.editOrderService(
          token, event.service, event.id, event.technicianId);

      if (serviceCreateResponse.statusCode == 200 ||
          serviceCreateResponse.statusCode == 201) {
        serviceId = int.parse(event.id);
        if (event.material != null && event.material!.isNotEmpty) {
          // ignore: avoid_function_literals_in_foreach_calls
          event.material!.forEach((material) async {
            final Response materialResponse =
                await apiRepo.editOrderServiceItem(token, material, serviceId);
            if (materialResponse.statusCode == 200 ||
                materialResponse.statusCode == 201) {
            } else {
              materialDone = false;
            }
          });
        }
        if (event.part != null && event.part!.isNotEmpty) {
          for (var part in event.part!) {
            final Response partResponse =
                await apiRepo.editOrderServiceItem(token, part, serviceId);
            if (partResponse.statusCode == 200 ||
                partResponse.statusCode == 201) {
            } else {
              partDone = false;
            }
          }
        }
        if (event.labor != null && event.labor!.isNotEmpty) {
          for (var labor in event.labor!) {
            final Response laborResponse =
                await apiRepo.editOrderServiceItem(token, labor, serviceId);
            if (laborResponse.statusCode == 200 ||
                laborResponse.statusCode == 201) {
            } else {
              laborDone = false;
            }
          }
        }
        if (event.subcontract != null && event.subcontract!.isNotEmpty) {
          for (var subcontract in event.subcontract!) {
            final Response subcontractResponse = await apiRepo
                .editOrderServiceItem(token, subcontract, serviceId);
            if (subcontractResponse.statusCode == 200 ||
                subcontractResponse.statusCode == 201) {
            } else {
              subcontractDone = false;
            }
          }
        }
        if (event.fee != null && event.fee!.isNotEmpty) {
          for (var fee in event.fee!) {
            final Response feeResponse =
                await apiRepo.editOrderServiceItem(token, fee, serviceId);
            if (feeResponse.statusCode == 200 ||
                feeResponse.statusCode == 201) {
            } else {
              feeDone = false;
            }
          }
        }
        if (event.deletedItems!.isNotEmpty) {
          for (var element in event.deletedItems!) {
            final Response deleteResponse =
                await apiRepo.deleteOrderServiceItem(token, element);
            if (deleteResponse.statusCode == 200 ||
                deleteResponse.statusCode == 201) {
            } else {}
          }
        }
        if ((event.editedItems ?? []).isNotEmpty) {
          for (var element in event.editedItems!) {
            try {
              final Response editResponse = await apiRepo.editOrderServiceItems(
                  token, element, element.id, event.id);
              log(editResponse.body);
              if (editResponse.statusCode != 200) {
                if (element.itemType == "Material") {
                  materialDone = false;
                } else if (element.itemType == 'Part') {
                  partDone = false;
                } else if (element.itemType == 'Labor') {
                  laborDone = false;
                } else if (element.itemType == "Fee") {
                  feeDone = false;
                } else if (element.itemType == 'SubContract') {
                  subcontractDone = false;
                }
              }
            } catch (e) {
              if (element.itemType == "Material") {
                materialDone = false;
              } else if (element.itemType == 'Part') {
                partDone = false;
              } else if (element.itemType == 'Labor') {
                laborDone = false;
              } else if (element.itemType == "Fee") {
                feeDone = false;
              } else if (element.itemType == 'SubContract') {
                subcontractDone = false;
              }
            }
          }
        }
        String message = 'Service Updated Successfully';
        String errorMessage =
            'Service Updated\nBut Something Went Wrong with\n';

        if (!materialDone) {
          errorMessage += ' Material';
        }
        if (!partDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Part';
        }
        if (!laborDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Labor';
        }
        if (!subcontractDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Sub Contract';
        }
        if (!feeDone) {
          if (errorMessage !=
              'Service Updated\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Fee';
        }
        if (errorMessage !=
            'Service Updated\nBut Something Went Wrong with\n') {
          message = errorMessage;
        }

        emit(EditOrderServiceSuccessState(message: message));
      } else {
        final decodedBody = await jsonDecode(serviceCreateResponse.body);
        if (decodedBody.containsKey('service_note')) {
          emit(CreateCannedOrderServiceErrorState(
              message: decodedBody['service_note'][0]));
        } else {
          emit(const CreateCannedOrderServiceErrorState(
              message: "Something went wrong"));
        }
      }
    } catch (e) {
      emit(const EditCannedServiceErrorState(message: "Something went wrong"));
    }
  }

  Future<void> deleteCannedService(
    DeleteCannedServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      emit(DeleteCannedServiceLoadingState());
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.deleteCannedService(token, event.id);
      if (response.statusCode == 200) {
        emit(DeleteCannedServiceSuccessState());
      } else {
        final body = await jsonDecode(response.body);
        emit(
            DeleteCannedServiceErrorState(message: body['message'].toString()));
      }
    } catch (e) {
      emit(
          const DeleteCannedServiceErrorState(message: 'Something went wrong'));
    }
  }

  Future<void> getAllVendors(
    GetAllVendorsEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      Response getProvinceRes =
          await apiRepo.getAllVendors(token!, currentPage);
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
      emit(const GetAllVendorsErrorState(message: 'Something went wrong'));
    }
  }

  getAllServices(
    GetAllServicess event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      CannedServiceModel cannedServiceModel;
      emit(ServiceDetailsLoadingState());
      if (currentPage == 1) {
        isEmployeesLoading = true;
      }

      final token = await AppUtils.getToken();
      await apiRepo.getServices(token, currentPage, event.query).then((value) {
        if (value.statusCode == 200) {
          cannedServiceModel = cannedServiceModelFromJson(value.body);
          emit(
              GetAllCannedServiceState(cannedServiceModel: cannedServiceModel));
          final data = cannedServiceModel.data;
          currentPage = data.currentPage ?? 0;
          totalPages = data.lastPage ?? 0;
          if (currentPage <= totalPages) {
            currentPage++;
          }
        } else {
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

      if (serviceCreateResponse.statusCode == 200 ||
          serviceCreateResponse.statusCode == 201) {
        final body = jsonDecode(serviceCreateResponse.body);
        serviceId = body['created_id'];
        if (event.material != null) {
          event.material!.forEach((material) async {
            final Response materialResponse = await apiRepo
                .createCannedOrderServiceItem(token, material, serviceId);
            if (materialResponse.statusCode == 200 ||
                materialResponse.statusCode == 201) {
            } else {
              materialDone = false;
            }
          });
        }
        if (event.part != null) {
          for (var part in event.part!) {
            final Response partResponse = await apiRepo
                .createCannedOrderServiceItem(token, part, serviceId);
            if (partResponse.statusCode == 200 ||
                partResponse.statusCode == 201) {
            } else {
              partDone = false;
            }
          }
        }
        if (event.labor != null) {
          for (var labor in event.labor!) {
            final Response laborResponse = await apiRepo
                .createCannedOrderServiceItem(token, labor, serviceId);
            if (laborResponse.statusCode == 200 ||
                laborResponse.statusCode == 201) {
            } else {
              laborDone = false;
            }
          }
        }
        if (event.subcontract != null) {
          for (var subcontract in event.subcontract!) {
            final Response subcontractResponse = await apiRepo
                .createCannedOrderServiceItem(token, subcontract, serviceId);
            if (subcontractResponse.statusCode == 200 ||
                subcontractResponse.statusCode == 201) {
            } else {
              subcontractDone = false;
            }
          }
        }
        if (event.fee != null) {
          for (var fee in event.fee!) {
            final Response feeResponse = await apiRepo
                .createCannedOrderServiceItem(token, fee, serviceId);
            if (feeResponse.statusCode == 200 ||
                feeResponse.statusCode == 201) {
            } else {
              feeDone = false;
            }
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
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Part';
        }
        if (!laborDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Labor';
        }
        if (!subcontractDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Sub Contract';
        }
        if (!feeDone) {
          if (errorMessage !=
              'Service Created\nBut Something Went Wrong with\n') {
            errorMessage += ',';
          }
          errorMessage += ' Fee';
        }
        if (errorMessage !=
            'Service Created\nBut Something Went Wrong with\n') {
          message = errorMessage;
        }

        emit(CreateCannedOrderServiceSuccessState(message: message));
      } else {
        final decodedBody = await jsonDecode(serviceCreateResponse.body);
        if (decodedBody.containsKey('service_note')) {
          emit(CreateCannedOrderServiceErrorState(
              message: decodedBody['service_note'][0]));
        } else {
          emit(const CreateCannedOrderServiceErrorState(
              message: "Something went wrong"));
        }
      }
    } catch (e) {
      emit(const CreateCannedOrderServiceErrorState(
          message: "Something went wrong"));
    }
  }
}
