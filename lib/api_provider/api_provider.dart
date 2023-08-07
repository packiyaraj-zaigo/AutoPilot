import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/parts_model.dart';
import 'package:auto_pilot/Models/time_card_create_model.dart';
import 'package:auto_pilot/Models/workflow_bucket_model.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/canned_service_create.dart';
import '../Models/workflow_model.dart';
import '../Screens/customer_information_screen.dart';
import '../Models/employee_creation_model.dart';
import '../utils/app_constants.dart';

class ApiProvider {
  //DEV Server

  static const BASE_URL =
      'http://ec2-13-235-8-199.ap-south-1.compute.amazonaws.com/';

  late Map<String, String> requestHeaders;

  getHeader(String token) {
    return requestHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }

  Future<dynamic> createAccount(String firstName, String lastName, String email,
      String password, String phoneNumber) async {
    print("into provider");
    final List<String> emptyList = [];
    Map bodymap = {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "emp_phone": phoneNumber,
      "password": password,
      "users": emptyList
    };

    var encodedBody = json.encode(bodymap);
    log(encodedBody.toString());

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/register");
      // var request = http.MultipartRequest("POST", url)
      //   ..fields['email'] = email
      //   ..fields['first_name'] = firstName
      //   ..fields['last_name'] = lastName
      //   ..fields['emp_phone'] = phoneNumber
      //   ..fields['password'] = password
      //   ..fields['users']=json.encode(emptyList);

      var response = http.post(url,
          body: encodedBody,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      //  request.files.add(http.MultipartFile.fromString("users", emptyList));

      // request.headers.addAll(getHeader(token));
      // var response = await request.send();
      // inspect(response);
      // print(response.statusCode.toString() + "provider status code");
      // print(response.toString() + "provider response");
      // return http.Response.fromStream(response);
      inspect(response);
      return response;
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> login(String email, String password) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/login");
      var request = http.MultipartRequest("POST", url)
        ..fields['email'] = email
        ..fields['password'] = password;

      // request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getRevenueChartData(String token) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/dashboard");
      var request = http.MultipartRequest("Get", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> resetPasswordGetOtp(String email) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/password/create");
      var request = http.MultipartRequest("POST", url)..fields['email'] = email;

      // request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> resetPasswordSendOtp(String email, String otp) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse(
        "${BASE_URL}api/password/find?email=$email&code=$otp",
      );
      var request = http.MultipartRequest("GET", url);
      // ..fields['email'] = email
      // ..fields['code'] = otp;

      // request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createNewPassword(String email, String password,
      String passwordConfirm, String newToken) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse(
        "${BASE_URL}api/password/reset?email=$email&password=$password&password_confirmation=$passwordConfirm&token=$newToken",
      );
      var request = http.MultipartRequest("POST", url);
      // ..fields['email'] = email
      // ..fields['code'] = otp;

      // request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getUserProfile(String token) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;

    try {
      var url = Uri.parse(
        "${BASE_URL}api/myprofile",
      );
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getEmployees(String token, int page, String query) async {
    try {
      final clientId = await AppUtils.getUserID();
      String url = '${BASE_URL}api/users?client_id=$clientId';

      if (page != 1) {
        url = '$url&page=$page';
      }
      if (query != '') {
        url = '$url&first_name=$query';
      }
      print(url);
      var response = http.get(Uri.parse(url), headers: getHeader(token));
      return response;
    } catch (e) {
      print(e.toString() + 'get employee error');
    }
  }

  Future<dynamic> getServices(String token, int page, String query) async {
    try {
      final clientId = await AppUtils.getUserID();
      String url =
          '${BASE_URL}api/canned_services?page=$page&orderby=id&sort=DESC&client_id=$clientId';

      if (query != '') {
        url = '$url&service_name=$query';
      }

      print(url);
      var response = http.get(Uri.parse(url), headers: getHeader(token));
      return response;
    } catch (e) {
      print(e.toString() + 'get service error');
    }
  }

  Future<dynamic> getVechile(String token, int page, String query) async {
    try {
      final clientId = await AppUtils.getUserID();
      String url =
          '${BASE_URL}api/vehicles?client_id=$clientId&orderby=id&sort=DESC';
      if (page != 1) {
        url = '$url&page=$page';
      }
      if (query != '') {
        url = '$url&vehicle_model=$query';
        // if (url.contains('?')) {

        // }
        //  else {
        //   url = '$url?vehicle_model=$query';
        // }
      }
      // : '${BASE_URL}api/vehicles?page=${page + 1}';
      var response = await http.get(Uri.parse(url), headers: getHeader(token));
      print(response);
      inspect(response);
      return response;
    } catch (e) {
      print(e.toString() + 'get employee error');
    }
  }

  // Future<dynamic> getVechile(String token) async {
  //   print("into provider");
  //   //  LoadingFormModel? loadingFormModel;
  //   try {
  //     var url = Uri.parse(
  //       "${BASE_URL}api/vehicles",
  //     );
  //     var request = http.MultipartRequest("GET", url);
  //
  //     request.headers.addAll(getHeader(token));
  //     var response = await request.send();
  //     inspect(response);
  //     print(response.statusCode.toString() + "provider status code");
  //     print(response.request!.method + "provider response");
  //     return http.Response.fromStream(response);
  //   } catch (e, s) {
  //     print(e.toString() + "provider error");
  //     print(s);
  //   }
  // }

  Future<dynamic> addVechile(
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
  ) async {
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse("${BASE_URL}api/vehicles?client_id=$clientId");
      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = "Bearer $token  "
        ..fields['vehicle_type'] = type
        ..fields['vehicle_year'] = year
        ..fields['vehicle_make'] = make
        ..fields['vehicle_model'] = model
        ..fields['vehicle_color'] = color
        ..fields['vin'] = vinNumber
        ..fields['sub_model'] = submodel
        ..fields['engine_size'] = engine
        ..fields['licence_plate'] = licNumber;

      // final map = {};
      var response = await request.send();
      inspect(response);
      return http.Response.fromStream(response);
    } catch (e) {
      log(e.toString() + "Edit vehicle api error");
    }
  }

  Future<dynamic> editVechile(
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
  ) async {
    try {
      var url = Uri.parse("${BASE_URL}api/vehicles/$id");
      final map = {};
      map['customer_id'] = 0;
      map['vehicle_type'] = type;
      map['vehicle_year'] = year;
      map['vehicle_make'] = make;
      map['vehicle_model'] = model;
      map['vehicle_color'] = color;
      map['vin'] = vinNumber;
      map['sub_model'] = submodel;
      map['engine_size'] = engine;
      map['licence_plate'] = licNumber;

      var response =
          await http.put(url, body: jsonEncode(map), headers: getHeader(token));
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "Edit vehicle api error");
    }
  }

  Future<dynamic> deleteVechile(
    String token,
    String id,
  ) async {
    try {
      var url = Uri.parse("${BASE_URL}api/vehicles/$id");
      var request = http.MultipartRequest("DELETE", url)
        ..headers['Authorization'] = "Bearer $token";
      var response = await request.send();
      inspect(response);
      return http.Response.fromStream(response);
    } catch (e) {
      log(e.toString() + "Delete vehicle api error");
    }
  }

  Future<dynamic> customerLoad(String token, int page, String query) async {
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse(
          '${BASE_URL}api/customers?client_id=$clientId&page=$page&first_name=$query&orderby=id&sort=DESC');
      var request = http.MultipartRequest("GET", url);
      request.headers.addAll(getHeader(token));
      var response = await request.send();
      print('hggggggggggggg${response.statusCode.toString()}');
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> addCustomerload(
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
  ) async {
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse('${BASE_URL}api/customers?client_id=$clientId');
      print('hjjjjjjjjjjjjjjjj${token}');

      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = "Bearer $token"
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['email'] = email
        ..fields['phone'] = mobileNo
        ..fields['notes'] = customerNotes
        ..fields['address_line_1'] = address
        ..fields['province_name'] = state
        ..fields['province_id'] = stateId
        ..fields['town_city'] = city
        ..fields['zipcode'] = pinCode;

      var response = await request.send();
      print('object========id: ${stateId}=name:=${state}=====================');
      if (response.statusCode == 200 || response.statusCode == 201) {}
      print(response.statusCode.toString());
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> editCustomerload(
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
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(
          '${BASE_URL}api/customers/$id?email=$email&first_name=$firstName&last_name=$lastName&phone=$mobileNo&notes=$customerNotes&address_line_1=$address&province_name=$state&province_id=$stateId&town_city=$city&zipcode=$pinCode&client_id=${prefs.getString(AppConstants.USER_ID)}');
      print('hjjjjjjjjjjjjjjjj${token}');

      var request = http.MultipartRequest("PUT", url)
        ..headers['Authorization'] = "Bearer $token";

      var response = await request.send();
      print('object========id: ${stateId}=name:=${state}=====================');
      if (response.statusCode == 200 || response.statusCode == 201) {}
      print(response.statusCode.toString());
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> deleteCustomer(token, customerId) async {
    try {
      var url = Uri.parse('${BASE_URL}api/customers/$customerId');
      var request = http.MultipartRequest("DELETE", url)
        ..headers['Authorization'] = "Bearer $token";
      var response = await request.send();
      print('hggggggggggggg${response.statusCode.toString()}');
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> calendarload(String token, DateTime selectedDate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var url = Uri.parse(
          '${BASE_URL}api/calendar_events_mobile?client_id=${prefs.getString(AppConstants.USER_ID)}&start_date=$selectedDate&end_date=${DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1, selectedDate.minute - 1)}');
      var request = http.MultipartRequest("GET", url);
      request.headers.addAll(getHeader(token));
      var response = await request.send();
      print('callllllllllllllllll${response.statusCode.toString()}');
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> calendarWeekLoad(String token, DateTime selectedDate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var url = Uri.parse(
          '${BASE_URL}api/calendar_events_weekly?client_id=${prefs.getString(AppConstants.USER_ID)}&start_date=$selectedDate&end_date=${DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 6)}');
      var request = http.MultipartRequest("GET", url);
      request.headers.addAll(getHeader(token));
      var response = await request.send();
      print('callllllllllllllllll${response.statusCode.toString()}');
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> createEmployee(
      String token, EmployeeCreationModel model) async {
    try {
      final response = http.post(Uri.parse('${BASE_URL}api/users'),
          headers: getHeader(token), body: json.encode(model.toJson()));

      log(model.phone);
      return response;
    } catch (e) {
      print(e.toString() + 'Create employee error');
    }
  }

  Future<dynamic> getAllRoles(String token) async {
    try {
      final response = http.get(Uri.parse('${BASE_URL}api/roles'),
          headers: getHeader(token));
      return response;
    } catch (e) {
      print(e.toString() + 'Roles error');
    }
  }

  Future<dynamic> dropdownVechile(String token) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse(
        "${BASE_URL}api/vehicle_types",
      );
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.request!.method + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getVinDetailsGlobal(String vin) async {
    try {
      final url = Uri.parse(
          'https://vpic.nhtsa.dot.gov/api/vehicles/DecodeVinValues/$vin?format=json');
      final response = http.get(url);
      return response;
    } catch (e) {
      log('Error on getting global response');
    }
  }

  Future<dynamic> getVinDetailsLocal(String token, String vin) async {
    try {
      final clientId = await AppUtils.getUserID();

      final url =
          Uri.parse('${BASE_URL}api/vehicles?vin=$vin&client_id=$clientId');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  Future<dynamic> getVehicleEstimates(
      String token, String vehicleId, int page) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse(
          '${BASE_URL}api/orders?vehicle_id=$vehicleId&page=$page&client_id=$clientId');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  Future<dynamic> getEstimate(
      String token, String orderStatus, int currentPage) async {
    print("into provider");

    try {
      final clientId = await AppUtils.getUserID();

      var url = Uri.parse(
        orderStatus == ""
            ? "${BASE_URL}api/orders?client_id=$clientId"
            : orderStatus == "Estimate"
                ? "${BASE_URL}api/orders?order_status=Estimate&page=${currentPage}&client_id=$clientId"
                : orderStatus == "Orders"
                    ? "${BASE_URL}api/orders?order_status=Order&page=${currentPage}&client_id=$clientId"
                    : "${BASE_URL}api/orders?order_status=Invoice&page=${currentPage}&client_id=$clientId",
      );
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getNotifications(
      String token, String clientId, int page) async {
    try {
      final url = Uri.parse(
          "${BASE_URL}api/notifications?client_id=$clientId&page=$page");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Notification API error");
    }
  }

  Future<dynamic> getParts(String token, int page, String query) async {
    try {
      final clientId = await AppUtils.getUserID();
      String url =
          '${BASE_URL}api/inventory_parts?order_by=id&sort=DESC&client_id=$clientId';
      if (page != 1) {
        url = '$url&page=$page';
      }
      if (query != '') {
        url = '$url&item_name=$query';
      }
      var response = http.get(Uri.parse(url), headers: getHeader(token));
      print(response);
      return response;
    } catch (e) {
      print(e.toString() + 'get parts error');
    }
  }

  Future<dynamic> addParts(
    token,
    BuildContext context,
    itemname,
    serialnumber,
    type,
    quantity,
    fee,
    supplies,
    epa,
    cost,
  ) async {
    try {
      var url = Uri.parse('${BASE_URL}api/inventory_parts');
      final clientId = await AppUtils.getUserID();
      final map = {};
      log(quantity.toString());
      map['item_name'] = itemname;
      map['part_name'] = itemname;
      map['sub_total'] =
          (double.tryParse(cost) ?? 0 * (double.tryParse(quantity) ?? 0));
      map['quantity_in_hand'] = double.tryParse(quantity) ?? 0;
      map['item_service_note'] = serialnumber;
      map['vendor_id'] = "0";
      map['category_id'] = "0";
      map['bin_location'] = "top";
      map['quantity_critical'] = double.tryParse(quantity) ?? 0;
      map['markup'] = "0";
      map['margin'] = "0";
      map['unit_price'] = double.tryParse(cost) ?? 0;
      map['client_id'] = clientId;
      final response = await http.post(url,
          body: jsonEncode(map), headers: getHeader(token));

      return response;
    } catch (e) {
      log("Part api error ${e.toString()}");
    }
  }

  Future<dynamic> editParts(
    token,
    itemname,
    serialnumber,
    quantity,
    cost,
    id,
  ) async {
    try {
      var url = Uri.parse('${BASE_URL}api/inventory_parts/$id');
      final clientId = await AppUtils.getUserID();
      final map = {};
      log(quantity.toString());
      map['item_name'] = itemname;
      map['part_name'] = itemname;
      map['sub_total'] =
          (double.tryParse(cost) ?? 0 * (double.tryParse(quantity) ?? 0));
      map['quantity_in_hand'] = double.tryParse(quantity) ?? 0;
      map['item_service_note'] = serialnumber;
      map['vendor_id'] = "0";
      map['category_id'] = "0";
      map['bin_location'] = "top";
      map['quantity_critical'] = double.tryParse(quantity) ?? 0;
      map['markup'] = "0";
      map['margin'] = "0";
      map['unit_price'] = double.tryParse(cost) ?? 0;
      map['client_id'] = clientId;
      final response =
          await http.put(url, body: jsonEncode(map), headers: getHeader(token));

      return response;
    } catch (e) {
      log("Part api error ${e.toString()}");
    }
  }

  Future<dynamic> editPart(PartsDatum part, String token) async {
    try {
      final response = await http.put(
          Uri.parse('${BASE_URL}api/inventory_parts/${part.id}'),
          headers: getHeader(token),
          body: json.encode(part.toJson()));
      return response;
    } catch (e) {
      log(e.toString() + 'Edit part provider error');
    }
  }

  Future<dynamic> deleteParts(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${BASE_URL}api/inventory_parts/$id'),
        headers: getHeader(token),
      );
      return response;
    } catch (e) {
      log(e.toString() + 'Delete part provider error');
    }
  }

  Future<dynamic> getAllTimeCards(String token) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse("${BASE_URL}api/mobilelist?client_id=$clientId");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "  Get all time cards api error");
    }
  }

  Future<dynamic> getProvince(String token, int currentPage) async {
    print("into provider");

    try {
      var url = Uri.parse("${BASE_URL}api/provinces?page=$currentPage");
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createTimeCard(
      String token, TimeCardCreateModel timeCard) async {
    try {
      final url = Uri.parse("${BASE_URL}api/clocks");
      final response = http.post(url,
          headers: getHeader(token), body: json.encode(timeCard.toJson()));
      return response;
    } catch (e) {
      log(e.toString() + "  Create time cards api error");
    }
  }

  Future<dynamic> getLicDetails(String token, String lic) async {
    try {
      final clientId = await AppUtils.getUserID();

      final url = Uri.parse(
          '${BASE_URL}api/vehicles?licence_plate=$lic&client_id=$clientId');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }
  // Future<dynamic> addParts(
  //   BuildContext context,
  //   String token,
  //   String itemname,
  //   String serialnumber,
  //   String type,
  //   String quantity,
  //   String fee,
  //   String supplies,
  //   String epa,
  //   String cost,
  // ) async {
  //   print("eeeeeeeeeeeeeeeeeeeeeeeeeee$token");
  //
  //   //  LoadingFormModel? loadingFormModel;
  //   try {
  //     var url = Uri.parse("${BASE_URL}api/inventory_parts");
  //     var request = http.MultipartRequest("POST", url)
  //       ..headers['Authorization'] = "Bearer $token"
  //       ..fields['item_name'] = itemname
  //       ..fields['part_name'] = serialnumber
  //       ..fields['unit_price'] = cost
  //       ..fields['quantity_in_hand'] = quantity;
  //     var response = await request.send();
  //     inspect(response);
  //     print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww${response.statusCode}");
  //     print(response.toString() + "provider status code");
  //     print(response.toString() + "provider response");
  //     return http.Response.fromStream(response);
  //   } catch (e) {
  //     print(e.toString() + "provider error");
  //   }

  Future<dynamic> addCompany(
      Map<String, dynamic> dataMap, dynamic token, String clientId) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/clients/$clientId");
      // var request = http.MultipartRequest("PUT", url)
      //   ..fields['company_name'] = dataMap['company_name']
      //   ..fields['phone'] = dataMap['phone']
      //   ..fields['address_1']=dataMap['address_1']
      //   ..fields['town_city']=dataMap['town_city']
      //   ..fields['province_id']=dataMap['province_id']
      //   ..fields['zipcode']=dataMap['zipcode']
      //   ..fields['employee_count']=dataMap['employee_count']
      //   ..fields['service_type']=dataMap['service_type']
      //   ..fields['time_zone']=dataMap['time_zone']
      //   ..fields['sales_tax_rate']=dataMap['sales_tax_rate']
      //   ..fields['base_labor_cost']=dataMap['base_labor_cost'];

      //  request.headers.addAll(getHeader(token));
      // var response = await request.send();
      Map bodyMap = {
        "company_name": dataMap['company_name'],
        "phone": dataMap['phone']
            .toString()
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .replaceAll(" ", ""),
        "address_1": dataMap['address_1'],
        "town_city": dataMap['town_city'],
        "province_id": dataMap['province_id'],
        "zipcode": dataMap['zipcode'],
        "employee_count": dataMap['employee_count'],
        "service_type": "Full service",
        "time_zone": dataMap['time_zone'],
        "sales_tax_rate": dataMap['sales_tax_rate'],
        "labor_tax_rate": dataMap["labor_tax_rate"],
        "material_tax_rate": dataMap["material_tax_rate"],
        "tax_on_parts": dataMap["tax_on_parts"],
        "tax_on_material": dataMap["tax_on_material"],
        "tax_on_labors": dataMap["tax_on_labors"],
        "base_labor_cost":
            dataMap['base_labor_cost'].toString().replaceAll("\$", "")
      };
      var encodedBody = json.encode(bodyMap);
      log(bodyMap.toString());
      log(clientId);

      var response =
          http.put(url, body: encodedBody, headers: getHeader(token));
      inspect(response);
      // print(response.statusCode.toString() + "provider status code");
      // print(response.toString() + "provider response");
      // return http.Response.fromStream(response);
      return response;
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getCustomerMessages(
      String token, String clientId, int currentPage) async {
    print("into provider");
    log(currentPage.toString() + ":::::::::::::::::");

    try {
      var url = Uri.parse(
          "${BASE_URL}api/sentmessages?client_id=$clientId&page=$currentPage&orderby=created_at&sort=DESC");
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> sendCustomerMessage(String token, String clientId,
      String customerId, String messageBody) async {
    print("into provider");

    try {
      var url = Uri.parse("${BASE_URL}api/sentmessages");
      var request = http.MultipartRequest("POST", url)
        ..fields['sender_user_id'] = clientId
        ..fields['receiver_customer_id'] = customerId
        ..fields['message_type'] = "SMS"
        ..fields['message_body'] = messageBody
        ..fields['message_info'] = json.encode({})
        ..fields['status'] = "Open";

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  // Future<dynamic> createNewEstimate(
  //    String id,String which, dynamic token) async {
  //   print("into provider");

  //   Map bodymap = {
  //     "customer_id": customerId,
  //     "vehicle_id": vehicleId,
  //     "estimation_name": "name",
  //   };

  //   var encodedBody = json.encode(bodymap);
  //   log(encodedBody.toString());

  //   try {
  //     var url = Uri.parse("${BASE_URL}api/orders");

  //     var response =
  //         http.post(url, body: encodedBody, headers: getHeader(token));

  //     inspect(response);
  //     return response;
  //   } catch (e) {
  //     print(e.toString() + "provider error");
  //   }
  // }

  Future<dynamic> createNewEstimate(
      String id, String which, dynamic token) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse("${BASE_URL}api/orders");
      var request = http.MultipartRequest("POST", url)
        ..fields['client_id'] = clientId;
      if (which == "vehicle") {
        request.fields['vehicle_id'] = id;
        request.fields['customer_id'] = "0";
      } else {
        request.fields['customer_id'] = id;
      }

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> editEstimate(String id, String which, dynamic token,
      String orderId, String customerId, String? dropSchedule) async {
    print("into provider");
    print(customerId + "cusstomerrr");

    //  LoadingFormModel? loadingFormModel;
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse("${BASE_URL}api/orders/$orderId");
      Object customerBody = {"client_id": clientId, "customer_id": id};

      final vehicleBody = {
        "client_id": clientId,
        "customer_id": customerId,
        "vehicle_id": id,
      };

      if (dropSchedule != null) {
        vehicleBody["drop_schedule"] = dropSchedule;
      }
      // var request = http.MultipartRequest("PUT", url)
      //   ..fields['client_id'] = clientId;
      // if (which == "vehicle") {
      //   request.fields['vehicle_id'] = id;

      //   request.fields['customer_id'] = customerId;
      // } else {
      //   request.fields['customer_id'] = id;
      // }

      // request.headers.addAll(getHeader(token));
      // var response = await request.send();
      // inspect(response);
      // print(response.statusCode.toString() + "provider status code");
      // print(response.toString() + "provider response");
      // return http.Response.fromStream(response);

      Response response = await http.put(url,
          body: which == "vehicle"
              ? json.encode(vehicleBody)
              : json.encode(customerBody),
          headers: getHeader(token));

      return response;
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> addEstimateNote(
      String orderId, String comment, dynamic token) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/work_order_notes");
      var request = http.MultipartRequest("POST", url)
        ..fields['order_id'] = orderId
        ..fields['comments'] = comment;

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> editEstimateNote(
      String orderId, String comment, dynamic token, String id) async {
    print("into provider");
    print(id + "idddddddddddddddddd");
    print(orderId + "ooooderrrr iddd");
    print(comment + "cooommmennttt");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/work_order_notes/$id");
      // var request = http.MultipartRequest("PUT", url)
      //   ..fields['order_id'] = orderId
      //   ..fields['comments'] = comment;

      // request.headers.addAll(getHeader(token));
      // var response = await request.send();
      Map<String, String> body = {"order_id": orderId, "comments": comment};

      Response response = await http.put(url,
          body: json.encode(body), headers: getHeader(token));
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return response;
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> deleteEstimateNote(String token, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/work_order_notes/$id');
      final response = await http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Delete provider error");
    }
  }

  Future<dynamic> getAllWorkflows(String token, int page) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url =
          Uri.parse('${BASE_URL}api/workfloworders?client_id=$clientId');
      final response = await http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Get workflows error");
    }
  }

  Future<dynamic> getWorkflowBucket(String token, int page) async {
    try {
      // final clientId = await AppUtils.getUserID();
      final url = Uri.parse('${BASE_URL}api/workflowbuckets?page=$page');
      final response = await http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Get workflow bucket error");
    }
  }

  Future<dynamic> editWorkflowPosition(
      String token, WorkflowBucketModel workflow) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse('${BASE_URL}api/workflowbuckets/${workflow.id}');
      final response = await http.put(url,
          headers: getHeader(token), body: jsonEncode(workflow.toJson()));

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "put workflows error");
    }
  }

  Future<dynamic> getTechniciansOnly(String token) async {
    print("into provider");

    try {
      var url = Uri.parse(
        "${BASE_URL}api/users/role/Technician",
      );
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createAppointment(
      String token, AppointmentCreateModel appointment) async {
    try {
      final url = Uri.parse('${BASE_URL}api/appointments');
      final response = await http.post(
        url,
        headers: getHeader(token),
        body: appointmentCreateModelToJson(appointment),
      );
      return response;
    } catch (e) {
      log(e.toString() + " create appointment api error");
    }
  }

  Future<dynamic> createAppointmentEstimate(
    dynamic token,
    String orderId,
    String customerId,
    String vehicleId,
    String startTime,
    String endTime,
    String notes,
  ) async {
    try {
      final body = {
        "appointment_title": orderId,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "notes": notes,
        "start_on": startTime,
        "end_on": endTime
      };
      final url = Uri.parse('${BASE_URL}api/appointments');
      final response = await http.post(
        url,
        headers: getHeader(token),
        body: json.encode(body),
      );
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + " create appointment api error");
    }
  }

  Future<dynamic> editAppointmentEstimate(
      dynamic token,
      String orderId,
      String customerId,
      String vehicleId,
      String startTime,
      String endTime,
      String notes,
      String id) async {
    try {
      final body = {
        "appointment_title": orderId,
        "customer_id": customerId,
        "vehicle_id": vehicleId,
        "notes": notes,
        "start_on": startTime,
        "end_on": endTime
      };
      final url = Uri.parse('${BASE_URL}api/appointments/$id');
      final response = await http.put(
        url,
        headers: getHeader(token),
        body: json.encode(body),
      );
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + " create appointment api error");
    }
  }

  Future<dynamic> deleteEmployee(String token, int id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/users/$id');
      final response = await http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Delete provider error");
    }
  }

  Future<dynamic> editEmployee(
      String token, EmployeeCreationModel model, int id) async {
    try {
      final response = http.put(Uri.parse('${BASE_URL}api/users/$id'),
          headers: getHeader(token), body: json.encode(model.toJson()));
      inspect(response);
      return response;
    } catch (e) {
      print(e.toString() + 'Create employee error');
    }
  }

  Future<dynamic> addWorkflowBucket(
      String token, Map<String, dynamic> map) async {
    try {
      final url = Uri.parse('${BASE_URL}api/workflowbuckets');
      final clientId = await AppUtils.getUserID();
      map['client_id'] = int.parse(clientId);
      final response = await http.post(url,
          headers: getHeader(token), body: json.encode(map));
      return response;
    } catch (e) {
      log(e.toString() + " Add workflow api error");
    }
  }

  Future<dynamic> createCannedOrderService(
      String token, CannedServiceCreateModel model) async {
    try {
      final url = Uri.parse('${BASE_URL}api/canned_services');

      final response = await http.post(url,
          headers: getHeader(token), body: json.encode(model.toJson()));
      return response;
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
    }
  }

  Future<dynamic> createCannedOrderServiceItem(
      String token, CannedServiceAddModel model, int serviceId) async {
    try {
      final url = Uri.parse('${BASE_URL}api/canned_service_items');
      final map = model.toJson();
      if (map['vendor_id'] == null) {
        map.remove('vendor_id');
      }
      map['canned_service_id'] = serviceId;
      final response = await http.post(url,
          headers: getHeader(token), body: json.encode(map));

      log(map.toString());
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
    }
  }

  Future<dynamic> getSingleEstimate(String token, String orderId) async {
    print("into provider");

    try {
      // final clientId = await AppUtils.getUserID();

      var url = Uri.parse("${BASE_URL}api/orders/$orderId");
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getEstimateNote(String token, String orderId) async {
    print("into provider");

    try {
      // final clientId = await AppUtils.getUserID();

      var url = Uri.parse("${BASE_URL}api/work_order_notes?order_id=$orderId");
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getEstimateAppointmentDetails(
      String token, String orderId) async {
    print("into provider");

    try {
      // final clientId = await AppUtils.getUserID();

      var url =
          Uri.parse("${BASE_URL}api/appointments?appointment_title=$orderId");
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getAllVendors(String token, int page) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse('${BASE_URL}api/vendors?client_id=');

      final response = await http.get(
        url,
        headers: getHeader(token),
      );
      return response;
    } catch (e) {
      log(e.toString() + " Get all vendors api error");
    }
  }

  Future<dynamic> uploadImage(dynamic token, File filePath) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/upload");
      var request = http.MultipartRequest("POST", url);
      request.files.add(http.MultipartFile.fromBytes(
          filename: filePath.path.split("/").last,
          'image',
          filePath.readAsBytesSync()));

      log(filePath.readAsBytesSync().toString());

      request.headers.addAll(getHeader(token));
      inspect(request);

      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e, s) {
      print(s);
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createOrderImage(dynamic token, String orderId,
      String imageUrl, String inspectionId) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/order_images");
      var request = http.MultipartRequest("POST", url)
        ..fields['order_id'] = orderId
        ..fields['file_name'] = imageUrl
        ..fields['inspection_id'] = inspectionId;

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createInspectionNotes(
    dynamic token,
    String orderId,
  ) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/inspection_notes");
      var request = http.MultipartRequest("POST", url)
        ..fields['order_id'] = orderId
        ..fields['inspection_area'] = "Top"
        ..fields['comments'] = "static_test_comment";

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> getAllOrderImages(String token, String orderId) async {
    print("into provider");

    try {
      // final clientId = await AppUtils.getUserID();

      var url = Uri.parse("${BASE_URL}api/order_images?order_id=$orderId");
      var request = http.MultipartRequest("GET", url);

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> deleteOrderImage(dynamic token, String imageId) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/order_images/$imageId");
      var request = http.MultipartRequest("DELETE", url);

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createOrderService(
      dynamic token,
      String orderId,
      String serviceName,
      String serviceNotes,
      String laborRate,
      String tax) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/order_services");
      var request = http.MultipartRequest("POST", url)
        ..fields['order_id'] = orderId
        ..fields['service_name'] = serviceName
        ..fields['service_note'] = serviceNotes
        ..fields['technician_id'] = "0";

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createOrderServiceItem(
      dynamic token,
      String cannedServiceId,
      String itemType,
      String itemName,
      String unitPrice,
      String quantityHours,
      String discount,
      String discountType,
      String position,
      String subTotal) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/order_service_items");
      var request = http.MultipartRequest("POST", url)
        ..fields['order_service_id'] = cannedServiceId
        ..fields['item_type'] = itemType
        ..fields['item_name'] = itemName
        ..fields['unit_price'] = unitPrice
        ..fields['quanity_hours'] = quantityHours
        ..fields['discount'] = discount
        ..fields['discount_type'] = discountType
        ..fields['position'] = position
        ..fields['sub_total'] = subTotal;

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> deleteCannedService(dynamic token, String serviceId) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/canned_services/$serviceId");
      var response = http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Delete Canned Service api error");
    }
  }

  Future<dynamic> deleteCannedServiceItem(dynamic token, String id) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/canned_service_items/$id");
      var response = http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Delete Canned Service api error");
    }
  }

  Future<dynamic> editCannedOrderService(
      String token, CannedServiceCreateModel model, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/canned_services/$id');

      final response = await http.put(url,
          headers: getHeader(token), body: json.encode(model.toJson()));
      return response;
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
    }
  }

  Future<dynamic> editOrderServiceItem(
      String token, CannedServiceAddModel model, int serviceId) async {
    try {
      final url = Uri.parse('${BASE_URL}api/order_service_items');
      final map = model.toJson();
      if (map['vendor_id'] == null) {
        map.remove('vendor_id');
      }
      map['order_service_id'] = serviceId;
      map.remove('canned_service_id');

      final response = await http.post(url,
          headers: getHeader(token), body: json.encode(map));

      log(map.toString());
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
    }
  }

  Future<dynamic> deleteOrderServiceItem(dynamic token, String id) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/order_service_items/$id");
      var response = http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Delete Canned Service api error");
    }
  }

  Future<dynamic> editOrderService(String token, CannedServiceCreateModel model,
      String id, String technicianId) async {
    try {
      final url = Uri.parse('${BASE_URL}api/order_services/$id');
      final map = model.toJson();
      map['technician_id'] = technicianId;

      final response = await http.put(url,
          headers: getHeader(token), body: json.encode(map));
      return response;
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
    }
  }

  Future<dynamic> getClientByClientId() async {
    try {
      final clientId = await AppUtils.getUserID();
      final token = await AppUtils.getToken();
      final url = Uri.parse('${BASE_URL}api/clients/$clientId');
      final response = await http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Get client api error");
    }
  }

  Future<dynamic> deleteOrderService(String token, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/order_services/$id');
      final response = await http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Delete provider error");
    }
  }

  Future<dynamic> sendToCustomerEstimate(
      String token, String customerId, String orderId, String subject) async {
    try {
      final body = {
        "customer_id": customerId,
        "order_id": orderId,
        "template_id": 2,
        "subject": subject,
        "send_email": true,
        "notes": "Test"
      };
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse('${BASE_URL}api/authorize_digital_signatures');
      final response = await http.post(url,
          headers: getHeader(token), body: jsonEncode(body));

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "send to customer provider  error");
    }
  }

  Future<dynamic> deleteAppointment(dynamic token, String appointmentId) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/appointments/$appointmentId");
      var request = http.MultipartRequest("DELETE", url);

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.statusCode.toString() + "provider status code");
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> collectPayment(
      String token,
      String customerId,
      String orderId,
      String paymentMode,
      String amount,
      String date,
      String notes) async {
    try {
      final body = {
        "customer_id": customerId,
        "order_id": orderId,
        "payment_mode": paymentMode,
        "paid_amount": amount,
        "payment_date": date,
        "note": notes
      };

      final url = Uri.parse('${BASE_URL}api/payments');
      final response = await http.post(url,
          headers: getHeader(token), body: jsonEncode(body));

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "send to customer provider  error");
    }
  }
}
