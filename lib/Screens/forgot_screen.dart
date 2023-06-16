import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/app_colors.dart';
import '../utils/app_colors.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({super.key, required this.widgetIndex});
  int widgetIndex;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool emailSent = true;

  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          newpassword()
          // widget.widgetIndex == 0
          //     ? resetpasswordscreen()
          //     : recoveryemailscreen()
        ],
      ),
    );
  }

  Widget resetpasswordscreen() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reset Password",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: AppColors.primaryTitleColor),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Provide your email to receive a reset link",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.greyText),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Email",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
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
                // Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //         builder: (context) => recoveryemailscreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: emailSent ? AppColors.primaryColors : Colors.white,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
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
                displayBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColors,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
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

  displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.800,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
                        decoration: BoxDecoration(
                          color: AppColors.dividerColors,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "5-Digit Code",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                          color: AppColors.primaryTitleColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please enter the code we\'ve sent to Johndoe@gmail.com.",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColors.greyText),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 5,
                        validator: (v) {
                          if (v!.length < 3) {
                            return "Enter OTP";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          selectedColor: Colors.black,
                          inactiveColor: AppColors.greyText,
                          activeColor: const Color(0xff808B9E),
                          errorBorderColor: const Color(0xff808B9E),
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
                          debugPrint(value);
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) => newpassword()));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColors.primaryColors,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        const Text('Don\'t receive a code?'),
                        TextButton(
                          child: const Text(
                            'Resend',
                            style: TextStyle(
                                fontSize: 20, color: AppColors.greyText),
                          ),
                          onPressed: () {},
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              ),
            ));
  }

  Widget newpassword() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Create a new password",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: AppColors.primaryTitleColor),
          ),
          SizedBox(
            height: 26,
          ),
          Text(
            "New password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "SF Pro",
                color: AppColors.greyText),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 55,
            child: CupertinoTextField(
              placeholder: 'Enter password...',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: AppColors.greyText),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Confirm New password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                fontFamily: "SF Pro",
                color: AppColors.greyText),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 55,
            child: CupertinoTextField(
              placeholder: 'Enter password...',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: AppColors.greyText),
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
                displayBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColors,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
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
