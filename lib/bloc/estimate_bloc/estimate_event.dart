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
      subTotal;

  CreateOrderServiceItemEvent(
      {required this.cannedServiceId,
      required this.itemType,
      required this.itemName,
      required this.discount,
      required this.discountType,
      required this.position,
      required this.quantityHours,
      required this.subTotal,
      required this.unitPrice});
}
