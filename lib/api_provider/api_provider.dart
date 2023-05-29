
import 'dart:io';
import 'package:http/http.dart' as http;


class ApiProvider {
  //DEV Server
  // static const BASE_URL = "https://devgateway.getfieldy.com/z1/";
  //QA Server
  // static const BASE_URL = " https://qagateway.getfieldy.com/z1/"
  //Live Server
  static const BASE_URL = 'https://gateway.getfieldy.com/z1/';

  //LIVE Server
  // static const origin =  "https://app.getfieldy.com";
  //DEV Server
  static const origin = "https://devapp.fieldy.in";
  //QA Server
  //static const origin = "https://qaapp.zaigotech.com"

  late Map<String, String> requestHeaders;

  getHeader(String token) {
    return requestHeaders = {
      'device': 'mobile',
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
  }
}
