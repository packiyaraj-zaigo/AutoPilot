part of 'service_bloc.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object> get props => [];
}

class GetAllServicess extends ServiceEvent {
  final String query;
  GetAllServicess({this.query = ''});
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
  const EditCannedOrderServiceEvent({
    required this.id,
    required this.service,
    this.material,
    this.part,
    this.labor,
    this.subcontract,
    this.fee,
    this.deletedItems,
  });
}

class DeleteCannedServiceEvent extends ServiceEvent {
  final String id;
  const DeleteCannedServiceEvent({required this.id});
}
