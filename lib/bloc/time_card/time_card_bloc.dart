import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/api_provider/api_provider.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/Models/time_card_create_model.dart';
import 'package:auto_pilot/Models/time_card_model.dart';
import 'package:http/http.dart';

part 'time_card_event.dart';
part 'time_card_state.dart';

class TimeCardBloc extends Bloc<TimeCardEvent, TimeCardState> {
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  final apiRepo = ApiRepository();

  TimeCardBloc() : super(TimeCardInitial()) {
    on<GetAllTimeCardsEvent>(getAllTimeCards);
    on<CreateTimeCardEvent>(createTimeCard);
  }

  getAllTimeCards(
    GetAllTimeCardsEvent event,
    Emitter<TimeCardState> emit,
  ) async {
    emit(GetAllTimeCardsLoadingState());
    if (currentPage != 1) {
      isLoading = true;
    }
    try {
      final token = await AppUtils.getToken();
      final Response response = await apiRepo.getAllTimeCards(token);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        log(body.toString() + "BODY");
        log(body['data'].toString());
        final List<TimeCardModel> timeCards = [];
        if (body['data'] != null && body['data'].isNotEmpty) {
          body['data'].forEach((json) {
            timeCards.add(TimeCardModel.fromJson(json));
          });
        }
        emit(GetAllTimeCardsSucessState(timeCards: timeCards));
      } else {
        throw body[body.keys.first][0];
      }
    } catch (e) {
      emit(const GetAllTimeCardsErrorState(message: 'Something went wrong'));
      log("$e  Get Time card bloc error");
    }
    isLoading = false;
  }

  createTimeCard(
    CreateTimeCardEvent event,
    Emitter<TimeCardState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.createTimeCard(token, event.timeCard);
      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        emit(CreateTimeCardSucessState());
      } else {
        if (body.containsKey('message')) {
          emit(CreateTimeCardErrorState(message: body['message'].toString()));
        } else {
          emit(const CreateTimeCardErrorState(message: 'Something went wrong'));
        }
      }
    } catch (e) {
      log(e.toString() + "Create time card bloc error");
      emit(CreateTimeCardErrorState(message: 'Something went wrong'));
    }
  }
}
