import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/Models/parts_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/parts_model/parts_event.dart';
import 'package:auto_pilot/bloc/parts_model/parts_state.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PartsBloc extends Bloc<PartsEvent, PartsState> {
  bool isPartsLoading = false;
  final apiRepo = ApiRepository();
  bool isPagenationLoading = false;

  int currentPage = 1;
  int totalPages = 1;
  final JsonDecoder _decoder = const JsonDecoder();
  Map errorRes = {};
  PartsBloc() : super(PartsInitial()) {
    on<GetAllParts>(getAllParts);
    on<AddParts>(addAllParts);
  }

  getAllParts(
    GetAllParts event,
    Emitter<PartsState> emit,
  ) async {
    try {
      emit(PartsDetailsLoadingState());
      if (currentPage == 1) {
        isPartsLoading = true;
      }

      final token = await AppUtils.getToken();
      Response response =
          await apiRepo.getParts(token, currentPage, event.query);
      if (response.statusCode == 200) {
        print(response.body);
        final responseBody = jsonDecode(response.body);
        emit(
          PartsDetailsSuccessStates(
            part: Parts.fromJson(
              responseBody,
            ),
          ),
        );
        final data = responseBody['data'];
        currentPage = data['current_page'] ?? 1;

        totalPages = data['last_page'] ?? 1;
        print(totalPages.toString() + ':::::::::::::::');
        if (currentPage <= totalPages) {
          currentPage++;
        }
        print(response.body.toString());
      } else {
        log(response.body.toString());
        final body = jsonDecode(response.body);
        emit(PartsDetailsErrorState(message: body['message']));
      }
      isPartsLoading = false;
      isPagenationLoading = false;
    } catch (e) {
      print(e.toString() + "catch error");
      emit(PartsDetailsErrorState(message: e.toString()));
      isPartsLoading = false;
      isPagenationLoading = false;
    }
  }

  Future<void> addAllParts(
    AddParts event,
    Emitter<PartsState> emit,
  ) async {
    try {
      isPartsLoading = true;
      emit(AddPartsDetailsLoadingState());
      final token = await AppUtils.getToken();
      // Response addVechileRes = await _apiRepository.addVechile(
      //     event.context,event.year,event.type,event.make,event.model,event.licNumber,event.vinNumber,event.color,event.engine,event.submodel,event.email);
      // var addVechileData = _decoder.convert(addVechileRes.body);
      //

      Response response = await apiRepo.addParts(
          event.context,
          token,
          event.itemname,
          event.epa,
          event.fee,
          event.supplies,
          event.serialnumber,
          event.cost,
          event.quantity,
          event.type);
      var partsAdd = _decoder.convert(response.body);
      print("33333333333333333333######3${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("${response.statusCode}");
        isPartsLoading = false;
        Navigator.pop(
          event.context,
        );
        ScaffoldMessenger.of((event.context)).showSnackBar(
          SnackBar(
            content: Text('${partsAdd['message']}'),
            backgroundColor: Colors.green,
          ),
        );
        emit(PartsDetailsPageNationLoading());
      } else if (response.statusCode == 422) {
        emit(AddPartDetailsErrorState());
        errorRes = partsAdd;
      }
    } catch (e) {
      emit(PartsDetailsErrorState(message: e.toString()));
      isPartsLoading = false;
    }
  }
}
