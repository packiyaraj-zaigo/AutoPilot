import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../Models/calendar_model.dart';
import '../../api_provider/api_repository.dart';
import '../../utils/app_utils.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final ApiRepository _apiRepository;
  int showLoading = 0;
  DateTime? selectedDate;

  CalendarBloc({
    required ApiRepository apiRepository,
  })  : _apiRepository = apiRepository,
        super(CalendarInitial()) {
    on<CalendarDetails>(calendarEvent);
    // on<CalendarButtonUpdate>(calendarButtonUpdate);
  }
  Future<void> calendarEvent(
    CalendarDetails event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(CalendarLoading());
      final token = await AppUtils.getToken();
      Response loadedResponse =
          await _apiRepository.calendarload(token, event.selectedDate);
      if (loadedResponse.statusCode == 200) {
        emit(CalendarReady(
            calendarModel: calendarModelFromJson(loadedResponse.body)));
        print('=======-------------------------${loadedResponse.body}');
      }
    } catch (e) {
      showLoading = 0;
      emit(CalendarError(message: e.toString()));
    }
  }
}
