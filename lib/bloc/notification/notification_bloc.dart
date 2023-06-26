import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auto_pilot/Models/notification_response_model.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  int totalPages = 1;
  int currentPage = 1;
  bool isLoading = false;

  NotificationBloc() : super(NotificationInitial()) {
    on<GetAllNotification>(getAllNotifcation);
  }

  getAllNotifcation(
    GetAllNotification event,
    Emitter<NotificationState> emit,
  ) async {
    emit(AllNotificationLoadingState());
    try {
      if (currentPage != 1) {
        isLoading = true;
      }
      final token = await AppUtils.getToken();
      final clientId = await AppUtils.getUserID();
      final response =
          await ApiRepository().getNotifications(token, clientId, currentPage);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final notifications = NotificationResponseModel.fromJson(body['data']);
        emit(AllNotificationSucessState(notification: notifications));
        currentPage = body['data']['current_page'] ?? 1;
        totalPages = body['data']['last_page'] ?? 1;
      } else {
        emit(const AllNotificationsErorState(
            message: 'Something went wrong please try again later'));
      }
    } catch (e) {
      log('$e Notification bloc error');
      emit(AllNotificationsErorState(message: e.toString()));
    }
    isLoading = false;
  }
}
