import 'package:auto_pilot/Screens/login_signup_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/welcome_bg.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  child: const Wrap(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
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
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2.6,
                width: MediaQuery.of(context).size.width,
              ),
              const Text(
                "Welcome to Autopilot",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur\nadipiscing elit uis porta ante dui, .",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.8,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: GestureDetector(
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
                      color: AppColors.primaryColors,
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),

              //Signin Button

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginAndSignupScreen(
                          widgetIndex: 0,
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
                      color: const Color(0xffDFDFDF),
                    ),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColors),
                    ),
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
