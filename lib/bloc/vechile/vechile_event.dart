import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../Models/vechile_dropdown_model.dart';
import '../../Models/vechile_model.dart';

abstract class VechileEvent extends Equatable {
  const VechileEvent();

  @override
  List<Object> get props => [];
}

class GetAllVechile extends VechileEvent {}

class CreateVechile extends VechileEvent {
  final VechileResponse model;
  CreateVechile({required this.model});
}

class AddVechile extends VechileEvent {
  final BuildContext context;
  final String email,
      year,
      model,
      submodel,
      engine,
      color,
      vinNumber,
      licNumber,
      type,
      make;
  AddVechile({
    required this.context,
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
  });
}

class DropDownVechile extends VechileEvent {}
