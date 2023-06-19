
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;


class ApiProvider {
  //DEV Server

  static const BASE_URL = 'http://ec2-13-235-8-199.ap-south-1.compute.amazonaws.com/';


  late Map<String, String> requestHeaders;

  getHeader(String token) {
    return requestHeaders = {
     
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }


  Future<dynamic> createAccount(
      String firstName,String lastName,String email,String password,String phoneNumber) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse(
       "${BASE_URL}api/register"
           
      );
      var request = http.MultipartRequest("POST", url)
        ..fields['email'] = email
        ..fields['first_name'] = firstName
        ..fields['last_name']=lastName
        ..fields['emp_phone']=phoneNumber
        ..fields['password']=password
        ..fields['users']=json.encode([]);

     

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


   Future<dynamic> login(
      String email,String password) async {
    print("into provider");

    //  LoadingFormModel? loadingFormModel;
    try {
      var url = Uri.parse(
       "${BASE_URL}api/login"
           
      );
      var request = http.MultipartRequest("POST", url)
        ..fields['email'] = email
      
        ..fields['password']=password;
      

     

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

  Future<dynamic> getEmployees(String token, int page) async {
    try {
      final url = page == 1
          ? '${BASE_URL}api/users'
          : '${BASE_URL}api/users?page=$page';
      var response = http.get(Uri.parse(url), headers: getHeader(token));
      return response;
    } catch (e) {
      print(e.toString() + 'get employee error');
    }
  }
}
