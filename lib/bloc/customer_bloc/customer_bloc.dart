// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/create_estimate_model.dart' as ce;
import 'package:auto_pilot/Models/customer_note_model.dart';
import 'package:auto_pilot/Models/cutomer_message_model.dart' as cm;
import 'package:auto_pilot/Models/estimate_model.dart' as em;
import 'package:auto_pilot/Models/vechile_model.dart' as vm;

import 'package:auto_pilot/Screens/customers_screen.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/customer_model.dart';
import '../../Models/province_model.dart' as data;
import '../../api_provider/api_repository.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_utils.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  bool isEmployeesLoading = false;
  bool isPaginationLoading = false;

  bool isMessageLoading = false;
  bool isMessagePaginationLoading = false;

  int messageCurrentPage = 1;
  int messageTotalPage = 1;
  bool isFetching = false;
  int currentPage = 1;
  int totalPages = 1;
  int? newMessageCurrentPage;
  bool isVechileLoading = false;
  bool isPagenationLoading = false;
  final _apiRepository = ApiRepository();
  int showLoading = 0;
  final JsonDecoder _decoder = const JsonDecoder();

  CustomerBloc() : super(AddCustomerInitial()) {
    on<customerDetails>(CustomerEvent);
    on<AddCustomerDetails>(addCustomerEvent);
    on<GetCustomerMessageEvent>(getCustomerMessageBloc);
    on<SendCustomerMessageEvent>(sendCustomerMessageBloc);
    on<GetProvinceEvent>(getProvinceBloc);
    on<GetCustomerMessagePaginationEvent>(getCustomerMessagePaginationBloc);
    on<DeleteCustomerEvent>(deleteCustomer);
    on<EditCustomerDetails>(editCustomerEvent);
    on<CreateCustomerNoteEvent>(createCustomerNotes);
    on<DeleteCustomerNoteEvent>(deleteCustomerNotes);
    on<GetAllCustomerNotesEvent>(getAllCustomerNotes);
    on<GetCustomerEstimatesEvent>(getCustomerEstimates);
    on<GetSingleEstimateEvent>(getSingleEstimate);
    on<GetCustomerVehiclesEvent>(getCustomerVehicles);
    on<GetSingleCustomerEvent>(getSingleCustomer);
  }

  getCustomerVehicles(
    GetCustomerVehiclesEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(GetCustomerVehiclesLoadingState());
      if (currentPage == 1) {
        isVechileLoading = true;
      }

      final token = await AppUtils.getToken();
      Response response =
          await _apiRepository.getVechile(token, currentPage, "", event.id);
      if (response.statusCode == 200) {
        print(response.body);
        final responseBody = jsonDecode(response.body);
        emit(
          GetCustomerVehiclesSuccessState(
            vehicles: vm.VechileResponse.fromJson(
              responseBody,
            ),
          ),
        );
        final data = responseBody['data'];
        currentPage = data['current_page'] ?? 1;

        totalPages = data['last_page'] ?? 1;
        print(totalPages.toString() + ':::::::::::::::');
        if (currentPage <= totalPages) {
          currentPage++;
        }
        print(response.body.toString());
      } else {
        log(response.body.toString());
        final body = jsonDecode(response.body);
        emit(GetCustomerVehiclesErrorState(message: body['message']));
      }
      isVechileLoading = false;
      isPagenationLoading = false;
    } catch (e, s) {
      log(s.toString() + " Get customer vehicles bloc error");
      emit(GetCustomerVehiclesErrorState(message: "Something went wrong"));
      isVechileLoading = false;
      isPagenationLoading = false;
    }
  }

  Future<void> getSingleCustomer(
    GetSingleCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(GetSingleCustomerLoadingState());

      final token = await AppUtils.getToken();
      final response = await _apiRepository.getSingleCustomer(token, event.id);
      if (response.statusCode == 200) {
        final body = await json.decode(response.body);
        emit(GetSingleCustomerSuccessState(
            customer: Datum.fromJson(body['customer'])));
      } else {
        emit(GetSingleCustomerErrorState(message: "Something went wrong"));
      }
    } catch (e) {
      emit(GetSingleCustomerErrorState(message: "Something went wrong"));
    }
  }

  Future<void> getCustomerEstimates(
    GetCustomerEstimatesEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      em.EstimateModel estimateModel;

      if (currentPage == 1) {
        emit(GetCustomerEstimatesLoadingState());
      }

      Response getEstimateRes = await _apiRepository.getEstimate(
          token, "", currentPage, event.customerId);

      log("res${getEstimateRes.body}");

      if (getEstimateRes.statusCode == 200) {
        estimateModel = em.estimateModelFromJson(getEstimateRes.body);
        totalPages = estimateModel.data.lastPage ?? 1;
        isFetching = false;
        emit(GetCustomerEstimatesSuccessState(estimateData: estimateModel));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      } else {
        emit(const GetCustomerEstimatesErrorState(
            message: "Something went wrong"));
      }
    } catch (e) {
      emit(const GetCustomerEstimatesErrorState(
          message: "Something went wrong"));
      log("$e Get estimates bloc error");
    }
  }

  Future<void> getSingleEstimate(
    GetSingleEstimateEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      ce.CreateEstimateModel createEstimateModel;

      Response singleEstimate =
          await _apiRepository.getSingleEstimate(token!, event.orderId);

      log("res${singleEstimate.body}");

      if (singleEstimate.statusCode == 200) {
        createEstimateModel =
            ce.createEstimateModelFromJson(singleEstimate.body);
        emit(GetSingleEstimateState(createEstimateModel: createEstimateModel));
      } else {
        emit(const GetCustomerEstimatesErrorState(
            message: "Something went wrong"));
      }
    } catch (e) {
      emit(const GetCustomerEstimatesErrorState(
          message: "Something went wrong"));
      log(e.toString() + "Get single estimate error customer");
    }
  }

  Future<void> getAllCustomerNotes(
    GetAllCustomerNotesEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(GetCustomerNotesLoadingState());
      final token = await AppUtils.getToken();

      final response =
          await _apiRepository.getAllCustomerNotes(token, event.id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = await json.decode(response.body);
        final List<CustomerNoteModel> notes = [];
        if (body['data'] != null && body['data'].isNotEmpty) {
          body['data'].forEach((note) {
            notes.add(CustomerNoteModel.fromJson(note));
          });
        }
        emit(GetCustomerNotesSuccessState(notes: notes));
      } else {
        emit(const GetCustomerNotesErrorState(
            message: 'Unable to delete the note'));
      }
    } catch (e) {
      log("$e Delete note bloc error");
      emit(const GetCustomerNotesErrorState(message: "Something went wrong"));
    }
  }

  Future<void> createCustomerNotes(
    CreateCustomerNoteEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(CreateCustomerNoteLoadingState());
      final token = await AppUtils.getToken();
      final clientId = await AppUtils.getUserID();

      final response = await _apiRepository.createCustomerNotes(
          token, event.notes, event.customerId, clientId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateCustomerNoteSuccessState());
      } else {
        emit(const CreateCustomerNoteErrorState(
            message: 'Unable to create the note'));
      }
    } catch (e) {
      log("$e Create note bloc error");
      emit(const CreateCustomerNoteErrorState(message: "Something went wrong"));
    }
  }

  Future<void> deleteCustomerNotes(
    DeleteCustomerNoteEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(DeleteCustomerNoteLoadingState());
      final token = await AppUtils.getToken();

      final response =
          await _apiRepository.deleteCustomerNotes(token, event.id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(DeleteCustomerNoteSuccessState());
      } else {
        emit(const DeleteCustomerNoteErrorState(
            message: 'Unable to delete the note'));
      }
    } catch (e) {
      log("$e Delete note bloc error");
      emit(const DeleteCustomerNoteErrorState(message: "Something went wrong"));
    }
  }

  Future<void> CustomerEvent(
    customerDetails event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(CustomerLoading());
      if (currentPage == 1) {
        isEmployeesLoading = true;
      } else {
        isEmployeesLoading = false;
      }
      final token = await AppUtils.getToken();
      Response loadedResponse =
          await _apiRepository.customerLoad(token, currentPage, event.query);
      if (loadedResponse.statusCode == 200) {
        final responseBody = jsonDecode(loadedResponse.body);
        emit(
          CustomerReady(
            customer: Data.fromJson(
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
        // emit(CustomerReady(data: customerModelFromJson(loadedResponse.body)));
        log("${loadedResponse.body}preivew api call");
      } else {
        final body = jsonDecode(loadedResponse.body);
        emit(CustomerError(message: body['message']));
      }
      isEmployeesLoading = false;
      isPaginationLoading = false;
    } catch (e) {
      showLoading = 0;
      emit(CustomerError(message: e.toString()));
      isEmployeesLoading = false;
      isPaginationLoading = false;
    }
  }

  Future<void> addCustomerEvent(
    AddCustomerDetails event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      emit(AddCustomerLoading());
      Response loadedResponse = await _apiRepository.addCustomerload(
          token,
          (event.context),
          event.firstName,
          event.lastName,
          event.email,
          event.mobileNo,
          event.customerNotes,
          event.address,
          event.state,
          event.city,
          event.pinCode,
          event.stateId);
      var unloadData = _decoder.convert(loadedResponse.body);
      log(unloadData.toString());
      if (loadedResponse.statusCode == 200 ||
          loadedResponse.statusCode == 201) {
        emit(CreateCustomerState(id: unloadData['created_id'].toString()));
      } else {
        if (unloadData.containsKey('message')) {
          emit(AddCustomerError(message: unloadData['message']));
        } else if (unloadData.containsKey('error')) {
          emit(AddCustomerError(message: unloadData['error']));
        } else {
          emit(AddCustomerError(
              message: unloadData[unloadData.keys.first][0].toString()));
        }
      }
    } catch (e) {
      showLoading = 0;
      emit(AddCustomerError(message: "Something went wrong"));
    }
  }

  Future<void> editCustomerEvent(
    EditCustomerDetails event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      emit(EditCustomerLoading());
      Response loadedResponse = await _apiRepository.editCustomerload(
          token,
          (event.context),
          event.firstName,
          event.lastName,
          event.email,
          event.mobileNo,
          event.customerNotes,
          event.address,
          event.state,
          event.city,
          event.pinCode,
          event.stateId,
          event.id);
      var unloadData = _decoder.convert(loadedResponse.body);
      if (loadedResponse.statusCode == 200 ||
          loadedResponse.statusCode == 201) {
        CommonWidgets()
            .showSuccessDialog(event.context, 'Customer Updated Successfully');
        Navigator.of(event.context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const CustomersScreen(),
          ),
          (route) => false,
        );
      } else {
        emit(EditCustomerError(message: unloadData));
      }
    } catch (e) {
      showLoading = 0;
      emit(EditCustomerError(message: e.toString()));
    }
  }

  Future<void> getProvinceBloc(
    GetProvinceEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      data.ProvinceModel provinceModel;

      // emit(DashboardLoadingState());

      Response getProvinceRes =
          await _apiRepository.getProvince(token!, currentPage);
      // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${getProvinceRes.body}");

      if (getProvinceRes.statusCode == 200) {
        provinceModel = data.provinceModelFromJson(getProvinceRes.body);
        totalPages = provinceModel.data.lastPage ?? 1;
        isFetching = false;

        print("before emit");
        emit(GetProvinceState(provinceList: provinceModel));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      }
      // else if(createAccRes.statusCode==422){
      //   emit(CreateAccountErrorState());
      //   errorRes=createAccData;
      // }
    } catch (e) {
      // emit(CreateAccountErrorState());

      print(e.toString());
      // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }

  // Future<void> getCustomerMessageBloc(
  //   GetCustomerMessageEvent event,
  //   Emitter<CustomerState> emit,
  // ) async {
  //   try {
  //     emit(GetCustomerMessageLoadingState());
  //     // if (messageCurrentPage == 1) {
  //     //   isMessageLoading = true;
  //     // } else {
  //     //   isMessageLoading = false;
  //     // }
  //     final token = await AppUtils.getToken();
  //     final clientId = await AppUtils.getUserID();
  //     cm.CustomerMessageModel messageModel;

  //     Response messageResponse = await _apiRepository.getCustomerMessages(
  //         token, clientId, messageCurrentPage);
  //     if (messageResponse.statusCode == 200) {
  //       messageModel = cm.customerMessageModelFromJson(messageResponse.body);
  //       messageCurrentPage = messageModel.data.lastPage;

  //       print(messageCurrentPage.toString() + "firstt curreent");
  //       Response newMessageRes = await _apiRepository.getCustomerMessages(
  //           token, clientId, messageCurrentPage);
  //       messageModel = cm.customerMessageModelFromJson(newMessageRes.body);

  //       emit(GetCustomerMessageState(messageModel: messageModel));

  //       log('=======-------------------------${messageResponse.body}');
  //       messageCurrentPage--;
  //     } else {
  //       emit(GetCustomerMessageErrorState(errorMsg: "Something went wrong"));
  //     }

  //     isEmployeesLoading = false;
  //     isPaginationLoading = false;
  //   } catch (e) {
  //     showLoading = 0;
  //     emit(GetCustomerMessageErrorState(errorMsg: "Something went wrong"));
  //     isEmployeesLoading = false;
  //     isPaginationLoading = false;
  //   }
  // }

  Future<void> getCustomerMessageBloc(
    GetCustomerMessageEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      String clientId = await AppUtils.getUserID();

      cm.CustomerMessageModel messageModel;

      if (messageCurrentPage == 1) {
        emit(GetCustomerMessageLoadingState());
      }

      Response getMessageRes = await _apiRepository.getCustomerMessages(
          token!, clientId, messageCurrentPage);

      log("res${getMessageRes.body}");

      if (getMessageRes.statusCode == 200) {
        messageModel = cm.customerMessageModelFromJson(getMessageRes.body);
        messageTotalPage = messageModel.data.lastPage ?? 1;
        isFetching = false;
        emit(GetCustomerMessageState(messageModel: messageModel));

        if (messageTotalPage > messageCurrentPage && messageCurrentPage != 0) {
          messageCurrentPage += 1;
        } else {
          messageCurrentPage = 0;
          print("this works");
        }
      } else {
        emit(const GetCustomerMessageErrorState(
            errorMsg: "Something went wrong"));
      }
    } catch (e, s) {
      emit(
          const GetCustomerMessageErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
      print(s.toString());

      print("thisss");
    }
  }

  Future<void> sendCustomerMessageBloc(
    SendCustomerMessageEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      emit(SendCustomerMessageLoadingState());

      final token = await AppUtils.getToken();
      final clientId = await AppUtils.getUserID();

      Response sendMessageResponse = await _apiRepository.sendCustomerMessage(
          token, clientId, event.customerId, event.messageBody);
      if (sendMessageResponse.statusCode == 409) {
        emit(SendCustomerMessageState());
      } else {
        emit(SendCustomerMessageErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e) {
      emit(GetCustomerMessageErrorState(errorMsg: "Something went wrong"));
    }
  }

  Future<void> getCustomerMessagePaginationBloc(
    GetCustomerMessagePaginationEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      print("${messageCurrentPage}currrent paggee");
      // emit(GetCustomerMessagePaginationLoadingState());

      final token = await AppUtils.getToken();
      final clientId = await AppUtils.getUserID();
      cm.CustomerMessageModel messageModel;
      log("$messageCurrentPage:::::::::::::::::");
      if (messageCurrentPage < 1) {
        return;
      }
      await _apiRepository
          .getCustomerMessages(token, clientId, messageCurrentPage)
          .then((messageResponse) {
        if (messageResponse.statusCode == 200) {
          print("sucesss condition");
          messageModel = cm.customerMessageModelFromJson(messageResponse.body);
          emit(GetCustomerMessagePaginationState(messageModel: messageModel));

          if (messageModel.data.currentPage >= 1) {
            print("thiss workss");
            messageCurrentPage--;
            print(messageCurrentPage);
          }

          print('=======-------------------------${messageResponse.body}');
        }
      });
      //  else {
      //   emit(GetCustomerMessageErrorState(errorMsg: "Something went wrong"));
      // }
      isEmployeesLoading = false;
      isPaginationLoading = false;
    } catch (e) {
      showLoading = 0;
      print("${e}Catch error");
      emit(GetCustomerMessageErrorState(errorMsg: "Something went wrong"));
      isEmployeesLoading = false;
      isPaginationLoading = false;
    }
  }

  Future<void> deleteCustomer(
    DeleteCustomerEvent event,
    Emitter<CustomerState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      emit(DeleteCustomerLoading());
      Response loadedResponse =
          await _apiRepository.deleteCustomer(token, event.customerId);
      var unloadData = _decoder.convert(loadedResponse.body);
      if (loadedResponse.statusCode == 200) {
        emit(
          DeleteCustomer(),
        );
      } else {
        if (unloadData.containsKey('message')) {
          emit(DeleteCustomerErrorState(errorMsg: unloadData['message']));
        } else if (unloadData.containsKey('error')) {
          emit(DeleteCustomerErrorState(errorMsg: unloadData['error']));
        } else {
          throw '';
        }
      }
    } catch (e) {
      showLoading = 0;
      emit(DeleteCustomerErrorState(errorMsg: "Something went wrong"));
    }
  }
}
