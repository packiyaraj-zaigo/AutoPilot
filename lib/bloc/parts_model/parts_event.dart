import 'package:auto_pilot/Models/parts_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PartsEvent extends Equatable {
  const PartsEvent();

  @override
  List<Object> get props => [];
}

class GetAllParts extends PartsEvent {
  final String query;
  GetAllParts({this.query = ''});
}

class AddParts extends PartsEvent {
  final BuildContext context;
  final String itemname, serialnumber, type, quantity, fee, supplies, epa, cost;
  AddParts({
    required this.context,
    required this.itemname,
    required this.serialnumber,
    required this.type,
    required this.quantity,
    required this.fee,
    required this.supplies,
    required this.epa,
    required this.cost,
  });
}

class ChangeQuantity extends PartsEvent {
  final PartsDatum part;
  const ChangeQuantity({required this.part});
}

class DeletePart extends PartsEvent {
  final String id;
  const DeletePart({required this.id});
}

class EditPartEvent extends PartsEvent {
  final String itemname, serialnumber, quantity, fee, cost, id;
  const EditPartEvent({
    required this.itemname,
    required this.serialnumber,
    required this.quantity,
    required this.fee,
    required this.cost,
    required this.id,
  });
}
// class AddPart extends PartsEvent {
//   final BuildContext context;
//   final String itemname, serialnumber, quantity, fee, supplies, epa, cost;
//   PartsEvent({
//     required this.context,
//     required this.itemname,
//     required this.serialnumber,
//     required this.quantity,
//     required this.fee,
//     required this.supplies,
//     required this.epa,
//     required this.cost,
//
//   });
// }
