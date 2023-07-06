import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_pilot/Models/service_model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ServiceInfoScreen extends StatefulWidget {
  const ServiceInfoScreen({super.key, required this.serviceData});
  final Datum serviceData;

  @override
  State<ServiceInfoScreen> createState() => _ServiceInfoScreenState();
}

class _ServiceInfoScreenState extends State<ServiceInfoScreen> {
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryTitleColor,
        title: const Text(
          "Service Information",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
          padding: const EdgeInsets.only(top: 8.0, right: 24, left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.serviceData.serviceName,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
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
                              vertical: 10, horizontal: 42),
                          child: _segmentTitles[i],
                        )
                    },
                  ),
                ),
              ),
              selectedIndex == 0 ? serviceInfoWidget() : serviceNoteWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceInfoWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          detailTileWidget("Service Id", widget.serviceData.id.toString()),
          detailTileWidget(
              "EPA", "${widget.serviceData.serviceEpa.toString()}%"),
          detailTileWidget("Tax", "${widget.serviceData.tax.toString()}%"),
          detailTileWidget(
              "Supplies", "${widget.serviceData.shopSupplies.toString()}%"),
          detailTileWidget(
              "Sub Total", "\$${widget.serviceData.serviceEpa.toString()}")
        ],
      ),
    );
  }

  Widget serviceNoteWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            height: 56,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xffF6F6F6),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primaryColors,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Add New Note",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColors),
                  ),
                )
              ],
            ),
          ),
          widget.serviceData.serviceNote.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: noteTile(widget.serviceData.serviceNote),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget detailTileWidget(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTitleColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              height: 0.5,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xffE8EAED),
            ),
          )
        ],
      ),
    );
  }

  Widget noteTile(String notes) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  offset: Offset(2, 3),
                  spreadRadius: 0.8,
                  blurRadius: 0.8,
                  color: Color.fromARGB(22, 106, 113, 135))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            notes,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryTitleColor,
                height: 1.5),
          ),
        ),
      ),
    );
  }
}
