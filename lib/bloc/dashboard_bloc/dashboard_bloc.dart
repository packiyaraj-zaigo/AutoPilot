import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/province_model.dart';
import 'package:auto_pilot/Models/revenue_chart_model.dart';
import 'package:auto_pilot/Models/user_profile_model.dart';
import 'package:auto_pilot/Screens/add_company_screen.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  // ignore: unused_field
  final ApiRepository _apiRepository;
  // ignore: unused_field
  final JsonDecoder _decoder = const JsonDecoder();
  String? token = '';
  int currentPage = 1;
  int totalPages = 0;
  bool isFetching = false;
  DashboardBloc({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(DashboardLoadingState()) {
    on<GetRevenueChartDataEvent>(getRevenueChartDataBloc);
    on<GetUserProfileEvent>(getUserProfileBloc);
    on<GetProvinceEvent>(getProvinceBloc);
    on<AddCompanyEvent>(addCompanyBloc);
  }

  Future<void> getRevenueChartDataBloc(
    GetRevenueChartDataEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      RevenueChartModel revenueChartModel;

      emit(DashboardLoadingState());

      Response getChartDataRes =
          await _apiRepository.getRevenueChartData(token);
      // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${getChartDataRes.body}");

      if (getChartDataRes.statusCode == 200) {
        revenueChartModel = revenueChartModelFromJson(getChartDataRes.body);
        emit(GetRevenueChartDataState(revenueData: revenueChartModel));
      }
      // else if(createAccRes.statusCode==422){
      //   emit(CreateAccountErrorState());
      //   errorRes=createAccData;
      // }
    } catch (e) {
      // emit(CreateAccountErrorState());

      print(e.toString());
      // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }

  Future<void> getUserProfileBloc(
    GetUserProfileEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // var token = prefs.getString(AppConstants.USER_TOKEN);
      var token = await AppUtils.getToken();
      UserProfileModel userModel;

      // emit(DashboardLoadingState());

      Response getUserProfileRes = await _apiRepository.getUserProfile(token);
      // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${getUserProfileRes.body}");

      if (getUserProfileRes.statusCode == 200) {
        userModel = userProfileModelFromJson(getUserProfileRes.body);
        emit(GetProfileDetailsState(userProfile: userModel));
      }
      // else if(createAccRes.statusCode==422){
      //   emit(CreateAccountErrorState());
      //   errorRes=createAccData;
      // }
    } catch (e) {
      // emit(CreateAccountErrorState());

      print(e.toString());
      // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }

  Future<void> getProvinceBloc(
    GetProvinceEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      ProvinceModel provinceModel;

      // emit(DashboardLoadingState());

      Response getProvinceRes =
          await _apiRepository.getProvince(token!, currentPage);
      // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${getProvinceRes.body}");

      if (getProvinceRes.statusCode == 200) {
        provinceModel = provinceModelFromJson(getProvinceRes.body);
        totalPages = provinceModel.data.lastPage ?? 1;
        isFetching = false;

        print("before emit");
        emit(GetProvinceState(provinceList: provinceModel));

        if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      }
      // else if(createAccRes.statusCode==422){
      //   emit(CreateAccountErrorState());
      //   errorRes=createAccData;
      // }
    } catch (e) {
      // emit(CreateAccountErrorState());

      print(e.toString());
      // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }

  Future<void> addCompanyBloc(
    AddCompanyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      var clientId = prefs.getString(AppConstants.USER_ID);

      emit(AddCompanyLoadingState());

      Response addCompanyResponse = await _apiRepository.addCompany(
          event.dataMap, token, clientId!, event.imagePath);
      // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${addCompanyResponse.body}");

      if (addCompanyResponse.statusCode == 200) {
        prefs.setBool('add_company', true);
        emit(AddCompanySucessState());
        AppUtils.setTempVar("");
        Navigator.pushAndRemoveUntil(event.context, MaterialPageRoute(
          builder: (context) {
            return BottomBarScreen();
          },
        ), (route) => false);
      } else {
        emit(AddCompanyErrorState(
            errorMessage: "Adding your company has been failed!"));
      }
      // else if(createAccRes.statusCode==422){
      //   emit(CreateAccountErrorState());
      //   errorRes=createAccData;
      // }
    } catch (e) {
      // emit(CreateAccountErrorState());
      emit(AddCompanyErrorState(
          errorMessage: "Adding your company has been failed!"));

      print(e.toString());
      // emit(LoginInvalidCredentialsState(message: e.toString()));
      print("thisss");
    }
  }
}
