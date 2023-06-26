part of 'estimate_bloc.dart';

abstract class EstimateEvent extends Equatable {
  const EstimateEvent();

  @override
  List<Object> get props => [];
}


class GetEstimateEvent extends EstimateEvent{
  final String orderStatus;
  const GetEstimateEvent({required this.orderStatus});
}
