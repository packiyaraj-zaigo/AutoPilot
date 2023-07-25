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
  final CannedServiceAddModel? material;
  final CannedServiceAddModel? part;
  final CannedServiceAddModel? labor;
  final CannedServiceAddModel? subcontract;
  final CannedServiceAddModel? fee;
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
