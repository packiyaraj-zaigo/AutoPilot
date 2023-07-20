part of 'estimate_bloc.dart';

abstract class EstimateEvent extends Equatable {
  const EstimateEvent();

  @override
  List<Object> get props => [];
}

class GetEstimateEvent extends EstimateEvent {
  final String orderStatus;
  const GetEstimateEvent({required this.orderStatus});
}

class CreateEstimateEvent extends EstimateEvent {
  final String id;
  final String which;
  CreateEstimateEvent({required this.id, required this.which});
}

class EditEstimateEvent extends EstimateEvent {
  final String id, orderId, which;
  EditEstimateEvent(
      {required this.id, required this.orderId, required this.which});
}
