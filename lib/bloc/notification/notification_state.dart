part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class AllNotificationsErorState extends NotificationState {
  final String message;
  const AllNotificationsErorState({required this.message});
}

class AllNotificationLoadingState extends NotificationState {}

class AllNotificationSucessState extends NotificationState {
  final NotificationResponseModel notification;
  const AllNotificationSucessState({required this.notification});
}
