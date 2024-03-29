import 'dart:developer';

import 'package:auto_pilot/Models/employee_creation_model.dart';
import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Models/role_model.dart';
import 'package:auto_pilot/Screens/employee_details_screen.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen(
      {super.key, required this.navigation, this.employee});
  final String navigation;
  final Employee? employee;

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final TextEditingController firstNameController = TextEditingController();
  String firstNameError = '';
  final TextEditingController lastNameController = TextEditingController();
  String lastNameError = '';
  final TextEditingController emailController = TextEditingController();
  String emailError = '';
  final TextEditingController phoneController = TextEditingController();
  String phoneError = '';
  String dropdownValue = '';
  String positionError = '';
  final List<RoleModel> roles = [];

  late final EmployeeBloc bloc;

  populateDataToFields() {
    final employee = widget.employee!;
    firstNameController.text = employee.firstName ?? '';
    lastNameController.text = employee.lastName ?? '';
    emailController.text = employee.email ?? '';
    if (employee.phone != null) {
      phoneController.text = '(' +
          widget.employee!.phone!.substring(0, 3) +
          ')' +
          ' ' +
          widget.employee!.phone!.substring(3, 6) +
          "-" +
          widget.employee!.phone!.substring(6);
    }
    dropdownValue = employee.roles![0].name!;
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EmployeeBloc>(context);
    bloc.add(GetAllRoles());
    if (widget.employee != null) {
      populateDataToFields();
    }
  }

  Future<bool> networkCheck() async {
    final value = await AppUtils.getConnectivity().then((value) {
      return value;
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: Text(
          widget.navigation == "add_company" && widget.employee != null
              ? "Edit Employee"
              : widget.navigation == "edit_employee" && widget.employee != null
                  ? "Edit Employee"
                  : 'New Employee',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.navigation == "add_employee") {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const EmployeeListScreen(),
                ));
              } else if (widget.navigation == "edit_employee") {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        EmployeeDetailsScreen(employee: widget.employee!),
                  ),
                );
              } else {
                Navigator.of(context).pop(false);
              }
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
                if (widget.navigation == "add_employee") {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EmployeeListScreen(),
                  ));
                } else {
                  Navigator.of(context).pop(false);
                }
              } else if (state is EmployeeCreateErrorState) {
                CommonWidgets().showDialog(context, state.message);
              } else if (state is EmployeeRolesSuccessState) {
                roles.clear();
                roles.addAll(state.roles);
              } else if (state is EmployeeCreateSuccessState) {
                // BlocProvider.of<EmployeeBloc>(context).add(GetAllEmployees());

                if (widget.navigation == "add_employee") {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EmployeeListScreen(),
                  ));
                  CommonWidgets().showSuccessDialog(
                      context, 'Employee created successfully');
                } else {
                  Navigator.of(context).pop(true);
                }
              } else if (state is EditEmployeeSuccessState) {
                if (widget.navigation == "edit_employee") {
                  widget.employee!.firstName = firstNameController.text;
                  widget.employee!.lastName = lastNameController.text;
                  widget.employee!.email = emailController.text;
                  widget.employee!.phone = phoneController.text
                      .trim()
                      .replaceAll(RegExp(r'[^\w\s]+'), '')
                      .replaceAll(" ", "");
                  widget.employee!.roles![0].name = dropdownValue;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => EmployeeDetailsScreen(
                      employee: widget.employee!,
                    ),
                  ));
                } else {
                  Navigator.of(context).pop(true);
                }
                CommonWidgets().showSuccessDialog(
                    context, 'Employee updated successfully');
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
                    textBox('Enter First Name', firstNameController,
                        'First Name', firstNameError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: firstNameError.isNotEmpty,
                          child: Text(
                            firstNameError,
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
                    textBox('Enter Last Name', lastNameController, 'Last Name',
                        lastNameError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: lastNameError.isNotEmpty,
                          child: Text(
                            lastNameError,
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
                    textBox('Enter Your Email', emailController, 'Email',
                        emailError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: emailError.isNotEmpty,
                          child: Text(
                            emailError,
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
                    textBox('Ex. (555) 555-5555', phoneController, 'Phone',
                        phoneError.isNotEmpty, context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Visibility(
                          visible: phoneError.isNotEmpty,
                          child: Text(
                            phoneError,
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
                    const Row(
                      children: [
                        Text(
                          "Position",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6A7187),
                          ),
                        ),
                        Text(
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
                              padding: const EdgeInsets.only(
                                  top: 2, left: 16, right: 16),
                              isExpanded: true,
                              hint: const Text(
                                "Select",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryTitleColor),
                              ),
                              value: dropdownValue == '' ? null : dropdownValue,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.primaryColors,
                              ),
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(color: Colors.transparent),
                              onChanged: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: roles.map<DropdownMenuItem<String>>(
                                  (RoleModel role) {
                                return DropdownMenuItem<String>(
                                  value: role.name,
                                  child: Text(
                                    (role.name![0].toUpperCase() ?? '') +
                                        (role.name!.substring(1) ?? ''),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.greyText,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        : const SizedBox(),
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
                    const SizedBox(height: 77),
                    ElevatedButton(
                      onPressed: () async {
                        final validate = validation();

                        networkCheck().then((value) async {
                          if (!validate) {
                          } else if (value) {
                            final clientId = await AppUtils.getUserID();

                            if (widget.employee == null) {
                              bloc.add(
                                CreateEmployee(
                                  model: EmployeeCreationModel(
                                    clientId: int.parse(clientId),
                                    email: emailController.text.trim(),
                                    firstName: firstNameController.text.trim(),
                                    lastName: lastNameController.text.trim(),
                                    phone: phoneController.text
                                        .trim()
                                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                                        .replaceAll(" ", ""),
                                    role: dropdownValue,
                                  ),
                                ),
                              );
                            } else {
                              bloc.add(
                                EditEmployee(
                                  id: widget.employee!.id!,
                                  employee: EmployeeCreationModel(
                                    clientId: int.parse(clientId),
                                    email: emailController.text.trim(),
                                    firstName: firstNameController.text.trim(),
                                    lastName: lastNameController.text.trim(),
                                    phone: phoneController.text
                                        .trim()
                                        .replaceAll(RegExp(r'[^\w\s]+'), '')
                                        .replaceAll(" ", ""),
                                    role: dropdownValue,
                                  ),
                                ),
                              );
                            }
                          } else if (!value) {
                            CommonWidgets().showDialog(context,
                                'Please check your internet connection and try again');
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primaryColors,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        fixedSize: Size(MediaQuery.of(context).size.width, 56),
                      ),
                      child: Text(
                        widget.employee != null ? "Update" : "Confirm",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
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
              textCapitalization: label != "Email"
                  ? TextCapitalization.sentences
                  : TextCapitalization.none,
              keyboardType: label == 'Phone' ? TextInputType.number : null,
              inputFormatters:
                  label == "Phone" ? [PhoneInputFormatter()] : null,
              maxLength: label == 'Phone'
                  ? 14
                  : label.contains('Name')
                      ? 100
                      : 50,
              textInputAction: TextInputAction.next,
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
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text.trim());
    if (firstNameController.text.trim().isEmpty) {
      firstNameError = "First name can't be empty";
      status = false;
    } else if (firstNameController.text.trim().length < 2) {
      firstNameError = 'Enter a valid first name';
      status = false;
    } else {
      firstNameError = '';
    }

    if (lastNameController.text.trim().isEmpty) {
      lastNameError = "Last name can't be empty";
      status = false;
    } else if (lastNameController.text.trim().length < 2) {
      lastNameError = 'Enter a valid last name';
      status = false;
    } else {
      lastNameError = '';
    }

    if (emailController.text.trim().isEmpty) {
      emailError = "Email can't be empty";
      status = false;
    } else if (!emailValid) {
      emailError = 'Enter a valid email';
      status = false;
    } else {
      emailError = '';
    }
    if (phoneController.text.trim().isEmpty) {
      phoneError = "Phone number can't be empty";
      status = false;
    } else if (phoneController.text
            .replaceAll(RegExp(r'[^\w\s]+'), '')
            .replaceAll(" ", "")
            .length <
        10) {
      phoneError = 'Enter a valid phone number';
      status = false;
    } else {
      phoneError = '';
    }
    if (dropdownValue == '') {
      positionError = 'Please select a position';
      status = false;
    } else {
      positionError = '';
    }
    log("${dropdownValue}ROLE");
    setState(() {});
    return status;
  }
}
