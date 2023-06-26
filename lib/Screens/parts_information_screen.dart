import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/parts_model.dart';
import '../Models/vechile_model.dart';
import '../utils/app_utils.dart';

class PartsInformation extends StatefulWidget {
  PartsInformation({
    Key? key,
    required this.parts,
  }) : super(key: key);
  final PartsDatum parts;
  @override
  State<PartsInformation> createState() => _PartsInformationState();
}

class _PartsInformationState extends State<PartsInformation> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

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
          color: AppColors.primaryColors,
          icon: Icon(Icons.arrow_back),
        ),
        title: Center(
          child: Text(
            "Parts Information",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlackColors),
          ),
        ),
        actions: [
          Icon(
            Icons.more_horiz,
            color: AppColors.primaryColors,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.parts.itemName}",
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
                            vertical: 10, horizontal: 65),
                        child: _segmentTitles[i],
                      )
                  },
                ),
              ),
            ),
            Expanded(
              child: selectedIndex == 1
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                        offset: Offset(
                                            0, 7), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      '${widget.parts.createdAt}',
                                      style: TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      '${widget.parts.itemServiceNote}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: AppColors.primaryTitleColor),
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
                            padding: const EdgeInsets.only(left: 24, top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Serial Number",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryGrayColors),
                                ),
                                Text(
                                  "${widget.parts.partName}",
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
                                  "Type",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryGrayColors),
                                ),
                                Text(
                                  "${widget.parts.itemName ?? ""}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryTitleColor),
                                ),
                                AppUtils.verticalDivider(),
                                SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        Text(
                                          '$_counter',
                                          style: TextStyle(fontSize: 24.0),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        alignment: Alignment.topCenter,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: _decrementCounter,
                                              child: SvgPicture.asset(
                                                "assets/images/parts_minns.svg",
                                                color: AppColors.primaryColors,
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            InkWell(
                                              onTap: _incrementCounter,
                                              child: SvgPicture.asset(
                                                "assets/images/parts_add.svg",
                                                color: AppColors.primaryColors,
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                AppUtils.verticalDivider(),
                                SizedBox(
                                  height: 14,
                                ),
                                Text(
                                  "Fee",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryGrayColors),
                                ),
                                Text(
                                  "${widget.parts.subTotal ?? ""}",
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
                                  "Cost",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primaryGrayColors),
                                ),
                                Text(
                                  "${widget.parts.taxRate ?? ""}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryTitleColor),
                                ),
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
