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

class VechileDetailsLoadingState extends VechileState {}

class VechileDetailsSuccessState extends VechileState {
  final VechileResponse vechile;
  VechileDetailsSuccessState({required this.vechile});

  @override
  List<Object> get props => [];
}

class VechileDetailsPageNationLoading extends VechileState {}

class VechileDetailsErrorState extends VechileState {
  final String message;
  VechileDetailsErrorState({required this.message});
}

class AddVechileInitial extends VechileState {
  List<Object> get props => [];
}

class AddVechileDetailsLoadingState extends VechileState {}

class AddVechileDetailsSuccessState extends VechileState {
  @override
  List<Object> get props => [];
}

class AddVechileDetailsPageNationLoading extends VechileState {}

class AddVechileDetailsErrorState extends VechileState {
  final String message;
  AddVechileDetailsErrorState({required this.message});
}

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
