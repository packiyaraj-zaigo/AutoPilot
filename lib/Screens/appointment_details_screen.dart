import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primaryColors,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Appointment",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTitleColor),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_horiz,
                color: AppColors.primaryColors,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Date and status row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appointmentTileWidget("Date", "12/02/2023",
                      MediaQuery.of(context).size.width / 2.8),
                  appointmentTileWidget("Status", "In Progress",
                      MediaQuery.of(context).size.width / 2.8)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dividerLine(MediaQuery.of(context).size.width / 2.8),
                    dividerLine(MediaQuery.of(context).size.width / 2.8)
                  ],
                ),
              ),

              //Start and End time row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appointmentTileWidget("Start Time", "9:00 AM",
                      MediaQuery.of(context).size.width / 2.8),
                  appointmentTileWidget("End Time", "3:00 PM",
                      MediaQuery.of(context).size.width / 2.8)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dividerLine(MediaQuery.of(context).size.width / 2.8),
                    dividerLine(MediaQuery.of(context).size.width / 2.8)
                  ],
                ),
              ),

              //Customer name tile
              appointmentTileWidget("Customer Name", "Vivek K",
                  MediaQuery.of(context).size.width),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: dividerLine(MediaQuery.of(context).size.width),
              ),

              //Estimate tile
              appointmentTileWidget(
                  "Estimate", "#1001", MediaQuery.of(context).size.width),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: dividerLine(MediaQuery.of(context).size.width),
              ),

              //Vehicle tile
              appointmentTileWidget("Vehicle", "2022 Tesla Model S",
                  MediaQuery.of(context).size.width),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: dividerLine(MediaQuery.of(context).size.width),
              ),

              // Notes Tile
              appointmentTileWidget(
                  "Notes",
                  "Mike is a referral customer from the government, please take good care of him.",
                  MediaQuery.of(context).size.width),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: dividerLine(MediaQuery.of(context).size.width),
              ),

              const Padding(
                padding: EdgeInsets.only(top: 64.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "\$ 1449",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryColors),
                  child: const Text(
                    "Go to Estimate",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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

  Widget appointmentTileWidget(String title, String value, boxWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: SizedBox(
        width: boxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTitleColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dividerLine(double linewidth) {
    return Container(
      height: 1,
      width: linewidth,
      color: const Color(0xffE8EAED),
    );
  }
}
