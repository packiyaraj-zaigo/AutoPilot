import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeCardCreate extends StatefulWidget {
  const TimeCardCreate({super.key});

  @override
  State<TimeCardCreate> createState() => _TimeCardCreateState();
}

class _TimeCardCreateState extends State<TimeCardCreate> {
  final TextEditingController employeeController = TextEditingController();
  String employeeError = '';
  final TextEditingController taskController = TextEditingController();
  String taskError = '';
  final TextEditingController dateController = TextEditingController();
  String dateError = '';
  final TextEditingController clockInController = TextEditingController();
  String clockInError = '';
  final TextEditingController clockOutController = TextEditingController();
  String clockOutError = '';
  final TextEditingController totalTimeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String notesError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'New Time Card',
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
      body: SingleChildScrollView(
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
              textBoxFullCard(
                  employeeController, employeeError, 'Select', 'Employee'),
              textBoxFullCard(taskController, taskError, 'Enter Task', 'Task'),
              textBoxFullCard(dateController, dateError, 'Select', 'Date'),
              Row(
                children: [
                  // halfTextBox('Select time...', clockInController, 'Clocked In',
                  //     clock, context)
                ],
              ),
              textBoxFullCard(totalTimeController, '', '-', 'Time'),
              textBoxFullCard(
                  notesController, notesError, 'Enter notes', 'Notes'),
            ],
          ),
        ),
      ),
    );
  }

  Column textBoxFullCard(TextEditingController controller, String error,
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.greyText,
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onTap: label == 'Task' || label == "Notes" ? null : () {},
              controller: controller,
              readOnly: label == "Task" || label == 'Notes' ? false : true,
              minLines: label == 'Notes' ? 5 : 1,
              maxLines: label == 'Notes' ? 5 : 1,
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

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, BuildContext context) {
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
            width: MediaQuery.of(context).size.width / 2.4,
            child: TextField(
              onSubmitted: (value) {},
              controller: controller,
              maxLength: 50,
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
}
