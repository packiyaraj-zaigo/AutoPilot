import 'dart:developer';

import 'package:auto_pilot/bloc/workflow/workflow_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateWorkflowScreen extends StatefulWidget {
  const CreateWorkflowScreen({super.key});

  @override
  State<CreateWorkflowScreen> createState() => _CreateWorkflowScreenState();
}

class _CreateWorkflowScreenState extends State<CreateWorkflowScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  String titleError = '';
  String colorError = '';
  String positionError = '';

  List<Map<String, dynamic>> colors = [
    {'color': 0xFFFF0000, 'name': "RED"},
    {'color': 0xFF00FF00, 'name': "GREEN"},
    {'color': 0xFF0000FF, 'name': "BLUE"},
    {'color': 0xFF000000, 'name': "BLACK"},
  ];
  Color code = Colors.transparent;
  List<String> statuses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Column',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTitleColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.clear,
                color: AppColors.primaryColors,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Basic Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              textBox(
                  'Estimate', titleController, 'Title', titleError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: titleError.isNotEmpty,
                    child: Text(
                      titleError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Select Color', colorController, 'Color',
                  colorError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: colorError.isNotEmpty,
                    child: Text(
                      colorError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 16),
              textBox('Select Position', positionController, 'Position',
                  positionError.isNotEmpty),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Visibility(
                    visible: positionError.isNotEmpty,
                    child: Text(
                      positionError,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(
                          0xffD80027,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Statuses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      statuses.add(
                        'Status is good',
                      );
                      setState(() {});
                    },
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.add,
                          color: AppColors.primaryColors,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Add Status',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColors,
                              height: 1.5),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            statuses[index],
                            style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                statuses.removeAt(index);
                                setState(() {});
                              },
                              icon: const Icon(
                                CupertinoIcons.clear_circled_solid,
                                color: Color(0xFFFF5C5C),
                                size: 18,
                              ))
                        ],
                      ),
                      Divider(height: 16)
                    ],
                  );
                },
                itemCount: statuses.length,
              ),
              BlocListener<WorkflowBloc, WorkflowState>(
                listener: (context, state) {
                  if (state is CreateWorkflowErrorState) {
                    CommonWidgets().showDialog(context, state.message);
                  } else if (state is CreateWorkflowSuccessState) {
                    Navigator.of(context).pop();
                  }
                },
                child: BlocBuilder<WorkflowBloc, WorkflowState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        if (validate()) {
                          BlocProvider.of<WorkflowBloc>(context).add(
                            CreateWorkflow(
                              json: {
                                'workflow_type': "Shop",
                                'title': titleController.text,
                                'color': code.value.toString(),
                                'position': positionController.text,
                                'parent_id': 0,
                              },
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fixedSize: Size(MediaQuery.of(context).size.width, 56),
                        primary: AppColors.primaryColors,
                      ),
                      child: state is CreateWorkflowLoadingState
                          ? const CupertinoActivityIndicator(
                              color: AppColors.greyText,
                            )
                          : const Text(
                              "Update",
                              style: TextStyle(
                                  letterSpacing: 1.1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        letterSpacing: 1.1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColors),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
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
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              maxLength: 50,
              onTap: label == "Color"
                  ? () {
                      log('here');
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => colorSelector(),
                      );
                    }
                  : null,
              // onSubmitted: (value) {},
              textInputAction: TextInputAction.done,
              keyboardType: label == 'Position' ? TextInputType.number : null,
              inputFormatters: label == 'Position'
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              readOnly: label == 'Color',
              decoration: InputDecoration(
                prefixIcon: label == 'Color' && controller.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircleAvatar(
                          backgroundColor: code,
                          radius: 1,
                        ),
                      )
                    : null,
                suffixIcon: label == 'Color'
                    ? const Icon(
                        CupertinoIcons.chevron_down,
                        color: AppColors.primaryColors,
                      )
                    : null,
                hintText: placeHolder,
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

  validate() {
    bool status = true;
    if (titleController.text.isEmpty) {
      titleError = "Title can't be empty";
      status = false;
    } else {
      titleError = '';
    }
    if (colorController.text.isEmpty) {
      colorError = "Color can't be empty";
      status = false;
    } else {
      colorError = '';
    }
    if (positionController.text.isEmpty) {
      positionError = "Position cant't be empty";
      status = false;
    } else {
      positionError = '';
    }
    setState(() {});
    return status;
  }

  colorSelector() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Colors",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTitleColor),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: LimitedBox(
                maxHeight: MediaQuery.of(context).size.height / 2 - 90,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          print("heyy");

                          colorController.text = colors[index]['name'];
                          code = Color(colors[index]['color']);
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Color(colors[index]['color']),
                                ),
                                Text(
                                  colors[index]['name'],
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: colors.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
