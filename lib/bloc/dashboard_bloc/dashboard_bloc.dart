import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/revenue_chart_model.dart';
import 'package:auto_pilot/Models/user_profile_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
 DashboardBloc({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(DashboardLoadingState()) {
         on<GetRevenueChartDataEvent>(getRevenueChartDataBloc);
         on<GetUserProfileEvent>(getUserProfileBloc);
        
   
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

      Response getChartDataRes = await _apiRepository.getRevenueChartData(token);
     // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${getChartDataRes.body}");

      
      if (getChartDataRes.statusCode==200) {
        revenueChartModel=revenueChartModelFromJson(getChartDataRes.body);
        emit(GetRevenueChartDataState(revenueData:revenueChartModel ));
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
           SharedPreferences prefs = await SharedPreferences.getInstance();
        var token = prefs.getString(AppConstants.USER_TOKEN);
      UserProfileModel userModel;
      
     // emit(DashboardLoadingState());

      Response getUserProfileRes = await _apiRepository.getUserProfile(token!);
     // var getChartData = _decoder.convert(getChartDataRes.body);
      log("res${getUserProfileRes.body}");

      
      if (getUserProfileRes.statusCode==200) {
        userModel=userProfileModelFromJson(getUserProfileRes.body);
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
}
