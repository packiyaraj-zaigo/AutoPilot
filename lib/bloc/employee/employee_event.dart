part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class GetAllEmployees extends EmployeeEvent {}

class CreateEmployee extends EmployeeEvent {
  final EmployeeCreationModel model;
  CreateEmployee({required this.model});
}
