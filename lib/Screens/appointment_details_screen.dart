import 'dart:developer';

import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.eventId});
  final String eventId;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  CreateEstimateModel? createEstimateModel;
  DateTime? beginDate;
  DateTime? endDate;
  String notes = "";
  double totalAmount = 0.00;
  String laborTaxRate = "";
  String laborRate = "";
  bool isAppointmentEdit = false;

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final appointmentController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  bool startTimeErrorStatus = false;
  bool endTimeErrorStatus = false;
  bool appointmentErrorStatus = false;
  bool startDateErrorStatus = false;
  bool endDateErrorStatus = false;

  String startTimeErrorMsg = "";
  String endTimeErrorMsg = "";
  String appointmentErrorMsg = "";
  String startDateErrorMsg = "";
  String endDateErrorMsg = "";

  String startTimeToServer = "";
  String endTimeToServer = "";
  String startDateToServer = "";
  String endDateToServer = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(GetEventDetailsByIdEvent(eventId: widget.eventId))
        ..add(GetClientByIdInEstimateEvent()),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is GetEventDetailsByIdState) {
            beginDate = state.beginDate;
            endDate = state.endDate;
            notes = state.notes;

            context
                .read<EstimateBloc>()
                .add(GetSingleEstimateEvent(orderId: state.orderId));
          }
          if (state is EditAppointmentEstimateState) {
            isAppointmentEdit = false;
          }
          if (state is GetSingleEstimateState) {
            createEstimateModel = state.createEstimateModel;

            calculateAmount();
          }

          if (state is GetClientByIdInEstimateState) {
            laborTaxRate = state.clientModel.laborTaxRate ?? "0";
            laborRate = state.clientModel.baseLaborCost ?? "0";
          }
          if (state is EditAppointmentEstimateState) {
            CommonWidgets()
                .showSuccessDialog(context, 'Appointment updated successfully');
            beginDate = DateTime.parse(
              "$startDateToServer $startTimeToServer",
            );
            endDate = DateTime.parse(
              "$endDateToServer $endTimeToServer",
            );
            notes = appointmentController.text;
          }
          if (state is CreateAppointmentEstimateErrorState) {
            CommonWidgets().showDialog(context, state.errorMessage);
          }
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
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
                    onPressed: () {
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) => editAppointmentSheet(),
                      // );
                    },
                    icon: const Icon(
                      Icons.more_horiz,
                      color: AppColors.primaryColors,
                    ),
                  )
                ],
              ),
              body: state is AppointmentDetailsLoadingState ||
                      state is GetSingleEstimateLoadingState
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Date and status row
                            isAppointmentEdit
                                ? appointmentEditWidget()
                                : appointmentDateAndTime(context),

                            //Customer name tile
                            appointmentTileWidget(
                                "Customer Name",
                                "${createEstimateModel?.data.customer?.firstName ?? ""} ${createEstimateModel?.data.customer?.lastName ?? ""}",
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            //Estimate tile
                            appointmentTileWidget(
                                "Estimate",
                                createEstimateModel?.data.orderNumber != null
                                    ? "#${createEstimateModel?.data.orderNumber ?? ""}"
                                    : "No Estimate",
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            //Vehicle tile
                            appointmentTileWidget(
                                "Vehicle",
                                "${createEstimateModel?.data.vehicle?.vehicleYear ?? ""} ${createEstimateModel?.data.vehicle?.vehicleMake ?? ""} ${createEstimateModel?.data.vehicle?.vehicleModel ?? ""}",
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            // Notes Tile
                            isAppointmentEdit
                                ? const SizedBox()
                                : appointmentTileWidget("Notes", notes,
                                    MediaQuery.of(context).size.width),
                            isAppointmentEdit
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 14.0),
                                    child: dividerLine(
                                        MediaQuery.of(context).size.width),
                                  ),

                            Padding(
                              padding: const EdgeInsets.only(top: 64.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                        color: AppColors.primaryTitleColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "\$ ${totalAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: AppColors.primaryTitleColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: GestureDetector(
                                onTap: isAppointmentEdit
                                    ? () {
                                        BlocProvider.of<EstimateBloc>(context)
                                            .add(
                                          EditAppointmentEstimateEvent(
                                            startTime:
                                                "$startDateToServer $startTimeToServer",
                                            endTime:
                                                "$endDateToServer $endTimeToServer",
                                            orderId: createEstimateModel
                                                    ?.data.id
                                                    .toString() ??
                                                '0',
                                            appointmentNote:
                                                appointmentController.text,
                                            customerId: createEstimateModel
                                                    ?.data.customerId
                                                    .toString() ??
                                                '0',
                                            vehicleId: createEstimateModel
                                                    ?.data.vehicleId
                                                    .toString() ??
                                                '0',
                                            id: widget.eventId,
                                          ),
                                        );
                                      }
                                    : () {
                                        if (createEstimateModel
                                                ?.data.orderNumber !=
                                            null) {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return EstimatePartialScreen(
                                                estimateDetails:
                                                    createEstimateModel!,
                                                navigation:
                                                    "appointment_details",
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
                                      color: createEstimateModel
                                                  ?.data.orderNumber !=
                                              null
                                          ? AppColors.primaryColors
                                          : Colors.grey.shade300),
                                  child: Text(
                                    isAppointmentEdit
                                        ? "Update Appointment"
                                        : "Go to Estimate",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: createEstimateModel
                                                  ?.data.orderNumber !=
                                              null
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

  Column appointmentEditWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            halfTextBox("Select Date", startDateController, "Start Date",
                startDateErrorStatus, "start_time", startDateErrorMsg),
            halfTextBox("Select Date", endDateController, "End Date",
                endDateErrorStatus, "end_time", endDateErrorMsg)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              halfTextBox("Select Time", startTimeController, "Start Time",
                  startTimeErrorStatus, "start_time", startTimeErrorMsg),
              halfTextBox("Select Time", endTimeController, "End Time",
                  endTimeErrorStatus, "end_time", endTimeErrorMsg)
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 16.0),
        //   child: textBox(
        //       "Select Date",
        //       dateController,
        //       "Date",
        //       dateErrorStatus),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: textBox("Enter Appointment Note", appointmentController,
              "Appointment Note", appointmentErrorStatus),
        ),
        errorWidget(appointmentErrorMsg, appointmentErrorStatus),
      ],
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
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
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: label == 'Phone Number' || label == "Amount To Pay"
                  ? TextInputType.number
                  : null,
              maxLength: 50,
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

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, String whichTime, String errorMsg) {
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
                if (label == "Start Date") {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return datePicker("start_date");
                      });
                } else if (label == "End Date") {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return datePicker("end_date");
                      });
                } else {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return timerPicker(whichTime);
                    },
                  );
                }
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
        errorWidget(errorMsg, errorStatus),
      ],
    );
  }

  Widget timerPicker(String timeType) {
    String selectedTime = "${DateTime.now().hour}:${DateTime.now().minute}";
    if (timeType == "start_time" && isAppointmentEdit) {
      selectedTime =
          DateFormat('hh:mm').format(beginDate ?? DateTime.now()).toString();
    } else if (timeType == "end_time" && isAppointmentEdit) {
      selectedTime =
          DateFormat('hh:mm').format(endDate ?? DateTime.now()).toString();
    }
    if (timeType == "start_time" && endTimeController.text.trim().isNotEmpty) {
      selectedTime = startTimeToServer;
    } else if (timeType == "end_time" &&
        endTimeController.text.trim().isNotEmpty) {
      selectedTime = endTimeToServer;
    } else if (timeType == "end_time" &&
        endTimeController.text.trim().isEmpty) {
      selectedTime = startTimeToServer;
    }

    return CupertinoPopupSurface(
      child: Container(
        color: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text("Clear"),
                  onPressed: () {
                    if (timeType == "start_time") {
                      startTimeController.text = "";
                      startTimeToServer = "";
                    } else {
                      endTimeController.text = "";
                      endTimeToServer = "";
                    }
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      if (timeType == "start_time") {
                        startTimeToServer = selectedTime;
                        startTimeController
                            .text = AppUtils.getTimeMinFormatted(Duration(
                                hours: int.parse(
                                  selectedTime.substring(0, 2),
                                ),
                                minutes: int.parse(selectedTime.substring(3)))
                            .toString());
                      } else {
                        endTimeToServer = selectedTime;
                        endTimeController
                            .text = AppUtils.getTimeMinFormatted(Duration(
                                hours: int.parse(
                                  selectedTime.substring(0, 2),
                                ),
                                minutes: int.parse(selectedTime.substring(3)))
                            .toString());
                      }
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoDatePicker(
                // mode: CupertinoTimerPickerMode.hm,
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 1,
                initialDateTime: isAppointmentEdit && timeType == "start_time"
                    ? DateTime(2023, 1, 1, beginDate?.hour ?? 0,
                        beginDate?.minute ?? 0)
                    : isAppointmentEdit && timeType == "end_time"
                        ? DateTime(2023, 1, 1, endDate?.hour ?? 0,
                            endDate?.minute ?? 0)
                        : timeType == 'end_time' &&
                                    startTimeToServer.isNotEmpty ||
                                timeType == 'start_time' &&
                                    startTimeToServer.isNotEmpty
                            ? DateTime(
                                2023,
                                1,
                                1,
                                int.parse(
                                    startTimeToServer.trim().substring(0, 2)),
                                int.parse(
                                  startTimeToServer.trim().substring(3),
                                ),
                              )
                            : DateTime.now(),

                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    selectedTime =
                        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                  });
                },
              ),
            ),
          ],
        ),
      ),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text("Clear"),
                    onPressed: () {
                      if (dateType == "start_date") {
                        startDateController.text = "";
                        startDateToServer = "";
                      } else if (dateType == "end_date") {
                        endDateController.text = "";
                        endDateToServer = "";
                      }

                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      if (dateType == "start_date") {
                        if (selectedDate != "") {
                          startDateController.text = selectedDate;
                          startDateToServer = startDateToServer;
                        } else {
                          startDateController.text =
                              "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().year}";

                          startDateToServer =
                              "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
                        }
                      } else if (dateType == "end_date") {
                        if (selectedDate != "") {
                          endDateController.text = selectedDate;
                          endDateToServer = endDateToServer;
                        } else {
                          endDateController.text =
                              "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().year}";
                          endDateToServer =
                              "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
                        }
                      }

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: dateType == "end_date"
                      ? DateTime.parse(endDateToServer)
                      : DateTime.parse(startDateToServer),
                  onDateTimeChanged: (DateTime newdate) {
                    setState(() {
                      selectedDate =
                          "${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}-${newdate.year}";
                      if (dateType == "end_date") {
                        endDateToServer =
                            "${newdate.year}-${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}";
                      } else if (dateType == "start_date") {
                        startDateToServer =
                            "${newdate.year}-${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}";
                      }
                    });
                  },
                  use24hFormat: true,
                  maximumDate: DateTime.now().add(const Duration(days: 3650)),
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

  Padding errorWidget(String errorString, bool errorStatus) {
    //log(errorStatus.toString() + errorString);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Visibility(
          visible: errorStatus,
          child: Text(
            errorString,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(
                0xffD80027,
              ),
            ),
          )),
    );
  }

  Column appointmentDateAndTime(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            appointmentTileWidget(
                "Start Date",
                beginDate != null
                    ? DateFormat("MM/dd/yyyy").format(beginDate!)
                    : "",
                MediaQuery.of(context).size.width / 2.8),
            appointmentTileWidget(
                "End Date",
                endDate != null
                    ? DateFormat("MM/dd/yyyy").format(endDate!)
                    : "",
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
            appointmentTileWidget(
                "Start Time",
                beginDate != null
                    ? DateFormat("hh:mm a").format(beginDate!)
                    : "",
                MediaQuery.of(context).size.width / 2.8),
            appointmentTileWidget(
                "End Time",
                endDate != null ? DateFormat("hh:mm a").format(endDate!) : "",
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
      ],
    );
  }

  Widget editAppointmentSheet() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select an option",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAppointmentEdit = true;
                    startTimeController.text = DateFormat("hh:mm a")
                        .format(beginDate ?? DateTime.now());
                    startTimeToServer = DateFormat('HH:mm')
                        .format(beginDate ?? DateTime.now())
                        .toString();
                    endTimeController.text = DateFormat('hh : mm a')
                        .format(endDate ?? DateTime.now())
                        .toString();
                    endTimeToServer = DateFormat('HH:mm')
                        .format(endDate ?? DateTime.now())
                        .toString();

                    appointmentController.text = notes;
                    startDateController.text =
                        "${(beginDate ?? DateTime.now()).month.toString().padLeft(2, '0')}-${(beginDate ?? DateTime.now()).day.toString().padLeft(2, '0')}-${(beginDate ?? DateTime.now()).year}";
                    startDateToServer =
                        "${(beginDate ?? DateTime.now()).year}-${(beginDate ?? DateTime.now()).month.toString().padLeft(2, '0')}-${(beginDate ?? DateTime.now()).day.toString().padLeft(2, '0')}";
                    endDateController.text =
                        "${(endDate ?? DateTime.now()).month.toString().padLeft(2, '0')}-${(endDate ?? DateTime.now()).day.toString().padLeft(2, '0')}-${(endDate ?? DateTime.now()).year}";
                    endDateToServer =
                        "${(endDate ?? DateTime.now()).year}-${(endDate ?? DateTime.now()).month.toString().padLeft(2, '0')}-${(endDate ?? DateTime.now()).day.toString().padLeft(2, '0')}";
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/edit_pen_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  print("ontapped");
                  deleteAppointmentPopup(
                      context, "", widget.eventId.toString());

                  // Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/delete_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Remove",
                          style: TextStyle(
                              color: Color(0xffFF5C5C),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future deleteAppointmentPopup(BuildContext ctx, message, String id) {
    return showCupertinoDialog(
      context: ctx,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is DeleteAppointmentEstimateState) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => BottomBarScreen(
                      currentIndex: 2,
                    ),
                  ),
                  (route) => false);
            }
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Appointment?"),
                content: const Text("Do you want to remove this appointment?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context.read<EstimateBloc>().add(
                            DeleteAppointmentEstimateEvent(appointmetId: id));
                      }),
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              );
            },
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

  calculateAmount() {
    createEstimateModel?.data.orderService?.forEach((element) {
      if (element.orderServiceItems != null &&
          element.orderServiceItems!.isEmpty) {
        totalAmount = totalAmount +
            double.parse(laborRate) +
            ((double.parse(laborRate) * double.parse(laborTaxRate)) / 100);
      }
      element.orderServiceItems?.forEach((element2) {
        totalAmount = totalAmount + double.parse(element2.subTotal);
      });
    });
  }
}
