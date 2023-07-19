import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/customers_screen.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/Screens/dummy_screen.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/Screens/services_list_screen.dart';
import 'package:auto_pilot/Screens/time_card_screen.dart';
import 'package:auto_pilot/Screens/vehicles_screen.dart';
import 'package:auto_pilot/Screens/welcome_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

showDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      padding: const EdgeInsets.all(0),
      children: [
        DrawerHeader(
          // padding: EdgeInsets.zero,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ), //BoxDecoration
          child: UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            accountName: const Text(
              "Hello",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600),
            ),
            accountEmail: Text(
              userName.isNotEmpty
                  ? "${userName[0].toUpperCase() + userName.substring(1)}"
                  : "",
              style: const TextStyle(
                  fontSize: 28,
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.w600),
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
        drawerTileWidget("assets/images/dashboard_drawer_icon.svg", "Dashboard",
            context, BottomBarScreen()),
        drawerTileWidget("assets/images/employee_drawer_icon.svg", "Employees",
            context, EmployeeListScreen()),
        drawerTileWidget(
            "assets/images/customer_drawer_icon.svg",
            "Customers",
            context,
            DummyScreen(
              name: "Customer Screen",
            )),
        //  CustomersScreen()),
        //  CustomersScreen()),
        drawerTileWidget(
            "assets/images/vehicle_drawer_icon.svg",
            "Vehicles",
            context,
            // DummyScreen(
            //   name: "Vehicle Screen",
            // )),
            VehiclesScreen()),
        // VehiclesScreen()),

        drawerTileWidget("assets/images/parts_drawer_icon.svg", "Parts",
            context, BottomBarScreen()),
        drawerTileWidget(
            "assets/images/service_drawer_icon.svg",
            "Services",
            context,
            DummyScreen(
              name: "Service Screen",
            )),
        //  ServicesListScreen()),
        drawerTileWidget("assets/images/reports_drawrer_icon.svg", "Reports",
            context, BottomBarScreen()),
        drawerTileWidget(
            "assets/images/time_card_drawer_icon.svg",
            "Time Cards",
            context,
            DummyScreen(
              name: "Time Card Screen",
            )),
        const SizedBox(
          height: 52,
        ),
        drawerBottomTile("Settings", context, BottomBarScreen()),
        drawerBottomTile("Legal", context, BottomBarScreen()),
        drawerBottomTile("About", context, BottomBarScreen()),
        drawerBottomTile("Sign Out", context, BottomBarScreen()),
        const SizedBox(
          height: 20,
        )
      ],
    ),
  );
}

Widget drawerTileWidget(
    String iconUrl, String label, BuildContext context, constructor) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      if (label == "Dashboard") {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return BottomBarScreen();
          },
        ), (route) => false);
      } else {
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return constructor;
          },
        ));
      }
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 33.0, top: 33),
      child: Row(
        children: [
          SizedBox(
              height: label == "Parts" || label == "Vehicles" ? 19 : 22,
              width: label == "Parts" || label == "Vehicles" ? 19 : 22,
              child: SvgPicture.asset(iconUrl)),
          Padding(
            padding: const EdgeInsets.only(left: 14.0),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTitleColor),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget drawerBottomTile(String label, BuildContext context, constructor) {
  return GestureDetector(
    onTap: () {
      if (label == "Sign Out") {
        AppUtils.setToken("");
        AppUtils.setUserName("");

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();
          },
        ), (route) => false);
      } else {
        Navigator.pop(context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 33.0, top: 26),
      child: Text(
        label,
        style: const TextStyle(
            color: AppColors.primaryTitleColor,
            fontSize: 16,
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}
