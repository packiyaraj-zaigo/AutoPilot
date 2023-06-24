import 'dart:async';
import 'dart:convert';

import 'package:auto_pilot/Screens/customers_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Models/customer_model.dart';
import '../../api_provider/api_repository.dart';
import '../../utils/app_utils.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  bool isEmployeesLoading = false;
  bool isPaginationLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  final _apiRepository = ApiRepository();
  int showLoading = 0;
  final JsonDecoder _decoder = const JsonDecoder();

  CustomerBloc() : super(AddCustomerInitial()) {
    on<customerDetails>(CustomerEvent);
    on<AddCustomerDetails>(addCustomerEvent);
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
        print('=======-------------------------${loadedResponse.body}');
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
          event.pinCode);
      var unloadData = _decoder.convert(loadedResponse.body);
      print('nnnnnnnnnnnnnnnnnnnnnnnnnn');

      print(unloadData.toString());
      if (loadedResponse.statusCode == 200 ||
          loadedResponse.statusCode == 201) {
        print('sssvvvvvvvvvvvvvvvvvvvvvvvs');

        ScaffoldMessenger.of((event.context)).showSnackBar(SnackBar(
            content: Text('${unloadData['message']}'),
            backgroundColor: Colors.green));
        Navigator.of(event.context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => CustomersScreen(),
          ),
          (route) => false,
        );
      } else {
        emit(AddCustomerError(message: unloadData));
      }
    } catch (e) {
      showLoading = 0;
      emit(AddCustomerError(message: e.toString()));
    }
  }
}
