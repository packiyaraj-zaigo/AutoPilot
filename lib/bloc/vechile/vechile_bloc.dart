import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Models/vehicle_notes_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../Models/vechile_model.dart';
import '../../Screens/vehicles_screen.dart';

class VechileBloc extends Bloc<VechileEvent, VechileState> {
  bool isVechileLoading = false;
  final apiRepo = ApiRepository();
  bool isPagenationLoading = false;

  int currentPage = 1;
  int totalPages = 1;
  final JsonDecoder _decoder = const JsonDecoder();
  Map errorRes = {};
  VechileBloc() : super(VechileInitial()) {
    on<GetAllVechile>(getAllVechile);
    on<AddVechile>(addAlllVechile);
    on<DropDownVechile>(dropdownVechile);
    on<DeleteVechile>(deleteVechile);
    on<EditVehicleEvent>(editVehicle);
    on<GetVehicleNoteEvent>(getVehicleNoteBloc);
    on<AddVehicleNoteEvent>(addVehicleNoteBloc);
    on<DeleteVehicleNotesEvent>(deleteVehicleNoteBloc);
  }
  getAllVechile(
    GetAllVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(VechileDetailsLoadingState());
      if (currentPage == 1) {
        isVechileLoading = true;
      }

      final token = await AppUtils.getToken();
      Response response =
          await apiRepo.getVechile(token, currentPage, event.query);
      if (response.statusCode == 200) {
        print(response.body);
        final responseBody = jsonDecode(response.body);
        emit(
          VechileDetailsSuccessStates(
            vechile: VechileResponse.fromJson(
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
        emit(VechileDetailsErrorState(message: body['message']));
      }
      isVechileLoading = false;
      isPagenationLoading = false;
    } catch (e) {
      print(e.toString() + "catch error");
      emit(VechileDetailsErrorState(message: "Something went wrong"));
      isVechileLoading = false;
      isPagenationLoading = false;
    }
  }

  Future<void> addAlllVechile(
    AddVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      isVechileLoading = true;
      emit(AddVechileDetailsLoadingState());
      final token = await AppUtils.getToken();

      final response = await apiRepo.addVechile(
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
        isVechileLoading = false;

        emit(CreateVehicleSuccessState(
            createdId: vechileAdd['created_id'].toString()));
      } else {
        if (vechileAdd.containsKey('message')) {
          emit(CreateVehicleErrorState(message: vechileAdd['message']));
        } else if (vechileAdd.containsKey('error')) {
          emit(CreateVehicleErrorState(message: vechileAdd['error']));
        } else {
          emit(CreateVehicleErrorState(
              message: vechileAdd[vechileAdd.keys.first][0]));
        }
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: 'Something went wrong'));
      isVechileLoading = false;
    }
  }

  Future<void> dropdownVechile(
    DropDownVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(VechileDetailsLoadingState());
      DropDown dropdownData;
      final token = await AppUtils.getToken();
      Response response = await apiRepo.dropdownVechile(token);
      if (response.statusCode == 200) {
        dropdownData = dropDownFromJson(response.body);
        emit(
          DropdownVechileDetailsSuccessState(dropdownData: dropdownData),
        );
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: "Something went wrong"));
      isVechileLoading = false;
    }
  }

  Future<void> deleteVechile(
    DeleteVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(DeleteVechileDetailsLoadingState());
      final token = await AppUtils.getToken();
      Response response = await apiRepo.deleteVechile(token, event.id);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        emit(
          DeleteVechileDetailsSuccessState(),
        );
      }
    } catch (e) {
      emit(DeleteVechileDetailsErrorState(message: "Something went wrong"));
      isVechileLoading = false;
    }
  }

  editVehicle(
    EditVehicleEvent event,
    Emitter<VechileState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final response = await apiRepo.editVechile(
        token,
        event.id,
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
      final body = await jsonDecode(response.body);
      log(body[body.keys.first][0].toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(EditVehicleSuccessState());
      } else {
        if (body.containsKey('message')) {
          emit(EditVehicleErrorState(message: body['message']));
        } else if (body.containsKey('error')) {
          emit(EditVehicleErrorState(message: body['error']));
        } else {
          emit(EditVehicleErrorState(message: body[body.keys.first][0]));
        }
      }
    } catch (e) {
      log(e.toString() + " Edit bloc error");
      emit(EditVehicleErrorState(message: "Something went wrong"));
    }
  }

  getVehicleNoteBloc(
    GetVehicleNoteEvent event,
    Emitter<VechileState> emit,
  ) async {
    try {
      VehicleNoteModel vehicleNoteModel;
      final token = await AppUtils.getToken();
      Response response = await apiRepo.getVehicleNotes(token, event.vehicleId);
      //  final body = await jsonDecode(response.body);
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        vehicleNoteModel = vehicleNoteModelFromJson(response.body);
        emit(GetVehicleNoteState(vehicleModel: vehicleNoteModel));
      } else {
        emit(GetVehicleNoteErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log(e.toString() + " Edit bloc error");
      emit(GetVehicleNoteErrorState(errorMessage: "Something went wrong"));
    }
  }

  addVehicleNoteBloc(
    AddVehicleNoteEvent event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(AddVehicleNoteLoadingState());
      final token = await AppUtils.getToken();
      Response response =
          await apiRepo.addVehicleNotes(token, event.vehicleId, event.notes);
      //  final body = await jsonDecode(response.body);
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddVehicleNoteState());
      } else {
        emit(AddVehicleNoteErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log(e.toString() + " Edit bloc error");
      emit(AddVehicleNoteErrorState(errorMessage: "Something went wrong"));
    }
  }

  deleteVehicleNoteBloc(
    DeleteVehicleNotesEvent event,
    Emitter<VechileState> emit,
  ) async {
    try {
      emit(DeleteVehicleNoteLoadingState());
      final token = await AppUtils.getToken();
      Response response =
          await apiRepo.deleteVehicleNotes(token, event.vehicleId);
      //  final body = await jsonDecode(response.body);
      log(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(DeleteVehicleNoteState());
      } else {
        emit(DeleteVehicleNoteErrorState(errorMessage: "Something went wrong"));
      }
    } catch (e) {
      log(e.toString() + " Edit bloc error");
      emit(DeleteVehicleNoteErrorState(errorMessage: "Something went wrong"));
    }
  }
}
