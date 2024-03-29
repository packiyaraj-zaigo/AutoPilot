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

  // static const BASE_URL =
  //     'http://ec2-13-235-8-199.ap-south-1.compute.amazonaws.com/';

  //Live Server
  static const BASE_URL = "http://api.autopilot-crm.com/";

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

  Future<dynamic> getRevenueChartData(String token, String today) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/dashboard?selected_date=$today");
      var request = http.MultipartRequest("Get", url);
      request.headers.addAll(getHeader(token));
      log('Inside revenue chart ');
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
      String url =
          '${BASE_URL}api/users?client_id=$clientId&order_by=created_at';

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

  Future<dynamic> getVechile(
      String token, int page, String query, String? customerId) async {
    try {
      final clientId = await AppUtils.getUserID();
      String url = '';
      url = '${BASE_URL}api/vehicles?client_id=$clientId&orderby=id&sort=DESC';
      if (customerId != null) {
        url =
            '${BASE_URL}api/vehicles?customer_id=$customerId&orderby=id&sort=DESC';
      }
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
      String customerId,
      String mileage) async {
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
        ..fields['licence_plate'] = licNumber
        ..fields['customer_id'] = customerId;
      if (mileage != "") {
        request.fields['kilometers'] = mileage;
      } else {
        request.fields['kilometers'] = "0";
      }

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
      String customerId,
      String mileage) async {
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
      map['customer_id'] = customerId;
      if (mileage != "") {
        map['kilometers'] = mileage;
      } else {
        map['kilometers'] = "0";
      }

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
        ..fields['phone'] = mobileNo;

      if (customerNotes.isNotEmpty) {
        request.fields['notes'] = customerNotes;
      }
      if (address.isNotEmpty) {
        request.fields['address_line_1'] = address;
      }
      if (state.isNotEmpty) {
        request.fields['province_name'] = state;
      }
      if (stateId.isNotEmpty) {
        request.fields['province_id'] = stateId;
      }
      if (city.isNotEmpty) {
        request.fields['town_city'] = city;
      }
      if (pinCode.isNotEmpty) {
        request.fields['zipcode'] = pinCode;
      }
      log(request.fields.toString());

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
      var url =
          '${BASE_URL}api/customers/$id?email=$email&first_name=$firstName&last_name=$lastName&phone=$mobileNo&notes=$customerNotes&address_line_1=$address&province_name=$state&province_id=$stateId&town_city=$city&zipcode=$pinCode&client_id=${prefs.getString(AppConstants.USER_ID)}';
      print('hjjjjjjjjjjjjjjjj${token}');

      if (address.isNotEmpty) {
        url = url + "&address_line_1=$address";
      }
      if (state.isNotEmpty) {
        url = url + "&province_name=$state";
      }
      if (stateId.isNotEmpty) {
        url = url + "&province_id=$stateId";
      }
      if (city.isNotEmpty) {
        url = url + "&town_city=$city";
      }
      if (pinCode.isNotEmpty) {
        url = url + "&zipcode=$pinCode";
      }
      var request = http.MultipartRequest("PUT", Uri.parse(url))
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
      return http.Response.fromStream(response);
    } catch (e) {
      print("errroor draft found ${e.toString()}");
    }
  }

  Future<dynamic> calendarload(String token, DateTime selectedDate) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      final clientId = await AppUtils.getUserID();

      var url = Uri.parse(
          '${BASE_URL}api/calendar_events_mobile?client_id=${clientId}&start_date=$selectedDate&end_date=${DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1, selectedDate.minute - 1)}');
      var request = http.MultipartRequest("GET", url);
      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(request);
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

      log(model.toJson().toString());

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

  Future<dynamic> getVehicleNotes(String token, String vehicleId) async {
    try {
      print(vehicleId);
      final url =
          Uri.parse('${BASE_URL}api/vehicle_notes?vehicle_id=$vehicleId');
      final response = http.get(url, headers: getHeader(token));

      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  Future<dynamic> getEstimate(String token, String orderStatus, int currentPage,
      [String? customerId]) async {
    print("into provider");

    try {
      final clientId = await AppUtils.getUserID();

      var url = Uri.parse(
        customerId != null
            ? "${BASE_URL}api/orders?customer_id=$customerId&page=$currentPage&order_by=id&sort=DESC"
            : orderStatus == ""
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

  Future<dynamic> getEstimateFromVehicle(
      String token, int currentPage, String vehicleId) async {
    print("into provider");

    try {
      // final clientId = await AppUtils.getUserID();

      var url = Uri.parse(
          "${BASE_URL}api/orders?vehicle_id=$vehicleId&page=$currentPage");

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
          '${BASE_URL}api/inventory_parts?order_by=id&sort=DESC&client_id=$clientId&order_by=id&sort=DESC';
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

  Future<dynamic> getAllTimeCards(String token, String userName) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse(
          "${BASE_URL}api/mobilelist?client_id=$clientId&order_by=id&sort=DESC&username=$userName");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "  Get all time cards api error");
    }
  }

  Future<dynamic> getUserTimeCards(
      String token, String technicianId, int page) async {
    try {
      final url = Uri.parse(
          "${BASE_URL}api/clocks?technician_id=$technicianId&page=$page&order_by=id&sort=DESC");
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
      log(json.encode(timeCard.toJson()));
      return response;
    } catch (e) {
      log(e.toString() + "  Create time cards api error");
    }
  }

  Future<dynamic> editTimeCard(
      String token, TimeCardCreateModel timeCard, String id) async {
    try {
      final url = Uri.parse("${BASE_URL}api/clocks/$id");
      final response = http.put(url,
          headers: getHeader(token), body: json.encode(timeCard.toJson()));
      return response;
    } catch (e) {
      log(e.toString() + "  Edit time cards api error");
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

  Future<dynamic> addCompany(Map<String, dynamic> dataMap, dynamic token,
      String clientId, dynamic imagePath) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/clients/$clientId");
      // var request = http.MultipartRequest("PUT", url)
      //   ..fields['company_name'] = dataMap['company_name']
      //   ..fields['phone'] = dataMap['phone']
      //   ..fields['address_1'] = dataMap['address_1']
      //   ..fields['town_city'] = dataMap['town_city']
      //   ..fields['province_id'] = dataMap['province_id'].toString()
      //   ..fields['zipcode'] = dataMap['zipcode']
      //   ..fields['employee_count'] = dataMap['employee_count']
      //   ..fields['service_type'] = "Full Service"
      //   ..fields['time_zone'] = dataMap['time_zone']
      //   ..fields['sales_tax_rate'] = dataMap['sales_tax_rate']
      //   ..fields["labor_tax_rate"] = dataMap["labor_tax_rate"]
      //   ..fields["material_tax_rate"] = dataMap["material_tax_rate"]
      //   ..fields["tax_on_parts"] = dataMap["tax_on_parts"]
      //   ..fields["tax_on_material"] = dataMap["tax_on_material"]
      //   ..fields["tax_on_labors"] = dataMap["tax_on_labors"]
      //   ..fields['base_labor_cost'] =
      //       dataMap['base_labor_cost'].toString().replaceAll("\$", "");
      // if (imagePath != null) {
      //   request.files.add(await http.MultipartFile.fromPath(
      //       'company_logo', File(imagePath).path));
      // }
      // log(request.fields.toString() + "Request fields");
      // log(request.fields.toString() + "Request fields");

      // request.headers.addAll(getHeader(token));
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
        "base_labor_cost":
            dataMap['base_labor_cost'].toString().replaceAll("\$", ""),
        "labor_tax_rate": dataMap["labor_tax_rate"],
        "material_tax_rate": dataMap["material_tax_rate"],
        "tax_on_parts": dataMap["tax_on_parts"],
        "tax_on_material": dataMap["tax_on_material"],
        "tax_on_labors": dataMap["tax_on_labors"],
        "company_logo": imagePath
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
    } catch (e, s) {
      print(e.toString() + "provider error");
      print(s);
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

  Future<dynamic> createNewEstimate(String id, String which, dynamic token,
      dropSchedule, vehicleCheckin) async {
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
        if (dropSchedule != null) {
          request.fields["drop_schedule"] = dropSchedule;
        }
        if (vehicleCheckin != null) {
          request.fields['vehicle_checkin'] = vehicleCheckin;
        }
      } else {
        request.fields['customer_id'] = id;
        if (dropSchedule != null) {
          request.fields["drop_schedule"] = dropSchedule;
        }
        if (vehicleCheckin != null) {
          request.fields['vehicle_checkin'] = vehicleCheckin;
        }
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

  Future<dynamic> createNewEstimateFromAppointment(
      String vehicleId,
      String customerId,
      dynamic token,
      String? dropSchedule,
      String? vehicleCheckin) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse("${BASE_URL}api/orders");
      var request = http.MultipartRequest("POST", url)
        ..fields['client_id'] = clientId;
      request.fields['vehicle_id'] = vehicleId;
      request.fields['customer_id'] = customerId;
      if (dropSchedule != null) {
        request.fields["drop_schedule"] = dropSchedule;
      }
      if (vehicleCheckin != null) {
        request.fields['vehicle_checkin'] = vehicleCheckin;
      }

      request.headers.addAll(getHeader(token));
      var response = await request.send();
      inspect(response);
      return http.Response.fromStream(response);
    } catch (e) {
      log(e.toString() + "create estimate from appointment api error");
    }
  }

  Future<dynamic> editEstimate(
      String id,
      String which,
      dynamic token,
      String orderId,
      String customerId,
      String? dropSchedule,
      String? vehicleCheckin) async {
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
      if (vehicleCheckin != null) {
        vehicleBody['vehicle_checkin'] = vehicleCheckin;
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

      inspect(response);

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

  Future<dynamic> getAllWorkflows(String token) async {
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

  Future<dynamic> editWorkflows(
      String token,
      String clientBucketId,
      String orderId,
      String updatedBy,
      String oldBucketId,
      String workflowId) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse('${BASE_URL}api/workfloworders/$workflowId');
      final body = {
        "client_id": clientId,
        "client_bucket_id": clientBucketId,
        "order_id": orderId,
        "updated_by": updatedBy,
        "old_bucket_id": oldBucketId
      };
      final response = await http.put(url,
          headers: getHeader(token), body: json.encode(body));
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "Edit workflows error");
    }
  }

  Future<dynamic> getAllStatus(String token) async {
    try {
      final url = Uri.parse('${BASE_URL}api/workflowbuckets/status');
      final response = await http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Get workflows error");
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
      log(appointment.toJson().toString() + "APPOINTMENT");
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
        "end_on": endTime,
        "createEvent": "1",
        "order_id": orderId
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
        "vehicle_id": vehicleId.isEmpty ? '0' : vehicleId,
        "notes": notes,
        "start_on": startTime,
        "end_on": endTime,
        "createEvent": "1",
        "order_id": orderId
      };
      final url = Uri.parse('${BASE_URL}api/appointments/$id');
      final response = await http.put(
        url,
        headers: getHeader(token),
        body: json.encode(body),
      );

      inspect(response);

      log(body.toString() + "APPOINTMENT BODY");
      log(id.toString() + "APPOINTMENT ID");
      log(response.body.toString() + "APPOINTMENT EDIT RESPONSE");

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
      log(model.toJson().toString());
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
      print(map.toString() + "maaappp");
      final response = await http.post(url,
          headers: getHeader(token), body: json.encode(map));
      return response;
    } catch (e) {
      log(e.toString() + " Add workflow api error");
    }
  }

  Future<dynamic> getSingleWorkflowBucket(String token, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/workflowbuckets/$id');
      final response = await http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Get workflow api error");
    }
  }

  Future<dynamic> editWorkflowBucket(
      String token, Map<String, dynamic> map, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/workflowbuckets/$id');
      final clientId = await AppUtils.getUserID();
      map['client_id'] = int.parse(clientId);
      final response = await http.put(url,
          headers: getHeader(token), body: json.encode(map));
      return response;
    } catch (e) {
      log(e.toString() + " Add workflow api error");
    }
  }

  Future<dynamic> deleteWorkflowBucket(String token, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/workflowbuckets/$id');

      final response = await http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " delete workflow api error");
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

      if (map['markup'] == null || map['markup'] == '') {
        map.remove('markup');
      }

      map['tax'] = map['is_tax'];
      map.remove('is_tax');
      map['canned_service_id'] = serviceId;
      map['tax'] = map['is_tax'];
      map.remove('is_tax');
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

  Future<dynamic> getSingleCustomer(String token, String id) async {
    try {
      var url = Uri.parse("${BASE_URL}api/customers/$id");
      var response = http.get(url, headers: getHeader(token));

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "Get single customer api error");
    }
  }

  Future<dynamic> getSingleVehicle(String token, String id) async {
    try {
      var url = Uri.parse("${BASE_URL}api/vehicles/$id");
      var response = http.get(url, headers: getHeader(token));

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "Get single vehicle api error");
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
      final url =
          Uri.parse('${BASE_URL}api/vendors?client_id=$clientId&page=$page');

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
      String tax,
      String servicePrice,
      String technicianId) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/order_services");
      var request = http.MultipartRequest("POST", url)
        ..fields['order_id'] = orderId
        ..fields['service_name'] = serviceName
        ..fields['service_note'] = serviceNotes
        ..fields['technician_id'] = "0"
        ..fields['service_price'] = servicePrice
        ..fields["tax"] = tax
        ..fields["technician_id"] = technicianId;

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      inspect(response);
      print(response.toString() + "provider response");
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createOrderServiceItems(String token,
      CannedServiceAddModel model, String serviceId, String taxAmount) async {
    try {
      final url = Uri.parse('${BASE_URL}api/order_service_items');
      final map = model.toJson();
      if (map['vendor_id'] == null) {
        map.remove('vendor_id');
      }
      map.remove('canned_service_id');

      map['order_service_id'] = serviceId;
      final request = http.MultipartRequest(
        'POST',
        url,
      );

      map["tax"] = model.tax;
      map.remove('is_tax');

      if (map['markup'] == null || map['markup'] == '') {
        map.remove('markup');
      }
      map.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      request.headers.addAll(getHeader(token));
      final response = await request.send();

      log(map.toString());
      inspect(response);
      return http.Response.fromStream(response);
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
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

  Future<dynamic> authServiceByTech(dynamic token, String serviceId,
      String technicianId, serviceName, String auth) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      final authorizeBody = {
        "order_status": "Order",
        "is_authorized": "Y",
        "is_authorized_customer": "Y",
        "technician_id": technicianId,
        "service_name": serviceName,
      };
      final notYetAuthorizedBody = {
        "order_status": "Estimate",
        "is_authorized": "N",
        "is_authorized_customer": "N",
        "technician_id": technicianId,
        "service_name": serviceName,
      };
      final declineBody = {
        "order_status": "Estimate",
        "is_authorized": "Y",
        "is_authorized_customer": "N",
        "technician_id": technicianId,
        "service_name": serviceName,
      };

      // Map body = {
      //   "is_authorized": auth,
      //   "service_name": serviceName,
      //   "technician_id": technicianId
      // };
      var url = Uri.parse("${BASE_URL}api/order_services/$serviceId");
      var response = http.put(url,
          headers: getHeader(token),
          body: json.encode(auth == "Authorize"
              ? authorizeBody
              : auth == "Decline"
                  ? declineBody
                  : notYetAuthorizedBody));

      inspect(response);
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

  Future<dynamic> editCannedOrderServiceItems(String token,
      CannedServiceAddModel model, String id, String serviceId) async {
    try {
      final map = model.toJson();
      map['canned_service_id'] = serviceId;

      if (map['markup'] == null || map['markup'] == '') {
        map.remove('markup');
      }
      map['tax'] = map['is_tax'];
      map.remove('is_tax');

      final url = Uri.parse('${BASE_URL}api/canned_service_items/$id');
      map['tax'] = map['is_tax'];
      map.remove('is_tax');

      final response = await http.put(url,
          headers: getHeader(token), body: json.encode(map));
      return response;
    } catch (e) {
      log(e.toString() + " Create canned order service api error");
    }
  }

  Future<dynamic> editOrderServiceItems(String token,
      CannedServiceAddModel model, String id, String serviceId) async {
    try {
      final map = model.toJson();
      map['order_service_id'] = serviceId;
      map.remove('canned_service_id');
      map["tax"] = model.tax;
      map.remove('is_tax');

      if (map['markup'] == null || map['markup'] == '') {
        map.remove('markup');
      }

      final url = Uri.parse('${BASE_URL}api/order_service_items/$id');

      final response = await http.put(url,
          headers: getHeader(token), body: json.encode(map));
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

      if (map['markup'] == null || map['markup'] == '') {
        map.remove('markup');
      }

      map['order_service_id'] = serviceId.toString();
      map.remove('canned_service_id');
      map["tax"] = model.tax;
      map.remove('is_tax');

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
      inspect(response);
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
        "notes": "Test",
        "enable_signature": true,
        "request_authorization": true
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

  Future<dynamic> deleteEvent(dynamic token, String id) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/calendar_events/$id");
      var request = http.MultipartRequest("DELETE", url);

      request.headers.addAll(getHeader(token));
      inspect(request);
      var response = await request.send();
      return http.Response.fromStream(response);
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> createCustomerNotes(
      String token, String notes, String customerId, String clientId) async {
    try {
      final url = Uri.parse("${BASE_URL}api/customer_notes");
      final map = {
        "client_id": clientId,
        "customer_id": customerId,
        "notes": notes,
      };
      final response = await http.post(url,
          headers: getHeader(token), body: jsonEncode(map));
      log(response.body.toString());
      return response;
    } catch (e) {
      log(e.toString() + " Create notes api error");
    }
  }

  Future<dynamic> getAllCustomerNotes(String token, String customerId) async {
    try {
      final url = Uri.parse(
          "${BASE_URL}api/customer_notes?customer_id=$customerId&order_by=id&sort=DESC");

      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Create notes api error");
    }
  }

  Future<dynamic> deleteCustomerNotes(String token, String id) async {
    try {
      final url = Uri.parse("${BASE_URL}api/customer_notes/$id");

      final response = http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Delete notes api error");
    }
  }

  Future<dynamic> collectPayment(
      String token,
      String customerId,
      String orderId,
      String paymentMode,
      String amount,
      String date,
      String notes,
      String? transactionId,
      String totalAmount) async {
    try {
      final body = {
        "customer_id": customerId,
        "order_id": orderId,
        "payment_mode": paymentMode,
        "paid_amount": amount,
        "payment_date": date,
        "note": notes,
        "full_amount": totalAmount
      };
      if (transactionId != null) {
        body['transaction_id'] = transactionId;
      }

      final url = Uri.parse('${BASE_URL}api/payments');
      final response = await http.post(url,
          headers: getHeader(token), body: jsonEncode(body));

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + "send to customer provider  error");
    }
  }

  Future<dynamic> deleteEstimate(String token, String id) async {
    try {
      final url = Uri.parse('${BASE_URL}api/orders/$id');
      final response = await http.delete(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Delete provider error");
    }
  }

  Future<dynamic> addVehicleNote(
      dynamic token, String vehicleId, String notes) async {
    try {
      final body = {
        "vehicle_id": vehicleId,
        "notes": notes,
      };
      final url = Uri.parse('${BASE_URL}api/vehicle_notes?$vehicleId');
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

  Future<dynamic> deleteVehicleNotes(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${BASE_URL}api/vehicle_notes/$id'),
        headers: getHeader(token),
      );
      return response;
    } catch (e) {
      log(e.toString() + 'Delete part provider error');
    }
  }

  Future<dynamic> getPaymentHistroy(
      String orderId, String token, int currentPage) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${BASE_URL}api/payments?order_id=$orderId &page=$currentPage'),
        headers: getHeader(token),
      );
      return response;
    } catch (e) {
      log(e.toString() + 'Delete part provider error');
    }
  }

  Future<dynamic> getVehicleInfo(String token, String vehicleId) async {
    try {
      final url = Uri.parse("${BASE_URL}api/vehicles/$vehicleId");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + "Notification API error");
    }
  }

  Future<dynamic> globalSearch(String token, String query) async {
    try {
      final url = Uri.parse(
          '${BASE_URL}api/search?keyword=$query&show_vehicle=1&show_estimate=1&show_customer=1');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log(e.toString() + " Search api error");
    }
  }

  Future<dynamic> estimateStatusChange(
      String token, String orderId, String status) async {
    try {
      final url = Uri.parse('${BASE_URL}api/orders/status/$orderId');
      final response = http.post(url,
          headers: getHeader(token),
          body: json.encode(
              {"order_status": status == "Authorize" ? 'Order' : "Estimate"}));
      return response;
    } catch (e) {
      log(e.toString() + " Search api error");
    }
  }

  Future<dynamic> getEmployeeMessage(String token, int currentPage,
      String receiverUserId, String senderUserId) async {
    try {
      final clientId = await AppUtils.getUserID();
      // final userId = await AppUtils.geCurrenttUserID();
      final response = await http.get(
        Uri.parse(
            '${BASE_URL}api/notifications?sender_user_id=$senderUserId&received_user_id=$receiverUserId&page=$currentPage&offset=100'),
        headers: getHeader(token),
      );
      log(response.request!.url.toString());

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + 'Get message api error');
    }
  }

  Future<dynamic> sendEmployeeMessage(
      String token, String receiverUserId, String message) async {
    try {
      final clientId = await AppUtils.getUserID();
      final userId = await AppUtils.geCurrenttUserID();
      final url = Uri.parse('${BASE_URL}api/notifications');
      final body = {
        "client_id": clientId,
        "title": message,
        "message": message,
        "is_read": true,
        "sender_user_id": userId,
        "received_user_id": receiverUserId,
      };
      final response = await http.post(
        url,
        headers: getHeader(token),
        body: json.encode(body),
      );

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + 'send message api error');
    }
  }

  Future<dynamic> getEventDetailsById(String token, String eventId) async {
    try {
      final clientId = await AppUtils.getUserID();
      // final userId = await AppUtils.geCurrenttUserID();
      final response = await http.get(
        Uri.parse('${BASE_URL}api/calendar_events/$eventId'),
        headers: getHeader(token),
      );

      log("test $eventId");

      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + 'Delete part provider error');
    }
  }

  Future<dynamic> createVendor(String clientId, String name, String email,
      String contactPerson, String token) async {
    try {
      final url = Uri.parse("${BASE_URL}api/vendors");
      final body = {
        'client_id': clientId,
        'vendor_name': name,
        'email': email,
        'contact_person': contactPerson,
      };

      final response =
          http.post(url, body: json.encode(body), headers: getHeader(token));
      inspect(response);
      return response;
    } catch (e) {
      log(e.toString() + 'Create vendor provider error');
    }
  }

  Future<dynamic> getPartsNotes(String token, String partsId) async {
    try {
      final url = Uri.parse('${BASE_URL}api/inventory_notes?parts_id=$partsId');
      final response = http.get(url, headers: getHeader(token));

      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  Future<dynamic> deletePartsNotes(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${BASE_URL}api/inventory_notes/$id'),
        headers: getHeader(token),
      );
      return response;
    } catch (e) {
      log(e.toString() + 'Delete part provider error');
    }
  }

  Future<dynamic> addPartsNote(
      String partsId, String token, String notes) async {
    try {
      final body = {"parts_id": partsId, "notes": notes};
      final response = await http.post(
          Uri.parse('${BASE_URL}api/inventory_notes'),
          headers: getHeader(token),
          body: json.encode(body));
      return response;
    } catch (e) {
      log(e.toString() + 'Delete part provider error');
    }
  }

  Future<dynamic> getAppointmentDetails(
      String token, String appointmentId) async {
    try {
      final url = Uri.parse('${BASE_URL}api/appointments/$appointmentId');
      final response = http.get(url, headers: getHeader(token));

      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  //////////////////////////////////////////////////////////////
  ///REPORT MODULE
  ///
  ///
  ///Api call to get all invoice reports
  Future<dynamic> getAllInvoiceReport(
      String token,
      String startDate,
      String endDate,
      String paidFileter,
      int page,
      String searchQuery,
      String exportType,
      String? sortBy,
      String? tableName,
      String? fieldName) async {
    try {
      //  final clientId = await AppUtils.getUserID();
      final url = sortBy != null && tableName != null && fieldName != null
          ? Uri.parse(
              '${BASE_URL}api/invoices?filter=fully_paid&type=$paidFileter&file_type=$exportType&page=$page&sort_by=$sortBy&table=$tableName&field_name=$fieldName')
          : Uri.parse(
              '${BASE_URL}api/invoices?filter=fully_paid&type=$paidFileter&file_type=$exportType&page=$page');

      //mock api url
      // final url = Uri.parse(
      //     'https://run.mocky.io/v3/fcb7770e-ed14-4bfb-8682-6607acb306ce');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  //Api call to get sales tax report
  Future<dynamic> getSalesTaxReport(String token, String startDate,
      String endDate, int page, String exportType) async {
    try {
      // final clientId = await AppUtils.getUserID();
      final url = Uri.parse(
          '${BASE_URL}api/sales_tax_report?from_date=$startDate&to_date=$endDate&file_type=$exportType');
      //mock api url
      // final url = Uri.parse(
      //     'https://run.mocky.io/v3/9eafb7f2-bd2a-45fb-84b6-e81a59dd143f');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  //Api call to get payment type report
  Future<dynamic> getPaymentTypeReport(String token, String typeFilter,
      String searchQuery, int page, String exportType) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = Uri.parse(
          '${BASE_URL}api/payment_types_report?filter=$typeFilter&file_type=$exportType');
      //mock url
      // final url = Uri.parse(
      //     'https://run.mocky.io/v3/0c38e7e0-1774-46fa-a61e-9b468be3a5b9');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  //Api call to get time log report
  Future<dynamic> getTimeLogReport(
      String token,
      String monthFilter,
      String techFilter,
      String searchQuery,
      int page,
      String exportType,
      String? sortBy,
      String? tableName,
      String? fieldName) async {
    try {
      // final clientId = await AppUtils.getUserID();
      final url = sortBy != null && fieldName != null && tableName != null
          ? Uri.parse(
              '${BASE_URL}api/time_log?time_in=$monthFilter&techician_id=$techFilter&file_type=$exportType&page=$page&sort_by=$sortBy&field_name=$fieldName&table=$tableName')
          : Uri.parse(
              '${BASE_URL}api/time_log?time_in=$monthFilter&techician_id=$techFilter&file_type=$exportType&page=$page');

      //mock api url
      // final url = Uri.parse(
      //     'https://run.mocky.io/v3/669aa7b0-b377-4a2c-b720-994591e6c57e');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  //Api call to get service by technician report.
  Future<dynamic> getServiceByTechnicianReport(
      String token,
      String startDate,
      String endDate,
      String searchQuery,
      String techFilter,
      int page,
      String exportType,
      String? sort,
      String? tableName,
      String? fieldName) async {
    try {
      final clientId = await AppUtils.getUserID();
      final url = sort != null && tableName != null && fieldName != null
          ? Uri.parse(
              '${BASE_URL}api/service_by_techicians?techician_id=$techFilter&from_date=$startDate&to_date=$endDate&file_type=$exportType&page=$page&sort_by=$sort&field_name=$fieldName&table=$tableName')
          : Uri.parse(
              '${BASE_URL}api/service_by_techicians?techician_id=$techFilter&from_date=$startDate&to_date=$endDate&file_type=$exportType&page=$page');
      //mock api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/84ef9e71-4038-4e03-9ccc-72046160b368");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

//Api call to get technican list for report module.
  Future<dynamic> getReportTechnicanList(String token) async {
    print("into provider");

    try {
      var url = Uri.parse(
        "${BASE_URL}api/techicians_list",
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

  // api to get shopperformance summary
  Future<dynamic> getShopPerformanceSummary(
      String token, String exportType) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/133183fa-775c-471f-a347-b75e8eb83c94");
      var url = Uri.parse(
          "${BASE_URL}api/shop_performace_summary?file_type=$exportType");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  // api to get transaction report
  Future<dynamic> getTransactionReport(
      String token,
      int page,
      String exportType,
      String createFilter,
      String? sortBy,
      String? fieldName,
      String? table) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/298211eb-6a30-4993-9116-9e42c60d7142");
      var url = sortBy != null && fieldName != null && table != null
          ? Uri.parse(
              "${BASE_URL}api/transaction?page=$page&file_type=$exportType&filter=$createFilter&sort_by=$sortBy&field_name=$fieldName&table=$table")
          : Uri.parse(
              "${BASE_URL}api/transaction?page=$page&file_type=$exportType&filter=$createFilter");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  // api to get all orders report
  Future<dynamic> getAllOrdersReport(
      String token,
      int page,
      String exportType,
      String createFilter,
      String? sortBy,
      String? fieldName,
      String? table) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/09a5e963-57f9-44ef-9c4f-647845583683");
      var url = sortBy != null && table != null && fieldName != null
          ? Uri.parse(
              "${BASE_URL}api/all_orders?page=$page&file_type=$exportType&filter=$createFilter&sort_by=$sortBy&field_name=$fieldName&table=$table")
          : Uri.parse(
              "${BASE_URL}api/all_orders?page=$page&file_type=$exportType&filter=$createFilter");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  // api to get line item detail report
  Future<dynamic> getLineItemDetailReport(
      String token,
      int page,
      String exportType,
      String createFilter,
      String? sortBy,
      String? fieldName,
      String? table) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/e989e845-a8eb-493d-b4d9-0085082415e2");

      //  sortBy != null && table != null && fieldName != null
      //     ? Uri.parse(
      //         "${BASE_URL}api/line_item_detail?page=$page&file_type=$exportType&type=$createFilter&sort_by=$sortBy&field_name=$fieldName&table=$table")
      //     :
      var url = Uri.parse(
          "${BASE_URL}api/line_item_detail?page=$page&file_type=$exportType&filter=$createFilter");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  // api to get end of day report
  Future<dynamic> getEndOfDayReport(String token, String exportType) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/7e8c5207-0834-473d-8a4d-0054cc7b10a1");
      var url = Uri.parse("${BASE_URL}api/end_of_day?file_type=$exportType");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  // api to get profitablity report
  Future<dynamic> getProfitablityReport(
      String token,
      String fromDate,
      String toDate,
      String serviceId,
      String exportType,
      int page,
      String? sortBy,
      String? fieldName,
      String? table) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/7e8c5207-0834-473d-8a4d-0054cc7b10a1");
      var url = sortBy != null && fieldName != null && table != null
          ? Uri.parse(
              "${BASE_URL}api/profitablity?from_date=$fromDate&to_date=$toDate&service_id=$serviceId&file_type=$exportType&page=$page&sort_by=$sortBy&field_name=$fieldName&table=$table")
          : Uri.parse(
              "${BASE_URL}api/profitablity?from_date=$fromDate&to_date=$toDate&service_id=$serviceId&file_type=$exportType&page=$page");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
    // api to get service writer data
  }

  // api to get summary by customer report
  Future<dynamic> getCustomerSummaryReport(
      String token,
      String createFilter,
      String exportType,
      int page,
      String? sortBy,
      String? fieldName,
      String? table) async {
    try {
      //mock api url. change to live api url
      // final url = Uri.parse(
      //     "https://run.mocky.io/v3/7e8c5207-0834-473d-8a4d-0054cc7b10a1");
      var url = sortBy != null && fieldName != null && table != null
          ? Uri.parse(
              "${BASE_URL}api/summary_by_customer?type=$createFilter&file_type=$exportType&page=$page&sort_by=$sortBy&field_name=$fieldName&table=$table")
          : Uri.parse(
              "${BASE_URL}api/summary_by_customer?type=$createFilter&file_type=$exportType&page=$page");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
    // api to get service writer data
  }

  //Api to get all service writer data

  Future<dynamic> getServiceWriter(String token) async {
    try {
      var url = Uri.parse("${BASE_URL}api/service_writer");
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }
}
