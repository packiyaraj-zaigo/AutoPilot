import 'dart:convert';
import 'dart:developer';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
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
  int showLoading = 0;
  int currentPage = 1;
  int totalPages = 1;
  final JsonDecoder _decoder = const JsonDecoder();
  Map errorRes = {};
  VechileBloc() : super(VechileInitial()) {
    on<GetAllVechile>(getAllVechile);
    on<AddVechile>(addAlllVechile);
    on<DropDownVechile>(dropdownVechile);
    on<DeleteVechile>(deleteVechile);
    on<EditVechileDetails>(editVechile);
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
      emit(VechileDetailsErrorState(message: e.toString()));
      isVechileLoading = false;
      isPagenationLoading = false;
    }
  }

  // getAllVechile(
  //   GetAllVechile event,
  //   Emitter<VechileState> emit,
  // ) async {
  //   try {
  //     emit(VechileDetailsLoadingState());
  //     if (currentPage == 1) {
  //       isVechileLoading = true;
  //     }
  //
  //     final token = await AppUtils.getToken();
  //     await apiRepo.getEmployees(token, currentPage).then((value) {
  //       if (value.statusCode == 200) {
  //         final responseBody = jsonDecode(value.body);
  //         emit(
  //           VechileDetailsSuccessStates(
  //             vechile: VechileResponse.fromJson(
  //               responseBody['data'],
  //             ),
  //           ),
  //         );
  //         final data = responseBody['data'];
  //         currentPage = data['current_page'] ?? 1;
  //         totalPages = data['last_page'] ?? 1;
  //         if (currentPage <= totalPages) {
  //           currentPage++;
  //         }
  //         print(value.body.toString());
  //       } else {
  //         log(value.body.toString());
  //         final body = jsonDecode(value.body);
  //         emit(VechileDetailsErrorState(message: body['message']));
  //       }
  //       isVechileLoading = false;
  //       isPagenationLoading = false;
  //     });
  //   } catch (e) {
  //     emit(VechileDetailsErrorState(message: e.toString()));
  //     isVechileLoading = false;
  //     isPagenationLoading = false;
  //   }
  // }
  //
  Future<void> addAlllVechile(
    AddVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      isVechileLoading = true;
      emit(AddVechileDetailsLoadingState());
      final token = await AppUtils.getToken();
      // Response addVechileRes = await _apiRepository.addVechile(
      //     event.context,event.year,event.type,event.make,event.model,event.licNumber,event.vinNumber,event.color,event.engine,event.submodel,event.email);
      // var addVechileData = _decoder.convert(addVechileRes.body);
      //

      final response = await apiRepo.addVechile(
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
        print("${response.body}");
        isVechileLoading = false;
        Navigator.pop(event.context, event.vinNumber);
        ScaffoldMessenger.of((event.context)).showSnackBar(
          SnackBar(
            content: Text('${vechileAdd['message']}'),
            backgroundColor: Colors.green,
          ),
        );
        emit(AddVechileDetailsPageNationLoading());
      } else if (response.statusCode == 422) {
        emit(AddVechileDetailsErrorState());
        errorRes = vechileAdd;
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: e.toString()));
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
        // print(
        //     "qqqqqqqqqqqqqqqqqqqqqeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwwwww${responseBody}");
        emit(
          DropdownVechileDetailsSuccessState(dropdownData: dropdownData),
        );
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: e.toString()));
      isVechileLoading = false;
    }
  }

  Future<void> deleteVechile(
    DeleteVechile event,
    Emitter<VechileState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      Response response = await apiRepo.deleteVechile(token, event.deleteId);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print(
            "qqqqqqqqqqqqqqqqqqqqqeeeeeeeeeeeeeeeeeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwwwww${responseBody}");
        emit(
          DeleteVechileDetailsSuccessState(
            vechile: VechileResponse.fromJson(
              responseBody["data"],
            ),
          ),
        );
      }
    } catch (e) {
      emit(VechileDetailsErrorState(message: e.toString()));
      isVechileLoading = false;
    }
  }

  Future<void> editVechile(
    EditVechileDetails event,
    Emitter<VechileState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      emit(EditVechileLoading());
      Response loadedResponse = await apiRepo.editVechile(
          token,
          (event.context),
          event.vehicletype,
          event.vehicleyear,
          event.vin,
          event.vehiclemodel,
          event.submodel,
          event.enginesize,
          event.kilometers,
          event.licenceplate,
          event.notes,
          event.unit,
          event.vehiclecolor,
          event.vehiclemake,
          event.context);
      var unloadData = _decoder.convert(loadedResponse.body);
      print('nnnnnnnnnnnnnnnnnnnnnnnnnn');

      print(unloadData.toString());
      if (loadedResponse.statusCode == 200 ||
          loadedResponse.statusCode == 201) {
        print('sssvvvvvvvvvvvvvvvvvvvvvvvs');

        Navigator.of(event.context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => VehiclesScreen(),
          ),
          (route) => false,
        );
      } else {
        emit(EditVechileError(message: unloadData));
      }
    } catch (e) {
      showLoading = 0;
      emit(EditVechileError(message: e.toString()));
    }
  }
}
