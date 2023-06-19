import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/app_utils.dart';

class VechileInformation extends StatefulWidget {
  const VechileInformation({Key? key}) : super(key: key);

  @override
  State<VechileInformation> createState() => _VechileInformationState();
}

class _VechileInformationState extends State<VechileInformation> {
  final List _segmentTitles = [
    SvgPicture.asset(
      "assets/images/info.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/note.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/dollar.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppColors.primaryTitleColor,
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Vehicles Information",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlackColors),
        ),
        actions: [
          Icon(
            Icons.more_horiz,
            color: AppColors.primaryTitleColor,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "2020 Tesla Model 3",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.primaryTitleColor),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 0, left: 10, right: 10),
              child: Center(
                child: CupertinoSlidingSegmentedControl(
                  onValueChanged: (value) {
                    setState(() {
                      selectedIndex = value ?? 0;
                    });
                  },
                  groupValue: selectedIndex,
                  children: {
                    for (int i = 0; i < _segmentTitles.length; i++)
                      i: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 42),
                        child: _segmentTitles[i],
                      )
                  },
                ),
              ),
            ),
            Expanded(
              child: selectedIndex == 2
                  ? Column(
                      children: [Text("dateeeeeeeeeeeeeeeea")],
                    )
                  : selectedIndex == 1
                      ? Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Container(
                              color: CupertinoColors.white,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print("object");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: AppColors.buttonColors,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: AppColors.primaryColors,
                                          ),
                                          const Text(
                                            'Add New Note',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColors,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 32),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                7), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          '10/10/2023 - 3:34 PM',
                                          style: TextStyle(
                                              color: AppColors.greyText,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(
                                          'This is a note entry for the vehicle, it can be multiple lines tall. ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        // trailing: Icon(Icons.add),),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        )
                      : selectedIndex == 0
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              color: const Color(0xffF9F9F9),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Owner",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "Mike Stevenson",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Sub-Model",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "Plaid",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "Engine",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "N\A",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "Color",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "Blue",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "VIN",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "WPOAF746JAKB936352",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "LIC",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "4A63573",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    Text(
                                      "Type",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryGrayColors),
                                    ),
                                    Text(
                                      "Sedam",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    AppUtils.verticalDivider(),
                                  ],
                                ),
                              ))
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [Text("data")],
                                      );
                                    },
                                    // itemCount: equipmentFormList.length,
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics: const ClampingScrollPhysics(),
                                  ),
                                ],
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
