import 'dart:developer';

import 'package:auto_pilot/Models/employee_creation_model.dart';
import 'package:auto_pilot/Models/role_model.dart';
import 'package:auto_pilot/Screens/add_company_details.dart';
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
  const CreateEmployeeScreen({super.key,required this.navigation});
  final String navigation;

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

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EmployeeBloc>(context);
    bloc.add(GetAllRoles());
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

              if(widget.navigation=="add_employee"){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => EmployeeListScreen(),
              ));

              }else{
                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => AddCompanyDetailsScreen(widgetIndex: 2),
              ));

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
                if(widget.navigation=="add_employee"){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => EmployeeListScreen(),
                ));

                }else{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AddCompanyDetailsScreen(widgetIndex: 2),
                ));

                }
              } else if (state is EmployeeCreateErrorState) {
                CommonWidgets().showDialog(context, state.message);
              } else if (state is EmployeeRolesSuccessState) {
                roles.clear();
                roles.addAll(state.roles);
              } else if (state is EmployeeCreateSuccessState) {
                // BlocProvider.of<EmployeeBloc>(context).add(GetAllEmployees());

                if(widget.navigation=="add_employee"){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => EmployeeListScreen(),
                ));

                }else{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => AddCompanyDetailsScreen(widgetIndex: 2),
                ));

                }
              
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
                    textBox('Enter your first name', firstNameController, 'First Name',
                        firstNameError.isNotEmpty, context),
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
                    textBox('Enter your last name', lastNameController, 'Last Name',
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
                    textBox('Enter your email', emailController, 'Email',
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
                    textBox('ex. (555) 555-5555', phoneController, 'Phone',
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
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(
                                0xffD80027,
                              ),
              ),
            ),
                      ],
                    ),
                    SizedBox(height: 10),
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
                                    role.name.toString().toUpperCase(),
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
                        : SizedBox(),
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
                    GestureDetector(
                      onTap: () async {
                        final validate = validation();
                        if (validate) {
                          final clientId = await AppUtils.getUserID();
                          print(phoneController.text.trim().replaceAll(RegExp(r'[^\w\s]+'),'').replaceAll(" ", ""));
                          bloc.add(
                            CreateEmployee(
                              model: EmployeeCreationModel(
                                clientId: int.parse(clientId),
                                email: emailController.text.trim(),
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                phone: phoneController.text.trim().replaceAll(RegExp(r'[^\w\s]+'),''),
                                role: dropdownValue,
                              ),
                            ),
                          );
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
              style:  TextStyle(
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
              keyboardType: label == 'Phone' ? TextInputType.phone : null,
              inputFormatters:
                  label == "Phone" ? [PhoneInputFormatter()] : null,
              maxLength: label == 'Phone'
                  ? 19
                  : label.contains('Name')
                      ? 100
                      : 50,
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
    } else if (phoneController.text.replaceAll(RegExp(r'[^\w\s]+'),'').replaceAll(" ", "").length < 6) {
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
    setState(() {});
    return status;
  }
}
