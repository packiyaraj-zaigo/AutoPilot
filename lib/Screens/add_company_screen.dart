import 'dart:developer';

import 'package:auto_pilot/Screens/add_company_details.dart';
import 'package:auto_pilot/Screens/add_company_review_screen.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCompanyScreen extends StatefulWidget {
  const AddCompanyScreen({
    super.key,
  });

  @override
  State<AddCompanyScreen> createState() => _AddCompanyScreenState();
}

class _AddCompanyScreenState extends State<AddCompanyScreen> {
  List<dynamic> navigationData = [];
  Map<String, dynamic>? basicDetailsMap = {};
  Map<String, dynamic>? operationDetailsMap = {};
  Map<String, dynamic>? employeeDetailsMap = {};
  // bool? isEmployee = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: const SizedBox(),
        //  actions: [Padding(
        //    padding: const EdgeInsets.only(right:8.0),
        //    child: GestureDetector(
        //     onTap: (){

        //      // AppUtils.setTempVar("");
        //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
        //         return BottomBarScreen();
        //       },), (route) => false);
        //     },
        //      child: Row(

        //       children: [
        //           Container(
        //             alignment: Alignment.center,
        //           height: 24,
        //           width: 47,
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(6),
        //             border: Border.all(
        //               color: AppColors.primaryColors,
        //               width: 1.3
        //             )
        //           ),
        //           child: Text("Skip"),
        //         )
        //       ],
        //      ),
        //    ),
        //  )],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GestureDetector(
          onTap: () {
            //  AppUtils.setTempVar("");
            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
            //   return BottomBarScreen();
            // },), (route) => false);

            if (basicDetailsMap != null &&
                basicDetailsMap!.isNotEmpty &&
                operationDetailsMap != null &&
                operationDetailsMap!.isNotEmpty &&
                employeeDetailsMap != null &&
                employeeDetailsMap!.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AddCompanyReviewScreen(
                    basicDetailsMap: basicDetailsMap!,
                    operationDetailsMap: operationDetailsMap!,
                    employeeDetailsMap: employeeDetailsMap!,
                  );
                },
              ));
            }
          },
          child: Container(
            height: 56,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: basicDetailsMap != null &&
                      basicDetailsMap!.isNotEmpty &&
                      operationDetailsMap != null &&
                      operationDetailsMap!.isNotEmpty &&
                      employeeDetailsMap != null &&
                      employeeDetailsMap!.isNotEmpty
                  ? AppColors.primaryColors
                  : Color.fromARGB(255, 136, 169, 250),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Your Company",
              style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                "This is required to fully take advantage of Autopilot's features. It shouldn’t take long!",
                style: TextStyle(
                    color: Color(0xff6A7187),
                    fontSize: 14,
                    height: 1.4,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 52.0),
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return AddCompanyDetailsScreen(
                          widgetIndex: 0,
                          basicDetailsMap: basicDetailsMap,
                        );
                      },
                    )).then((value) {
                      setState(() {
                        // isBasicDetails=value;
                        // navigationData=value;
                        basicDetailsMap = value;
                        print(value);
                      });
                    });
                  },
                  child: stepTile(
                      "Step 1. Basic Details",
                      basicDetailsMap != null && basicDetailsMap!.isNotEmpty
                          ? true
                          : false)),
            ),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return AddCompanyDetailsScreen(
                        widgetIndex: 1,
                        operationDetailsMap: operationDetailsMap,
                      );
                    },
                  )).then((value) {
                    setState(() {
                      operationDetailsMap = value;
                    });
                  });
                },
                child: stepTile(
                    "Step 2. Operating Details",
                    operationDetailsMap != null &&
                            operationDetailsMap!.isNotEmpty
                        ? true
                        : false)),
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const AddCompanyDetailsScreen(
                        widgetIndex: 2,
                      );
                    },
                  )).then((value) {
                    setState(() {
                      employeeDetailsMap = value;
                      log(employeeDetailsMap.toString());
                    });
                  });
                },
                child: stepTile(
                    "Step 3. Employees",
                    employeeDetailsMap != null && employeeDetailsMap!.isNotEmpty
                        ? true
                        : false))
          ],
        ),
      ),
    );
  }

  Widget stepTile(String title, bool? isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 62,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffC1C4CD),
            ),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor),
              ),
              isCompleted != null && isCompleted
                  ? const Icon(
                      Icons.check_circle,
                      color: Color(0xff12A58C),
                    )
                  : SvgPicture.asset("assets/images/check_disable_icon.svg")
            ],
          ),
        ),
      ),
    );
  }
}
