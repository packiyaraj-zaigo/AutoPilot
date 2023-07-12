part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

class AppointmentInitial extends AppointmentState {}

class CreateAppointmentLoadingState extends AppointmentState {}

class CreateAppointmentErrorState extends AppointmentState {
  final String message;
  const CreateAppointmentErrorState({required this.message});
}

class CreateAppointmentSuccessState extends AppointmentState {
  final String id;
  const CreateAppointmentSuccessState({required this.id});

  @override
  List<Object> get props => [id];
}
