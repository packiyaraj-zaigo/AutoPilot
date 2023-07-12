import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final apiRepo = ApiRepository();
  AppointmentBloc() : super(AppointmentInitial()) {
    on<CreateAppointmentEvent>(createAppointment);
  }

  createAppointment(
    CreateAppointmentEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final response =
          await apiRepo.createAppointment(token, event.appointment);
      final responseBody = jsonDecode(response.body);
      log(responseBody.toString());
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(CreateAppointmentSuccessState(
            id: responseBody['created_id'].toString()));
      } else {
        if (responseBody.containsKey('message')) {
          emit(CreateAppointmentErrorState(
              message: responseBody['message'].toString()));
        } else {
          emit(CreateAppointmentErrorState(
              message: responseBody[responseBody.keys.first][0].toString()));
        }
      }
    } catch (e) {
      emit(const CreateAppointmentErrorState(message: 'Something went wrong'));
      log("$e create appointment bloc error");
    }
  }
}
