import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.mark_chat_unread_outlined, color: Colors.black87),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.notification_add, color: Colors.black87),
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
              // padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.white,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                accountName: Text(
                  "Hello",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                accountEmail: Text(
                  "Madhi",
                  style: TextStyle(fontSize: 28, color: Colors.black),
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EmployeeListScreen(),
                ));
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
                      style: TextStyle(fontSize: 20),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.stacked_bar_chart_rounded),
                        title: Text('Sales'),
                        trailing: Text('\$3,275'),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Weekly Revenue',
                style: TextStyle(fontSize: 20),
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
