import 'package:auto_pilot/login_screens/first_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ResetPassword(),
    );
  }
}

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool emailSent = true;
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // emailSent
          //     ?  resetpasswordscreen()
          //     :  recoveryemailscreen(),
          // recoveryemailscreen(),
          // resetpasswordscreen()
          newpassword(),
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
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Provide your email to receive a reset link",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.teal),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Email",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => recoveryemailscreen()));
              },
              style: ElevatedButton.styleFrom(
                primary: emailSent ? Colors.black : Colors.white,
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
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Please check your email",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.teal),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "If this email is associated with an account you will receive a password reser link.",
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 20, color: Colors.teal),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Email",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                displayBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
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
                          color: Colors.teal,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "5-Digit Code",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Please enter the code we\'ve sent to Johndoe@gmail.com.",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.teal),
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
                          selectedColor: const Color(0xff808B9E),
                          inactiveColor: const Color(0xff808B9E),
                          activeColor: const Color(0xff808B9E),
                          errorBorderColor: const Color(0xff808B9E),
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(15),
                          fieldHeight: 54,
                          fieldWidth: 63,
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
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
                            style: TextStyle(fontSize: 20),
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
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "New password",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: CupertinoTextField(
              placeholder: 'Enter password',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Confirm New password",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: CupertinoTextField(
              placeholder: 'Enter password',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                displayBottomSheet(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
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
