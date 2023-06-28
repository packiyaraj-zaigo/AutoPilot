// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';


import 'package:auto_pilot/Screens/add_company_screen.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

   final ApiRepository _apiRepository;
  final JsonDecoder _decoder = const JsonDecoder();

  Map errorRes={};
 LoginBloc({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(LoginInitial()) {
          on<CreateAccountEvent>(createAccountBloc);
          on<UserLoginEvent>(loginBloc);
          on<ResetPasswordGetPasswordEvent>(resetPasswordGetOtpBloc);
          on<ResetPasswordSendOtpEvent>(resetPasswordSendOtpBloc);
   
  }



   Future<void> createAccountBloc(
    CreateAccountEvent event,
    Emitter<LoginState> emit,
  ) async {

    
    try {
      
      emit(CreateAccountLoadingState());

      Response createAccRes = await _apiRepository.createAccount(
          event.firstName,event.lastName,event.email,event.phoneNumber,event.password);
      var createAccData = _decoder.convert(createAccRes.body);
      log("res${createAccRes.body}");

      
      if (createAccRes.statusCode==201) {
        emit(CreateAccountSuccessState());
        AppUtils.setTempVar("user_created");
      }else if(createAccRes.statusCode==422){
        emit(CreateAccountErrorState());
        errorRes=createAccData;
      }
       
       
    } catch (e) {
      emit(CreateAccountErrorState());
      
      print(e.toString());
     // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }


   Future<void> loginBloc(
    UserLoginEvent event,
    Emitter<LoginState> emit,
  ) async {

    
    try {
       SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tempVar = prefs.getString(AppConstants.TEMP_VAR);
      
      emit(UserLoginLoadingState());

      Response userLoginRes = await _apiRepository.login(
        event.email,event.password);
      var userLoginData = _decoder.convert(userLoginRes.body);
      log("res${userLoginRes.body}");

      
      if (userLoginRes.statusCode==200) {
        emit(UserLoginSuccessState());
        AppUtils.setToken(userLoginData['access_token']);
        AppUtils.setUserID(userLoginData['client_id'].toString());

        if(tempVar!=null &&tempVar!=""){
          
        Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(
          builder: (context) {
            return const AddCompanyScreen();
      },), (route) => false);

        }else{
          
        Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(
          builder: (context) {
            return BottomBarScreen();
      },), (route) => false);
        }


      }else{
        if(userLoginRes.body.contains("email")){
           emit(UserLoginErrorState(
          errorMessage: userLoginData['email'][0]));
        }
        emit(UserLoginErrorState(
          errorMessage: userLoginData['message']
        ));
      }
       
       
    } catch (e) {
      emit(CreateAccountErrorState());

      print(e.toString());
     // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }



   Future<void> resetPasswordGetOtpBloc(
    ResetPasswordGetPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {


    try {

      emit(ResetPasswordGetOtpLoadingState());

      Response resetPasswordRes = await _apiRepository.resetPasswordGetOtp(
        event.emailId);
      var resetPasswordData = _decoder.convert(resetPasswordRes.body);
      log("res${resetPasswordRes.body}");


      if (resetPasswordRes.statusCode==200) {
        emit(ResetPasswordGetOtpState());

      }else{
        emit(ResetPasswordGetOtpErrorState(
          errorMsg: resetPasswordData['message']
        ));
      }


    } catch (e) {
      emit(ResetPasswordGetOtpErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
     // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }


   Future<void> resetPasswordSendOtpBloc(
    ResetPasswordSendOtpEvent event,
    Emitter<LoginState> emit,
  ) async {


    try {

      emit(ResetPasswordSendOtpLoadingState());

      Response resetPasswordRes = await _apiRepository.resetPasswordSendOtp(
        event.email,event.otp);
      var resetPasswordData = _decoder.convert(resetPasswordRes.body);
      log("res${resetPasswordRes.body}");


      if (resetPasswordRes.statusCode==200) {
        emit(ResetPasswordSendOtpState());

      }else{
        emit(ResetPasswordSendOtpErrorState(
          errorMsg: resetPasswordData['message']
        ));
      }


    } catch (e) {
      emit(ResetPasswordGetOtpErrorState(errorMsg: "Something went wrong"));

      print(e.toString());
     // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }
}
