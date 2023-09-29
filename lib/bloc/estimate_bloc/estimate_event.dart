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
  final String orderId,
      serviceName,
      serviceNotes,
      laborRate,
      tax,
      servicePrice,
      technicianId;
  CreateOrderServiceEvent(
      {required this.orderId,
      required this.serviceName,
      required this.serviceNotes,
      required this.laborRate,
      required this.tax,
      required this.servicePrice,
      required this.technicianId});
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
      tax,
      cost;

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
      required this.tax,
      required this.cost});
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
  final String? eventId;

  DeleteAppointmentEstimateEvent({required this.appointmetId, this.eventId});
}

class CollectPaymentEstimateEvent extends EstimateEvent {
  final String customerId, orderId, paymentMode, amount, date, note;
  final String? transactionId;
  CollectPaymentEstimateEvent({
    required this.amount,
    required this.customerId,
    required this.orderId,
    required this.paymentMode,
    required this.date,
    required this.note,
    this.transactionId,
  });
}

class DeleteEstimateEvent extends EstimateEvent {
  final String id;
  DeleteEstimateEvent({required this.id});
}

class GetPaymentHistoryEvent extends EstimateEvent {
  final String orderId;

  GetPaymentHistoryEvent({required this.orderId});
}

class CreateEstimateFromAppointmentEvent extends EstimateEvent {
  final String customerId;
  final String vehicleId;
  final String appointmentId;
  final String startTime;
  final String endTime;
  final String appointmentNote;

  const CreateEstimateFromAppointmentEvent({
    required this.customerId,
    required this.vehicleId,
    required this.appointmentId,
    required this.startTime,
    required this.endTime,
    required this.appointmentNote,
  });
}

class AuthServiceByTechnicianEvent extends EstimateEvent {
  final String serviceId, serviceName, technicianId, auth;
  AuthServiceByTechnicianEvent(
      {required this.serviceId,
      required this.serviceName,
      required this.technicianId,
      required this.auth});
}

class ChangeEstimateStatusEvent extends EstimateEvent {
  final String orderId;
  ChangeEstimateStatusEvent({required this.orderId});
}

class GetEventDetailsByIdEvent extends EstimateEvent {
  final String eventId;
  GetEventDetailsByIdEvent({required this.eventId});
}

class GetClientByIdInEstimateEvent extends EstimateEvent {}

class CreateCannedOrderServiceEstimateEvent extends EstimateEvent {
  final CannedServiceCreateModel service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subcontract;
  final List<CannedServiceAddModel>? fee;
  const CreateCannedOrderServiceEstimateEvent({
    required this.service,
    this.material,
    this.part,
    this.labor,
    this.subcontract,
    this.fee,
  });
}

class GetAppointmentDetailsEvent extends EstimateEvent {
  final String appointmentId;
  GetAppointmentDetailsEvent({required this.appointmentId});
}

class GetSingleCustomerDetailsEvent extends EstimateEvent {
  final String customerId;
  GetSingleCustomerDetailsEvent({required this.customerId});
}

class GetSingleVehicleDetailsEvent extends EstimateEvent {
  final String vehicleId;
  GetSingleVehicleDetailsEvent({required this.vehicleId});
}

class GetAllVendorsEstimateEvent extends EstimateEvent {}
