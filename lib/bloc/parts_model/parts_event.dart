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
