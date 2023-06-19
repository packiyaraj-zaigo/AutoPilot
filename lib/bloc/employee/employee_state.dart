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
  EmployeeDetailsErrorState({required this.message});
}

class EmployeeDetailsSuccessState extends EmployeeState {
  final AllEmployeeResponse employees;
  EmployeeDetailsSuccessState({required this.employees});

  @override
  List<Object> get props => [employees];
}

class EmployeeDetailsPageNationLoading extends EmployeeState {}
