import 'package:auto_pilot/login_screens/welcome_screen.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BottomBarScreen extends StatelessWidget {
  const BottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text("Dashboard screen"),
            ),
            Padding(
              padding: const EdgeInsets.only(top:24.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                    return const WelcomeScreen();
                  },), (route) => false);
                  AppUtils.setToken("");

                },
                child: Text("Signout",style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 16
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}