import 'package:flutter/material.dart';

import 'package:auto_pilot/Models/employee_creation_model.dart';

import 'api_provider.dart';

class ApiRepository {
  final apiProvider = ApiProvider();

  Future createAccount(
      String firstName, lastName, email, phoneNumber, password) {
    return apiProvider.createAccount(
        firstName, lastName, email, password, phoneNumber);
  }

  Future login(String email, password) {
    return apiProvider.login(email, password);
  }

  Future getRevenueChartData(dynamic token) {
    return apiProvider.getRevenueChartData(token);
  }

  Future resetPasswordGetOtp(String emailId) {
    return apiProvider.resetPasswordGetOtp(emailId);
  }

  Future resetPasswordSendOtp(String emailId, String otp) {
    return apiProvider.resetPasswordSendOtp(emailId, otp);
  }

  Future getUserProfile(String token) {
    return apiProvider.getUserProfile(token);
  }

  Future getEmployees(String token, int currentPage) {
    return apiProvider.getEmployees(token, currentPage);
  }

  Future customerLoad(
    String token,
  ) {
    return apiProvider.customerLoad(token);
  }

  Future addCustomerload(
    token,
    BuildContext context,
    firstName,
    lastName,
    email,
    mobileNo,
    customerNotes,
    address,
    state,
    city,
    pinCode,
  ) {
    return apiProvider.addCustomerload(token, context, firstName, lastName,
        email, mobileNo, customerNotes, address, state, city, pinCode);
  }

  Future createEmployee(String token, EmployeeCreationModel model) {
    return apiProvider.createEmployee(token, model);
  }

  Future getAllRoles(String token) {
    return apiProvider.getAllRoles(token);
  }
}

class NetworkError extends Error {}
