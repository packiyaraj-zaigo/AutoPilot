import 'package:auto_pilot/Models/parts_notes_model.dart';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:equatable/equatable.dart';

import '../../Models/parts_model.dart';
import '../../Models/vechile_model.dart';

abstract class PartsState extends Equatable {
  const PartsState();

  @override
  List<Object> get props => [];
}

class PartsInitial extends PartsState {
  List<Object> get props => [];
}

class PartsDetailsLoadingState extends PartsState {
  @override
  List<Object> get props => [];
}

class AddPartsDetailsLoadingState extends PartsState {}

class AddPartDetailsErrorState extends PartsState {
  final String message;
  AddPartDetailsErrorState({required this.message});
}

class PartsDetailsPageNationLoading extends PartsState {}

class PartsDetailsErrorState extends PartsState {
  final String message;
  PartsDetailsErrorState({required this.message});
}

class AddPardDetailsSuccessState extends PartsState {}

class PartsDetailsSuccessStates extends PartsState {
  final Parts part;
  const PartsDetailsSuccessStates({required this.part});

  @override
  List<Object> get props => [part];
}

class DeletePartLoadingState extends PartsState {}

class DeletePartErrorState extends PartsState {
  final String message;
  const DeletePartErrorState({required this.message});
}

class DeletePartSuccessState extends PartsState {}

class GetPartsNoteState extends PartsState {
  final PartsNotesModel partsNotesModel;
  GetPartsNoteState({required this.partsNotesModel});
}

class GetPartsNoteLoadingState extends PartsState {}

class GetPartsNoteErrorState extends PartsState {
  final String errorMessage;
  GetPartsNoteErrorState({required this.errorMessage});
}

class DeletePartsNoteState extends PartsState {}

class DeletePartsNoteErrorState extends PartsState {
  final String errorMessage;
  DeletePartsNoteErrorState({required this.errorMessage});
}

class DeletePartsNoteLoadingState extends PartsState {}

class AddPartsNoteState extends PartsState {}

class AddPartsNoteLoadingState extends PartsState {}

class AddPartsNoteErrorState extends PartsState {
  final String errorMessage;
  AddPartsNoteErrorState({required this.errorMessage});
}
