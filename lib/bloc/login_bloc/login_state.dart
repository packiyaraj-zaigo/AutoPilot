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

class ResetPasswordGetOtpState extends LoginState{}
class ResetPasswordGetOtpLoadingState extends LoginState{}
class ResetPasswordGetOtpErrorState extends LoginState{
  final String errorMsg;
  const ResetPasswordGetOtpErrorState({required this.errorMsg});

}

class ResetPasswordSendOtpState extends LoginState{}
class ResetPasswordSendOtpLoadingState extends LoginState{}
class ResetPasswordSendOtpErrorState extends LoginState{
  final String errorMsg;
  const ResetPasswordSendOtpErrorState({required this.errorMsg});

}