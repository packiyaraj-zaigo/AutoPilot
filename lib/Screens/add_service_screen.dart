import 'dart:developer';

import 'package:auto_pilot/Models/employee_creation_model.dart';
import 'package:auto_pilot/Models/role_model.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final TextEditingController serviceNameController = TextEditingController();
  String serviceNameError = '';
  final TextEditingController laborDescriptionController =
      TextEditingController();
  String laborDescriptionError = '';
  final TextEditingController rateController = TextEditingController();
  String rateError = '';
  final TextEditingController taxController = TextEditingController();
  String taxError = '';
  final TextEditingController taxRateController = TextEditingController();
  String taxRateError = '';
  String dropdownValue = '';
  String categoryError = '';
  final List roles = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
    'Category 6',
  ];

  CountryCode? selectedCountry;
  final countryPicker = const FlCountryCodePicker();
  late final EmployeeBloc bloc;

  @override
  void initState() {
    super.initState();
    // bloc = BlocProvider.of<EmployeeBloc>(context);
    // bloc.add(GetAllRoles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'New Employee',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: BlocListener<EmployeeBloc, EmployeeState>(
            listener: (context, state) {
              if (state is EmployeeRolesErrorState) {
                CommonWidgets().showDialog(
                    context, 'Something went wrong please try again later');
                Navigator.pop(context);
              } else if (state is EmployeeCreateErrorState) {
                CommonWidgets().showDialog(context, state.message);
              } else if (state is EmployeeRolesSuccessState) {
                roles.clear();
                roles.addAll(state.roles);
              } else if (state is EmployeeCreateSuccessState) {
                BlocProvider.of<EmployeeBloc>(context).add(GetAllEmployees());
                Navigator.of(context).pop();
              }
            },
            child: BlocBuilder<EmployeeBloc, EmployeeState>(
              builder: (context, state) {
                if (state is EmployeeRolesLoadingState) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (state is EmployeeCreateLoadingState) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                return ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(
                          0xFF061237,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    textBox('Enter Name', serviceNameController, 'Service Name',
                        serviceNameError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: serviceNameError.isNotEmpty,
                          child: Text(
                            serviceNameError,
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
                    textBox(
                        'Enter Description',
                        laborDescriptionController,
                        'Labour Description',
                        laborDescriptionError.isNotEmpty,
                        context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: laborDescriptionError.isNotEmpty,
                          child: Text(
                            laborDescriptionError,
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
                    const Text(
                      "Category",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6A7187),
                      ),
                    ),
                    const SizedBox(height: 10),
                    roles.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xffC1C4CD))),
                            child: DropdownButton<String>(
                              padding:
                                  EdgeInsets.only(top: 2, left: 16, right: 16),
                              isExpanded: true,
                              hint: Text(
                                "Select Category",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyText),
                              ),
                              value: dropdownValue == '' ? null : dropdownValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(color: Colors.transparent),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: roles
                                  .map<DropdownMenuItem<String>>((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(
                                    category.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.greyText,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: categoryError.isNotEmpty,
                          child: Text(
                            categoryError,
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
                    textBox('Enter Rate', rateController, 'Rate',
                        rateError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: rateError.isNotEmpty,
                          child: Text(
                            rateError,
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
                    textBox('Enter Tax', taxController, 'Tax',
                        taxError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: taxError.isNotEmpty,
                          child: Text(
                            taxError,
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
                    textBox('Enter Percentage Rate', taxRateController,
                        'Tax Rate', taxRateError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: taxRateError.isNotEmpty,
                          child: Text(
                            taxRateError,
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
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () async {
                        final validate = validation();
                        if (validate) {
                          final clientId = await AppUtils.getUserID();
                          // bloc.add(
                          //   CreateEmployee(
                          //     model: EmployeeCreationModel(
                          //       clientId: int.parse(clientId),
                          //       email: rateController.text.trim(),
                          //       firstName: serviceNameController.text.trim(),
                          //       lastName:
                          //           laborDescriptionController.text.trim(),
                          //       phone: taxController.text.trim(),
                          //       role: dropdownValue,
                          //     ),
                          //   ),
                          // );
                          log(clientId.toString() +
                              ":::::::::::::::Client id:::::::::::");
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
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    CupertinoButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    const SizedBox(height: 34),
                  ],
                );
              },
            ),
          ),
        ),
      ),
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
                color: Color(0xff6A7187),
              ),
            ),
            label == 'Service Name' ||
                    label == 'Labour Description' ||
                    label == 'Rate' ||
                    label == 'Tax Rate'
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
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
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
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              decoration: InputDecoration(
                  suffixIcon: label == "State"
                      ? const Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.black,
                        )
                      : null,
                  hintText: placeHolder,
                  hintStyle: label == 'State'
                      ? const TextStyle(color: Colors.black)
                      : null,
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

  validation() {
    bool status = true;

    if (serviceNameController.text.trim().isEmpty) {
      serviceNameError = 'Service name cannot be empty';
      status = false;
    } else if (serviceNameController.text.trim().length < 2) {
      serviceNameError = 'Enter a valid Service name';
      status = false;
    } else {
      serviceNameError = '';
    }

    if (laborDescriptionController.text.trim().isEmpty) {
      laborDescriptionError = 'Description cannot be empty';
      status = false;
    } else if (laborDescriptionController.text.trim().length < 2) {
      laborDescriptionError = 'Enter a valid description';
      status = false;
    } else {
      laborDescriptionError = '';
    }

    if (rateController.text.trim().isEmpty) {
      rateError = 'Rate cannot be empty';
      status = false;
    } else {
      rateError = '';
    }
    if (taxController.text.trim().isEmpty) {
      status = false;
    } else if (taxController.text.trim().length < 2) {
      taxError = 'Enter a valid tax';
      status = false;
    } else {
      taxError = '';
    }
    if (dropdownValue == '') {
      categoryError = 'Category cannot be empty';
      status = false;
    } else {
      categoryError = '';
    }
    if (taxRateError == '') {
      taxRateError = 'Tax rate cannot be empty';
    }
    setState(() {});
    return status;
  }
}
