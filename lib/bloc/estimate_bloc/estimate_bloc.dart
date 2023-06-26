import 'dart:developer';

import 'package:auto_pilot/Models/estimate_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final ApiRepository _apiRepository;
  int currentPage=1;
  int totalPages=0;
  bool isFetching = false;
  EstimateBloc({
     required ApiRepository apiRepository,
  }) :_apiRepository = apiRepository, super(EstimateInitial()) {
    on<GetEstimateEvent>(getEstimateBloc);
  }

  Future<void> getEstimateBloc(
    GetEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      EstimateModel estimateModel;

      if(currentPage==1){
        emit(GetEstimateLoadingState());

      }

      

      Response getEstimateRes = await _apiRepository.getEstimate(token,event.orderStatus,currentPage);

      log("res${getEstimateRes.body}");

      if (getEstimateRes.statusCode == 200) {
        estimateModel = estimateModelFromJson(getEstimateRes.body);
        totalPages=estimateModel.data.lastPage??1;
        isFetching=false;
        emit(GetEstimateState(estimateData: estimateModel));

         if (totalPages > currentPage && currentPage != 0) {
          currentPage += 1;
        } else {
          currentPage = 0;
        }
      } else {
        emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));
      }
    } catch (e) {
      emit(const GetEstimateErrorState(errorMsg: "Something went wrong"));

      print(e.toString());

      print("thisss");
    }
  }
}
