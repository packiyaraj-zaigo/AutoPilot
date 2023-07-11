import 'dart:developer';

import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Screens/customer_select_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/app_colors.dart';

class NewAppointment extends StatefulWidget {
  const NewAppointment({Key? key}) : super(key: key);

  @override
  State<NewAppointment> createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  String? _dateCount;
  String? _range;
  String? _range1;
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
  Duration initialTimer = const Duration();
  Duration initialTimer1 = const Duration();
  bool startTimeErrorMsg = false;
  bool endTimeErrorMsg = false;
  bool nameErrorMsg = false;
  bool notesErrorMsg = false;
  bool customerErrorMsg = false;
  bool vehicleErrorMsg = false;

  bool isChecked = false;

  @override
  void initState() {
    _dateCount = '';
    _range = '';
    super.initState();
    startDateController.text = _range = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(const Duration(days: 4)))
        .toString();
    completionDateController.text = _range1 = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().add(const Duration(days: 3)))
        .toString();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
        _range1 = DateFormat('dd/MM/yyyy')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
        startDateController.text = _range.toString();
        completionDateController.text =
            _range1 == null ? '' : _range1.toString();

        print("${args.value.startDate}");
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
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
      body: SingleChildScrollView(
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
                  halfTextTime("Select Time", startTimeController, "Start time",
                      startTimeErrorMsg),
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
                  final status = validate();
                  if (status) {}
                },
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primaryColors,
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
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
    if (nameController.text.isEmpty) {
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
    if (vehicleController.text.isEmpty) {
      vehicleErrorMsg = true;
      status = false;
    } else {
      vehicleErrorMsg = false;
    }
    if (notesController.text.isEmpty) {
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
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: const Duration(),
                onTimerDurationChanged: (Duration changeTimer) {
                  setState(() {
                    if (controller == startTimeController) {
                      initialTimer = changeTimer;
                      startTimeController.text =
                          "${initialTimer.inHours}: ${initialTimer.inMinutes % 60}";
                    } else {
                      initialTimer1 = changeTimer;
                      endTimeController.text =
                          "${initialTimer1.inHours}: ${initialTimer1.inMinutes % 60}";
                    }
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
                        builder: (context) => SelectCustomerScreen(),
                      ));
                      if (data != null) {
                        setState(() {
                          customerController.text =
                              data.firstName + ' ' + data.lastName;
                          customer = customer;
                        });
                      }
                    }
                  : label == 'Vehicle'
                      ? () {}
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
