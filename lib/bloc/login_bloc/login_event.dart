// ignore_for_file: must_be_immutable

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

class ResetPasswordGetPasswordEvent extends LoginEvent{
  String emailId;
  ResetPasswordGetPasswordEvent({required this.emailId});
}

class ResetPasswordSendOtpEvent extends LoginEvent{
  final String email,otp;
 const ResetPasswordSendOtpEvent({required this.email,required this.otp});
}
