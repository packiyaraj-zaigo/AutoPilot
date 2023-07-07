import 'package:auto_pilot/Models/time_card_create_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../Models/vechile_dropdown_model.dart';
import '../Models/employee_creation_model.dart';
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

  Future createNewPassword(
      String email, String password, String passwordConfirm, String newToken) {
    return apiProvider.createNewPassword(
        email, password, passwordConfirm, newToken);
  }

  Future getUserProfile(String token) {
    return apiProvider.getUserProfile(token);
  }

  Future getEmployees(String token, int currentPage, String query) {
    return apiProvider.getEmployees(token, currentPage, query);
  }

  Future getServices(String token, int currentPage, String query) {
    return apiProvider.getServices(token, currentPage, query);
  }

  Future customerLoad(
    String token,
    int currentPage,
    String query,
  ) {
    return apiProvider.customerLoad(token, currentPage, query);
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

  Future getVechile(String token, int currentPage, String query) {
    return apiProvider.getVechile(token, currentPage, query);
  }

  Future addVechile(
    BuildContext context,
    String token,
    String email,
    String year,
    String model,
    String submodel,
    String engine,
    String color,
    String vinNumber,
    String licNumber,
    String type,
    String make,
  ) {
    return apiProvider.addVechile(
      context,
      token,
      email,
      year,
      model,
      submodel,
      engine,
      color,
      vinNumber,
      licNumber,
      type,
      make,
    );
  }

  Future dropdownVechile(String token) {
    return apiProvider.dropdownVechile(token);
  }

  Future getVinDetailsGlobal(String vin) {
    return apiProvider.getVinDetailsGlobal(vin);
  }

  Future getVinDetailsLocal(String token, String vin) {
    return apiProvider.getVinDetailsLocal(token, vin);
  }

  Future getLicDetails(String token, String lic) {
    return apiProvider.getLicDetails(token, lic);
  }

  Future getVehicleEstimates(String token, String vehicleId, int page) {
    return apiProvider.getVehicleEstimates(token, vehicleId, page);
  }

  Future getEstimate(dynamic token, String orderStatus, int currentPage) {
    return apiProvider.getEstimate(token, orderStatus, currentPage);
  }

  Future getNotifications(String token, String clientId, int page) {
    return apiProvider.getNotifications(token, clientId, page);
  }

  Future getParts(String token, int currentPage, String query) {
    return apiProvider.getParts(token, currentPage, query);
  }

  Future getAllTimeCards(String token) {
    return apiProvider.getAllTimeCards(token);
  }

  Future createTimeCard(String token, TimeCardCreateModel timeCard) {
    return apiProvider.createTimeCard(token, timeCard);
  }

  Future addParts(
    BuildContext context,
    String token,
    String itemname,
    String serialnumber,
    String quantity,
    String fee,
    String supplies,
    String epa,
    String cost,
    String type,
  ) {
    return apiProvider.addParts(token, context, itemname, serialnumber,
        quantity, fee, supplies, epa, cost, type);
  }

  Future getProvince(String token, int currentPage) {
    return apiProvider.getProvince(token, currentPage);
  }

  Future addCompany(
      Map<String, dynamic> dataMap, dynamic token, String clientId) {
    return apiProvider.addCompany(dataMap, token, clientId);
  }

  Future getCustomerMessages(String token, String clientId, int currentPage) {
    return apiProvider.getCustomerMessages(token, clientId, currentPage);
  }

  Future sendCustomerMessage(
      String token, String clientId, String customerId, String messageBody) {
    return apiProvider.sendCustomerMessage(
        token, clientId, customerId, messageBody);
  }

  Future createNewEstimate(int customerId, int vehicleId, dynamic token) {
    return apiProvider.createNewEstimate(customerId, vehicleId, token);
  }
}

class NetworkError extends Error {}
