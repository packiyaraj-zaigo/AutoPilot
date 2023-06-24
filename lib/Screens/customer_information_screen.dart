import 'package:auto_pilot/Models/customer_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../api_provider/api_repository.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_utils.dart';

class CustomerInformationScreen extends StatefulWidget {
  CustomerInformationScreen({
    Key? key,
    required this.customerData,
  }) : super(key: key);
  final Datum customerData;

  @override
  State<CustomerInformationScreen> createState() =>
      _CustomerInformationScreenState();
}

class _CustomerInformationScreenState extends State<CustomerInformationScreen> {
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
      "assets/images/chat_icon.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/car_icon.svg",
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
  int? selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryBlackColors,
            size: AppStrings.fontSize16,
          ),
        ),
        title: Text(
          'Customer Information',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: AppStrings.fontSize16,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.more_horiz,
                size: AppStrings.fontSize20,
                color: AppColors.primaryBlackColors,
              )),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => CustomerBloc()..add(customerDetails(query: '')),
        child: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerError) {
            } else if (state is CustomerLoading) {}
          },
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is CustomerReady) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mike Stevenson',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CupertinoSlidingSegmentedControl(
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
                                  vertical: 12, horizontal: 25),
                              child: _segmentTitles[i],
                            )
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      selectedIndex == 0
                          ? Expanded(
                              child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  color: const Color(0xffF9F9F9),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24, right: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Phone",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .primaryGrayColors),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${widget.customerData.phone.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .primaryTitleColor),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/images/sms.svg"),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Icon(CupertinoIcons.phone),
                                              ],
                                            )
                                          ],
                                        ),
                                        AppUtils.verticalDivider(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Email",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColors
                                                          .primaryGrayColors),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${widget.customerData.email.toString()}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors
                                                          .primaryTitleColor),
                                                ),
                                              ],
                                            ),
                                            Icon(CupertinoIcons.mail)
                                          ],
                                        ),
                                        AppUtils.verticalDivider(),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          "Address",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${widget.customerData.addressLine1.toString()}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        AppUtils.verticalDivider(),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          "License Number",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Need to change",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        AppUtils.verticalDivider(),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          "Customer Created",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${widget.customerData.createdAt.toString()}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        AppUtils.verticalDivider(),
                                        SizedBox(
                                          height: 14,
                                        ),
                                        Text(
                                          "Address",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "${widget.customerData.addressLine1.toString()}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        AppUtils.verticalDivider(),
                                      ],
                                    ),
                                  )),
                            )
                          : Container(),
                      selectedIndex == 1
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor:
                                            AppColors.buttonColors),
                                    onPressed: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline_rounded,
                                          color: AppColors.primaryColors,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Add New Note',
                                          style: AppUtils.cardStyle(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   itemCount: widget.customerData.clientId
                                //       .toString()
                                //       .length,
                                //   itemBuilder:
                                //       (BuildContext context, int index) {
                                //     return
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 18,
                                        top: 2,
                                        bottom: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${widget.customerData.createdAt}',
                                            style: AppUtils.requiredStyle(),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${widget.customerData.notes}',
                                            style: AppUtils.summaryStyle(),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //   );
                                  // },
                                )
                              ],
                            )
                          : Container(),
                      selectedIndex == 2
                          ? Center(
                              child: Text('Coming Soon'),
                            )
                          : Container(),
                      selectedIndex == 3
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              width: double.infinity,
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 18,
                                    top: 2,
                                    bottom: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.customerData.createdAt}',
                                        style: AppUtils.requiredStyle(),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${widget.customerData.notes}',
                                        style: AppUtils.summaryStyle(),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //   );
                              // },
                            )
                          : Container(),
                      selectedIndex == 4
                          ? Center(
                              child: Text('Coming Soon'),
                            )
                          : Container()
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
