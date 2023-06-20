part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeDetailsLoadingState extends EmployeeState {
  @override
  List<Object> get props => [];
}

class EmployeeDetailsErrorState extends EmployeeState {
  final String message;
  const EmployeeDetailsErrorState({required this.message});
}

class EmployeeDetailsSuccessState extends EmployeeState {
  final AllEmployeeResponse employees;
  const EmployeeDetailsSuccessState({required this.employees});

  @override
  List<Object> get props => [employees];
}

class EmployeeCreateLoadingState extends EmployeeState {}

class EmployeeCreateErrorState extends EmployeeState {
  final String message;
  const EmployeeCreateErrorState({required this.message});
}

class EmployeeCreateSuccessState extends EmployeeState {}

class EmployeeRolesLoadingState extends EmployeeState {}

class EmployeeRolesErrorState extends EmployeeState {
  final String message;
  const EmployeeRolesErrorState({required this.message});
}

class EmployeeRolesSuccessState extends EmployeeState {
  final List<RoleModel> roles;
  const EmployeeRolesSuccessState({required this.roles});
}
