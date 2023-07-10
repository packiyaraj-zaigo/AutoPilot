import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/vechile_model.dart';
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
  int licCurrentEstimatePage = 1;
  int licTotalEstimatePages = 1;
  bool isEstimatePagenationLoading = false;
  String vehicleId = '';
  final apiRepo = ApiRepository();

  ScannerBloc() : super(ScannerInitial()) {
    on<GetVehiclesFromVin>(getVehicleFromVin);
    on<LicEstimatePageNation>(licEstimatePageNation);
    on<GetVehiclesFromLic>(getVehicleFromLic);
    on<EstimatePageNation>(estimatePageNation);
  }

  getVehicleFromVin(
    GetVehiclesFromVin event,
    Emitter<ScannerState> emit,
  ) async {
    try {
      emit(VinSearchLoadingState());
      final token = await AppUtils.getToken();
      final localResponse = await apiRepo.getVinDetailsLocal(token, event.vin);
      if (localResponse.statusCode == 200) {
        final body = jsonDecode(localResponse.body);
        if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
          final vehicle = Datum.fromJson(body['data']['data'][0]);
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
              totalEstimatePages = estimateBody['data']['last_page'] ?? 1;
              currentEstimatePage = estimateBody['data']['current_page'] ?? 1;
              return;
            } else {
              throw '';
            }
          } catch (e) {
            log(e.toString() + 'errorrrr');
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
      emit(VinSearchErrorState(message: 'Something went wrong'));
    }
  }

  estimatePageNation(
    EstimatePageNation event,
    Emitter<ScannerState> emit,
  ) async {
    try {
      emit(VinSearchLoadingState());
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
      }
    } catch (e, s) {
      log(s.toString());
      emit(PageNationErrorState());
    }
    isEstimatePagenationLoading = false;
  }

  getVehicleFromLic(
    GetVehiclesFromLic event,
    Emitter<ScannerState> emit,
  ) async {
    try {
      emit(LicSearchLoadingState());
      final token = await AppUtils.getToken();
      final localResponse = await apiRepo.getLicDetails(token, event.lic);
      if (localResponse.statusCode == 200) {
        final body = jsonDecode(localResponse.body);
        if (body['data']['data'] != null && body['data']['data'].isNotEmpty) {
          final vehicle = Datum.fromJson(body['data']['data'][0]);
          vehicleId = vehicle.id.toString();
          log(vehicleId.toString());

          try {
            final estimateResponse = await apiRepo.getVehicleEstimates(
                token, vehicleId, licCurrentEstimatePage);
            if (estimateResponse.statusCode == 200) {
              final estimateBody = jsonDecode(estimateResponse.body);
              final List<VehicleEstimateResponseModel> estimates = [];
              estimateBody['data']['data'].forEach((estimate) {
                estimates.add(VehicleEstimateResponseModel.fromJson(estimate));
              });
              emit(LicPlateFound(vehicle: vehicle, estimates: estimates));
              licTotalEstimatePages = estimateBody['data']['last_page'] ?? 1;
              licCurrentEstimatePage =
                  estimateBody['data']['current_page'] ?? 1;
              return;
            } else {
              throw 'Something went wrong';
            }
          } catch (e) {
            log(e.toString() + 'errorrrr');
            emit(LicPlateFound(vehicle: vehicle, estimates: []));
            return;
          }
        } else {
          throw 'No vehicles found';
        }
      }
    } catch (e) {
      log(e.toString() + "::::::::::::::::::::::::::");
      emit(LicSearchErrorState(message: e.toString()));
    }
  }

  licEstimatePageNation(
    LicEstimatePageNation event,
    Emitter<ScannerState> emit,
  ) async {
    try {
      emit(LicSearchLoadingState());
      final token = await AppUtils.getToken();
      licCurrentEstimatePage = licCurrentEstimatePage + 1;
      final response = await apiRepo.getVehicleEstimates(
          token, vehicleId, licCurrentEstimatePage);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['data']['data'] != null) {
          final List<VehicleEstimateResponseModel> estimates = [];
          body['data']['data'].forEach((estimate) {
            estimates.add(VehicleEstimateResponseModel.fromJson(estimate));
          });
          emit(LicPageNationSucessState(estimates: estimates));
        }
      }
    } catch (e, s) {
      log(s.toString());
      emit(LicPageNationErrorState());
    }
    isEstimatePagenationLoading = false;
  }
}
