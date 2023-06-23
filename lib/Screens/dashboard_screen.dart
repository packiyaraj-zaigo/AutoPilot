// ignore_for_file: deprecated_member_use

import 'package:auto_pilot/Models/revenue_chart_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


String userName='';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  bool hideSummary = true;
   final scaffoldKey = GlobalKey<ScaffoldState>();
   RevenueChartModel? revenueChartData;
   
  // final List<ChartData> chartData = [
  //   ChartData(1, 35),
  //   ChartData(2, 23),
  //   ChartData(3, 34),
  //   ChartData(4, 25),
  //   ChartData(5, 40)
  // ];
  final List<ChartData> chartData = [
    
  ];
  final List<ChartData> chartData2 = [
  
  ];

  final List<String> dashIconUrl = [
    'assets/images/sales.svg',
    'assets/images/drop.svg',
    'assets/images/pick.svg',
    'assets/images/current_vehicle_dash_icon.svg',
    'assets/images/staff_dash_icon.svg'
  ];
  final List<String> dashTitle = [
    'Sales',
    'Drop-offs',
    'Pick-ups',
    'Current Vehicles',
    'Staff'
  ];

  final List<String>dashboardCountList=[];
  @override
  Widget build(BuildContext context) {
   
    return BlocProvider(
      create: (context) => DashboardBloc(apiRepository: ApiRepository())
      ..add(GetRevenueChartDataEvent())
      ..add(GetUserProfileEvent()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if(state is GetRevenueChartDataState){
            revenueChartData=state.revenueData;
            print(revenueChartData?.graphdata??"");
            dashboardCountList.clear();
            chartData.clear();
            chartData2.clear();

            dashboardCountList.add(revenueChartData?.sales??"");
             dashboardCountList.add(revenueChartData?.dropoffs.toString()??"");
               dashboardCountList.add(revenueChartData?.pickups.toString()??"");
                dashboardCountList.add(revenueChartData?.currentVehicles.toString()??"");
                 dashboardCountList.add(revenueChartData?.staff.toString()??"");
            revenueChartData?.graphdata.week1.forEach((element) { 
              chartData.add(ChartData(element.x, double.parse(element.y)));
            });

             revenueChartData?.graphdata.week2.forEach((element) { 
              chartData2.add(ChartData(element.x, double.parse(element.y)));
            });
           
          } else if(state is GetProfileDetailsState){
            AppUtils.setUserName(state.userProfile.user[0].firstName);
            getUserName();
            print(userName);




          }
          // TODO: implement listener
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              key: scaffoldKey,
              // appBar: AppBar(
              //   leading: IconButton(
              //     icon: const Icon(
              //       Icons.menu,
              //       color: Colors.black87,
              //     ),
              //     onPressed: () {
              //       scaffoldKey.currentState!.openDrawer();
              //     },
              //   ),
              //   backgroundColor: Colors.white,
              //   elevation: 0,
              //   title: const Text(
              //     'Autopilot',
              //     style: TextStyle(color: Colors.black87),
              //   ),
              //   centerTitle: true,
              //   actions: [
              //     IconButton(
              //         onPressed: () {},
              //         icon: SvgPicture.asset("assets/images/message.svg")),
              //     IconButton(
              //         onPressed: () {},
              //         icon: SvgPicture.asset(
              //             "assets/images/notification.svg"))
              //   ],
              // ),
              // drawer: showDrawer(context),
              body:state is DashboardLoadingState?const Center(
                child: CupertinoActivityIndicator(),
              ): ScrollConfiguration(
                
                behavior: const ScrollBehavior(
                 

                ),
                child: SingleChildScrollView(
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
                          child: const Row(
                            children: [
                               Text(
                                'Today\'s Summary',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500,
                                    color: AppColors.primaryTitleColor),
                              ),
                              // hideSummary
                              //     ? const Icon(
                              //         Icons.keyboard_arrow_down_outlined,
                              //       )
                              //     : const Icon(
                              //         Icons.keyboard_arrow_up_outlined,
                              //       )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: hideSummary,
                          // child: ListView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: 5,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     return dashBoardTile(
                          //         dashIconUrl[index], dashTitle[index], dashboardCountList[index]);
                          //   },
                          //   physics: const NeverScrollableScrollPhysics(),
                          // ),

                           child: Column(
                          children: [
                             dashBoardTile(
                                   'assets/images/sales.svg','Sales', revenueChartData?.sales??""),
                                dashBoardTile(
                                    'assets/images/drop.svg','Drop-offs', revenueChartData?.dropoffs.toString()??"") ,
                                   dashBoardTile(
                                   'assets/images/pick.svg','Pick-ups', revenueChartData?.pickups.toString()??""),
                                    dashBoardTile(
                                   'assets/images/current_vehicle_dash_icon.svg','Current Vehicles', revenueChartData?.currentVehicles.toString()??"") ,
                                       dashBoardTile(
                                   'assets/images/staff_dash_icon.svg','Staff', revenueChartData?.staff.toString()??"")               

                          ],
                         )
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Weekly Revenue',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500,
                              color: AppColors.primaryTitleColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 220,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SfCartesianChart(
                                  primaryXAxis: CategoryAxis(),
                                  // Palette colors
                                  palette:const <Color> [
                                    AppColors.primaryColors,
                                    Colors.grey,
                                  ],
                                  series: <CartesianSeries>[
                                    ColumnSeries<ChartData, String>(
                                        dataSource: chartData,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                    ColumnSeries<ChartData, String>(
                                        dataSource: chartData2,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dashBoardTile(String iconUrl, String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(iconUrl,
                  color: AppColors.primaryTitleColor,),
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTitleColor),
                    ),
                  )
                ],
              ),
              Text(
                subTitle,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUserName()async{
   
     await AppUtils.getUserName().then((value) {
      setState(() {
        userName=value;
      });
     });
      



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
