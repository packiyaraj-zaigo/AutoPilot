import 'package:auto_pilot/bloc/calendar_bloc/calendar_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
}

class CalendarDetails extends CalendarEvent {
  final DateTime selectedDate;
  CalendarDetails({required this.selectedDate});

  @override
  List<Object?> get props => [];
}

class CalendarWeekDetails extends CalendarEvent {
  final DateTime startDate;
  final DateTime endDate;
  CalendarWeekDetails({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [];
}
