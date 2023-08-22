import 'dart:developer';

import 'package:auto_pilot/Models/workflow_status_model.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/bloc/workflow/workflow_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CreateWorkflowScreen extends StatefulWidget {
  const CreateWorkflowScreen({super.key, required this.id, this.status});
  final String id;
  final ChildBucket? status;
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

  Color code = Colors.transparent;
  Color pickerColor = Colors.transparent;
  Color currentColor = Colors.transparent;
  List<String> statuses = [];

  @override
  void initState() {
    super.initState();
    if (widget.status != null) {
      titleController.text = widget.status!.title;
    }
  }

  final key = GlobalKey();

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
        child: BlocProvider(
          create: (context) => WorkflowBloc(),
          child: Padding(
            key: key,
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
                textBox('Estimate', titleController, 'Title',
                    titleError.isNotEmpty),
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
                // textBox('Select Position', positionController, 'Position',
                //     positionError.isNotEmpty),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: Visibility(
                //       visible: positionError.isNotEmpty,
                //       child: Text(
                //         positionError,
                //         style: const TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500,
                //           color: Color(
                //             0xffD80027,
                //           ),
                //         ),
                //       )),
                // ),
                // const SizedBox(height: 20),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text(
                //       'Statuses',
                //       style: TextStyle(
                //         fontSize: 18,
                //         fontWeight: FontWeight.w500,
                //         height: 1.5,
                //       ),
                //     ),
                //     GestureDetector(
                //       behavior: HitTestBehavior.translucent,
                //       onTap: () {
                //         statuses.add(
                //           'Status is good',
                //         );
                //         setState(() {});
                //       },
                //       child: const Row(
                //         children: [
                //           Icon(
                //             CupertinoIcons.add,
                //             color: AppColors.primaryColors,
                //             size: 16,
                //           ),
                //           SizedBox(width: 5),
                //           Text(
                //             'Add Status',
                //             style: TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w600,
                //                 color: AppColors.primaryColors,
                //                 height: 1.5),
                //           )
                //         ],
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(height: 24),
                // ListView.builder(
                //   physics: const NeverScrollableScrollPhysics(),
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     return Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //               statuses[index],
                //               style: TextStyle(
                //                 color: AppColors.primaryTitleColor,
                //                 fontWeight: FontWeight.w400,
                //                 fontSize: 16,
                //               ),
                //             ),
                //             IconButton(
                //                 onPressed: () {
                //                   statuses.removeAt(index);
                //                   setState(() {});
                //                 },
                //                 icon: const Icon(
                //                   CupertinoIcons.clear_circled_solid,
                //                   color: Color(0xFFFF5C5C),
                //                   size: 18,
                //                 ))
                //           ],
                //         ),
                //         Divider(height: 16)
                //       ],
                //     );
                //   },
                //   itemCount: statuses.length,
                // ),
                BlocListener<WorkflowBloc, WorkflowState>(
                  listener: (context, state) {
                    if (state is CreateWorkflowErrorState) {
                      CommonWidgets().showDialog(context, state.message);
                    } else if (state is CreateWorkflowSuccessState) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                BottomBarScreen(currentIndex: 1),
                          ),
                          (route) => false);
                    }
                  },
                  child: BlocBuilder<WorkflowBloc, WorkflowState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (validate()) {
                            if (widget.status != null) {
                              BlocProvider.of<WorkflowBloc>(context).add(
                                EditWorkflowBucketEvent(
                                  id: widget.status!.id.toString(),
                                  json: {
                                    'id': widget.status!.id.toString(),
                                    'workflow_type': "Shop",
                                    'title': titleController.text,
                                    'color': code
                                        .toString()
                                        .replaceAll(
                                            "MaterialColor(primary value: Color(0xff",
                                            "")
                                        .replaceAll(")", ""),
                                    'position': '0',
                                    'parent_id': widget.id,
                                  },
                                ),
                              );
                            } else {
                              BlocProvider.of<WorkflowBloc>(context).add(
                                CreateWorkflowBucketEvent(
                                  json: {
                                    'workflow_type': "Shop",
                                    'title': titleController.text,
                                    'color': code
                                        .toString()
                                        .replaceAll(
                                            "MaterialColor(primary value: Color(0xff",
                                            "")
                                        .replaceAll(")", ""),
                                    'position': '0',
                                    'parent_id': widget.id,
                                  },
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 56),
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
              maxLength: 25,
              onTap: label == "Color"
                  ? () {
                      showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => colorPickerDialog(context),
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

  Container colorPickerDialog(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  height: 5,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade300,
                  ),
                ),
                CupertinoButton(
                  child: const Text("Done"),
                  onPressed: () {
                    Map<Color, String> colorNames = {
                      Colors.red: 'Red',
                      Colors.pink: 'Pink',
                      Colors.purple: 'Purple',
                      Colors.deepPurple: 'Deep Purple',
                      Colors.indigo: 'Indigo',
                      Colors.blue: 'Blue',
                      Colors.lightBlue: 'Light Blue',
                      Colors.cyan: 'Cyan',
                      Colors.teal: 'Teal',
                      Colors.green: 'Green',
                      Colors.lightGreen: 'Light Green',
                      Colors.lime: 'Lime',
                      Colors.yellow: 'Yellow',
                      Colors.amber: 'Amber',
                      Colors.orange: 'Orange',
                      Colors.deepOrange: 'Deep Orange',
                      Colors.brown: 'Brown',
                      Colors.grey: 'Grey',
                      Colors.blueGrey: 'Blue Grey',
                      Colors.black: 'Black',
                    };
                    colorController.text =
                        colorNames[currentColor] ?? "Unknown";
                    code = currentColor;
                    setState(() {});
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            StatefulBuilder(builder: (context, setUI) {
              return BlockPicker(
                // portraitOnly: true,
                useInShowDialog: false,
                pickerColor: currentColor,
                onColorChanged: (color) {
                  currentColor = color;

                  setUI(() {});
                },
              );
            }),
          ],
        ),
      ),
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
    // if (positionController.text.isEmpty) {
    //   positionError = "Position cant't be empty";
    //   status = false;
    // } else {
    //   positionError = '';
    // }
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

                          // colorController.text = colors[index]['name'];
                          // code = Color(colors[index]['color']);
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
                                // CircleAvatar(
                                //   backgroundColor:
                                //       Color(colors[index]['color']),
                                // ),
                                // Text(
                                //   colors[index]['name'],
                                //   style: const TextStyle(
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.w500),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  // itemCount: colors.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
