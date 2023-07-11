import 'dart:developer';

import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/bloc/service_bloc/service_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';

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

  //Add material popup controllers
  final addMaterialNameController = TextEditingController();
  final addMaterialDescriptionController = TextEditingController();
  final addMaterialPriceController = TextEditingController();
  final addMaterialCostController = TextEditingController();
  final addMaterialDiscountController = TextEditingController();
  final addMaterialBatchController = TextEditingController();

  //Add material errorstatus and error message variables
  bool addMaterailNameErrorStatus = false;
  bool addMaterialDescriptionErrorStatus = false;
  bool addMaterialPriceErrorStatus = false;
  bool addMaterialCostErrorStatus = false;
  bool addMaterialDiscountErrorStatus = false;
  bool addMaterailBatchErrorStatus = false;
  bool addMaterialPricingErrorStatus = false;

  dynamic _currentPricingModelSelectedValue;
  List<String> pricingModelList = ['per Sqrt', 'per feet'];

  String taxRateError = '';
  var dropdownValue;
  String categoryError = '';
  List<Datum> technicianData = [];

  bool rateErrorStatus = false;
  bool taxErrorStatus = false;

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
          'New Service',
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
          child: BlocProvider(
            create: (context) => ServiceBloc()..add(GetTechnicianEvent()),
            child: BlocListener<ServiceBloc, ServiceState>(
              listener: (context, state) {
                if (state is GetTechnicianState) {
                  technicianData.addAll(state.technicianModel.data);
                  print(technicianData);
                }
              },
              child: BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  return ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      textBox('Enter Service Name', serviceNameController,
                          'Service Name', serviceNameError.isNotEmpty, context),
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
                      textBox('Enter Notes', laborDescriptionController,
                          'Notes', laborDescriptionError.isNotEmpty, context),
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
                        "Technician",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff6A7187),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xffC1C4CD))),
                        child: DropdownButton<Datum>(
                          padding: const EdgeInsets.only(
                              top: 2, left: 16, right: 16),
                          isExpanded: true,
                          hint: const Text(
                            "Select",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.greyText),
                          ),
                          value: dropdownValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(color: Colors.transparent),
                          onChanged: (Datum? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              dropdownValue = value!;
                            });
                          },
                          items: technicianData
                              .map<DropdownMenuItem<Datum>>((category) {
                            return DropdownMenuItem<Datum>(
                              value: category,
                              child: Text(
                                category.firstName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.greyText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: Visibility(
                      //       visible: categoryError.isNotEmpty,
                      //       child: Text(
                      //         categoryError,
                      //         style: const TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(
                      //             0xffD80027,
                      //           ),
                      //         ),
                      //       )),
                      // ),
                      // const SizedBox(height: 16),
                      // textBox('Enter rate', rateController, 'Rate',
                      //     rateError.isNotEmpty, context),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: Visibility(
                      //       visible: rateError.isNotEmpty,
                      //       child: Text(
                      //         rateError,
                      //         style: const TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(
                      //             0xffD80027,
                      //           ),
                      //         ),
                      //       )),
                      // ),
                      // const SizedBox(height: 16),
                      // textBox('Enter rate...', taxController, 'Tax',
                      //     taxError.isNotEmpty, context),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: Visibility(
                      //       visible: taxError.isNotEmpty,
                      //       child: Text(
                      //         taxError,
                      //         style: const TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(
                      //             0xffD80027,
                      //           ),
                      //         ),
                      //       )),
                      // ),
                      // const SizedBox(height: 16),
                      // textBox('Enter percentage rate...', taxRateController,
                      //     'Tax Rate', taxRateError.isNotEmpty, context),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: Visibility(
                      //       visible: taxRateError.isNotEmpty,
                      //       child: Text(
                      //         taxRateError,
                      //         style: const TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(
                      //             0xffD80027,
                      //           ),
                      //         ),
                      //       )),
                      //  ),

                      addTileWidget("Material"),
                      addTileWidget("Part"),
                      addTileWidget("Labor"),
                      addTileWidget("Subcontract"),
                      addTileWidget("Fee"),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox(
                            "Enter Labor Rate",
                            rateController,
                            "Labor Rate *For this service",
                            rateErrorStatus,
                            context),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox("Enter Tax", taxRateController, "Tax",
                            taxErrorStatus, context),
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
      ),
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
            color: Color(0xff6A7187),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: label == "Price" || label == "Cost"
                ? MediaQuery.of(context).size.width / 2.6
                : MediaQuery.of(context).size.width,
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
      taxRateError = 'Tax Rate canot be empty';
    }
    setState(() {});
    return status;
  }

  addTileWidget(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primaryTitleColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (label == "Material") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      content: addMaterialPopup(),
                    );
                  },
                );
              }
            },
            child: const Row(
              children: [
                Icon(
                  Icons.add,
                  color: AppColors.primaryColors,
                ),
                Text(
                  "  Add New",
                  style: TextStyle(
                    color: AppColors.primaryColors,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  addMaterialPopup() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add Material",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor),
              ),
              Icon(Icons.close)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: textBox("Enter Material Name", addMaterialNameController,
                "Name", addMaterailNameErrorStatus, context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: textBox(
                "Enter Material Description",
                addMaterialDescriptionController,
                "Description",
                addMaterialDescriptionErrorStatus,
                context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textBox("Amount", addMaterialDescriptionController, "Price",
                    addMaterialDescriptionErrorStatus, context),
                pricingModelDropDown()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textBox("Amount", addMaterialDescriptionController, "Cost",
                    addMaterialDescriptionErrorStatus, context),
                pricingModelDropDown()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 17),
            child: textBox("Enter Amount", addMaterialDiscountController,
                "Discoount", addMaterialDiscountErrorStatus, context),
          )
        ],
      ),
    );
  }

  Widget pricingModelDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pricing Model",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff6A7187)),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 2.6,
            height: 56,
            // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
            // padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(
                    color: addMaterialPricingErrorStatus
                        ? const Color(0xffD80027)
                        : const Color(0xffC1C4CD)),
                borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButtonFormField<String>(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: AppColors.primaryColors,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  menuMaxHeight: 380,
                  isExpanded: true,
                  value: _currentPricingModelSelectedValue,
                  style: const TextStyle(color: Color(0xff6A7187)),
                  items: pricingModelList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      alignment: AlignmentDirectional.centerStart,
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  hint: const Text(
                    "Select Pricing Model",
                    style: TextStyle(
                        color: Color(0xff6A7187),
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _currentPricingModelSelectedValue = value;
                    });
                  },
                  //isExpanded: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
