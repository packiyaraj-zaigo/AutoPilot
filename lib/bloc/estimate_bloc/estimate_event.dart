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
  final String id, orderId, which, customerId;
  EditEstimateEvent(
      {required this.id,
      required this.orderId,
      required this.which,
      required this.customerId});
}

class AddEstimateNoteEvent extends EstimateEvent {
  final String orderId, comment;
  AddEstimateNoteEvent({required this.orderId, required this.comment});
}

class CreateAppointmentEstimateEvent extends EstimateEvent {
  final String startTime, endTime, orderId, appointmentNote;
  final String customerId, vehicleId;
  CreateAppointmentEstimateEvent(
      {required this.startTime,
      required this.endTime,
      required this.orderId,
      required this.appointmentNote,
      required this.customerId,
      required this.vehicleId});
}
