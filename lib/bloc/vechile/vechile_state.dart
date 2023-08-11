import 'package:auto_pilot/Models/estimate_model.dart';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Models/vehicle_notes_model.dart';
import 'package:equatable/equatable.dart';

import '../../Models/vechile_model.dart';

abstract class VechileState extends Equatable {
  const VechileState();

  @override
  List<Object> get props => [];
}

class VechileInitial extends VechileState {
  List<Object> get props => [];
}

class VechileDetailsLoadingState extends VechileState {
  @override
  List<Object> get props => [];
}

class VechileDetailsPageNationLoading extends VechileState {}

class VechileDetailsErrorState extends VechileState {
  final String message;
  VechileDetailsErrorState({required this.message});
}

class VechileDetailsSuccessStates extends VechileState {
  final VechileResponse vechile;
  const VechileDetailsSuccessStates({required this.vechile});

  @override
  List<Object> get props => [vechile];
}

class AddVechileInitial extends VechileState {
  List<Object> get props => [];
}

class AddVechileDetailsLoadingState extends VechileState {}

class AddVechileDetailsSuccessState extends VechileState {
  final VechileResponse vechiles;
  const AddVechileDetailsSuccessState({required this.vechiles});
  @override
  List<Object> get props => [];
}

class AddVechileLoading extends VechileState {
  AddVechileLoading();
}

class AddVechileDetailsPageNationLoading extends VechileState {
  final String createdId;
  AddVechileDetailsPageNationLoading({required this.createdId});
}

class AddVechileDetailsErrorState extends VechileState {}

class DropdownVechileInitial extends VechileState {
  List<Object> get props => [];
}

class DropdownVechileDetailsLoadingState extends VechileState {}

class DropdownVechileDetailsSuccessState extends VechileState {
  final DropDown dropdownData;
  DropdownVechileDetailsSuccessState({required this.dropdownData});

  @override
  List<Object> get props => [];
}

class DropdownVechileDetailsPageNationLoading extends VechileState {}

class DropdownVechileDetailsErrorState extends VechileState {
  final String message;
  DropdownVechileDetailsErrorState({required this.message});
}

class DeleteVechileDetailsSuccessState extends VechileState {}

class DeleteVechileDetailsLoadingState extends VechileState {}

class DeleteVechileDetailsErrorState extends VechileState {
  final String message;
  DeleteVechileDetailsErrorState({required this.message});
}

class EditVehicleLoadingState extends VechileState {}

class EditVehicleErrorState extends VechileState {
  final String message;
  const EditVehicleErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class EditVehicleSuccessState extends VechileState {}

class CreateVehicleLoadingState extends VechileState {}

class CreateVehicleErrorState extends VechileState {
  final String message;
  const CreateVehicleErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class CreateVehicleSuccessState extends VechileState {
  final String createdId;
  const CreateVehicleSuccessState({required this.createdId});

  @override
  List<Object> get props => [createdId];
}

class GetVehicleNoteState extends VechileState {
  final VehicleNoteModel vehicleModel;
  GetVehicleNoteState({required this.vehicleModel});

  @override
  List<Object> get props => [vehicleModel];
}

class GetVehicleNoteLoadingState extends VechileState {}

class GetVehicleNoteErrorState extends VechileState {
  final String errorMessage;
  GetVehicleNoteErrorState({required this.errorMessage});
}

class AddVehicleNoteState extends VechileState {}

class AddVehicleNoteLoadingState extends VechileState {}

class AddVehicleNoteErrorState extends VechileState {
  final String errorMessage;
  AddVehicleNoteErrorState({required this.errorMessage});
}

class DeleteVehicleNoteState extends VechileState {}

class DeleteVehicleNoteLoadingState extends VechileState {}

class DeleteVehicleNoteErrorState extends VechileState {
  final String errorMessage;
  DeleteVehicleNoteErrorState({required this.errorMessage});
}

class GetEstimateFromVehicleState extends VechileState {
  final EstimateModel estimateData;
  const GetEstimateFromVehicleState({required this.estimateData});

  @override
  List<Object> get props => [estimateData];
}

class GetEstimateFromVehicleLoadingState extends VechileState {}

class GetEstimateFromVehicleErrorState extends VechileState {
  final String errorMessage;
  GetEstimateFromVehicleErrorState({required this.errorMessage});
}
