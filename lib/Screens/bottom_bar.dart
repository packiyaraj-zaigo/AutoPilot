// ignore_for_file: deprecated_member_use

import 'package:auto_pilot/Screens/add_company_screen.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/calendar_screen.dart';
import 'package:auto_pilot/Screens/create_estimate.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/Screens/dummy_screen.dart';
import 'package:auto_pilot/Screens/estimate_screen.dart';
import 'package:auto_pilot/Screens/no_internet_screen.dart';
import 'package:auto_pilot/Screens/notification_screen.dart';
import 'package:auto_pilot/Screens/scanner_screen.dart';
import 'package:auto_pilot/Screens/work_flow_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class BottomBarScreen extends StatefulWidget {
  BottomBarScreen({
    super.key,
  });

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
    with TickerProviderStateMixin {
  late TabController estimateTabController;
  late TabController workFlowTabController;
  PageController pageController = PageController();
  List pages = [];

  int currentIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    estimateTabController = TabController(length: 4, vsync: this);
    workFlowTabController = TabController(length: 2, vsync: this);

    pages = [
      DashBoardScreen(),
      //  WorkFlowScreen(tabController: workFlowTabController),
      DummyScreen(name: "Work flow Screen"),
      DummyScreen(name: "Calendar Screen"),
      //  CalendarScreen(),
      // EstimateScreen(
      //   tabController: estimateTabController,
      // )

      DummyScreen(name: "Estimate screen")
    ];
    // TODO: implement initState
    super.initState();
    // networkCheck();
    networkCheck().then((value) {
      // if (!network) {
      setState(() {});
    });
  }

  bool network = false;

  Future<bool> networkCheck() async {
    final value = await AppUtils.getConnectivity().then((value) {
      return value;
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await networkCheck().then((value) {
        if (value != network) {
          setState(() {
            network = value;
          });
        }
      });
    });
    return BlocProvider(
      create: (context) => DashboardBloc(apiRepository: ApiRepository())
        ..add(GetUserProfileEvent()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is GetProfileDetailsState) {
            AppUtils.setUserName(state.userProfile.user[0].firstName);
            getUserName();
            print(userName);
          }
          // TODO: implement listener
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Color(0xffFAFAFA),
              key: scaffoldKey,

              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                backgroundColor: AppColors.primaryColors,
                elevation: 0,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return mainCreateWidget();
                    },
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12.0)),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
              appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: AppColors.primaryColors,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: const Text(
                    'Autopilot',
                    style: TextStyle(color: Colors.black87),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) {
                          //     return AddCompanyScreen();
                          //   },
                          // ));
                        },
                        icon: SvgPicture.asset(
                          "assets/images/message.svg",
                          color: AppColors.primaryColors,
                        )),
                    IconButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => const NotificationScreen(),
                          //   ),
                          // );
                        },
                        icon: SvgPicture.asset(
                          "assets/images/notification.svg",
                          color: AppColors.primaryColors,
                        ))
                  ],
                  bottom: currentIndex == 3
                      ? PreferredSize(
                          preferredSize:
                              Size(MediaQuery.of(context).size.width, 80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  "Estimates",
                                  style: TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              TabBar(
                                controller: estimateTabController,
                                enableFeedback: false,
                                labelPadding: EdgeInsets.all(0),
                                indicatorColor: AppColors.primaryColors,
                                unselectedLabelColor: const Color(0xFF9A9A9A),
                                labelColor: AppColors.primaryColors,
                                tabs: const [
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Recent',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Estimates',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Orders',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Invoices',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : currentIndex == 1
                          ? PreferredSize(
                              preferredSize: const Size(double.infinity, 90),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      'Workflow',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  PreferredSize(
                                    preferredSize:
                                        const Size(double.infinity, 60),
                                    child: TabBar(
                                      controller: workFlowTabController,
                                      enableFeedback: false,
                                      indicatorColor: AppColors.primaryColors,
                                      unselectedLabelColor:
                                          const Color(0xFF9A9A9A),
                                      labelColor: AppColors.primaryColors,
                                      tabs: const [
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              'Orders',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              'Vehicle',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null),

              drawer: showDrawer(context),
              bottomNavigationBar: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                elevation: 100,
                color: Colors.white,
                notchMargin: 8,
                child: SizedBox(
                  height: 68,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              changePage(0);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                      "assets/images/bottom_dashboard.svg",
                                      color: currentIndex == 0
                                          ? AppColors.primaryColors
                                          : const Color(0xff9A9A9A)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text("Dashboard",
                                      style: TextStyle(
                                          color: currentIndex == 0
                                              ? AppColors.primaryColors
                                              : const Color(0xff9A9A9A),
                                          fontWeight: currentIndex == 0
                                              ? FontWeight.w600
                                              : FontWeight.w400)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              changePage(1);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                      "assets/images/workflow_icon.svg",
                                      color: currentIndex == 1
                                          ? AppColors.primaryColors
                                          : const Color(0xff9A9A9A)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text("Workflow",
                                      style: TextStyle(
                                          color: currentIndex == 1
                                              ? AppColors.primaryColors
                                              : const Color(0xff9A9A9A),
                                          fontWeight: currentIndex == 1
                                              ? FontWeight.w600
                                              : FontWeight.w400)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              changePage(2);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                      "assets/images/calender_icon.svg",
                                      color: currentIndex == 2
                                          ? AppColors.primaryColors
                                          : const Color.fromARGB(
                                              255, 81, 51, 51)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text("Calendar",
                                      style: TextStyle(
                                          color: currentIndex == 2
                                              ? AppColors.primaryColors
                                              : const Color(0xff9A9A9A),
                                          fontWeight: currentIndex == 2
                                              ? FontWeight.w600
                                              : FontWeight.w400)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              changePage(3);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                    "assets/images/estimate_icon.svg",
                                    color: currentIndex == 3
                                        ? AppColors.primaryColors
                                        : Color(0xff9A9A9A),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    "Estimate",
                                    style: TextStyle(
                                        color: currentIndex == 3
                                            ? AppColors.primaryColors
                                            : Color(0xff9A9A9A),
                                        fontWeight: currentIndex == 3
                                            ? FontWeight.w600
                                            : FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // child: Row(
                //   children: [
                //     Column(

                //       children: [
                //         SvgPicture.asset("assets/images/dashboard_icon.svg"),
                //         Text("Dashboard")

                //       ],
                //     )
                //   ],
                // ),
              ),
              body: PageView.builder(
                itemBuilder: (context, index) {
                  return !network
                      ? NoInternetScreen(state: setState)
                      : pages[index];
                },
                itemCount: pages.length,
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
              ),

              // body: SafeArea(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       const Center(
              //         child: Text("Dashboard screen"),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(top:24.0),
              //         child: GestureDetector(
              //           onTap: (){
              //             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
              //               return const WelcomeScreen();
              //             },), (route) => false);
              //             AppUtils.setToken("");

              //           },
              //           child: Text("Signout",style: TextStyle(
              //             decoration: TextDecoration.underline,
              //             fontSize: 16
              //           ),),
              //         ),
              //       )
              //     ],
              //   ),
              //  ),
            );
          },
        ),
      ),
    );
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      pageController.jumpToPage(index);
    });
    networkCheck().then((value) {
      setState(() {});
    });
  }

  Widget mainCreateWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.6,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              bottomSheetTile(
                  "New Estimate",
                  "assets/images/estimate_icon.svg",
                  DummyScreen(
                    name: "Create estimate screen",
                  )),
              //   CreateEstimateScreen()),
              bottomSheetTile(
                  "New Customer",
                  "assets/images/customer_icon.svg",
                  DummyScreen(
                    name: "New Customer Screen",
                  )),
              bottomSheetTile(
                  "New Vehicle",
                  "assets/images/vehicle_icon.svg",
                  DummyScreen(
                    name: "Vehicle Screen",
                  )),
              bottomSheetTile(
                  "New Appointment",
                  "assets/images/appointment_icon.svg",
                  DummyScreen(
                    name: "New Appointment Screen",
                  )),
              bottomSheetTile(
                  "Scanner",
                  "assets/images/scanner_icon.svg",
                  DummyScreen(
                    name: "Scanner Screen",
                  )),
              // ScannerScreen()),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColors),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetTile(String title, String iconUrl, constructor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => constructor,
          ));
        },
        child: Container(
          alignment: Alignment.center,
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconUrl,
                color: AppColors.primaryColors,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColors),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getUserName() async {
    await AppUtils.getUserName().then((value) {
      setState(() {
        userName = value;
      });
    });
  }
}
