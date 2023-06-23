import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/Models/single_vehicle_response.dart';
import 'package:auto_pilot/Models/vehicle_estimate_reponse.dart';
import 'package:auto_pilot/Models/vin_global_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:timezone/timezone.dart';

part 'scanner_event.dart';
part 'scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  int currentEstimatePage = 1;
  int totalEstimatePages = 1;
  bool isEstimatePagenationLoading = false;
  String vehicleId = '';
  final apiRepo = ApiRepository();

  ScannerBloc() : super(ScannerInitial()) {
    on<GetVehiclesFromVin>(getVehicleFromVin);
    on<EstimatePageNation>(estimatePageNation);
  }

  getVehicleFromVin(
    GetVehiclesFromVin event,
    Emitter<ScannerState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final localResponse = await apiRepo.getVinDetailsLocal(token, event.vin);
      if (localResponse.statusCode == 200) {
        final body = jsonDecode(localResponse.body);
        if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
          final vehicle =
              SingleVehicleResponseModel.fromJson(body['data']['data'][0]);
          vehicleId = vehicle.id.toString();
          log(vehicleId.toString());
          // Estimate for the above vehicle

          try {
            final estimateResponse = await apiRepo.getVehicleEstimates(
                token, vehicleId, currentEstimatePage);
            if (estimateResponse.statusCode == 200) {
              final estimateBody = jsonDecode(estimateResponse.body);
              final List<VehicleEstimateResponseModel> estimates = [];
              estimateBody['data']['data'].forEach((estimate) {
                estimates.add(VehicleEstimateResponseModel.fromJson(estimate));
              });
              emit(VinCodeInShopState(vehicle: vehicle, estimates: estimates));
              return;
            } else {
              throw '';
            }
          } catch (e) {
            emit(VinCodeInShopState(vehicle: vehicle, estimates: []));
            return;
          }
        }
      }
      final globalResponse = await apiRepo.getVinDetailsGlobal(event.vin);
      if (globalResponse.statusCode == 200) {
        final body = jsonDecode(globalResponse.body);
        final VinGlobalSearchResponseModel globalVehicle =
            VinGlobalSearchResponseModel.fromJson(body['Results'][0]);
        if (globalVehicle.bodyClass != '' ||
            globalVehicle.displacementCc != '' ||
            globalVehicle.driveType != '' ||
            globalVehicle.make != '' ||
            globalVehicle.manufacturer != '' ||
            globalVehicle.model != '' ||
            globalVehicle.modelYear != '' ||
            globalVehicle.transmissionStyle != '' ||
            globalVehicle.vehicleType != '') {
          emit(VinCodeNotInShopState(vehicle: globalVehicle));
        } else {
          emit(VehicleNotFoundState());
        }
      }
    } catch (e) {
      log(e.toString() + "::::::::::::::::::::::::::");
      emit(VinSearchErrorState(message: e.toString()));
    }
  }

  estimatePageNation(
    EstimatePageNation event,
    Emitter<ScannerState> emit,
  ) async {
    try {
      isEstimatePagenationLoading = true;
      final token = await AppUtils.getToken();
      currentEstimatePage = currentEstimatePage + 1;
      final response = await apiRepo.getVehicleEstimates(
          token, vehicleId, currentEstimatePage);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['data']['data'] != null) {
          final List<VehicleEstimateResponseModel> estimates = [];
          body['data']['data'].forEach((estimate) {
            estimates.add(VehicleEstimateResponseModel.fromJson(estimate));
          });
          emit(PageNationSucessState(estimates: estimates));
        }
        totalEstimatePages = body['data']['total'] ?? 1;
      }
    } catch (e) {
      emit(PageNationErrorState());
    }
    isEstimatePagenationLoading = false;
  }
}
