part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class GetAllEmployees extends EmployeeEvent {
  final String query;
  GetAllEmployees({this.query = ''});
}

class CreateEmployee extends EmployeeEvent {
  final EmployeeCreationModel model;
  CreateEmployee({required this.model});
}

class GetAllRoles extends EmployeeEvent {}

class DeleteEmployee extends EmployeeEvent {
  final int id;
  final BuildContext context;
  const DeleteEmployee({required this.id, required this.context});
}

class EditEmployee extends EmployeeEvent {
  final EmployeeCreationModel employee;
  final int id;
  const EditEmployee({required this.employee, required this.id});
}
