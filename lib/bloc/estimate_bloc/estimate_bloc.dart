import 'dart:developer';

import 'package:auto_pilot/Models/estimate_model.dart';
import 'package:auto_pilot/Models/estimation_details_model.dart';
import 'package:auto_pilot/Screens/estimate_details_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'estimate_event.dart';
part 'estimate_state.dart';

class EstimateBloc extends Bloc<EstimateEvent, EstimateState> {
  final ApiRepository _apiRepository;
  int currentPage = 1;
  int totalPages = 0;
  bool isFetching = false;
  EstimateBloc({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(EstimateInitial()) {
    on<GetEstimateEvent>(getEstimateBloc);
    on<CreateNewEstimateEvent>(createNewEstimateBloc);
  }

  Future<void> getEstimateBloc(
    GetEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      EstimateModel estimateModel;

      if (currentPage == 1) {
        emit(GetEstimateLoadingState());
      }

      Response getEstimateRes = await _apiRepository.getEstimate(
          token, event.orderStatus, currentPage);

      log("res${getEstimateRes.body}");

      if (getEstimateRes.statusCode == 200) {
        estimateModel = estimateModelFromJson(getEstimateRes.body);
        totalPages = estimateModel.data.lastPage ?? 1;
        isFetching = false;
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

  Future<void> createNewEstimateBloc(
    CreateNewEstimateEvent event,
    Emitter<EstimateState> emit,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.USER_TOKEN);
      EstimationDetailsModel estimateDetails;

      Response createNewEstimateRes = await _apiRepository.createNewEstimate(
          event.customerId, event.vehicleId, token);

      log("res${createNewEstimateRes.body}");

      if (createNewEstimateRes.statusCode == 201) {
        estimateDetails =
            estimationDetailsModelFromJson(createNewEstimateRes.body);
        emit(CreateNewEstimateState(estimateDetails: estimateDetails));
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
