import 'dart:developer';

import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';

part 'service_event.dart';
part 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final apiRepo = ApiRepository();
  ServiceBloc() : super(ServiceInitial()) {
    on<CreateCannedOrderServiceEvent>(createCannedOrderService);
  }

  Future<void> createCannedOrderService(
    CreateCannedOrderServiceEvent event,
    Emitter<ServiceState> emit,
  ) async {
    try {
      bool materialDone = false;
      bool partDone = false;
      bool laborDone = false;
      bool subcontractDone = false;
      bool feeDone = false;
      final token = await AppUtils.getToken();
      final Response serviceCreateResponse =
          await apiRepo.createCannedOrderService(token, event.service);
      if (serviceCreateResponse.statusCode == 200 ||
          serviceCreateResponse.statusCode == 201) {
        if (event.material != null) {
          final Response materialResponse = await apiRepo
              .createCannedOrderServiceItem(token, event.material!);
          if (materialResponse.statusCode == 200 ||
              materialResponse.statusCode == 201) {
            materialDone = true;
          }
        }
        if (event.part != null) {
          final Response partResponse =
              await apiRepo.createCannedOrderServiceItem(token, event.part!);
          if (partResponse.statusCode == 200 ||
              partResponse.statusCode == 201) {
            partDone = true;
          }
        }
        if (event.labor != null) {
          final Response laborResponse =
              await apiRepo.createCannedOrderServiceItem(token, event.labor!);
          if (laborResponse.statusCode == 200 ||
              laborResponse.statusCode == 201) {
            laborDone = true;
          }
        }
        if (event.subcontract != null) {
          final Response subcontractResponse = await apiRepo
              .createCannedOrderServiceItem(token, event.subcontract!);
          if (subcontractResponse.statusCode == 200 ||
              subcontractResponse.statusCode == 201) {
            subcontractDone = true;
          }
        }
        if (event.fee != null) {
          final Response feeResponse =
              await apiRepo.createCannedOrderServiceItem(token, event.fee!);
          if (feeResponse.statusCode == 200 || feeResponse.statusCode == 201) {
            feeDone = true;
          }
        }
        emit(CreateCannedOrderServiceSuccessState());
      } else {
        emit(const CreateCannedOrderServiceErrorState(
            message: 'Something went wrong'));
      }
    } catch (e) {
      log("$e Create service bloc error");
      emit(const CreateCannedOrderServiceErrorState(
          message: "Something went wrong"));
    }
  }
}
