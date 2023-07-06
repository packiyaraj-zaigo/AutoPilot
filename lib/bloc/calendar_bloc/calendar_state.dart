import 'package:equatable/equatable.dart';

import '../../Models/calendar_model.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object> get props => [];
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {}

class CalendarReady extends CalendarState {
  final CalendarModel calendarModel;
  CalendarReady({required this.calendarModel});
}

class CalendarError extends CalendarState {
  final String message;
  CalendarError({required this.message});
}
