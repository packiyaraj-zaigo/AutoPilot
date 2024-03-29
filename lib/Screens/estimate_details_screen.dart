import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EstimateDetailsScreen extends StatefulWidget {
  const EstimateDetailsScreen({super.key, required this.estimateDetails});
  final CreateEstimateModel estimateDetails;

  @override
  State<EstimateDetailsScreen> createState() => _EstimateDetailsScreenState();
}

class _EstimateDetailsScreenState extends State<EstimateDetailsScreen> {
  bool isEstimateNotes = false;
  bool isAppointment = false;
  bool isInspectionPhotos = false;
  bool isService = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryColors,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                Text(
                  "Save & Close",
                  style: TextStyle(
                      color: AppColors.primaryColors,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.close,
                  color: AppColors.primaryColors,
                )
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estimate Details',
                style: TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Confirm the details before submitting',
                  style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 14,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Estimate #1234',
                  style: TextStyle(
                      color: AppColors.primaryTitleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    subTitleWidget("Customer Details"),
                    const Icon(
                      Icons.more_horiz,
                      color: AppColors.primaryColors,
                    )
                  ],
                ),
              ),
              customerDetailsWidget(),
              vehicleDetailsWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    subTitleWidget("Estimate Notes"),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: GestureDetector(
                          onTap: () {
                            showEstimateNotes("estimate");
                          },
                          child: Icon(
                            isEstimateNotes
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            size: 32,
                          )),
                    )
                  ],
                ),
              ),
              isEstimateNotes ? estimateNoteWidget() : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    subTitleWidget("Appointment"),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: GestureDetector(
                          onTap: () {
                            showEstimateNotes("appointment");
                          },
                          child: Icon(
                            isAppointment
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            size: 32,
                          )),
                    )
                  ],
                ),
              ),
              isAppointment ? appointmentDetailsWidget() : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    subTitleWidget("Inspection Photos"),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: GestureDetector(
                          onTap: () {
                            showEstimateNotes("inspection");
                          },
                          child: Icon(
                            isInspectionPhotos
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            size: 32,
                          )),
                    ),
                  ],
                ),
              ),
              isInspectionPhotos ? inspectionWidget() : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    subTitleWidget("Services"),
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: GestureDetector(
                          onTap: () {
                            showEstimateNotes("service");
                          },
                          child: Icon(
                            isService
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            size: 32,
                          )),
                    ),
                  ],
                ),
              ),
              isService ? serviceDetailsWidget() : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: taxDetailsWidget("Material", "\$399"),
              ),
              taxDetailsWidget("Labor", "\$399"),
              taxDetailsWidget("Tax", "\$399"),
              taxDetailsWidget("Discount", "\$399"),
              taxDetailsWidget("Total", "\$399"),
              taxDetailsWidget("Balace due", "\$399"),
              Padding(
                padding: const EdgeInsets.only(top: 45.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: const Text(
                      "Send to customer",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColors,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColors),
                    child: const Text(
                      "Collect payment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget subTitleWidget(String subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTitleColor),
    );
  }

  Widget customerDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/images/estimate_customer_icon.svg"),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Customer",
                  style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Anthony Miller",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Anthonymiller@gmail.com",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.w400),
                ),
                SvgPicture.asset(
                  "assets/images/mail_icons.svg",
                  color: AppColors.primaryColors,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "(786) 000-0000",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/sms_icons.svg",
                      color: AppColors.primaryColors,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 34.0),
                      child: SvgPicture.asset(
                        "assets/images/phone_icon.svg",
                        color: AppColors.primaryColors,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget vehicleDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/images/estimate_vehicle_icon.svg"),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Vehicle",
                  style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "McLaren 765LT, 2022",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "1,387mi",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget estimateNoteWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 0.6,
                  spreadRadius: 0.7,
                  offset: Offset(3, 2))
            ]),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "10/10/2023 - 3:34 PM",
                    style: TextStyle(
                        color: Color(0xff6A7187),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: AppColors.primaryColors,
                  )
                ],
              ),
              Text(
                "John Doe",
                style: TextStyle(
                    color: Color(0xff6A7187),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                "This is a note entry for the vehicle, it can be multiple lines tall.",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showEstimateNotes(String whichValue) {
    setState(() {
      if (whichValue == 'estimate') {
        if (isEstimateNotes) {
          isEstimateNotes = false;
        } else {
          isEstimateNotes = true;
        }
      } else if (whichValue == 'appointment') {
        if (isAppointment) {
          isAppointment = false;
        } else {
          isAppointment = true;
        }
      } else if (whichValue == "inspection") {
        if (isInspectionPhotos) {
          isInspectionPhotos = false;
        } else {
          isInspectionPhotos = true;
        }
      } else if (whichValue == 'service') {
        if (isService) {
          isService = false;
        } else {
          isService = true;
        }
      }
    });
  }

  Widget appointmentDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appointmentLabelwithValue("Start date", "03/12/23"),
              appointmentLabelwithValue("Completion date", "08/12/23")
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appointmentLabelwithValue("Start time", "08:00 Am"),
                appointmentLabelwithValue("End time", "12:00 Pm")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: appointmentLabelwithValue("Date", "10/10/23"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: appointmentLabelwithValue("Appointment note",
                "Customers girlfriend will drop the car off."),
          ),
        ],
      ),
    );
  }

  Widget appointmentLabelwithValue(String label, String value) {
    return SizedBox(
      width: label == "Appointment note"
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2.3,
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
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTitleColor),
            ),
          )
        ],
      ),
    );
  }

  Widget inspectionSinglePhotoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 4.8,
      height: 75,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE8EAED)),
          borderRadius: BorderRadius.circular(8)),
      child: const Icon(
        Icons.add,
        color: AppColors.primaryColors,
      ),
    );
  }

  Widget inspectionWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          inspectionSinglePhotoWidget(),
          inspectionSinglePhotoWidget(),
          inspectionSinglePhotoWidget(),
          inspectionSinglePhotoWidget(),
        ],
      ),
    );
  }

  Widget serviceDetailsWidget() {
    return Column(
      children: [serviceTileWidget()],
    );
  }

  Widget serviceTileWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 0.6,
                  spreadRadius: 0.7,
                  offset: Offset(3, 2))
            ]),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Downpie updgrade",
                    style: TextStyle(
                        color: AppColors.primaryTitleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  Icon(
                    Icons.more_horiz,
                    color: AppColors.primaryColors,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blue Wrap 1.00",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("\$599.00",
                        style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blue Wrap 1.00",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("\$599.00",
                        style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blue Wrap 1.00",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Text("\$599.00",
                        style: TextStyle(
                            color: AppColors.primaryTitleColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget taxDetailsWidget(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "\$ $price",
            style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
