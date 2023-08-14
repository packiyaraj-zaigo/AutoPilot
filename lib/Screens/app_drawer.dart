import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/customers_screen.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/Screens/legal.dart';
import 'package:auto_pilot/Screens/parts_list_screen.dart';
import 'package:auto_pilot/Screens/services_list_screen.dart';
import 'package:auto_pilot/Screens/time_card_screen.dart';
import 'package:auto_pilot/Screens/vehicles_screen.dart';
import 'package:auto_pilot/Screens/welcome_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  ? userName[0].toUpperCase() + userName.substring(1)
                  : "",
              style: const TextStyle(
                  fontSize: 28,
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.w600),
            ),
          ), //UserAccountDrawerHeader
        ),
        const SizedBox(
          height: 16.5,
        ),
        drawerTileWidget("assets/images/dashboard_drawer_icon.svg", "Dashboard",
            context, BottomBarScreen()),
        drawerTileWidget("assets/images/employee_drawer_icon.svg", "Employees",
            context, const EmployeeListScreen()),
        drawerTileWidget(
            "assets/images/customer_drawer_icon.svg",
            "Customers",
            context,
            // DummyScreen(
            //   name: "Customer Screen",
            // )),
            const CustomersScreen()),
        drawerTileWidget(
            "assets/images/vehicle_drawer_icon.svg",
            "Vehicles",
            context,
            // DummyScreen(
            //   name: "Vehicle Screen",
            // )),
            const VehiclesScreen()),
        drawerTileWidget("assets/images/parts_drawer_icon.svg", "Parts",
            context, const PartsScreen()),
        drawerTileWidget(
            "assets/images/service_drawer_icon.svg",
            "Services",
            context,
            // DummyScreen(
            // name: "Service Screen",
            // )),
            const ServicesListScreen()),
        // drawerTileWidget("assets/images/reports_drawrer_icon.svg", "Reports",
        //     context, BottomBarScreen()),
        drawerTileWidget(
          "assets/images/time_card_drawer_icon.svg",
          "Time Cards",
          context,
          const TimeCardsScreen(),
        ),
        const SizedBox(
          height: 52,
        ),
        drawerBottomTile("Settings", context, BottomBarScreen()),
        drawerBottomTile("Legal", context, const LegalScreen()),
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
      padding: const EdgeInsets.only(left: 33.0, top: 16.5, bottom: 16.5),
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
    behavior: HitTestBehavior.translucent,
    onTap: () async {
      if (label == "Sign Out") {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (context) {
            return const WelcomeScreen();
          },
        ), (route) => false);
        AppUtils.setToken("");
        AppUtils.setUserName("");
        AppUtils.setTokenValidity('');
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('add_company', false);
      } else if (label == "Legal") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => constructor,
        ));
      } else {
        Navigator.pop(context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.only(left: 33.0, top: 13, bottom: 13),
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
