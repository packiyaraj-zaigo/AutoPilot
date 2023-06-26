import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Screens/customer_information_screen.dart';
import '../Models/employee_creation_model.dart';

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

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse("${BASE_URL}api/register");
      var request = http.MultipartRequest("POST", url)
        ..fields['email'] = email
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['emp_phone'] = phoneNumber
        ..fields['password'] = password
        ..fields['users'] = json.encode([]);

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
        "${BASE_URL}api/password/find",
      );
      var request = http.MultipartRequest("GET", url)
        ..fields['email'] = email
        ..fields['code'] = otp;

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
      String url = '${BASE_URL}api/users';

      if (page != 1) {
        url = '$url?page=$page';
      }
      if (query != '') {
        if (url.contains('?')) {
          url = '$url&first_name=$query';
        } else {
          url = '$url?first_name=$query';
        }
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
      String url = '${BASE_URL}api/users';

      if (page != 1) {
        url = '$url?page=$page';
      }
      if (query != '') {
        if (url.contains('?')) {
          url = '$url&first_name=$query';
        } else {
          url = '$url?first_name=$query';
        }
      }
      print(url);
      var response = http.get(Uri.parse(url), headers: getHeader(token));
      return response;
    } catch (e) {
      print(e.toString() + 'get employee error');
    }
  }

  Future<dynamic> getVechile(String token, int page, String query) async {
    try {
      String url = '${BASE_URL}api/vehicles';
      if (page != 1) {
        url = '$url?page=$page';
      }
      if (query != '') {
        if (url.contains('?')) {
          url = '$url&vehicle_model=$query';
        } else {
          url = '$url?vehicle_model=$query';
        }
      }
      // : '${BASE_URL}api/vehicles?page=${page + 1}';
      var response = http.get(Uri.parse(url), headers: getHeader(token));
      print(response);
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
  ) async {
    print("eeeeeeeeeeeeeeeeeeeeeeeeeee$token");

    //  LoadingFormModel? loadingFormModel;
    try {
      final clientId = await AppUtils.getUserID();
      var url = Uri.parse(
          "${BASE_URL}api/vehicles?customer_id=4&client_id=$clientId");
      var request = http.MultipartRequest("POST", url)
        ..headers['Authorization'] = "Bearer $token"
        ..fields['vehicle_type'] = type
        ..fields['vehicle_year'] = year
        ..fields['vehicle_make'] = make
        ..fields['vehicle_model'] = model
        ..fields['vehicle_color'] = color
        ..fields['engine_size'] = engine
        ..fields['vin'] = vinNumber
        ..fields['licence_plate'] = licNumber
        ..fields['sub_model'] = submodel;
      var response = await request.send();
      inspect(response);
      print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww${response.statusCode}");
      print(response.toString() + "provider status code");
      print(response.toString() + "provider response");
      final responseData = await http.Response.fromStream(response);
      return responseData;
    } catch (e) {
      print(e.toString() + "provider error");
    }
  }

  Future<dynamic> customerLoad(String token) async {
    try {
      final clientId = await AppUtils.getUserID();

      var url = Uri.parse('${BASE_URL}api/customers?client_id=$clientId');
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
        ..fields['state'] = state
        ..fields['town_city'] = city
        ..fields['zipcode'] = pinCode;

      var response = await request.send();
      print('object===============================');
      if (response.statusCode == 200 || response.statusCode == 201) {}
      print(response.statusCode.toString());
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
      final url = Uri.parse('${BASE_URL}api/vehicles?vin=$vin');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
    }
  }

  Future<dynamic> getVehicleEstimates(
      String token, String vehicleId, int page) async {
    try {
      final url =
          Uri.parse('${BASE_URL}api/orders?vehicle_id=$vehicleId&page=$page');
      final response = http.get(url, headers: getHeader(token));
      return response;
    } catch (e) {
      log('Error on getting local response');
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
}
