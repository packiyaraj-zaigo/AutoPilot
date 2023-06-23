import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EstimateScreen extends StatefulWidget {
  const EstimateScreen({super.key,required this.tabController});
  final TabController tabController;

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    //     TabController tabController = TabController(length: 4, vsync: this);
    // AppUtils().estimateTabController=tabController;
    // TODO: implement initState
    super.initState();
  }


  
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      // appBar: AppBar(
      //   leading: GestureDetector(
      //     child: Icon(Icons.menu)),
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   foregroundColor:AppColors.primaryColors ,
      //   title: const Text("AutoPilot",
      //   style: TextStyle(
      //     color: Color(0xff061237),
      //     fontSize: 16,
      //     fontWeight: FontWeight.w600
      //   ),),
      //   centerTitle: true,
      //   actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: AppColors.primaryColors,))],
      //   bottom:PreferredSize(
      //     preferredSize: const Size(double.infinity, 80),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //          const Padding(
      //            padding:  EdgeInsets.symmetric(horizontal:16.0),
      //            child: Text("Estimates",style: TextStyle(
      //                 color: AppColors.primaryTitleColor,
      //                 fontSize: 28,
      //                 fontWeight: FontWeight.w500
      //               ),),
      //          ),
      //         TabBar(
      //           controller: tabController,
      //           enableFeedback: false,
      //           indicatorColor: AppColors.primaryColors,
                
               

      //           unselectedLabelColor: const Color(0xFF9A9A9A),
      //           labelColor: AppColors.primaryColors,
      //           tabs: const [
      //             SizedBox(
      //               height: 50,
      //               child: Center(
      //               child: Text(
      //                 'Recent',
      //                 style: TextStyle(fontWeight: FontWeight.w500),
      //               ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 50,
      //               child: Center(
      //               child: Text(
      //                 'Estimates',
      //                 style: TextStyle(fontWeight: FontWeight.w500),
      //               ),
      //               ),
      //             ),
      //             SizedBox(
      //               height: 50,
      //               child: Center(
      //               child: Text(
      //                 'Orders',
      //                 style: TextStyle(fontWeight: FontWeight.w500),
      //               ),
      //               ),
      //             ),

      //                SizedBox(
      //               height: 50,
      //               child: Center(
      //               child: Text(
      //                 'Invoices',
      //                 style: TextStyle(fontWeight: FontWeight.w500),
      //               ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ) ,
      // ),
    //  drawer: showDrawer(context),
      body:  TabBarView(
        controller: widget.tabController,
        children: [
          recentTabWidget(),
          recentTabWidget(),
          recentTabWidget(),
          recentTabWidget()
        ])
    );
  }



  Widget recentTabWidget(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(itemBuilder:(context, index) {
        return tileWidget();
      },
      itemCount: 10,
      
       ),
    );
  }


  Widget tileWidget(){
    return Padding(
      padding: const EdgeInsets.only(bottom:12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
     
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const [
            
      BoxShadow(
          offset: Offset(0, 1),
          spreadRadius: 1,
          blurRadius: 6,
          color: Color.fromRGBO(88, 88, 88, 0.178),
      )
      
          ]
         
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                  const Text(" 3/7/23 9:00 Am - ",style: TextStyle(
                    color:AppColors.greyText,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),),
        
                    SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                  const Text(" 3/7/23 9:00 Am",style: TextStyle(
                    color:AppColors.greyText,
                    fontSize: 12,
                    fontWeight: FontWeight.w400
                  ),)
                ],
              ),
              const Padding(
                padding:  EdgeInsets.only(top:8.0),
                child: Text("Estimate #1847 - Satin Black Wrap",style: TextStyle(
                  color: AppColors.primaryColors,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),),
              ),
                 const Padding(
                padding:  EdgeInsets.only(top:8.0),
                child: Text("James Smith",style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),),
              ),
                 const Padding(
                padding:  EdgeInsets.only(top:8.0),
                child: Text("2022 Tesla Model Y",style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),),
              )
            ],
        
          ),
        ),
    
    
      ),
    );
  }
}