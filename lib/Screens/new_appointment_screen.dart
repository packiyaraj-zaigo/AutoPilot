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
  Duration initialTimer = const Duration();
  Duration initialTimer1 = const Duration();
  bool startDateErrorMsg = false;
  bool completionDateErrorMsg = false;
  bool startTimeErrorMsg = false;
  bool endTimeErrorMsg = false;
  bool nameErrorMsg = false;
  bool notesErrorMsg = false;

  @override
  void initState() {
    _dateCount = '';
    _range = '';
    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
        _range1 = DateFormat('dd/MM/yyyy')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
        print("${args.value.startDate}");
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startDateController.text = _range.toString();
    completionDateController.text = _range1 == null ? '' : _range1.toString();
    startTimeController.text =
        "${initialTimer.inHours}: ${initialTimer.inMinutes % 60}";
    endTimeController.text =
        "${initialTimer1.inHours}: ${initialTimer1.inMinutes % 60}";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'New Appointment',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlackColors),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding:  EdgeInsets.only(left: 10),
              child: Text(
                "Basic Details",
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.primaryTitleColor,
                ),
              ),
            ),
            SfDateRangePicker(
              headerStyle: DateRangePickerHeaderStyle(
                  textStyle: TextStyle(
                      fontSize: 22, color: AppColors.primaryBlackColors)),
              rangeSelectionColor: AppColors.primaryColors,
              startRangeSelectionColor: AppColors.primaryColors,
              endRangeSelectionColor: AppColors.primaryColors,
              onSelectionChanged: _onSelectionChanged,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                halfTextBox("Enter date...", startDateController, "Start date",
                    startDateErrorMsg),
                halfTextBox("Enter date...", completionDateController,
                    "Completion date", startDateErrorMsg),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                halfTextTime("Select", startTimeController, "Start time",
                    startTimeErrorMsg),
                halfTextTime(
                    "Select", endTimeController, "End Time", endTimeErrorMsg),
              ],
            ),
            textBox("Enter name...", nameController, "Name", nameErrorMsg),
            textBox("Enter notes...", notesController, "Appointment notes",
                notesErrorMsg),
          ],
        ),
      ),
    );
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
                    } else {
                      initialTimer1 = changeTimer;
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            padding: EdgeInsets.only(top: 6.0),
            child: SizedBox(
              height: 56,
              width: 180,
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
      ),
    );
  }

  Widget halfTextTime(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            padding: EdgeInsets.only(top: 6.0),
            child: SizedBox(
              height: 56,
              width: 180,
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
      ),
    );
  }
}

Widget textBox(String placeHolder, TextEditingController controller,
    String label, bool errorStatus) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
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
          padding: const EdgeInsets.only(top: 6.0, bottom: 15),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: placeHolder,
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
    ),
  );
}
