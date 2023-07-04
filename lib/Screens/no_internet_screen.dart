import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoInternetScreen extends StatelessWidget {
  NoInternetScreen({
    super.key,
    required this.state,
  });

  StateSetter state;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/no_internet.gif'),
              const SizedBox(height: 20),
              const Text(
                'No Internet',
                style:
                    TextStyle(fontSize: 18, color: AppColors.primaryTitleColor),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await AppUtils.getConnectivity().then((value) {
                    state(() {
                      // print(network);
                      // network = value;
                    });
                  });
                },
                child: const Text('Retry'),
              )
            ],
          ))),
    );
  }
}
