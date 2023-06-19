import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/Screens/welcome_screen.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



showDrawer(BuildContext context){

 return Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
             DrawerHeader(
              // padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                color: Colors.white,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.white),
                accountName: const Text(
                  "Hello",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                accountEmail: Text(
                 userName,
                  style: const TextStyle(fontSize: 28, color: Colors.black),
                ),
                // currentAccountPictureSize: Size.square(50),
                // currentAccountPicture: CircleAvatar(
                //   backgroundColor: Color.fromARGB(255, 165, 255, 137),
                //   child: Text(
                //     "A",
                //     style: TextStyle(fontSize: 30.0, color: Colors.blue),
                //   ), //Text
                // ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: Icon(Icons.data_saver_off),
              title: const Text('DashBoard'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_alt_outlined),
              title: const Text('Employees'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.person_3_fill),
              title: const Text('Customers'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.car_detailed),
              title: const Text('Vehicles'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.archivebox),
              title: const Text('Parts'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.car_crash_sharp),
              title: const Text('Service'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time_outlined),
              title: const Text('Time Cards'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Legal'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sign Out'),
              onTap: () {
                AppUtils.setToken("");
                AppUtils.setUserName("");

               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                 return const WelcomeScreen();
               },), (route) => false);
              },
            ),
          ],
        ),
      );
}


