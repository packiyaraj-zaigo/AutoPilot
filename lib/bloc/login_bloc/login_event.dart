part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}


class CreateAccountEvent extends LoginEvent{
  final String firstName,lastName,email,phoneNumber,password;
  CreateAccountEvent({required this.firstName,required this.lastName,required this.email,required this.password,required this.phoneNumber});

}


class UserLoginEvent extends LoginEvent{
  final String email,password;
  BuildContext context;
  UserLoginEvent({required this.email,required this.password,required this.context});

}
