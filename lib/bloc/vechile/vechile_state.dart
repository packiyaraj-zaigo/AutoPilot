import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
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

class AddVechileDetailsPageNationLoading extends VechileState {}

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

class DeleteVechileDetailsSuccessState extends VechileState {
  final VechileResponse vechile;
  const DeleteVechileDetailsSuccessState({required this.vechile});

  @override
  List<Object> get props => [];
}

class DeleteVechileDetailsErrorState extends VechileState {
  final String message;
  DeleteVechileDetailsErrorState({required this.message});
}

class EditVechileError extends VechileState {
  var message;
  EditVechileError({required this.message});
  @override
  List<Object> get props => [message];
}

class EditVechileLoading extends VechileState {
  EditVechileLoading();
}
