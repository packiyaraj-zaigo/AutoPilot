import 'package:auto_pilot/Screens/calendar_screen.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/Screens/estimate_screen.dart';
import 'package:auto_pilot/Screens/work_flow_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class BottomBarScreen extends StatefulWidget {
  BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  PageController pageController = PageController();

  int currentIndex = 0;

  List pages = [
    DashBoardScreen(),
    WorkFlowScreen(),
    CalendarScreen(),
    EstimateScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColors,
        elevation: 0,
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) {

            return mainCreateWidget();
          },
          isScrollControlled: true,
           shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
        ),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
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
                                  : Color(0xff9A9A9A)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text("Dashboard",
                              style: TextStyle(
                                  color: currentIndex == 0
                                      ? AppColors.primaryColors
                                      : Color(0xff9A9A9A),
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
                                  : Color(0xff9A9A9A)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text("Workflow",
                              style: TextStyle(
                                  color: currentIndex == 1
                                      ? AppColors.primaryColors
                                      : Color(0xff9A9A9A),
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
                                  : Color(0xff9A9A9A)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text("Calendar",
                              style: TextStyle(
                                  color: currentIndex == 2
                                      ? AppColors.primaryColors
                                      : Color(0xff9A9A9A),
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
          return pages[index];
        },
        itemCount: pages.length,
        controller: pageController,
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
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      pageController.jumpToPage(index);
    });
  }



  Widget mainCreateWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/1.6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            bottomSheetTile("New Estimate","assets/images/estimate_icon.svg"),
             bottomSheetTile("New Customer","assets/images/customer_icon.svg"),
             bottomSheetTile("New Vehicle","assets/images/vehicle_icon.svg"),
             bottomSheetTile("New Appointment","assets/images/appointment_icon.svg"),
             bottomSheetTile("Scanner","assets/images/scanner_icon.svg"),
             Padding(
               padding: const EdgeInsets.only(top:16.0),
               child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigator.pop(context);
                },
                 child: Container(
                       alignment: Alignment.center,
                       height: 56,
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                       
                         borderRadius: BorderRadius.circular(12)
                   
                       ),
                       child: const Text("Cancel",style:  TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w500,
                         color: AppColors.primaryColors
                         
                       ),),
                   
                     ),
               ),
             ),

      
          ],
        ),
      ),
   


     
    );
  }


  Widget bottomSheetTile(String title,String iconUrl){
    return Padding(
      padding: const EdgeInsets.only(top:16.0),
      child: Container(
        alignment: Alignment.center,
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: AppColors.primaryColors,
          borderRadius: BorderRadius.circular(12)
    
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconUrl,color: Colors.white,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text(title,style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white
                
              ),),
            ),
          ],
        ),
    
      ),
    );
  }
}
