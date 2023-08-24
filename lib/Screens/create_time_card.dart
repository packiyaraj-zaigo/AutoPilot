import 'dart:async';
import 'dart:developer';

import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Models/time_card_create_model.dart';
import 'package:auto_pilot/Models/time_card_user_model.dart';
import 'package:auto_pilot/Screens/time_card_screen.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/bloc/time_card/time_card_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TimeCardCreate extends StatefulWidget {
  const TimeCardCreate(
      {super.key, this.id = -1, this.employee = '', this.timeCard});
  final int? id;
  final String? employee;
  final TimeCardUserModel? timeCard;

  @override
  State<TimeCardCreate> createState() => _TimeCardCreateState();
}

class _TimeCardCreateState extends State<TimeCardCreate> {
  List<Employee> employeeList = [];
  ScrollController scrollController = ScrollController();
  final TextEditingController employeeController = TextEditingController();
  String employeeError = '';
  final TextEditingController taskController = TextEditingController();
  String taskError = '';
  final TextEditingController dateController = TextEditingController();
  String dateError = '';
  final TextEditingController clockInController = TextEditingController();
  final TextEditingController clockOutController = TextEditingController();
  String clockError = '';
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String notesError = '';
  int technicianId = -1;
  Duration clockIn = const Duration();
  Duration clockOut = const Duration();
  DateTime selectedDate = DateTime.now();

  populateData() {
    final timeCard = widget.timeCard!;
    employeeController.text =
        timeCard.technician.firstName + timeCard.technician.lastName;
    taskController.text = timeCard.activityType;
    dateController.text =
        AppUtils.getDateFormatterUI(timeCard.clockInTime.toString());
    clockInController.text =
        DateFormat('hh : mm a').format(timeCard.clockInTime).toString();
    clockOutController.text =
        DateFormat('hh : mm a').format(timeCard.clockOutTime).toString();

    totalTimeController.text = "${timeCard.totalTime.substring(0, 5)} Hours";
    notesController.text = timeCard.notes;
    selectedDate = timeCard.clockInTime;
    clockIn = Duration(
        hours: timeCard.clockInTime.hour, minutes: timeCard.clockInTime.minute);
    clockOut = Duration(
        hours: timeCard.clockOutTime.hour,
        minutes: timeCard.clockOutTime.minute);
    technicianId = timeCard.technicianId;
  }

  @override
  void initState() {
    super.initState();
    technicianId = widget.id!;
    employeeController.text = widget.employee!;
    if (widget.timeCard != null) {
      populateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          '${widget.timeCard != null ? "Edit" : "New"} Time Card',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: AppColors.primaryColors,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: BlocListener<TimeCardBloc, TimeCardState>(
        listener: (context, state) {
          if (state is CreateTimeCardErrorState) {
            CommonWidgets().showDialog(context, state.message);
          } else if (state is CreateTimeCardSucessState ||
              state is EditTimeCardSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const TimeCardsScreen(),
                ),
                (route) => false);
            CommonWidgets().showSuccessDialog(context,
                'Successfully ${widget.timeCard == null ? "Created" : "Updated"} the\ntime card');
          } else if (state is EditTimeCardErrorState) {
            CommonWidgets().showDialog(context, state.message);
          }
        },
        child: BlocBuilder<TimeCardBloc, TimeCardState>(
          builder: (context, state) {
            if (state is CreateTimeCardLoadingState ||
                state is EditTimeCardLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Time',
                      style: TextStyle(
                        color: AppColors.primaryTitleColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    textBoxFullCard(employeeController, employeeError,
                        'Select Employee', 'Employee'),
                    textBoxFullCard(
                        taskController, taskError, 'Enter Task', 'Task'),
                    textBoxFullCard(
                        dateController, dateError, 'Select Date', 'Date'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        halfTextBox('Select Time', clockInController,
                            'Clocked in', clockError.isNotEmpty, context),
                        halfTextBox('Select Time', clockOutController,
                            'Clocked out', clockError.isNotEmpty, context),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                        visible: clockError.isNotEmpty,
                        child: Text(
                          clockError,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(
                              0xffD80027,
                            ),
                          ),
                        ),
                      ),
                    ),
                    textBoxFullCard(totalTimeController, '', '-', 'Time'),
                    textBoxFullCard(
                        notesController, notesError, 'Enter Notes', 'Notes'),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: GestureDetector(
                        onTap: () async {
                          final status = validate();
                          if (status) {
                            dynamic clientId = await AppUtils.getUserID();
                            if (widget.timeCard != null) {
                              clientId = widget.timeCard!.clientId.toString();
                            }
                            final clockedIn = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                clockIn.inHours,
                                clockIn.inMinutes % 60);
                            final clockedOut = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                clockOut.inHours,
                                clockOut.inMinutes % 60);
                            final totalTime =
                                '${(clockOut.inHours - clockIn.inHours).toString().padLeft(2, '0')}:${((clockOut.inMinutes % 60) - (clockIn.inMinutes % 60)).toString().padLeft(2, '0')}:00';
                            final timeCard = TimeCardCreateModel(
                                clientId: int.parse(clientId),
                                technicianId: technicianId,
                                task: taskController.text,
                                notes: notesController.text,
                                clockInTime: clockedIn,
                                clockOutTime: clockedOut,
                                totalTime: totalTime);
                            if (widget.timeCard != null) {
                              BlocProvider.of<TimeCardBloc>(context).add(
                                  EditTimeCardEvent(
                                      timeCard: timeCard,
                                      id: widget.timeCard!.id.toString()));
                            } else {
                              BlocProvider.of<TimeCardBloc>(context)
                                  .add(CreateTimeCardEvent(timeCard: timeCard));
                            }
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
                          child: Text(
                            widget.timeCard != null ? "Update" : "Confirm",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryColors,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget textBoxFullCard(TextEditingController controller, String error,
      String placeholder, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        textBox(placeholder, controller, label, error.isNotEmpty, context),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Visibility(
            visible: error.isNotEmpty,
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(
                  0xffD80027,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, BuildContext context) {
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
                color: AppColors.greyText,
              ),
            ),
            label == 'Employee' || label == 'Task' || label == 'Date'
                ? Text(
                    " *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xffD80027,
                      ),
                    ),
                  )
                : Text('')
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: label == "Notes" ? null : 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onTap: label == 'Task' || label == "Notes"
                  ? null
                  : () {
                      if (label == "Date") {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return datePicker();
                          },
                        );
                      }
                      if (label == 'Employee' &&
                          widget.id == -1 &&
                          widget.timeCard == null) {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => employeeListSheet());
                      }
                    },
              controller: controller,
              readOnly: label == "Task" || label == 'Notes' ? false : true,
              minLines: label == 'Notes' ? 5 : 1,
              maxLines: label == 'Notes' ? 5 : 1,
              style: label == "Employee"
                  ? const TextStyle(color: AppColors.primaryTitleColor)
                  : null,
              decoration: InputDecoration(
                suffixIcon: label == "Employee"
                    ? const Icon(
                        CupertinoIcons.chevron_down,
                        color: Colors.black,
                      )
                    : null,
                hintText: placeHolder,
                hintStyle: label == "Employee"
                    ? const TextStyle(
                        color: AppColors.primaryTitleColor, fontSize: 16)
                    : const TextStyle(fontSize: 16),
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorStatus == true
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorStatus == true
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: errorStatus == true
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget timerPicker(bool isClockIn) {
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
                      final date = selectedDate;
                      if (isClockIn) {
                        if (clockInController.text.isEmpty) {
                          clockIn =
                              Duration(hours: date.hour, minutes: date.minute);
                          clockInController.text =
                              AppUtils.getTimeMinFormatted(clockIn.toString());
                        }
                      } else {
                        if (clockOutController.text.isEmpty) {
                          clockOut = Duration(
                              hours: clockIn.inHours,
                              minutes: clockIn.inMinutes % 60);

                          clockOutController.text =
                              AppUtils.getTimeMinFormatted(clockOut.toString());
                        }
                      }
                      if (clockInController.text.isNotEmpty &&
                          clockOutController.text.isNotEmpty &&
                          clockOut >= clockIn) {
                        totalTimeController.text =
                            '${(clockOut.inHours - clockIn.inHours).toString().padLeft(2, '0')}:${((clockOut.inMinutes % 60) - (clockIn.inMinutes % 60)).toString().padLeft(2, '0')} Hours';
                      } else {
                        totalTimeController.text = '00:00 Hours';
                      }
                    })
              ],
            ),
            Flexible(
              child: CupertinoDatePicker(
                // mode: CupertinoTimerPickerMode.hm,
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 1,
                initialDateTime: clockInController.text != '' && isClockIn
                    ? DateTime(
                        2023, 1, 1, clockIn.inHours, clockIn.inMinutes % 60)
                    : clockOutController.text != ''
                        ? DateTime(2023, 1, 1, clockOut.inHours,
                            clockOut.inMinutes % 60)
                        : DateTime.now(),

                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    if (isClockIn) {
                      clockIn = Duration(
                          hours: dateTime.hour, minutes: dateTime.minute);
                      clockInController.text =
                          AppUtils.getTimeMinFormatted(clockIn.toString());
                    } else {
                      clockOut = Duration(
                          hours: dateTime.hour, minutes: dateTime.minute);

                      clockOutController.text =
                          AppUtils.getTimeMinFormatted(clockOut.toString());
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget datePicker() {
    final date = DateTime.now();
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
                        Navigator.pop(context);
                        if (dateController.text.isEmpty) {
                          final date = DateTime.now().toString();
                          final formattedDate =
                              AppUtils.getDateFormatterUI(date);
                          dateController.text = formattedDate;
                        }
                      })
                ],
              ),
              //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: date,
                  onDateTimeChanged: (DateTime newdate) {
                    final formattedDate =
                        AppUtils.getDateFormatterUI(newdate.toString());
                    dateController.text = formattedDate;
                    selectedDate = newdate;
                  },
                  use24hFormat: true,
                  maximumDate: date,
                  minimumYear: 2009,
                  maximumYear: date.year,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ],
          )),
    );
  }

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, BuildContext context) {
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
                  color: Color(0xff6A7187)),
            ),
            label == 'Clocked in' || label == 'Clocked out'
                ? Text(
                    " *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xffD80027,
                      ),
                    ),
                  )
                : Text('')
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2.4,
            child: TextField(
              onSubmitted: (value) {},
              onTap: () {
                if (label == "Clocked in") {
                  if (dateController.text.isNotEmpty) {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return timerPicker(true);
                      },
                    );
                  } else {
                    CommonWidgets()
                        .showDialog(context, 'Please select your date first');
                  }
                } else if (label == "Clocked out" &&
                    clockInController.text.isNotEmpty) {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return timerPicker(false);
                    },
                  );
                } else if (dateController.text.isEmpty) {
                  CommonWidgets()
                      .showDialog(context, 'Please select your date first');
                } else {
                  CommonWidgets().showDialog(
                      context, 'Please select your clocked in time first');
                }
              },
              controller: controller,
              maxLength: 50,
              readOnly: true,
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

  validate() {
    bool status = true;
    if (technicianId == -1) {
      employeeError = 'Select an employee';
      status = false;
    } else {
      employeeError = '';
    }
    if (dateController.text.trim().isEmpty) {
      dateError = "Please select a date";
      status = false;
    } else {
      dateError = '';
    }
    if (notesController.text.isNotEmpty &&
            notesController.text.trim().length < 2 ||
        notesController.text.isNotEmpty &&
            notesController.text.trim().length >= 256) {
      notesError = "Notes should be between 2 and 256 characters";
      status = false;
    } else {
      notesError = '';
    }
    if (clockInController.text.isEmpty && clockOutController.text.isEmpty) {
      clockError = "Clock in and clock out can't be empty";
      status = false;
    } else if (clockInController.text.isEmpty) {
      clockError = "Clock in can't be empty";
      status = false;
    } else if (clockOutController.text.isEmpty) {
      clockError = "Clock out can't be empty";
      status = false;
    }
    // else if (clockIn >
    //         Duration(hours: selectedDate.hour, minutes: selectedDate.minute) &&
    //     selectedDate.day == DateTime.now().day &&
    //     selectedDate.month == DateTime.now().month &&
    //     selectedDate.year == DateTime.now().year) {
    //   clockError = "Clock in should be valid";
    //   status = false;
    // }
    else if (clockOut < clockIn) {
      clockError = "Clock out should be valid";
      status = false;
    } else {
      clockError = '';
    }
    if (taskController.text.trim().isEmpty) {
      taskError = "Task can't be empty";
      status = false;
    } else if (taskController.text.length > 50) {
      taskError = "Task can't be more than 50 characters";
      status = false;
    } else {
      taskError = '';
    }

    setState(() {});
    return status;
  }

  Widget employeeListSheet() {
    employeeList.clear();
    scrollController = ScrollController();
    return BlocProvider(
      create: (context) => EmployeeBloc()..add(GetAllEmployees()),
      child: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeDetailsSuccessState) {
            employeeList.addAll(state.employees.employeeList ?? []);
          }
        },
        child: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Employees",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    state is EmployeeDetailsLoadingState &&
                            !BlocProvider.of<EmployeeBloc>(context)
                                .isPagenationLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 1.8 - 78,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            employeeController.text =
                                                "${employeeList[index].firstName} ${employeeList[index].lastName}";
                                            technicianId =
                                                employeeList[index].id ?? -1;
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                "${employeeList[index].firstName} ${employeeList[index].lastName}",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        BlocProvider.of<EmployeeBloc>(context)
                                                        .currentPage <=
                                                    BlocProvider.of<
                                                                EmployeeBloc>(
                                                            context)
                                                        .totalPages &&
                                                index == employeeList.length - 1
                                            ? const Column(
                                                children: [
                                                  SizedBox(height: 24),
                                                  Center(
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  ),
                                                  SizedBox(height: 24),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: employeeList.length,
                                shrinkWrap: true,
                                controller: scrollController
                                  ..addListener(() {
                                    if (scrollController.offset ==
                                            scrollController
                                                .position.maxScrollExtent &&
                                        !BlocProvider.of<EmployeeBloc>(context)
                                            .isPagenationLoading &&
                                        BlocProvider.of<EmployeeBloc>(context)
                                                .currentPage <=
                                            BlocProvider.of<EmployeeBloc>(
                                                    context)
                                                .totalPages) {
                                      // final debouncer = Debouncer();

                                      // debouncer.run(() {
                                      BlocProvider.of<EmployeeBloc>(context)
                                          .isPagenationLoading = true;
                                      BlocProvider.of<EmployeeBloc>(context)
                                          .add(GetAllEmployees());
                                      // });
                                    }
                                  }),
                                physics: const ClampingScrollPhysics(),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
