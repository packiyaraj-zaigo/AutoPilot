import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/login_bloc/login_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'forgot_screen.dart';

// ignore: must_be_immutable
class LoginAndSignupScreen extends StatefulWidget {
  LoginAndSignupScreen({super.key, required this.widgetIndex});
  int widgetIndex;

  @override
  State<LoginAndSignupScreen> createState() => _LoginAndSignupScreenState();
}

class _LoginAndSignupScreenState extends State<LoginAndSignupScreen> {
  final countryPicker = const FlCountryCodePicker();
  CountryCode? selectedCountry;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController signUpPasswordController =
      TextEditingController();

  bool loginErrorStatus = false;
  bool nameErrorStaus = false;
  bool emailErrorStatus = false;
  bool phoneNumberErrorStatus = false;
  bool passwordErrorStatus = false;
  bool isObscure = true;

  String loginErrorMsg = '';
  String nameErrorMsg = '';
  String emailErrorMsg = '';
  String phoneErrorMsg = '';
  String passwordErrorMsg = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(apiRepository: ApiRepository()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is CreateAccountSuccessState) {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: (context) {
                return continueToLogin();
              },
            );
          } else if (state is UserLoginErrorState) {
            loginErrorMsg = state.errorMessage;
            loginErrorStatus = true;
          } else if (state is CreateAccountErrorState) {
            if (BlocProvider.of<LoginBloc>(context).errorRes.isNotEmpty) {
              if (BlocProvider.of<LoginBloc>(context)
                  .errorRes
                  .containsKey("email")) {
                print("thisss");

                emailErrorStatus = true;

                print(emailErrorStatus);
                emailErrorMsg =
                    BlocProvider.of<LoginBloc>(context).errorRes['email'][0];
                print(emailErrorMsg);
                // }
              } else {
                emailErrorStatus = false;
              }

              if (BlocProvider.of<LoginBloc>(context)
                  .errorRes
                  .containsKey("password")) {
                passwordErrorStatus = true;
                passwordErrorMsg =
                    BlocProvider.of<LoginBloc>(context).errorRes['password'][0];
              } else {
                passwordErrorStatus = false;
              }
              if (BlocProvider.of<LoginBloc>(context)
                  .errorRes
                  .containsKey("emp_phone")) {
                phoneNumberErrorStatus = true;
                phoneErrorMsg = BlocProvider.of<LoginBloc>(context)
                    .errorRes['emp_phone'][0];
              } else {
                phoneNumberErrorStatus = false;
              }
            }
          }
          // TODO: implement listener
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                foregroundColor: AppColors.primaryColors,
              ),
              // bottomNavigationBar: Padding(
              //   padding: const EdgeInsets.only(bottom: 16.0),
              //   child: Container(
              //     child:  Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //       widget.widgetIndex==0?  GestureDetector(
              //         onTap: (){
              //           setState(() {
              //             widget.widgetIndex=1;
              //           });
              //         },
              //         child: const Wrap(
              //             children: [
              //               Text(
              //                 "Dont have an account?",
              //                 style: TextStyle(
              //                   color: Color(0xff061237),
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14,
              //                 ),
              //               ),
              //               Text(
              //                 "Sign up",
              //                 style: TextStyle(
              //                   color: Color(0xff333333),
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 14,
              //                 ),
              //               )
              //             ],
              //           ),
              //       ):GestureDetector(
              //           onTap: (){
              //             setState(() {
              //               widget.widgetIndex=0;
              //             });
              //           },

              //           child: const Wrap(
              //             children: [
              //               Text(
              //                 "Already have an account?",
              //                 style: TextStyle(
              //                   color: Color(0xff061237),
              //                   fontWeight: FontWeight.w400,
              //                   fontSize: 14,
              //                 ),
              //               ),
              //               Text(
              //                 "Sign in",
              //                 style: TextStyle(
              //                   color: Color(0xff333333),
              //                   fontWeight: FontWeight.w600,
              //                   fontSize: 14,
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 28.0, top: 0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.widgetIndex == 0
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.widgetIndex = 1;
                          });
                        },
                        child: const Wrap(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Color(0xff061237),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              " Sign up",
                              style: TextStyle(
                                color: AppColors.primaryColors,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.widgetIndex = 0;
                          });
                        },
                        child: const Wrap(
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: Color(0xff061237),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              " Sign in",
                              style: TextStyle(
                                color: AppColors.primaryColors,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 22),
                  child: Column(
                    children: [
                      widget.widgetIndex == 0
                          ? loginWidget(context, state)
                          : signUpWidget(context, state)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loginWidget(BuildContext context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTitleColor),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            "Enter using your account credentials",
            style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w400,
                color: AppColors.greyText),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: textBox("Enter your email", loginEmailController, "Email",
              loginErrorStatus,false),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: textBox("Enter your password", loginPasswordController,
              "Password", loginErrorStatus,false),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: loginErrorStatus,
                  child: Text(
                    loginErrorMsg,
                    style:const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(
                        0xffD80027,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: GestureDetector(
            onTap: () {
              validateData(loginEmailController.text,
                  loginPasswordController.text, context);


                  print("second tap");
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryColors,
              ),
              child: state is UserLoginLoadingState
                  ? const CupertinoActivityIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
            ),
          ),
        ),

       
        SizedBox(height: 16),
        // GestureDetector(
        //   onTap: () async {
        //     // final auth = FirebaseAuth.instance;
        //     // final signIN = await auth.signInWithProvider(GoogleAuthProvider());
        //     // final token = await signIN.user!.uid;

        //     final googleUser = await GoogleSignIn().signIn();
        //     final auth = await googleUser?.authentication;
        //     final credential = GoogleAuthProvider.credential(
        //       accessToken: auth!.accessToken,
        //       idToken: auth.idToken,
        //     );
        //     FirebaseAuth.instance.signInWithCredential(credential);
        //     // await GoogleSignIn().signOut();
        //     // print(auth!.accessToken.toString() + ":::::::::::::::::::::");
        //     // await FirebaseAuth.instance.signOut();
        //   },
        //   child: Container(
        //     height: 56,
        //     alignment: Alignment.center,
        //     width: MediaQuery.of(context).size.width,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(12),
        //       color: Colors.white,
        //       border: Border.all(color: Color(0xffC1C4CD)),
        //     ),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SvgPicture.asset('assets/images/google_icon.svg'),
        //         const SizedBox(width: 10),
        //         const Text(
        //           "Sign in with Google",
        //           style: TextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w500,
        //               color: AppColors.primaryTitleColor),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),


         Row(
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
             GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      ResetPassword()));
                        },
                        child: const Text("Forgot Password?",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColors)),
                      ),
           ],
         ),
        
      ],
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus,bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff6A7187)),
                ),
                isRequired? const Text(
                  " *",
                  style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color:Color(0xFFD80027)),
                ):const SizedBox(),
              ],
            ),
            // label == 'Password' && widget.widgetIndex == 0
            //     ? GestureDetector(
            //         onTap: () {
            //           Navigator.push(
            //               context,
            //               CupertinoPageRoute(
            //                   builder: (BuildContext context) =>
            //                       ResetPassword()));
            //         },
            //         child: const Text("Forgot Password?",
            //             style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w600,
            //                 color: AppColors.primaryColors)),
            //       )
            //     : const SizedBox(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              inputFormatters:label=='Phone Number'? [
                PhoneInputFormatter(),
               
              //  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
              ]:[],
              keyboardType:
                  label == 'Phone Number' ? TextInputType.number : null,
              maxLength: label == 'Phone Number'
                  ? 16
                  : label == 'Password'
                      ? 12
                      : 50,
              obscureText: label == "Password" ? isObscure : false,
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  // prefixIcon:
                  //     label == 'Phone Number' ? countryPickerWidget() : null,
                  suffixIcon: label == "Password"
                      ? GestureDetector(
                          onTap: () {
                            print("tapped");
                            changePassVisible();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: SvgPicture.asset(
                                "assets/images/password_hide_icon.svg"),
                          ),
                        )
                      : const SizedBox(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff6A7187)),
                ),
                const Text(" *",style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color:Color(0xFFD80027)
                ),)
              ],
            ),
            label == 'Password'
                ? const Text(
                    "Forgot Password?",
                    style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColors),
                  )
                : const SizedBox(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2.4,
            child: TextField(
              controller: controller,
              maxLength: 50,
              inputFormatters: label=='First name'? [
                
                FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                FilteringTextInputFormatter.deny(RegExp(r"[!@#$%^&*()\-_=+{}[\]|;:',<.>/?~]")),
                FilteringTextInputFormatter.deny(RegExp('["]')),

              ]:[
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                FilteringTextInputFormatter.deny(RegExp(r"[!@#$%^&*()\-_=+{}[\]|;:',<.>/?~]")),
                FilteringTextInputFormatter.deny(RegExp('["]')),
              ],
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpWidget(BuildContext context, state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create an Account",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryTitleColor),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              halfTextBox("Enter first name", firstNameController, "First name",
                  nameErrorStaus),
              halfTextBox("Enter last name", lastNameController, "Last name",
                  nameErrorStaus),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Visibility(
              visible: nameErrorStaus,
              child: Text(
                nameErrorMsg,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD80027),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: textBox("Enter your email", signUpEmailController, "Email",
              emailErrorStatus,true),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Visibility(
              visible: emailErrorStatus,
              child: Text(emailErrorMsg,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(
                      0xffD80027,
                    ),
                  ))),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: textBox("Enter your phone number", phoneNumberController,
              "Phone Number", phoneNumberErrorStatus,true),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Visibility(
              visible: phoneNumberErrorStatus,
              child: Text(
                phoneErrorMsg,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xffD80027,
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: textBox("Min. 8 characters", signUpPasswordController,
              "Password", passwordErrorStatus,true),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Visibility(
              visible: passwordErrorStatus,
              child: Text(
                passwordErrorMsg,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xffD80027,
                  ),
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "By registering, i agree to the Autopilot",
                  style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1),
                ),
                TextSpan(
                    text: " Terms of service",
                    style: TextStyle(
                        color: AppColors.primaryColors,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        height: 1.2)),
                TextSpan(
                  text: " and",
                  style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1,
                      height: 1.2),
                ),
                TextSpan(
                    text: " Privacy Policy.",
                    style: TextStyle(
                        color: AppColors.primaryColors,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        height: 1.2)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: GestureDetector(
            onTap: () {
              //   Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return LoginAndSignupScreen(widgetIndex: 1,);
              // },));
            },
            child: GestureDetector(
              onTap: () {
                //  context.read<LoginBloc>().add(CreateAccountEvent(firstName: firstNameController.text, lastName: lastNameController.text, email: signUpEmailController.text, password: signUpPasswordController.text, phoneNumber: phoneNumberController.text));
                validateSignup(
                    firstNameController.text,
                    lastNameController.text,
                    signUpEmailController.text,
                    phoneNumberController.text,
                    signUpPasswordController.text,
                    context);
              },
              child: Container(
                height: 56,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColors,
                ),
                child: state is CreateAccountLoadingState
                    ? const CupertinoActivityIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Next",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20,)
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 16.0, top: 24),
        //   child: Container(
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         widget.widgetIndex == 0
        //             ? GestureDetector(
        //                 onTap: () {
        //                   setState(() {
        //                     widget.widgetIndex = 1;
        //                   });
        //                 },
        //                 child: const Wrap(
        //                   children: [
        //                     Text(
        //                       "Dont have an account?",
        //                       style: TextStyle(
        //                         color: Color(0xff061237),
        //                         fontWeight: FontWeight.w400,
        //                         fontSize: 14,
        //                       ),
        //                     ),
        //                     Text(
        //                       "Sign up",
        //                       style: TextStyle(
        //                         color: Color(0xff333333),
        //                         fontWeight: FontWeight.w600,
        //                         fontSize: 14,
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               )
        //             : GestureDetector(
        //                 onTap: () {
        //                   setState(() {
        //                     widget.widgetIndex = 0;
        //                   });
        //                 },
        //                 child: const Wrap(
        //                   children: [
        //                     Text(
        //                       "Already have an account?",
        //                       style: TextStyle(
        //                         color: Color(0xff061237),
        //                         fontWeight: FontWeight.w400,
        //                         fontSize: 14,
        //                       ),
        //                     ),
        //                     Text(
        //                       "Sign in",
        //                       style: TextStyle(
        //                         color: AppColors.primaryColors,
        //                         fontWeight: FontWeight.w600,
        //                         fontSize: 14,
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget continueToLogin() {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              setState(() {
                widget.widgetIndex = 0;
              });
            },
            child: Icon(Icons.close)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Confirm Your Email",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTitleColor),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "We just send you a confirmation email",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyText),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Text(
                        "Please open it and click the link to\ncomplete the registration.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyText),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LoginAndSignupScreen(
                              widgetIndex: 1,
                            );
                          },
                        ));
                      },
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        child: const Text(
                          "Resend Email",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff333333)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          widget.widgetIndex = 0;
                        });
                      },
                      child: Container(
                        height: 56,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.primaryColors,
                        ),
                        child: const Text(
                          "Continue to login",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  validateData(String email, String password, BuildContext context) {
    if (email.isNotEmpty && password.isNotEmpty) {
      context.read<LoginBloc>().add(UserLoginEvent(
          email: loginEmailController.text,
          password: loginPasswordController.text,
          context: context));
    } else {
      setState(() {
        loginErrorMsg = 'Please enter a valid email and password';
        loginErrorStatus = true;
      });
    }
  }

  validateSignup(String firstName, String lastName, String email,
      String phoneNumber, String password, BuildContext context) {
    if (firstName.isEmpty && lastName.isEmpty) {
      setState(() {
        nameErrorMsg = 'First and last names cant be empty';
        nameErrorStaus = true;
      });
    } else if (firstName.isEmpty) {
      setState(() {
        nameErrorMsg = 'First name cant be empty';
        nameErrorStaus = true;
      });
    } else if (lastName.isEmpty) {
      {
        setState(() {
          nameErrorMsg = 'last name cant be empty';
          nameErrorStaus = true;
        });
      }
    } else {
      setState(() {
        nameErrorStaus = false;
      });
    }

    if (email.isEmpty) {
      setState(() {
        emailErrorMsg = 'Email cant be empty';
        emailErrorStatus = true;
      });
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        setState(() {
          emailErrorStatus = true;
          emailErrorMsg = 'Please enter a valid email';
        });
      } else {
        setState(() {
          emailErrorStatus = false;
        });
      }
    }
    if (phoneNumber.isEmpty) {
      setState(() {
        phoneErrorMsg = 'Phone number cant be empty.';
        phoneNumberErrorStatus = true;
      });
    } else {
      if (phoneNumber.length < 6) {
        setState(() {
          phoneNumberErrorStatus = true;
          phoneErrorMsg = 'Please enter a valid phone number';
        });
      } else {
        setState(() {
          phoneNumberErrorStatus = false;
        });
      }
    }
    if (password.isEmpty) {
      setState(() {
        passwordErrorStatus = true;
        passwordErrorMsg = 'Password cant be empty';
      });
    } else {
      if (password.length < 8) {
        setState(() {
          passwordErrorMsg = 'Minimum 8 characters required';
          passwordErrorStatus = true;
        });
      } else {
        passwordErrorStatus = false;
      }
    }

    if (!emailErrorStatus &&
        !nameErrorStaus &&
        !phoneNumberErrorStatus &&
        !passwordErrorStatus) {
      context.read<LoginBloc>().add(CreateAccountEvent(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          phoneNumber: phoneNumber));
    }
  }

  changePassVisible() {
    if (isObscure) {
      setState(() {
        isObscure = false;
        print(isObscure);
      });
    } else {
      setState(() {
        isObscure = true;
      });
    }
  }

  Widget countryPickerWidget() {
    return GestureDetector(
      onTap: () async {
        // Show the country code picker when tapped.
        final code = await countryPicker.showPicker(context: context);
        // Null check
        if (code != null) {
          setState(() {
            selectedCountry = code;
          });
        }
        ;
      },
      child: Container(
        width: 90,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: Row(
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: CircleAvatar(
            //     radius: 9,
            //     backgroundColor: Colors.transparent,
            //     child: selectedCountry!=null?ClipOval(child: selectedCountry!.flagImage):const SizedBox() ,

            //   ),
            // ),

            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: selectedCountry != null
                      ? selectedCountry!.flagImage
                      : const SizedBox()),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: Text(
                  selectedCountry != null ? selectedCountry!.dialCode : "+1"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Container(
                width: 0.7,
                color: AppColors.greyText,
              ),
            )
          ],
        ),
      ),
    );
  }
}
