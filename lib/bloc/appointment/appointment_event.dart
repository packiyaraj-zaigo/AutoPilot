part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object> get props => [];
}

class CreateAppointmentEvent extends AppointmentEvent {
  final AppointmentCreateModel appointment;
  const CreateAppointmentEvent({required this.appointment});
}
