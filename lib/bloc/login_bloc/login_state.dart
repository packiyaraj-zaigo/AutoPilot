part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class CreateAccountSuccessState extends LoginState{}
class CreateAccountLoadingState extends LoginState{}
class CreateAccountErrorState extends LoginState{}

class UserLoginSuccessState extends LoginState{}
class UserLoginLoadingState extends LoginState{}
class UserLoginErrorState extends LoginState{
  final String errorMessage;
  UserLoginErrorState({required this.errorMessage});

}
