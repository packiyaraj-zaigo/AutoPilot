import 'dart:io';

import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/parts_model.dart';
import 'package:auto_pilot/Models/time_card_create_model.dart';
import 'package:auto_pilot/Models/workflow_bucket_model.dart';
import 'package:flutter/material.dart';
import '../Models/employee_creation_model.dart';
import '../Models/workflow_model.dart';
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

  Future deleteCustomer(
    String token,
    String customerId,
  ) {
    return apiProvider.deleteCustomer(token, customerId);
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
    stateId,
  ) {
    return apiProvider.addCustomerload(token, context, firstName, lastName,
        email, mobileNo, customerNotes, address, state, city, pinCode, stateId);
  }

  Future editCustomerload(
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
    stateId,
    id,
  ) {
    return apiProvider.editCustomerload(
        token,
        context,
        firstName,
        lastName,
        email,
        mobileNo,
        customerNotes,
        address,
        state,
        city,
        pinCode,
        stateId,
        id);
  }

  Future createEmployee(String token, EmployeeCreationModel model) {
    return apiProvider.createEmployee(token, model);
  }

  Future getAllRoles(String token) {
    return apiProvider.getAllRoles(token);
  }

  Future calendarload(
    String token,
    DateTime selectedDate,
  ) {
    return apiProvider.calendarload(token, selectedDate);
  }

  Future calendarWeekLoad(
    String token,
    DateTime selectedDate,
  ) {
    return apiProvider.calendarWeekLoad(token, selectedDate);
  }

  Future getVechile(String token, int currentPage, String query,
      [String? customerId]) {
    return apiProvider.getVechile(token, currentPage, query, customerId);
  }

  Future addVechile(
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
    String customerId,
  ) {
    return apiProvider.addVechile(
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
      customerId,
    );
  }

  Future editVechile(
    String token,
    String id,
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
    String customerId,
  ) {
    return apiProvider.editVechile(
      token,
      id,
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
      customerId,
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

  Future getEstimate(dynamic token, String orderStatus, int currentPage,
      [String? customerId]) {
    return apiProvider.getEstimate(token, orderStatus, currentPage, customerId);
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
    return apiProvider.addParts(
      token,
      context,
      itemname,
      serialnumber,
      type,
      quantity,
      fee,
      supplies,
      epa,
      cost,
    );
  }

  Future editParts(
    String token,
    String itemname,
    String serialnumber,
    String quantity,
    String cost,
    String id,
  ) {
    return apiProvider.editParts(
        token, itemname, serialnumber, quantity, cost, id);
  }

  Future deleteParts(String id, String token) async {
    return apiProvider.deleteParts(id, token);
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

  Future createNewEstimate(String id, String which, dynamic token) {
    return apiProvider.createNewEstimate(id, which, token);
  }

  Future createAppointmentEstimate(
      dynamic token,
      String orderId,
      String customerId,
      String vehicleId,
      String startTime,
      String endTime,
      String note) {
    return apiProvider.createAppointmentEstimate(
        token, orderId, customerId, vehicleId, startTime, endTime, note);
  }

  Future editAppointmentEstimate(
      dynamic token,
      String orderId,
      String customerId,
      String vehicleId,
      String startTime,
      String endTime,
      String note,
      String id) {
    return apiProvider.editAppointmentEstimate(
        token, orderId, customerId, vehicleId, startTime, endTime, note, id);
  }

  Future editEstimate(String id, String which, dynamic token, String orderId,
      String customerId, String? dropSchedule) {
    return apiProvider.editEstimate(
        id, which, token, orderId, customerId, dropSchedule);
  }

  Future addEstimateNote(String orderId, String comment, dynamic token) {
    return apiProvider.addEstimateNote(orderId, comment, token);
  }

  Future editEstimateNote(
      String orderId, String comment, dynamic token, String id) {
    return apiProvider.editEstimateNote(orderId, comment, token, id);
  }

  Future deleteEstimateNote(dynamic token, String id) {
    return apiProvider.deleteEstimateNote(token, id);
  }

  Future getAllWorkflows(String token, int page) {
    return apiProvider.getAllWorkflows(token, page);
  }

  Future getWorkflowBucket(String token, int page) {
    return apiProvider.getWorkflowBucket(token, page);
  }

  Future editWorkflowPosition(String token, WorkflowBucketModel workflow) {
    return apiProvider.editWorkflowPosition(token, workflow);
  }

  Future editPart(String token, PartsDatum part) {
    return apiProvider.editPart(part, token);
  }

  Future getTechniciansOnly(String token) {
    return apiProvider.getTechniciansOnly(token);
  }

  Future deleteVechile(String token, String deleteId) {
    return apiProvider.deleteVechile(token, deleteId);
  }

  Future createAppointment(String token, AppointmentCreateModel appointment) {
    return apiProvider.createAppointment(token, appointment);
  }

  Future deleteEmployee(String token, int id) {
    return apiProvider.deleteEmployee(token, id);
  }

  Future editEmployee(String token, EmployeeCreationModel employee, int id) {
    return apiProvider.editEmployee(token, employee, id);
  }

  Future addWorkflowBucket(String token, Map<String, dynamic> json) {
    return apiProvider.addWorkflowBucket(token, json);
  }

  Future<dynamic> createCannedOrderService(
      String token, CannedServiceCreateModel model) {
    return apiProvider.createCannedOrderService(token, model);
  }

  Future<dynamic> createCannedOrderServiceItem(
      String token, CannedServiceAddModel model, int serviceId) {
    return apiProvider.createCannedOrderServiceItem(token, model, serviceId);
  }

  Future<dynamic> editOrderServiceItem(
      String token, CannedServiceAddModel model, int serviceId) {
    return apiProvider.editOrderServiceItem(token, model, serviceId);
  }

  Future<dynamic> getAllVendors(String token, int page) {
    return apiProvider.getAllVendors(token, page);
  }

  Future getSingleEstimate(String token, String orderId) {
    return apiProvider.getSingleEstimate(token, orderId);
  }

  Future getSingleCustomer(String token, String id) {
    return apiProvider.getSingleCustomer(token, id);
  }

  Future getEstimateNote(String token, String orderId) {
    return apiProvider.getEstimateNote(token, orderId);
  }

  Future getEstimatAppointmentDetails(String token, String orderId) {
    return apiProvider.getEstimateAppointmentDetails(token, orderId);
  }

  Future uploadImage(String token, File imagePath) {
    return apiProvider.uploadImage(token, imagePath);
  }

  Future createOrderImage(
      String token, String orderId, String imageUrl, String inspectionId) {
    return apiProvider.createOrderImage(token, orderId, imageUrl, inspectionId);
  }

  Future createInspectionNote(String token, String orderId) {
    return apiProvider.createInspectionNotes(token, orderId);
  }

  Future getAllOrderImages(String token, String orderId) {
    return apiProvider.getAllOrderImages(token, orderId);
  }

  Future deleteOrderImage(String token, String imageId) {
    return apiProvider.deleteOrderImage(token, imageId);
  }

  Future createOrderService(String token, String orderId, String serviceName,
      String serviceNotes, String laborRate, String tax) {
    return apiProvider.createOrderService(
        token, orderId, serviceName, serviceNotes, laborRate, tax);
  }

  Future createOrderServiceItem(
      dynamic token,
      String cannedServiceId,
      String itemType,
      String itemName,
      String unitPrice,
      String quantityHours,
      String discount,
      String discountType,
      String position,
      String subTotal,
      String tax) {
    return apiProvider.createOrderServiceItem(
        token,
        cannedServiceId,
        itemType,
        itemName,
        unitPrice,
        quantityHours,
        discount,
        discountType,
        position,
        subTotal,
        tax);
  }

  Future deleteCannedService(String token, String serviceId) {
    return apiProvider.deleteCannedService(token, serviceId);
  }

  Future deleteCannedServiceItem(String token, String id) {
    return apiProvider.deleteCannedServiceItem(token, id);
  }

  Future deleteOrderServiceItem(String token, String id) {
    return apiProvider.deleteOrderServiceItem(token, id);
  }

  Future<dynamic> editCannedOrderService(
      String token, CannedServiceCreateModel model, String id) async {
    return apiProvider.editCannedOrderService(token, model, id);
  }

  Future<dynamic> editOrderService(String token, CannedServiceCreateModel model,
      String id, String technicianId) async {
    return apiProvider.editOrderService(token, model, id, technicianId);
  }

  Future<dynamic> getClientByClientId() async {
    return apiProvider.getClientByClientId();
  }

  Future<dynamic> deleteOrderService(dynamic token, String id) async {
    return apiProvider.deleteOrderService(token, id);
  }

  Future<dynamic> sendToCustomerEstimate(
      dynamic token, String customerId, String orderId, String subject) async {
    return apiProvider.sendToCustomerEstimate(
        token, customerId, orderId, subject);
  }

  Future<dynamic> deleteAppointmentEstimate(
      dynamic token, String appointmentId) async {
    return apiProvider.deleteAppointment(token, appointmentId);
  }

  Future<dynamic> collectPayment(
      dynamic token,
      String customerId,
      String orderId,
      String paymentMode,
      String amount,
      String date,
      String notes) async {
    return apiProvider.collectPayment(
        token, customerId, orderId, paymentMode, amount, date, notes);
  }

  Future<dynamic> deleteEstimate(dynamic token, String id) async {
    return apiProvider.deleteEstimate(token, id);
  }

  Future<dynamic> createCustomerNotes(
      String token, String notes, String customerId, String clientId) async {
    return apiProvider.createCustomerNotes(token, notes, customerId, clientId);
  }

  Future<dynamic> deleteCustomerNotes(String token, String id) async {
    return apiProvider.deleteCustomerNotes(token, id);
  }

  Future<dynamic> getAllCustomerNotes(String token, String customerId) async {
    return apiProvider.getAllCustomerNotes(token, customerId);
  }

  Future<dynamic> getVehicleNotes(dynamic token, String vehicleId) async {
    return apiProvider.getVehicleNotes(token, vehicleId);
  }

  Future<dynamic> addVehicleNotes(
      dynamic token, String vehicleId, String notes) async {
    return apiProvider.addVehicleNote(token, vehicleId, notes);
  }

  Future<dynamic> deleteVehicleNotes(dynamic token, String vehicleId) async {
    return apiProvider.deleteVehicleNotes(vehicleId, token);
  }

  Future<dynamic> getPaymentHistory(
      dynamic token, String orderId, int currentPage) async {
    return apiProvider.getPaymentHistroy(orderId, token, currentPage);
  }

  Future<dynamic> getEstimateFromVehicle(
      dynamic token, int currentPage, String vehicleId) async {
    return apiProvider.getEstimateFromVehicle(token, currentPage, vehicleId);
  }
}

class NetworkError extends Error {}
