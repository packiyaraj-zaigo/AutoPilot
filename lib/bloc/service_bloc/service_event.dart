part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class GetAllServicess extends ServiceEvent {
  final String query;
  const GetAllServicess({this.query = ''});
}

class CreateServices extends ServiceEvent {
  // final ServicesCreationModel model;
  // CreateServices({required this.model});
}

class GetTechnicianEvent extends ServiceEvent {}

class GetAllServicesEvent extends ServiceEvent {}

class CreateCannedOrderServiceEvent extends ServiceEvent {
  final CannedServiceCreateModel service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subcontract;
  final List<CannedServiceAddModel>? fee;
  const CreateCannedOrderServiceEvent({
    required this.service,
    this.material,
    this.part,
    this.labor,
    this.subcontract,
    this.fee,
  });
}

class GetAllVendorsEvent extends ServiceEvent {}

class EditCannedOrderServiceEvent extends ServiceEvent {
  final String id;
  final CannedServiceCreateModel service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subcontract;
  final List<CannedServiceAddModel>? fee;
  final List<String>? deletedItems;
  final List<CannedServiceAddModel>? editedItems;
  const EditCannedOrderServiceEvent({
    required this.id,
    required this.service,
    this.material,
    this.part,
    this.labor,
    this.subcontract,
    this.fee,
    this.deletedItems,
    this.editedItems,
  });
}

class EditOrderServiceEvent extends ServiceEvent {
  final String id;
  final CannedServiceCreateModel service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subcontract;
  final List<CannedServiceAddModel>? fee;
  final List<String>? deletedItems;
  List<CannedServiceAddModel>? editedItems;

  final String technicianId;
  EditOrderServiceEvent(
      {required this.id,
      required this.service,
      this.material,
      this.part,
      this.labor,
      this.subcontract,
      this.fee,
      this.deletedItems,
      this.editedItems,
      required this.technicianId});
}

class DeleteCannedServiceEvent extends ServiceEvent {
  final String id;
  const DeleteCannedServiceEvent({required this.id});
}

class GetClientByIdEvent extends ServiceEvent {}

class CreateVendorEvent extends ServiceEvent {
  final String name;
  final String email;
  final String contactPerson;
  const CreateVendorEvent({
    required this.name,
    required this.email,
    required this.contactPerson,
  });
}
