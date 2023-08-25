import 'dart:developer';

import 'package:auto_pilot/Models/appointment_create_model.dart';
import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/customer_select_screen.dart';
import 'package:auto_pilot/Screens/dummy_appointment_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:auto_pilot/Screens/vehicle_select_screen.dart';
import 'package:auto_pilot/bloc/appointment/appointment_bloc.dart';
import 'package:auto_pilot/utils/app_utils.dart';
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
  bool endTimeErrorStatus = false;

  String createdCustomerId = "";
  String createdVehicleId = "";

  @override
  void initState() {
    startDate = '';
    super.initState();
    startDateController.text =
        startDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    startDateToServer = DateTime.now();
    completionDateController.text =
        endDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    endDateToServer = DateTime.now();
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
            log(state.toString());
            if (isChecked == true) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DummyAppointmentScreen(
                  customerId: createdCustomerId != ""
                      ? createdCustomerId
                      : customer!.id.toString(),
                  vehicleId: createdVehicleId != ""
                      ? createdVehicleId
                      : vehicle!.id.toString(),
                  appointmentId: state.id,
                  startTime: DateTime(startDateToServer!.year,
                          startDateToServer!.month, startDateToServer!.day)
                      .add(startTime)
                      .toString(),
                  endTime: DateTime(endDateToServer!.year,
                          endDateToServer!.month, endDateToServer!.day)
                      .add(endTime)
                      .toString(),
                  appointmentNote: notesController.text.trim(),
                ),
              ));
            } else {
              Navigator.of(context).pop();
              CommonWidgets().showSuccessDialog(
                  context, "Appointment Created Successfully");
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
                    DateTime.now(),
                    DateTime.now(),
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
                        "Start time", startTimeErrorMsg, false),
                    halfTextTime(
                        "Select Time",
                        endTimeController,
                        "End Time",
                        endTimeErrorMsg || endTimeErrorStatus,
                        endTimeErrorStatus),
                  ],
                ),
                const SizedBox(height: 16),
                textBox("Select Customer", customerController, "Customer",
                    customerErrorMsg),
                const SizedBox(height: 16),
                textBox("Select Vehicle", vehicleController, "Vehicle",
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
                            customerId: createdCustomerId != ""
                                ? int.parse(createdCustomerId)
                                : customer!.id,
                            vehicleId: createdVehicleId != ""
                                ? int.parse(createdVehicleId)
                                : vehicle!.id,
                            startOn: DateTime(
                                    startDateToServer!.year,
                                    startDateToServer!.month,
                                    startDateToServer!.day)
                                .add(startTime),
                            endOn: DateTime(
                                    endDateToServer!.year,
                                    endDateToServer!.month,
                                    endDateToServer!.day)
                                .add(endTime),
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

  errorWidget(bool isError, String label, bool endTimeError) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Visibility(
          visible: isError,
          child: Text(
            endTimeError
                ? 'End Time Should be valid'
                : ' $label cannot be empty.',
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
    } else if (endTime.inMinutes <= startTime.inMinutes &&
        endDate == startDate) {
      endTimeErrorStatus = true;
      status = false;
    } else {
      endTimeErrorMsg = false;
      endTimeErrorStatus = false;
    }
    if (customerController.text.isEmpty
        // || customer == null
        ) {
      customerErrorMsg = true;
      status = false;
    } else {
      customerErrorMsg = false;
    }
    if (vehicleController.text.isEmpty
        //   || vehicle == null
        ) {
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
                        startTime = Duration(
                            hours: DateTime.now().hour,
                            minutes: DateTime.now().minute);
                        startTimeController.text =
                            AppUtils.getTimeMinFormatted(startTime.toString());
                      }
                      if (endTimeController.text.isEmpty &&
                          controller == endTimeController) {
                        endTime = Duration(
                            hours: DateTime.now().hour,
                            minutes: DateTime.now().minute);
                        endTimeController.text =
                            AppUtils.getTimeMinFormatted(endTime.toString());
                      }
                      if (isValidated) {
                        validate();
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
                initialDateTime: startTimeController.text != '' &&
                        controller == startTimeController
                    ? DateTime(
                        2023, 1, 1, startTime.inHours, startTime.inMinutes % 60)
                    : endTimeController.text != '' &&
                            controller == endTimeController
                        ? DateTime(
                            2023, 1, 1, endTime.inHours, endTime.inMinutes % 60)
                        : DateTime.now(),

                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    if (controller == startTimeController) {
                      startTime = Duration(
                          hours: dateTime.hour, minutes: dateTime.minute);
                      startTimeController.text =
                          AppUtils.getTimeMinFormatted(startTime.toString());
                    } else {
                      endTime = Duration(
                          hours: dateTime.hour, minutes: dateTime.minute);

                      endTimeController.text =
                          AppUtils.getTimeMinFormatted(endTime.toString());
                    }
                  });
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
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187),
              ),
            ),
            const Text(
              " *",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(
                  0xffD80027,
                ),
              ),
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
      String label, bool errorStatus, bool endTimeErrorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187),
              ),
            ),
            const Text(
              " *",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(
                  0xffD80027,
                ),
              ),
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
        errorWidget(
            errorStatus, label, label == "End Time" && endTimeErrorStatus)
      ],
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff6A7187),
                  ),
                ),
                const Text(
                  " *",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(
                      0xffD80027,
                    ),
                  ),
                ),
              ],
            ),
            label == "Customer" || label == "Vehicle"
                ? GestureDetector(
                    onTap: () {
                      if (label == "Customer") {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) {
                            return const NewCustomerScreen(
                              navigation: "create_appointment",
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              customerController.text = value[0];
                              createdCustomerId = value[1];
                            });
                          }
                        });
                      } else if (label == "Vehicle") {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) {
                            return const CreateVehicleScreen(
                              navigation: "create_appointment",
                            );
                          },
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              vehicleController.text = value[0];
                              createdVehicleId = value[1];
                            });
                          }
                        });
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryColors,
                          size: 18,
                        ),
                        Text(
                          "Add New",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
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
                        builder: (context) => const SelectCustomerScreen(
                            navigation: "appointment"),
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
                            builder: (context) => const SelectVehiclesScreen(
                                navigation: "appointment"),
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
        errorWidget(errorStatus, label, false)
      ],
    );
  }
}
