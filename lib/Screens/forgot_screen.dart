// ignore_for_file: must_be_immutable, sort_child_properties_last

import 'package:auto_pilot/Screens/login_signup_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/login_bloc/login_bloc.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/app_colors.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({
    super.key,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool emailSent = true;

  final TextEditingController otpController = TextEditingController();
  String otp = '';
  final TextEditingController emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newConfirmPasswordController = TextEditingController();
  int widgetIndex = 0;
  bool otpErrorStatus = false;
  String otpErrorMsg = '';
  bool emailErrorStatus = false;
  String emailErrorMsg = "";
  String newToken = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(apiRepository: ApiRepository()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is ResetPasswordGetOtpState) {
            widgetIndex++;
            displayBottomSheet(context, state);
          } else if (state is ResetPasswordSendOtpErrorState) {
            otpErrorMsg = state.errorMsg;
          } else if (state is ResetPasswordGetOtpErrorState) {
            emailErrorMsg = state.errorMsg;
            emailErrorStatus = true;
          }
          // else if(state is ResetPasswordSendOtpState){
          //   // print("state emitted");
          //   // Navigator.pop(context);
          //   // widgetIndex++;
          //   // newToken=state.newToken;

          // }
          else if (state is CreateNewPasswordState) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return LoginAndSignupScreen(widgetIndex: 0);
              },
            ), (route) => false);

            CommonWidgets()
                .showDialog(context, "Password changed successfully");
          } else if (state is CreateNewPasswordErrorState) {
            CommonWidgets().showDialog(context, state.errorMsg);
          }

          // TODO: implement listener
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryColors,
                  ),
                ),
              ),
              body: Column(
                children: [
                  widgetIndex == 0
                      ? resetpasswordscreen(context, state)
                      : widgetIndex == 2
                          ? newpassword(context, state)
                          : resetpasswordscreen(context, state)
                  // widget.widgetIndex == 0
                  //     ? resetpasswordscreen()
                  //     : recoveryemailscreen()
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget resetpasswordscreen(BuildContext context, state) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Forgot Password",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: AppColors.primaryTitleColor),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Provide your email to receive a reset link",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.greyText),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Email",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.greyText),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: CupertinoTextField(
              placeholder: 'Enter Your Email',
              controller: emailController,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: emailErrorStatus
                        ? Color(0xffD80027)
                        : Color(0xffC1C4CD)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: emailErrorStatus,
              child: Text(
                emailErrorMsg,
                style: const TextStyle(color: Color(0xffD80027)),
              )),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<LoginBloc>().add(ResetPasswordGetPasswordEvent(
                    emailId: emailController.text));
              },
              style: ElevatedButton.styleFrom(
                primary: emailSent ? AppColors.primaryColors : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: state is ResetPasswordGetOtpLoadingState
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Send',
                      style: TextStyle(fontSize: 15),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget recoveryemailscreen() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recovery Email Sent",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: AppColors.primaryTitleColor),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Please check your email.",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.greyText),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            "If this email is associated with an account you will receive a password reser link.",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: AppColors.greyText),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Email",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.greyText),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: CupertinoTextField(
              placeholder: 'Enter your email',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<LoginBloc>().add(ResetPasswordGetPasswordEvent(
                    emailId: emailController.text));
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Send',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  displayBottomSheet(BuildContext context, state) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (ctx) =>
            StatefulBuilder(builder: (context, StateSetter newSetState) {
              return BlocProvider(
                create: (context) => LoginBloc(apiRepository: ApiRepository()),
                child: BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSendOtpErrorState) {
                      otpErrorStatus = true;
                      otpErrorMsg = state.errorMsg;
                    } else if (state is ResetPasswordSendOtpState) {
                      Navigator.pop(ctx);
                      setState(() {
                        widgetIndex++;
                      });

                      newToken = state.newToken;
                    }
                    // TODO: implement listener
                  },
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.800,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.dividerColors,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                "4-Digit Code",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 28,
                                    color: AppColors.primaryTitleColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please enter the code we\'ve sent to ${emailController.text}.",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                    color: AppColors.greyText),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 4,
                                // validator: (v) {
                                //   // if (v!.length < 4) {
                                //   //   return "Enter a valid OTP";
                                //   // } else {
                                //   //   return null;
                                //   // }
                                // },
                                pinTheme: PinTheme(
                                  selectedColor: Colors.black,
                                  inactiveColor: AppColors.greyText,
                                  activeColor: otpErrorStatus
                                      ? Color(0xffD80027)
                                      : const Color(0xff808B9E),
                                  errorBorderColor: otpErrorStatus
                                      ? Color(0xffD80027)
                                      : const Color(0xff808B9E),
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(15),
                                  fieldHeight: 57,
                                  fieldWidth: 55,
                                  //activeColor: Colors.black
                                ),
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.number,
                                boxShadows: const [
                                  BoxShadow(
                                    offset: Offset.zero,
                                    color: Color(0xffFFFFFF),
                                    blurRadius: 0,
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    otp = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                  visible: otpErrorStatus,
                                  child: Text(
                                    otpErrorMsg,
                                    style: const TextStyle(
                                        color: Color(0xffD80027)),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<LoginBloc>().add(
                                        ResetPasswordSendOtpEvent(
                                            email: emailController.text,
                                            otp: otp));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: AppColors.primaryColors,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child:
                                      state is ResetPasswordSendOtpLoadingState
                                          ? const Center(
                                              child: CupertinoActivityIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Continue',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t receive a code?'),
                                  TextButton(
                                    child: const Text(
                                      'Resend',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.primaryColors),
                                    ),
                                    onPressed: () {
                                      context.read<LoginBloc>().add(
                                          ResetPasswordGetPasswordEvent(
                                              emailId: emailController.text));
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }));
  }

  Widget newpassword(BuildContext context, state) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Create a New Password",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: AppColors.primaryTitleColor),
          ),
          const SizedBox(
            height: 26,
          ),
          const Text(
            "New Password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "SF Pro",
                color: AppColors.greyText),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 55,
            child: CupertinoTextField(
              placeholder: 'Enter New Password',
              controller: newPasswordController,
              obscureText: true,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xffC1C4CD)),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Confirm New Password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "SF Pro",
                color: AppColors.greyText),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 55,
            child: CupertinoTextField(
              placeholder: 'Confirm New Password',
              controller: newConfirmPasswordController,
              obscureText: true,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color(0xffC1C4CD)),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<LoginBloc>().add(CreateNewPasswordEvent(
                    email: emailController.text,
                    password: newPasswordController.text,
                    confirmPassword: newConfirmPasswordController.text,
                    newToken: newToken));
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColors,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: state is CreateNewPasswordLoadingState
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : const Text(
                      'Confirm',
                      style: TextStyle(fontSize: 15),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
