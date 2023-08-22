import 'package:auto_pilot/Screens/add_company_screen.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/appointment/appointment_bloc.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/bloc/login_bloc/login_bloc.dart';

import 'package:auto_pilot/Screens/welcome_screen.dart';
import 'package:auto_pilot/bloc/notification/notification_bloc.dart';
import 'package:auto_pilot/bloc/scanner/scanner_bloc.dart';
import 'package:auto_pilot/bloc/parts_model/parts_bloc.dart';
import 'package:auto_pilot/bloc/time_card/time_card_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_bloc.dart';
import 'package:auto_pilot/bloc/workflow/workflow_bloc.dart';
import 'package:auto_pilot/utils/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/customer_bloc/customer_bloc.dart';

String? initScreen;
bool? addCompany;
bool? tokenValidity;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getString(AppConstants.USER_TOKEN);
  addCompany = prefs.getBool('add_company');
  // final tokenDate = prefs.getString('token_expiry');
  // final date = DateTime.parse(tokenDate ?? DateTime.now().toString());
  // tokenValidity = DateTime.now().isBefore(date);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(apiRepository: ApiRepository()),
        ),
        BlocProvider(
          create: (context) => EmployeeBloc(),
        ),
        // BlocProvider(
        //   create: (context) => VechileBloc(),
        // ),
        BlocProvider(
          create: (context) => CustomerBloc(),
        ),
        BlocProvider(
          create: (context) => PartsBloc(),
        ),
        BlocProvider(
          create: (context) => ScannerBloc(),
        ),
        BlocProvider(
          create: (context) => NotificationBloc(),
        ),
        BlocProvider(
          create: (context) => TimeCardBloc(),
        ),
        BlocProvider(
          create: (context) => WorkflowBloc(),
        ),
        BlocProvider(
          create: (context) => AppointmentBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'AutoPilot',
        initialRoute: initScreen != "" &&
                initScreen != null &&
                tokenValidity != null &&
                tokenValidity!
            ? addCompany == true
                ? "/home"
                : '/add_company'
            : "/login",
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Sfpro"),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => WelcomeScreen(),
          '/home': (BuildContext context) => BottomBarScreen(),
          '/add_company': (BuildContext context) => AddCompanyScreen(),
        },
      ),
    );
  }
}
