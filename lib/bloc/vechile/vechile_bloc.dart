import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Models/vechile_model.dart';

class VechileBloc extends Bloc<VechileEvent, VechileState> {
  bool isVechileLoading = false;
  final ApiRepository _apiRepository;

  int currentPage = 1;
  int totalPages = 1;
  final JsonDecoder _decoder = const JsonDecoder();
  VechileBloc({required ApiRepository apiRepository})
      : _apiRepository = apiRepository,
        super(VechileInitial()) {
    on<GetAllVechile>(getAllVechile);
    on<AddVechile>(addAlllVechile);
  }

  Future<void> getAllVechile(
    GetAllVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(VechileDetailsLoadingState());
      final token = await AppUtils.getToken();
      Response response = await _apiRepository.getVechile(token);
      if (response.statusCode == 200) {
        Response responseBody = await _apiRepository.getVechile(token);
        // print(
        //     "qqqqqqqqqqqqqqqqqqqqqeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwwwww${responseBody}");
        emit(
          VechileDetailsSuccessState(
            vechile: temperaturesFromJson(
              responseBody.body,
            ),
          ),
        );
        print(
            "qqqqqqqqqqqqqqqqqqqqqeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwwwww${responseBody}");
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: e.toString()));
      isVechileLoading = false;
    }
  }

  Future<void> addAlllVechile(
    AddVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(AddVechileDetailsLoadingState());
      final token = await AppUtils.getToken();
      Response response = await _apiRepository.addVechile(
        event.context,
        token,
        event.email,
        event.year,
        event.model,
        event.submodel,
        event.engine,
        event.color,
        event.vinNumber,
        event.licNumber,
        event.type,
        event.make,
      );
      var vechileAdd = _decoder.convert(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("${response.statusCode}");
        ScaffoldMessenger.of((event.context)).showSnackBar(SnackBar(
            content: Text('${vechileAdd['message']}'),
            backgroundColor: Colors.green));
        emit(AddVechileDetailsPageNationLoading());
        print(
            "qqqqqqqqqqqqqqqqqqqqqeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwwwww${vechileAdd['message']}");
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: e.toString()));
      isVechileLoading = false;
    }
  }
}
