import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/vechile_dropdown_model.dart';
import '../../Models/vechile_model.dart';

abstract class VechileEvent extends Equatable {
  const VechileEvent();

  @override
  List<Object> get props => [];
}

class GetAllVechile extends VechileEvent {
  final String query;
  GetAllVechile({this.query = ''});
}

class CreateVechile extends VechileEvent {
  final VechileResponse model;
  CreateVechile({required this.model});
}

class AddVechile extends VechileEvent {
  final String email,
      year,
      model,
      submodel,
      engine,
      color,
      vinNumber,
      licNumber,
      type,
      make,
      customerId,
      mileage;
  AddVechile(
      {required this.email,
      required this.year,
      required this.model,
      required this.submodel,
      required this.engine,
      required this.color,
      required this.vinNumber,
      required this.licNumber,
      required this.type,
      required this.make,
      required this.customerId,
      required this.mileage});
}

class DropDownVechile extends VechileEvent {}

class EditVehicleEvent extends VechileEvent {
  final String id,
      email,
      year,
      model,
      submodel,
      engine,
      color,
      vinNumber,
      licNumber,
      type,
      make,
      customerId,
      mileage;
  const EditVehicleEvent(
      {required this.id,
      required this.email,
      required this.year,
      required this.model,
      required this.submodel,
      required this.engine,
      required this.color,
      required this.vinNumber,
      required this.licNumber,
      required this.type,
      required this.make,
      required this.customerId,
      required this.mileage});
}

class DeleteVechile extends VechileEvent {
  final String id;
  const DeleteVechile({required this.id});
}

class GetVehicleNoteEvent extends VechileEvent {
  final String vehicleId;
  GetVehicleNoteEvent({required this.vehicleId});
}

class AddVehicleNoteEvent extends VechileEvent {
  final String vehicleId, notes;
  AddVehicleNoteEvent({required this.notes, required this.vehicleId});
}

class DeleteVehicleNotesEvent extends VechileEvent {
  final String vehicleId;
  DeleteVehicleNotesEvent({required this.vehicleId});
}

class GetEstimateFromVehicleEvent extends VechileEvent {
  final String vehicleId;
  GetEstimateFromVehicleEvent({required this.vehicleId});
}

class GetSingleEstimateFromVehicleEvent extends VechileEvent {
  final String orderId;
  GetSingleEstimateFromVehicleEvent({required this.orderId});
}

class GetVehicleInfoEvent extends VechileEvent {
  final String vehicleId;
  GetVehicleInfoEvent({required this.vehicleId});
}
