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
  final String? dropScedule;
  EditEstimateEvent(
      {required this.id,
      required this.orderId,
      required this.which,
      required this.customerId,
      this.dropScedule});
}

class AddEstimateNoteEvent extends EstimateEvent {
  final String orderId, comment;
  AddEstimateNoteEvent({required this.orderId, required this.comment});
}

class EditEstimateNoteEvent extends EstimateEvent {
  final String orderId, comment, id;
  EditEstimateNoteEvent(
      {required this.orderId, required this.comment, required this.id});
}

class DeleteEstimateNoteEvent extends EstimateEvent {
  final String id;
  DeleteEstimateNoteEvent({required this.id});
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

class EditAppointmentEstimateEvent extends EstimateEvent {
  final String startTime, endTime, orderId, appointmentNote;
  final String customerId, vehicleId, id;
  EditAppointmentEstimateEvent(
      {required this.startTime,
      required this.endTime,
      required this.orderId,
      required this.appointmentNote,
      required this.customerId,
      required this.vehicleId,
      required this.id});
}

class GetSingleEstimateEvent extends EstimateEvent {
  final String orderId;
  GetSingleEstimateEvent({required this.orderId});
}

class GetEstimateNoteEvent extends EstimateEvent {
  final String orderId;
  GetEstimateNoteEvent({required this.orderId});
}

class GetEstimateAppointmentEvent extends EstimateEvent {
  final String orderId;

  GetEstimateAppointmentEvent({required this.orderId});
}

class EstimateUploadImageEvent extends EstimateEvent {
  final File imagePath;
  final String orderId;
  final int index;
  EstimateUploadImageEvent(
      {required this.imagePath, required this.orderId, required this.index});
}

class CreateOrderImageEvent extends EstimateEvent {
  final List<String> imageUrlList;
  final String orderId;
  final String inspectionId;
  const CreateOrderImageEvent(
      {required this.imageUrlList,
      required this.inspectionId,
      required this.orderId});
}

class GetAllOrderImageEvent extends EstimateEvent {
  final String orderId;
  GetAllOrderImageEvent({required this.orderId});
}

class DeleteOrderImageEvent extends EstimateEvent {
  final String imageId;
  DeleteOrderImageEvent({required this.imageId});
}

class CreateOrderServiceEvent extends EstimateEvent {
  final String orderId, serviceName, serviceNotes, laborRate, tax;
  CreateOrderServiceEvent(
      {required this.orderId,
      required this.serviceName,
      required this.serviceNotes,
      required this.laborRate,
      required this.tax});
}

class CreateOrderServiceItemEvent extends EstimateEvent {
  final String cannedServiceId,
      itemType,
      itemName,
      unitPrice,
      quantityHours,
      discount,
      discountType,
      position,
      subTotal,
      tax;

  CreateOrderServiceItemEvent(
      {required this.cannedServiceId,
      required this.itemType,
      required this.itemName,
      required this.discount,
      required this.discountType,
      required this.position,
      required this.quantityHours,
      required this.subTotal,
      required this.unitPrice,
      required this.tax});
}

class DeleteOrderServiceEvent extends EstimateEvent {
  final String id;
  DeleteOrderServiceEvent({required this.id});
}

class SendEstimateToCustomerEvent extends EstimateEvent {
  final String customerId, orderId, subject;
  SendEstimateToCustomerEvent(
      {required this.customerId, required this.orderId, required this.subject});
}

class DeleteAppointmentEstimateEvent extends EstimateEvent {
  final String appointmetId;
  DeleteAppointmentEstimateEvent({required this.appointmetId});
}

class CollectPaymentEstimateEvent extends EstimateEvent {
  final String customerId, orderId, paymentMode, amount, date, note;
  CollectPaymentEstimateEvent(
      {required this.amount,
      required this.customerId,
      required this.orderId,
      required this.paymentMode,
      required this.date,
      required this.note});
}

class DeleteEstimateEvent extends EstimateEvent {
  final String id;
  DeleteEstimateEvent({required this.id});
}

class GetPaymentHistoryEvent extends EstimateEvent {
  final String orderId;
  GetPaymentHistoryEvent({required this.orderId});
}
