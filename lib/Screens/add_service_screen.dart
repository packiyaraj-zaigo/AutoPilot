import 'dart:developer';

import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/bloc/service_bloc/service_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  String serviceId = '';

  List<CannedServiceAddModel> material = [];
  List<CannedServiceAddModel> part = [];
  List<CannedServiceAddModel> labor = [];
  CannedServiceCreateModel? service;
  String subTotal = '0.0';

  //Add material popup controllers
  final addMaterialNameController = TextEditingController();
  final addMaterialDescriptionController = TextEditingController();
  final addMaterialPriceController = TextEditingController();
  final addMaterialCostController = TextEditingController();
  final addMaterialDiscountController = TextEditingController();
  final addMaterialBatchController = TextEditingController();

  //Add material errorstatus and error message variables
  String adddMaterialNameErrorStatus = '';
  String addMaterialDescriptionErrorStatus = '';
  String addMaterialPriceErrorStatus = '';
  String addMaterialCostErrorStatus = '';
  String addMaterialDiscountErrorStatus = '';
  String adddMaterialBatchErrorStatus = '';
  String addMaterialPricingErrorStatus = '';

  //Add part popup controllers
  final addPartNameController = TextEditingController();
  final addPartDescriptionController = TextEditingController();
  final addPartPriceController = TextEditingController();
  final addPartCostController = TextEditingController();
  final addPartDiscountController = TextEditingController();
  final addPartPartNumberController = TextEditingController();

  //Add part errorstatus and error message variables
  String addPartNameErrorStatus = '';
  String addPartDescriptionErrorStatus = '';
  String addPartPriceErrorStatus = '';
  String addPartCostErrorStatus = '';
  String addPartDiscountErrorStatus = '';
  String adddPartPartNumberErrorStatus = '';
  String addPartPricingErrorStatus = '';

  //Add Labor popup controllers
  final addLaborNameController = TextEditingController();
  final addLaborDescriptionController = TextEditingController();
  final addLaborCostController = TextEditingController();
  final addLaborDiscountController = TextEditingController();
  final addLaborHoursController = TextEditingController();

  //Add Labor errorstatus and error message variables
  String addLaborNameErrorStatus = '';
  String addLaborDescriptionErrorStatus = '';
  String addLaborCostErrorStatus = '';
  String addLaborDiscountErrorStatus = '';
  String addLaborHoursErrorStatus = '';

  dynamic _currentPricingModelSelectedValue;
  List<String> pricingModelList = ['per Sqrt', 'per feet'];

  String taxRateError = '';
  var dropdownValue;
  String categoryError = '';
  List<Datum> technicianData = [];

  CountryCode? selectedCountry;
  final countryPicker = const FlCountryCodePicker();
  List<String> tagDataList = [];

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
            create: (context) => ServiceBloc(),
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
                      errorWidget(error: serviceNameError),
                      const SizedBox(height: 16),
                      textBox('Enter Notes', laborDescriptionController,
                          'Notes', laborDescriptionError.isNotEmpty, context),
                      errorWidget(error: laborDescriptionError),

                      const SizedBox(height: 16),
                      // const Text(
                      //   "Technician",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     color: Color(0xff6A7187),
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      // Container(
                      //   width: double.infinity,
                      //   height: 56,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       border: Border.all(color: const Color(0xffC1C4CD))),
                      //   child: DropdownButton<Datum>(
                      //     padding: const EdgeInsets.only(
                      //         top: 2, left: 16, right: 16),
                      //     isExpanded: true,
                      //     hint: const Text(
                      //       "Select",
                      //       style: TextStyle(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w400,
                      //           color: AppColors.greyText),
                      //     ),
                      //     value: dropdownValue,
                      //     icon: const Icon(Icons.keyboard_arrow_down),
                      //     elevation: 16,
                      //     style: const TextStyle(color: Colors.deepPurple),
                      //     underline: Container(color: Colors.transparent),
                      //     onChanged: (Datum? value) {
                      //       // This is called when the user selects an item.
                      //       setState(() {
                      //         dropdownValue = value!;
                      //       });
                      //     },
                      //     items: technicianData
                      //         .map<DropdownMenuItem<Datum>>((category) {
                      //       return DropdownMenuItem<Datum>(
                      //         value: category,
                      //         child: Text(
                      //           category.firstName,
                      //           style: const TextStyle(
                      //             fontSize: 16,
                      //             color: AppColors.greyText,
                      //             fontWeight: FontWeight.w400,
                      //           ),
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final item = material[index];
                          return Text(item.itemName);
                        },
                        itemCount: material.length,
                      ),

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
                            rateError.isNotEmpty,
                            context),
                      ),
                      errorWidget(error: rateError),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox("Enter Tax", taxController, "Tax",
                            taxError.isNotEmpty, context),
                      ),
                      errorWidget(error: taxError),

                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          final validate = validation();
                          if (validate) {
                            final clientId = await AppUtils.getUserID();
                            service = CannedServiceCreateModel(
                              clientId: int.parse(clientId),
                              serviceName: serviceNameController.text,
                              servicePrice: rateController.text,
                              discount: '0',
                              tax: taxController.text,
                              subTotal: (double.parse(rateController.text) +
                                      double.parse(taxController.text))
                                  .toString(),
                            );
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
      String label, bool errorStatus, BuildContext context,
      [StateSetter? setState]) {
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
              onChanged: label == 'Discount' ||
                      label == 'Price' ||
                      label == "Cost"
                  ? (value) {
                      if (addMaterialPriceController.text.isNotEmpty &&
                          addMaterialDiscountController.text.isNotEmpty) {
                        subTotal =
                            (double.parse(addMaterialPriceController.text) -
                                    double.parse(
                                        addMaterialDiscountController.text))
                                .toString();
                        setState!(() {});
                      } else if (addMaterialPriceController.text.isNotEmpty) {
                        subTotal = addMaterialPriceController.text;
                        setState!(() {});
                      }
                      if (label == 'Cost' &&
                          setState != null &&
                          addLaborCostController.text.isNotEmpty &&
                          addLaborDiscountController.text.isNotEmpty) {
                        subTotal = (double.parse(addLaborCostController.text) -
                                double.parse(addLaborDiscountController.text))
                            .toString();
                        setState(() {});
                      } else if (addLaborCostController.text.isNotEmpty &&
                          label == "Cost") {
                        subTotal = addLaborCostController.text;
                        setState!(() {});
                      }
                    }
                  : null,
              decoration: InputDecoration(
                suffixIcon: label == 'Discount'
                    ? const Icon(
                        CupertinoIcons.money_dollar,
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

  addMaterialValidation(StateSetter setState) {
    bool status = true;
    if (addMaterialNameController.text.trim().isEmpty) {
      adddMaterialNameErrorStatus = 'Service name cannot be empty';
      status = false;
    } else {
      adddMaterialNameErrorStatus = '';
    }
    if (addMaterialPriceController.text.trim().isEmpty) {
      addMaterialPriceErrorStatus = 'Price cannot be empty';
      status = false;
    } else {
      addMaterialPriceErrorStatus = '';
    }
    if (addMaterialDiscountController.text.trim().isEmpty) {
      addMaterialDiscountErrorStatus = 'Discount cannot be empty';
      status = false;
    } else {
      addMaterialDiscountErrorStatus = '';
    }

    setState(() {});
    return status;
  }

  addPartValidation(StateSetter setState) {
    bool status = true;
    if (addPartNameController.text.trim().isEmpty) {
      addPartNameErrorStatus = 'Service name cannot be empty';
      status = false;
    } else {
      addPartNameErrorStatus = '';
    }
    if (addPartPriceController.text.trim().isEmpty) {
      addPartPriceErrorStatus = 'Price cannot be empty';
      status = false;
    } else {
      addPartPriceErrorStatus = '';
    }
    if (addPartDiscountController.text.trim().isEmpty) {
      addPartDiscountErrorStatus = 'Discount cannot be empty';
      status = false;
    } else {
      addPartDiscountErrorStatus = '';
    }

    setState(() {});
    return status;
  }

  addLaborValidation(StateSetter setState) {
    bool status = true;
    if (addLaborNameController.text.trim().isEmpty) {
      addLaborNameErrorStatus = 'Service name cannot be empty';
      status = false;
    } else {
      addLaborNameErrorStatus = '';
    }
    if (addLaborCostController.text.trim().isEmpty) {
      addLaborCostErrorStatus = 'Cost cannot be empty';
      status = false;
    } else {
      addLaborCostErrorStatus = '';
    }
    if (addLaborDiscountController.text.trim().isEmpty) {
      addLaborDiscountErrorStatus = 'Discount cannot be empty';
      status = false;
    } else {
      addLaborDiscountErrorStatus = '';
    }

    setState(() {});
    return status;
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
      laborDescriptionError = 'Notes cannot be empty';
      status = false;
    } else if (laborDescriptionController.text.trim().length < 2) {
      laborDescriptionError = 'Notes should be greater than 2 characters';
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
      taxError = 'Tax Cannot be empty';
      status = false;
    } else {
      taxError = '';
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
                subTotal = '0.0';
                adddMaterialNameErrorStatus = '';
                addMaterialCostErrorStatus = '';
                addMaterialDescriptionErrorStatus = '';
                addMaterialDiscountErrorStatus = '';
                addMaterialPriceErrorStatus = '';
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      content: addMaterialPopup(),
                    );
                  },
                );
              } else if (label == 'Part') {
                subTotal = '0.0';

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      content: addPartPopup(),
                    );
                  },
                );
              } else if (label == 'Labor') {
                subTotal = '0.0';

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      content: addLaborPopup(),
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
    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Material",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTitleColor),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox("Enter Material Name", addMaterialNameController,
                    "Name", adddMaterialNameErrorStatus.isNotEmpty, context),
              ),
              errorWidget(error: adddMaterialNameErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: textBox(
                    "Enter Material Description",
                    addMaterialDescriptionController,
                    "Description",
                    addMaterialDescriptionErrorStatus.isNotEmpty,
                    context),
              ),
              errorWidget(error: addMaterialDescriptionErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textBox(
                        "Amount",
                        addMaterialPriceController,
                        "Price",
                        addMaterialPriceErrorStatus.isNotEmpty,
                        context,
                        newSetState),
                    pricingModelDropDown()
                  ],
                ),
              ),
              errorWidget(error: addMaterialPriceErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textBox("Amount", addMaterialCostController, "Cost",
                        addMaterialCostErrorStatus.isNotEmpty, context),
                    pricingModelDropDown()
                  ],
                ),
              ),
              errorWidget(error: addMaterialCostErrorStatus),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: textBox(
                    "Enter Amount",
                    addMaterialDiscountController,
                    "Discount",
                    addMaterialDiscountErrorStatus.isNotEmpty,
                    context,
                    newSetState),
              ),
              errorWidget(error: addMaterialDiscountErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Label",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6A7187),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        newSetState(() {
                          tagDataList.add("Tag");
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.primaryColors,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColors,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //  maxCrossAxisExtent: 150,
                    mainAxisSpacing: 20,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3),
                itemBuilder: (context, index) {
                  return tagWidget(tagDataList[index], index, newSetState);
                },
                itemCount: tagDataList.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: textBox(
                    "Enter Batch Number",
                    addMaterialBatchController,
                    "Part/Batch Number",
                    adddMaterialBatchErrorStatus.isNotEmpty,
                    context),
              ),
              errorWidget(error: adddMaterialBatchErrorStatus),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sub Total :",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor),
                    ),
                    Text(
                      "\$$subTotal",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 31),
                child: ElevatedButton(
                  onPressed: () {
                    final status = addMaterialValidation(newSetState);
                    if (status) {
                      material.add(CannedServiceAddModel(
                        cannedServiceId: int.parse(serviceId),
                        note: addMaterialDescriptionController.text,
                        part: addMaterialBatchController.text,
                        itemName: addMaterialNameController.text,
                        unitPrice: addMaterialPriceController.text,
                        discount: addMaterialDiscountController.text,
                        itemType: "Material",
                        subTotal:
                            (double.parse(addMaterialPriceController.text) -
                                    double.parse(
                                        addMaterialDiscountController.text))
                                .toString(),
                      ));
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 56),
                    primary: AppColors.primaryColors,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  addPartPopup() {
    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Part",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTitleColor),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox("Enter Part Name", addPartNameController, "Name",
                    addPartNameErrorStatus.isNotEmpty, context),
              ),
              errorWidget(error: addPartNameErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: textBox(
                    "Enter Part Description",
                    addPartDescriptionController,
                    "Description",
                    addPartDescriptionErrorStatus.isNotEmpty,
                    context),
              ),
              errorWidget(error: addPartDescriptionErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textBox(
                        "Amount",
                        addPartPriceController,
                        "Price",
                        addPartPriceErrorStatus.isNotEmpty,
                        context,
                        newSetState),
                    pricingModelDropDown()
                  ],
                ),
              ),
              errorWidget(error: addPartPriceErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: textBox("Amount", addPartCostController, "Cost ",
                    addPartCostErrorStatus.isNotEmpty, context),
              ),
              errorWidget(error: addPartCostErrorStatus),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: textBox(
                    "Enter Amount",
                    addPartDiscountController,
                    "Discount",
                    addPartDiscountErrorStatus.isNotEmpty,
                    context,
                    newSetState),
              ),
              errorWidget(error: addPartDiscountErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Label",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6A7187),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        newSetState(() {
                          tagDataList.add("Tag");
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.primaryColors,
                          ),
                          Text(
                            "Add New",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColors,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //  maxCrossAxisExtent: 150,
                    mainAxisSpacing: 20,
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3),
                itemBuilder: (context, index) {
                  return tagWidget(tagDataList[index], index, newSetState);
                },
                itemCount: tagDataList.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: textBox(
                    "Enter Part Number",
                    addPartPartNumberController,
                    "Part Number",
                    adddPartPartNumberErrorStatus.isNotEmpty,
                    context),
              ),
              errorWidget(error: adddPartPartNumberErrorStatus),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sub Total :",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor),
                    ),
                    Text(
                      "\$$subTotal",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 31),
                child: ElevatedButton(
                  onPressed: () {
                    final status = addPartValidation(newSetState);
                    if (status) {
                      part.add(CannedServiceAddModel(
                        cannedServiceId: int.parse(serviceId),
                        note: addPartDescriptionController.text,
                        part: addPartPartNumberController.text,
                        itemName: addPartNameController.text,
                        unitPrice: addPartPriceController.text,
                        discount: addPartDiscountController.text,
                        itemType: "Part",
                        subTotal: (double.parse(addPartPriceController.text) -
                                double.parse(addPartDiscountController.text))
                            .toString(),
                      ));
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 56),
                    primary: AppColors.primaryColors,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  addLaborPopup() {
    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Labor",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTitleColor),
                  ),
                  IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox("Enter Labor Name", addLaborNameController,
                    "Name", addLaborNameErrorStatus.isNotEmpty, context),
              ),
              errorWidget(error: addLaborNameErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: textBox(
                    "Enter Labor Description",
                    addLaborDescriptionController,
                    "Description",
                    addLaborDescriptionErrorStatus.isNotEmpty,
                    context),
              ),
              errorWidget(error: addLaborDescriptionErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: textBox("Hours", addLaborHoursController, "Hours ",
                    addLaborHoursErrorStatus.isNotEmpty, context, newSetState),
              ),
              errorWidget(error: addLaborHoursErrorStatus),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: textBox("Amount", addLaborCostController, "Cost ",
                    addLaborCostErrorStatus.isNotEmpty, context),
              ),
              errorWidget(error: addLaborCostErrorStatus),
              Padding(
                padding: EdgeInsets.only(top: 17),
                child: textBox(
                    "Enter Amount",
                    addLaborDiscountController,
                    "Discount",
                    addLaborDiscountErrorStatus.isNotEmpty,
                    context,
                    newSetState),
              ),
              errorWidget(error: addLaborDiscountErrorStatus),
              Padding(
                padding: EdgeInsets.only(top: 31),
                child: ElevatedButton(
                  onPressed: () {
                    final status = addLaborValidation(newSetState);
                    if (status) {
                      labor.add(CannedServiceAddModel(
                        cannedServiceId: int.parse(serviceId),
                        note: addLaborDescriptionController.text,
                        // part: addLaborLaborNumberController.text,
                        part: '',
                        itemName: addLaborNameController.text,
                        unitPrice: addLaborCostController.text,
                        discount: addLaborDiscountController.text,
                        quanityHours: addLaborHoursController.text,
                        itemType: "Labor",
                        subTotal: (double.parse(addLaborCostController.text) -
                                double.parse(addLaborDiscountController.text))
                            .toString(),
                      ));
                      setState(() {});
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    fixedSize: Size(MediaQuery.of(context).size.width, 56),
                    primary: AppColors.primaryColors,
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
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
                    color: addMaterialPricingErrorStatus.isNotEmpty
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

  Widget tagWidget(String tagName, index, StateSetter newSetState) {
    return Container(
      height: 35,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: const Color(0xffF4F4F4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                tagName,
                style: const TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTitleColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                  onTap: () {
                    newSetState(() {
                      tagDataList.removeAt(index);
                    });
                  },
                  child: SvgPicture.asset("assets/images/close_tag_icon.svg")),
            )
          ],
        ),
      ),
    );
  }
}

class errorWidget extends StatelessWidget {
  const errorWidget({
    super.key,
    required this.error,
  });

  final String error;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          )),
    );
  }
}
