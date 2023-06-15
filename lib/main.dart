
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/login_bloc/login_bloc.dart';


import 'package:auto_pilot/Screens/welcome_screen.dart';
import 'package:auto_pilot/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';



String? initScreen;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getString(AppConstants.USER_TOKEN);
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
        
      ],
       child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: initScreen!="" &&initScreen!=null?"/home":"/login",
        theme: ThemeData(
         
          primarySwatch: Colors.blue,
          fontFamily: "Sfpro"
        ),
        home: WelcomeScreen(),
        debugShowCheckedModeBanner: false,

         routes: <String, WidgetBuilder>{
                '/login': (BuildContext context) => WelcomeScreen(),
                '/home': (BuildContext context) => BottomBarScreen(),
               
              },
        
      ),
   
    );
     
    
  }
}


