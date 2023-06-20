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
  const CustomerInformationScreen({Key? key}) : super(key: key);

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
        create: (context) => CustomerBloc(apiRepository: ApiRepository())
          ..add(customerDetails()),
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
                      selectedIndex == 0
                          ? Expanded(
                              child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  color: const Color(0xffF9F9F9),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24, top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Phone",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        Text(
                                          "${state.data.data.data[0].phone}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        AppUtils.verticalDivider(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.primaryGrayColors),
                                        ),
                                        Text(
                                          "Plaid",
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
                                        Text(
                                          "N\A",
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
                                        Text(
                                          "435435",
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
                                        Text(
                                          "WPOAF746JAKB936352",
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
                                        Text(
                                          "Sedam",
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
