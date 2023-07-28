import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/cutomer_message_model.dart' as cm;

import 'package:auto_pilot/Screens/customers_screen.dart';
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
        log(loadedResponse.body.toString() + "preivew api call");
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
      print('nnnnnnnnnnnnnnnnnnnnnnnnnn');

      print(unloadData.toString());
      if (loadedResponse.statusCode == 200 ||
          loadedResponse.statusCode == 201) {
        print('sssvvvvvvvvvvvvvvvvvvvvvvvs');

        emit(CreateCustomerState());

        // Navigator.of(event.context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => CustomersScreen(),
        //   ),
        //   (route) => false,
        // );
      }
    } catch (e) {
      showLoading = 0;
      emit(AddCustomerError(message: e.toString()));
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
      print('nnnnnnnnnnnnnnnnnnnnnnnnnn');

      print(unloadData.toString());
      if (loadedResponse.statusCode == 200 ||
          loadedResponse.statusCode == 201) {
        print('sssvvvvvvvvvvvvvvvvvvvvvvvs');

        Navigator.of(event.context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CustomersScreen(),
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
      print(messageCurrentPage.toString() + "currrent paggee");
      // emit(GetCustomerMessagePaginationLoadingState());

      final token = await AppUtils.getToken();
      final clientId = await AppUtils.getUserID();
      cm.CustomerMessageModel messageModel;
      log(messageCurrentPage.toString() + ":::::::::::::::::");
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
      print(e.toString() + "Catch error");
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
        Navigator.of(event.context).pushReplacement(MaterialPageRoute(
          builder: (context) {
            return CustomersScreen();
          },
        ));
        print('lllllllllll');
        final responseBody = jsonDecode(loadedResponse.body);
        emit(
          DeleteCustomer(
            customer: Data.fromJson(
              responseBody['data'],
            ),
          ),
        );
      }
      print('ccccccccc${loadedResponse.body}ccccccc');
    } catch (e) {
      showLoading = 0;
      emit(DeleteCustomerErrorState(errorMsg: "Something went wrong"));
    }
  }
}
