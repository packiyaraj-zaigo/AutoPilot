import 'dart:developer';

import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Screens/create_estimate.dart';
import 'package:auto_pilot/Screens/customer_select_screen.dart';
import 'package:auto_pilot/Screens/vehicle_select_screen.dart';
import 'package:auto_pilot/bloc/appointment/appointment_bloc.dart';
import '../Models/vechile_model.dart' as vm;

import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/app_colors.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({Key? key}) : super(key: key);

  @override
  State<CreateAppointmentScreen> createState() =>
      _CreateAppointmentScreenState();
}

class _CreateAppointmentScreenState extends State<CreateAppointmentScreen> {
  // String? _dateCount;
  DateTime? startDateToServer;
  DateTime? endDateToServer;
  String? startDate;
  String? endDate;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController completionDateController =
      TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController customerController = TextEditingController();
  final TextEditingController vehicleController = TextEditingController();
  Datum? customer;
  vm.Datum? vehicle;
  Duration startTime = const Duration();
  Duration endTime = const Duration();
  bool startTimeErrorMsg = false;
  bool endTimeErrorMsg = false;
  bool nameErrorMsg = false;
  bool notesErrorMsg = false;
  bool customerErrorMsg = false;
  bool vehicleErrorMsg = false;
  bool isValidated = false;
  bool isChecked = false;

  @override
  void initState() {
    startDate = '';
    super.initState();
    startDateController.text = startDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 4)))
        .toString();
    startDateToServer = DateTime.now().subtract(const Duration(days: 4));
    completionDateController.text = endDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().add(const Duration(days: 3)))
        .toString();
    endDateToServer = DateTime.now().subtract(const Duration(days: 3));
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        startDate =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
        startDateToServer = args.value.startDate;
        endDate = DateFormat('dd/MM/yyyy')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
        endDateToServer = args.value.endDate ?? args.value.startDate;
        startDateController.text = startDate.toString();
        completionDateController.text =
            endDate == null ? '' : endDate.toString();

        print("${args.value.startDate}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'New Appointment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryTitleColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.clear,
              color: AppColors.primaryColors,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: BlocListener<AppointmentBloc, AppointmentState>(
        listener: (context, state) {
          if (state is CreateAppointmentErrorState) {
            CommonWidgets().showDialog(context, state.message);
          }
          if (state is CreateAppointmentSuccessState) {
            log(isChecked.toString());
            if (isChecked == true) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CreateEstimateScreen(
                  customer: customer,
                  vehicle: vehicle,
                ),
              ));
            } else {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(
              //     content: Text('Appointment created succesfully'),
              //     backgroundColor: Colors.green,
              //   ),
              // );
              Navigator.of(context).pop();
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Basic Details",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryTitleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                SfDateRangePicker(
                  monthViewSettings:
                      const DateRangePickerMonthViewSettings(dayFormat: 'EEE'),
                  monthCellStyle: DateRangePickerMonthCellStyle(
                      cellDecoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEDEEFF)),
                    shape: BoxShape.circle,
                  )),

                  headerStyle: const DateRangePickerHeaderStyle(
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryTitleColor,
                          fontWeight: FontWeight.w600)),
                  // selectionTextStyle: TextStyle(color: Colors.white),
                  rangeTextStyle: const TextStyle(color: Colors.white),
                  rangeSelectionColor: AppColors.primaryColors,
                  startRangeSelectionColor: AppColors.primaryColors,
                  endRangeSelectionColor: AppColors.primaryColors,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(
                      const Duration(days: 3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    halfTextBox(
                        "Enter Date", startDateController, "Start date", false),
                    halfTextBox("Enter Date", completionDateController,
                        "Completion date", false),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    halfTextTime("Select Time", startTimeController,
                        "Start time", startTimeErrorMsg),
                    halfTextTime("Select Time", endTimeController, "End Time",
                        endTimeErrorMsg),
                  ],
                ),
                const SizedBox(height: 16),
                textBox("Select Customer", customerController, "Customer",
                    customerErrorMsg),
                const SizedBox(height: 16),
                textBox("Select Customer", vehicleController, "Vehicle",
                    vehicleErrorMsg),
                const SizedBox(height: 16),
                textBox("Enter Name", nameController, "Name", nameErrorMsg),
                const SizedBox(height: 16),
                textBox("Enter Notes", notesController, "Appointment notes",
                    notesErrorMsg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      checkColor: Colors.white,
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const Text(
                      "Create new estimate for this appointment.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.greyText,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    isValidated = true;
                    final status = validate();

                    if (status) {
                      BlocProvider.of<AppointmentBloc>(context).add(
                        CreateAppointmentEvent(
                          appointment: AppointmentCreateModel(
                            appointmentTitle: nameController.text,
                            createdBy: 0,
                            customerId: customer!.id,
                            vehicleId: vehicle!.id,
                            startOn: startDateToServer!.add(startTime),
                            endOn: endDateToServer!.add(endTime),
                            notes: notesController.text,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryColors,
                    ),
                    child: BlocBuilder<AppointmentBloc, AppointmentState>(
                      builder: (context, state) {
                        if (state is CreateAppointmentLoadingState) {
                          return const Center(
                            child: CupertinoActivityIndicator(
                              color: AppColors.greyText,
                            ),
                          );
                        }
                        return const Text(
                          "Confirm",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  errorWidget(bool isError, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Visibility(
          visible: isError,
          child: Text(
            ' $label cannot be empty.',
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

  validate() {
    bool status = true;

    if (startTimeController.text.isEmpty) {
      startTimeErrorMsg = true;
      status = false;
    } else {
      startTimeErrorMsg = false;
    }
    if (nameController.text.trim().isEmpty) {
      nameErrorMsg = true;
      status = false;
    } else {
      nameErrorMsg = false;
    }
    if (endTimeController.text.isEmpty) {
      endTimeErrorMsg = true;
      status = false;
    } else {
      endTimeErrorMsg = false;
    }
    if (customerController.text.isEmpty || customer == null) {
      customerErrorMsg = true;
      status = false;
    } else {
      customerErrorMsg = false;
    }
    if (vehicleController.text.isEmpty || vehicle == null) {
      vehicleErrorMsg = true;
      status = false;
    } else {
      vehicleErrorMsg = false;
    }
    if (notesController.text.trim().isEmpty) {
      notesErrorMsg = true;
      status = false;
    } else {
      notesErrorMsg = false;
    }
    setState(() {});
    return status;
  }

  Widget timerPicker(TextEditingController controller) {
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
                      if (startTimeController.text.isEmpty &&
                          controller == startTimeController) {
                        startTime = Duration.zero;
                        startTimeController.text = '0.0';
                      }
                      if (endTimeController.text.isEmpty &&
                          controller == endTimeController) {
                        endTime = Duration.zero;
                        endTimeController.text = '0.0';
                      }
                      if (isValidated) {
                        validate();
                      }
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: startTimeController.text != '' &&
                        controller == startTimeController
                    ? startTime
                    : endTimeController.text != '' &&
                            controller == endTimeController
                        ? endTime
                        : const Duration(),
                onTimerDurationChanged: (Duration changeTimer) {
                  // setState(() {
                  if (controller == startTimeController) {
                    startTime = changeTimer;
                    startTimeController.text =
                        "${startTime.inHours}: ${startTime.inMinutes % 60}";
                  } else {
                    endTime = changeTimer;
                    endTimeController.text =
                        "${endTime.inHours}: ${endTime.inMinutes % 60}";
                  }
                  // });
                  if (isValidated) {
                    validate();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget halfTextBox(String placeHolder, TextEditingController controller,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2 - 40,
            child: TextField(
              controller: controller,
              maxLength: 50,
              readOnly: true,
              onTap: () {
                // showCupertinoModalPopup(
                //   context: context,
                //   builder: (context) {
                //     return timerPicker(controller);
                //   },
                // );
              },
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget halfTextTime(String placeHolder, TextEditingController controller,
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2 - 40,
            child: TextField(
              controller: controller,
              maxLength: 50,
              readOnly: true,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return timerPicker(controller);
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
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD)))),
            ),
          ),
        ),
        errorWidget(errorStatus, label)
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
            // height: label == "Appointment notes" ? 150 : 56,
            width: double.infinity,
            child: TextField(
              onTap: label == "Customer"
                  ? () async {
                      final data =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SelectCustomerScreen(),
                      ));
                      if (data != null) {
                        customerController.text = (data.firstName ?? '') +
                            ' ' +
                            (data.lastName ?? '');
                        customer = data;
                        if (isValidated) {
                          validate();
                        }
                      }
                    }
                  : label == 'Vehicle'
                      ? () async {
                          final data = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => const SelectVehiclesScreen(),
                          ));
                          if (data != null) {
                            vehicleController.text = (data.vehicleYear ?? '') +
                                ' ' +
                                (data.vehicleModel ?? '');
                            vehicle = data;
                            if (isValidated) {
                              validate();
                            }
                          }
                        }
                      : null,
              readOnly: placeHolder.contains('Select'),
              minLines: label == "Appointment notes" ? 5 : 1,
              maxLines: label == "Appointment notes" ? 5 : 1,
              controller: controller,
              decoration: InputDecoration(
                  hintText: placeHolder,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? const Color(0xffD80027)
                              : const Color(0xffC1C4CD)))),
            ),
          ),
        ),
        errorWidget(errorStatus, label)
      ],
    );
  }
}
