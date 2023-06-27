part of 'time_card_bloc.dart';

abstract class TimeCardEvent extends Equatable {
  const TimeCardEvent();

  @override
  List<Object> get props => [];
}

class GetAllTimeCardsEvent extends TimeCardEvent {}

class CreateTimeCardEvent extends TimeCardEvent {
  final TimeCardCreateModel timeCard;
  const CreateTimeCardEvent({required this.timeCard});
}

class EditTimeCardEvent extends TimeCardEvent {
  final TimeCardCreateModel timeCard;
  const EditTimeCardEvent({required this.timeCard});
}
