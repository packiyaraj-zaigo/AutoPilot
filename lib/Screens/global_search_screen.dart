// ignore_for_file: deprecated_member_use

import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryColors,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTitleColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search by keyword',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6A7187),
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: SizedBox(
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        counterText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xffC1C4CD),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: ListView(
                  children: [
                    const Text(
                      'Users',
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: List.generate(
                        3,
                        (index) => userCard(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Vehicles',
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: List.generate(
                        3,
                        (index) => vehicleCard(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Order',
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: List.generate(
                        3,
                        (index) => estimateCard(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column userCard() {
    return Column(
      children: [
        Container(
          height: 77,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(),
                    Text(
                      "Tessa Woilliams",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF061237),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '2020 Tesla Model 3',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF6A7187),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/sms.svg',
                      color: AppColors.primaryColors,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/images/phone_icon.svg',
                      color: AppColors.primaryColors,
                    ))
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Column vehicleCard() {
    return Column(
      children: [
        Container(
          height: 77,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(),
                Text(
                  "2020 Tesla Model 3",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF061237),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Fernando Arbulu',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF6A7187),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget estimateCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
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
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                  const Text(
                    " 3/7/23 9:00 Am - ",
                    style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                  const Text(
                    " 3/7/23 9:00 Am",
                    style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Estimate #1847 - Satin Black Wrap",
                  style: TextStyle(
                      color: AppColors.primaryColors,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "James Smith",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "2022 Tesla Model Y",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
