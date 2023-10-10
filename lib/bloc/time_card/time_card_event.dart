part of 'time_card_bloc.dart';

abstract class TimeCardEvent extends Equatable {
  const TimeCardEvent();

  @override
  List<Object> get props => [];
}

class GetAllTimeCardsEvent extends TimeCardEvent {
  final String userName;
  GetAllTimeCardsEvent({required this.userName});
}

class CreateTimeCardEvent extends TimeCardEvent {
  final TimeCardCreateModel timeCard;
  const CreateTimeCardEvent({required this.timeCard});
}

class EditTimeCardEvent extends TimeCardEvent {
  final TimeCardCreateModel timeCard;
  final String id;
  const EditTimeCardEvent({required this.timeCard, required this.id});
}

class GetUserTimeCardsEvent extends TimeCardEvent {
  final String id;
  const GetUserTimeCardsEvent({required this.id});
}
