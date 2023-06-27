part of 'time_card_bloc.dart';

abstract class TimeCardState extends Equatable {
  const TimeCardState();

  @override
  List<Object> get props => [];
}

class TimeCardInitial extends TimeCardState {}

class GetAllTimeCardsLoadingState extends TimeCardState {}

class GetAllTimeCardsErrorState extends TimeCardState {
  final String message;
  const GetAllTimeCardsErrorState({required this.message});
}

class GetAllTimeCardsSucessState extends TimeCardState {
  final List<TimeCardModel> timeCards;
  const GetAllTimeCardsSucessState({required this.timeCards});
}

class CreateTimeCardLoadingState extends TimeCardState {}

class CreateTimeCardErrorState extends TimeCardState {
  final String message;
  const CreateTimeCardErrorState({required this.message});
}

class CreateTimeCardSucessState extends TimeCardState {}
