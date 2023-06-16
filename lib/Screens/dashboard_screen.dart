import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../utils/app_colors.dart';
import '../utils/app_utils.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool hideSummary = true;
  // final List<ChartData> chartData = [
  //   ChartData(1, 35),
  //   ChartData(2, 23),
  //   ChartData(3, 34),
  //   ChartData(4, 25),
  //   ChartData(5, 40)
  // ];
  final List<ChartData> chartData = [
    ChartData(
      'Mon',
      98,
    ),
    ChartData(
      'Tue',
      73,
    ),
    ChartData(
      'Wed',
      55,
    ),
    ChartData(
      'Thur',
      66,
    ),
    ChartData(
      'Fri',
      90,
    ),
    ChartData(
      'Sat',
      57,
    ),
    ChartData(
      'Sun',
      87,
    )
  ];
  final List<ChartData> chartData2 = [
    ChartData(
      'Mon',
      111,
    ),
    ChartData(
      'Tue',
      99,
    ),
    ChartData(
      'Wed',
      44,
    ),
    ChartData(
      'Thur',
      33,
    ),
    ChartData(
      'Fri',
      80,
    ),
    ChartData(
      'Sat',
      77,
    ),
    ChartData(
      'Sun',
      87,
    )
  ];

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Autopilot',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          SvgPicture.asset(
            "assets/images/message.svg",
            color: AppColors.primaryColors,
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 20,
          ),
          SvgPicture.asset(
            "assets/images/notification.svg",
            color: AppColors.primaryColors,
            height: 20,
            width: 20,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.white,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                accountName: Text(
                  "Hello",
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.greyText,
                      fontWeight: FontWeight.w600),
                ),
                accountEmail: Text(
                  "Madhi",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColors.primaryBlackColors,
                      fontWeight: FontWeight.w500),
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
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/dashboard_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Dashboard',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/employee_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Employees',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/customers_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Customers',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/vehicles_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Vehicles',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/parts_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Parts',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/services_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Service',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/reports_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Reports',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              horizontalTitleGap: 1,
              leading: SvgPicture.asset(
                "assets/images/time_icon.svg",
                color: AppColors.primaryColors,
                height: 20,
                width: 20,
              ),
              title: Text(
                'Time Cards',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text(
                'Settings',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Legal',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'About',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Sign Out',
                style: AppUtils.drawerStyle(),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    hideSummary = !hideSummary;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      'Today\'s Summary',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryTitleColor,
                          fontWeight: FontWeight.w600),
                    ),
                    hideSummary
                        ? Icon(
                            Icons.keyboard_arrow_down_outlined,
                          )
                        : Icon(
                            Icons.keyboard_arrow_up_outlined,
                          )
                  ],
                ),
              ),
              Visibility(
                visible: hideSummary,
                child: Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/sales.svg",
                          color: AppColors.greyText,
                          height: 20,
                          width: 20,
                        ),
                        title: Text(
                          'Sales',
                          style: AppUtils.summaryStyle(),
                        ),
                        trailing: Text(
                          '\$3,275.00',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor,
                            fontSize: 18,
                            fontFamily: '.SF Pro Text',
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/drop.svg",
                          color: AppColors.greyText,
                          height: 20,
                          width: 20,
                        ),
                        title: Text(
                          'Drop-offs',
                          style: AppUtils.summaryStyle(),
                        ),
                        trailing: Text(
                          '4',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor,
                            fontSize: 18,
                            fontFamily: '.SF Pro Text',
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/pick.svg",
                          color: AppColors.greyText,
                          height: 20,
                          width: 20,
                        ),
                        title: Text(
                          'Pick-ups',
                          style: AppUtils.summaryStyle(),
                        ),
                        trailing: Text(
                          '3',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor,
                            fontSize: 18,
                            fontFamily: '.SF Pro Text',
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/vehicles_icon.svg",
                          color: AppColors.greyText,
                          height: 20,
                          width: 20,
                        ),
                        title: Text(
                          'Current Vehicles',
                          style: AppUtils.summaryStyle(),
                        ),
                        trailing: Text(
                          '12',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor,
                            fontSize: 18,
                            fontFamily: '.SF Pro Text',
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "assets/images/customers_icon.svg",
                          color: AppColors.greyText,
                          height: 20,
                          width: 20,
                        ),
                        title: Text(
                          'Staff',
                          style: AppUtils.summaryStyle(),
                        ),
                        trailing: Text(
                          '4',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor,
                            fontSize: 18,
                            fontFamily: '.SF Pro Text',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Weekly Revenue',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor),
              ),
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  // Palette colors
                  palette: <Color>[
                    Colors.black,
                    Colors.grey,
                  ],
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                        dataSource: chartData,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y),
                    ColumnSeries<ChartData, String>(
                        dataSource: chartData2,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
  );
  final String x;
  final double? y;
}
