import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/time_card_user_model.dart';
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
  int currentUserTimeCardIndex = 1;
  int totalUserTimeCardIndex = 1;
  bool isCurrentUserTimeCardLoading = false;
  final apiRepo = ApiRepository();

  TimeCardBloc() : super(TimeCardInitial()) {
    on<GetAllTimeCardsEvent>(getAllTimeCards);
    on<GetUserTimeCardsEvent>(getUserTimeCards);
    on<CreateTimeCardEvent>(createTimeCard);
    on<EditTimeCardEvent>(editTimeCard);
  }

  getUserTimeCards(
    GetUserTimeCardsEvent event,
    Emitter<TimeCardState> emit,
  ) async {
    try {
      isCurrentUserTimeCardLoading = true;
      if (currentUserTimeCardIndex == 1) {
        emit(GetUserTimeCardsLoadingState());
      }

      final token = await AppUtils.getToken();
      await apiRepo
          .getUserTimeCards(token, event.id, currentUserTimeCardIndex)
          .then((value) async {
        if (value.statusCode == 200) {
          final responseBody = await jsonDecode(value.body);
          final data = responseBody['data'];

          final List<TimeCardUserModel> timeCards = [];
          if (data['data'] != null && data['data'].isNotEmpty) {
            data['data'].forEach((timeCard) {
              timeCards.add(TimeCardUserModel.fromJson(timeCard));
            });
          }

          currentUserTimeCardIndex = data['current_page'] ?? 1;
          totalUserTimeCardIndex = data['last_page'] ?? 1;
          // if (currentUserTimeCardIndex <= totalPages) {
          currentUserTimeCardIndex++;
          // }

          emit(
            GetUserTimeCardsSuccessState(timeCards: timeCards),
          );
        } else {
          log(value.body.toString());
          final body = jsonDecode(value.body);
          emit(GetUserTimeCardsErrorState(message: body['message']));
        }
        isCurrentUserTimeCardLoading = false;
      });
    } catch (e) {
      emit(GetUserTimeCardsErrorState(message: e.toString()));
      isCurrentUserTimeCardLoading = false;
    }
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

  editTimeCard(
    EditTimeCardEvent event,
    Emitter<TimeCardState> emit,
  ) async {
    try {
      final token = await AppUtils.getToken();
      final Response response =
          await apiRepo.editTimeCard(token, event.timeCard, event.id);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        emit(EditTimeCardSuccessState());
      } else {
        if (body.containsKey('message')) {
          emit(EditTimeCardErrorState(message: body['message'].toString()));
        } else {
          emit(const EditTimeCardErrorState(message: 'Something went wrong'));
        }
      }
    } catch (e) {
      log(e.toString() + "Edit time card bloc error");
      emit(EditTimeCardErrorState(message: 'Something went wrong'));
    }
  }
}
