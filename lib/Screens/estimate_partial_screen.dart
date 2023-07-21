import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/customer_select_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:auto_pilot/Screens/vehicle_select_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class EstimatePartialScreen extends StatefulWidget {
  const EstimatePartialScreen({super.key, required this.estimateDetails});
  final CreateEstimateModel estimateDetails;

  @override
  State<EstimatePartialScreen> createState() => _EstimatePartialScreenState();
}

class _EstimatePartialScreenState extends State<EstimatePartialScreen> {
  bool isEstimateNotes = false;
  bool isAppointment = false;
  bool isInspectionPhotos = false;
  bool isService = false;

  //Text Editing Controllers
  final vehicleController = TextEditingController();
  final customerController = TextEditingController();
  final estimateNoteController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final appointmentController = TextEditingController();
  final dateController = TextEditingController();
  final serviceController = TextEditingController();

  //Text Field Error Status Variables
  bool vehicleErrorStatus = false;
  bool customerErrorStatus = false;
  bool estimateNoteErrorStatus = false;
  bool startTimeErrorStatus = false;
  bool endTimeErrorStatus = false;
  bool appointmentErrorStatus = false;
  bool dateErrorStatus = false;
  bool serviceErrorStatus = false;

  //Text Field Error Message Variables
  String vehicleErrorMsg = "";
  String customerErrorMsg = '';
  String estimateNoteErrorMsg = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository()),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is AddEstimateNoteState) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return BottomBarScreen();
              },
            ), (route) => false);
          } else if (state is CreateAppointmentEstimateState) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return BottomBarScreen();
              },
            ), (route) => false);
          }
          // TODO: implement listener
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: AppColors.primaryColors,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        if (estimateNoteController.text.isNotEmpty) {
                          context.read<EstimateBloc>().add(AddEstimateNoteEvent(
                              orderId:
                                  widget.estimateDetails.data.id.toString(),
                              comment: estimateNoteController.text));
                        }
                        if (startTimeController.text.isNotEmpty &&
                            endTimeController.text.isNotEmpty &&
                            dateController.text.isNotEmpty &&
                            appointmentController.text.isNotEmpty) {
                          context.read<EstimateBloc>().add(
                              CreateAppointmentEstimateEvent(
                                  startTime: dateController.text +
                                      startTimeController.text,
                                  endTime: dateController.text +
                                      endTimeController.text,
                                  orderId:
                                      widget.estimateDetails.data.id.toString(),
                                  appointmentNote: appointmentController.text,
                                  customerId: widget
                                      .estimateDetails.data.customerId
                                      .toString(),
                                  vehicleId: "22"));
                        }
                      },
                      child: const Row(
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
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
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
                          'Follow the step to create an estimate.',
                          style: TextStyle(
                              color: AppColors.greyText,
                              fontSize: 14,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Estimate #${widget.estimateDetails.data.id}',
                          style: const TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      widget.estimateDetails.data.customer != null
                          ? Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  subTitleWidget("Customer Details"),
                                  const Icon(
                                    Icons.more_horiz,
                                    color: AppColors.primaryColors,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      widget.estimateDetails.data.customer != null
                          ? customerDetailsWidget()
                          : textBox("Select Existing", customerController,
                              "Customer", customerErrorStatus),
                      widget.estimateDetails.data.vehicle != null
                          ? vehicleDetailsWidget()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: textBox(
                                  "Select Exsisting",
                                  vehicleController,
                                  "Vehicle",
                                  vehicleErrorStatus),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: subTitleWidget("Estimate Notes"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox("Enter Note", estimateNoteController,
                            "Note", estimateNoteErrorStatus),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   child: Row(
                      //     children: [
                      //       subTitleWidget("Estimate Notes"),
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 6.0),
                      //         child: GestureDetector(
                      //             onTap: () {
                      //               showEstimateNotes("estimate");
                      //             },
                      //             child: Icon(
                      //               isEstimateNotes
                      //                   ? Icons.keyboard_arrow_down_rounded
                      //                   : Icons.keyboard_arrow_up_rounded,
                      //               size: 32,
                      //             )),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // isEstimateNotes ? estimateNoteWidget() : const SizedBox(),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 20.0),
                      //   child: Row(
                      //     children: [
                      //       subTitleWidget("Appointment"),
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 6.0),
                      //         child: GestureDetector(
                      //             onTap: () {
                      //               showEstimateNotes("appointment");
                      //             },
                      //             child: Icon(
                      //               isAppointment
                      //                   ? Icons.keyboard_arrow_down_rounded
                      //                   : Icons.keyboard_arrow_up_rounded,
                      //               size: 32,
                      //             )),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // isAppointment
                      //     ? appointmentDetailsWidget()
                      //     : const SizedBox(),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: subTitleWidget("Appointment"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            halfTextBox(
                                "Select Time",
                                startTimeController,
                                "Start time",
                                startTimeErrorStatus,
                                "start_time"),
                            halfTextBox("Select Time", endTimeController,
                                "End time", endTimeErrorStatus, "end_time")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox("Select Date", dateController, "Date",
                            dateErrorStatus),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox(
                            "Enter Appointment Note",
                            appointmentController,
                            "Appointment note",
                            appointmentErrorStatus),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: subTitleWidget("Inspection Photos"),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          "Upload photo",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6A7187)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  showActionSheet(context);
                                },
                                child: inspectionPhotoWidget()),
                            inspectionPhotoWidget(),
                            inspectionPhotoWidget(),
                            inspectionPhotoWidget()
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 16.0),
                      //   child: Row(
                      //     children: [
                      //       subTitleWidget("Services"),
                      //       Padding(
                      //         padding: const EdgeInsets.only(left: 6.0),
                      //         child: GestureDetector(
                      //             onTap: () {
                      //               showEstimateNotes("service");
                      //             },
                      //             child: Icon(
                      //               isService
                      //                   ? Icons.keyboard_arrow_down_rounded
                      //                   : Icons.keyboard_arrow_up_rounded,
                      //               size: 32,
                      //             )),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // isService ? serviceDetailsWidget() : const SizedBox(),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: subTitleWidget("Services"),
                      ),

                      //Service dropdown
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox("Select Existing", serviceController,
                            "Service", serviceErrorStatus),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: taxDetailsWidget("Material", "\$399"),
                      ),
                      taxDetailsWidget("Labor", "\$399"),
                      taxDetailsWidget("Tax", "\$399"),
                      taxDetailsWidget("Discount", "\$399"),
                      taxDetailsWidget("Total", "\$399"),
                      taxDetailsWidget("Balace due", "\$399"),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 45.0),
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Container(
                      //       height: 56,
                      //       alignment: Alignment.center,
                      //       width: MediaQuery.of(context).size.width,
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(12),
                      //         color: Colors.white,
                      //       ),
                      //       child: const Text(
                      //         "Send to customer",
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w500,
                      //           color: AppColors.primaryColors,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(top: 46.0),
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
                              "Update Estimate",
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
          },
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
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "${widget.estimateDetails.data.customer?.firstName ?? ""} ${widget.estimateDetails.data.customer?.lastName ?? ""}",
              style: const TextStyle(
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
                Text(
                  widget.estimateDetails.data.customer?.email ?? "",
                  style: const TextStyle(
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
                Text(
                  '(${widget.estimateDetails.data.customer?.phone?.substring(0, 3)}) ${widget.estimateDetails.data.customer?.phone?.substring(3, 6)} - ${widget.estimateDetails.data.customer?.phone?.substring(6)}',
                  style: const TextStyle(
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
            " $price",
            style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  //common text field

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            label == "Customer" || label == "Vehicle" || label == "Service"
                ? GestureDetector(
                    onTap: () {
                      if (label == "Customer") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return NewCustomerScreen();
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
                      } else if (label == "Vehicle") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CreateVehicleScreen();
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryColors,
                        ),
                        Text(
                          "Add new",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              readOnly: label == 'Date' ||
                      label == "Vehicle" ||
                      label == "Customer" ||
                      label == "Service"
                  ? true
                  : false,
              onTap: () async {
                if (label == 'Date') {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return datePicker("");
                    },
                  );
                } else if (label == "Customer") {
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (context) {
                  //       return customerBottomSheet();
                  //     },
                  //     backgroundColor: Colors.transparent);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return SelectCustomerScreen(
                        navigation: "partial",
                        orderId: widget.estimateDetails.data.id.toString(),
                      );
                    },
                  ));
                } else if (label == 'Vehicle') {
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   useSafeArea: true,
                  //   builder: (context) {
                  //     return SelectVehiclesScreen();
                  //   },
                  // );
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return SelectVehiclesScreen(
                        navigation: "partial",
                        orderId: widget.estimateDetails.data.id.toString(),
                        customerId:
                            widget.estimateDetails.data.customerId.toString(),
                      );
                    },
                  ));
                }
              },
              keyboardType:
                  label == 'Phone Number' ? TextInputType.number : null,
              maxLength: label == 'Phone Number'
                  ? 16
                  : label == 'Password'
                      ? 12
                      : 50,
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  suffixIcon: label == "Customer" ||
                          label == "Vehicle" ||
                          label == "Service"
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryColors,
                        )
                      : const SizedBox(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget datePicker(String dateType) {
    String selectedDate = "";
    return CupertinoPopupSurface(
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: CupertinoColors.white,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                      child: const Text("Done"),
                      onPressed: () {
                        if (selectedDate != "") {
                          dateController.text = selectedDate;
                        } else {
                          dateController.text =
                              "${DateTime.now().year}-${DateTime.now().month > 10 ? DateTime.now().month : "0${DateTime.now().month}"}-${DateTime.now().day > 10 ? DateTime.now().day : "0${DateTime.now().day}"}";
                        }
                        Navigator.pop(context);
                      })
                ],
              ),
              //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newdate) {
                    setState(() {
                      selectedDate =
                          "${newdate.year}-${newdate.month > 10 ? newdate.month : "0${newdate.month}"}-${newdate.day > 10 ? newdate.day : "0${newdate.day}"}";
                    });
                  },
                  use24hFormat: true,
                  maximumDate: new DateTime(2030, 12, 30),
                  minimumYear: 2009,
                  maximumYear: 2030,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ],
          )),
    );
  }

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, String whichTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2.4,
            child: TextField(
              controller: controller,
              maxLength: 50,
              readOnly: true,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return timerPicker(whichTime);
                  },
                );
              },
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget timerPicker(String timeType) {
    String selectedTime = "";
    return CupertinoPopupSurface(
      child: Container(
        color: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      if (timeType == "start_time") {
                        startTimeController.text = selectedTime;
                      } else {
                        endTimeController.text = selectedTime;
                      }
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: const Duration(),
                onTimerDurationChanged: (Duration changeTimer) {
                  setState(() {
                    // initialTimer = changeTimer;

                    selectedTime =
                        ' ${changeTimer.inHours > 10 ? changeTimer.inHours : "0${changeTimer.inHours}"}:${changeTimer.inMinutes % 60 > 10 ? changeTimer.inMinutes % 60 : "0${changeTimer.inMinutes % 60}"}:${changeTimer.inSeconds % 60 > 10 ? changeTimer.inSeconds % 60 : "0${changeTimer.inSeconds % 60}"}';

                    print(
                        '${changeTimer.inHours} hrs ${changeTimer.inMinutes % 60} mins ${changeTimer.inSeconds % 60} secs');
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                //  selectImages("camera");
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/camera.svg",
                    width: 24,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text('Camera'),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                //   selectImages("lib");
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/folder.svg",
                    width: 24,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text('Choose from Library'),
                  ),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          )),
    );
  }

  Widget inspectionPhotoWidget() {
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
}
