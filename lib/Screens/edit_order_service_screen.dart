import 'dart:developer';

import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/canned_service_model.dart' as cs;
import 'package:auto_pilot/Models/client_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/vendor_response_model.dart';
import 'package:auto_pilot/Screens/dummy_service.dart';
import 'package:auto_pilot/Screens/services_list_screen.dart';
import 'package:auto_pilot/bloc/service_bloc/service_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class EditOrderServiceScreen extends StatefulWidget {
  const EditOrderServiceScreen(
      {super.key,
      this.service,
      this.material,
      this.part,
      this.labor,
      this.subContract,
      this.fee,
      this.navigation,
      this.technicianId,
      required this.orderId});
  final cs.Datum? service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subContract;
  final List<CannedServiceAddModel>? fee;
  final String orderId;
  final String? technicianId;

  final String? navigation;

  @override
  State<EditOrderServiceScreen> createState() => _EditOrderServiceScreenState();
}

class _EditOrderServiceScreenState extends State<EditOrderServiceScreen> {
  final TextEditingController serviceNameController = TextEditingController();
  final List<VendorResponseModel> vendors = [];
  String serviceNameError = '';
  final TextEditingController laborDescriptionController =
      TextEditingController();
  String laborDescriptionError = '';
  final TextEditingController rateController = TextEditingController();
  String rateError = '';
  final TextEditingController taxController = TextEditingController();
  String taxError = '';
  String serviceId = '1';

  int? vendorId;
  bool isTax = false;
  bool isPercentage = false;

  final technicianController = TextEditingController();
  String technicianError = '';

  String technicianId = '0';

  CannedServiceCreateModel? service;
  List<CannedServiceAddModel> material = [];
  List<CannedServiceAddModel> part = [];
  List<CannedServiceAddModel> labor = [];
  List<CannedServiceAddModel> subContract = [];
  List<CannedServiceAddModel> fee = [];

  dynamic _currentPricingModelSelectedValue;
  List<String> pricingModelList = ['per Sqrt', 'per feet'];

  String taxRateError = '';
  var dropdownValue;
  String categoryError = '';
  List<Datum> technicianData = [];

  CountryCode? selectedCountry;
  final countryPicker = const FlCountryCodePicker();
  List<String> tagDataList = [];
  List<String> deletedItems = [];

  ClientModel? client;

  populateData() {
    serviceNameController.text = widget.service!.serviceName;
    laborDescriptionController.text = widget.service!.serviceNote.toString();
    rateController.text = widget.service!.servicePrice;
    taxController.text = widget.service!.tax;
    material.addAll(widget.material!);
    part.addAll(widget.part!);
    labor.addAll(widget.labor!);
    subContract.addAll(widget.subContract!);
    fee.addAll(widget.fee!);
  }

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
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
          widget.service != null ? "Edit Service" : 'New Service',
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
            create: (context) => ServiceBloc()
              ..add(GetClientByIdEvent())
              ..add(GetTechnicianEvent()),
            child: BlocListener<ServiceBloc, ServiceState>(
              listener: (context, state) {
                if (state is EditOrderServiceSuccessState) {
                  // if (widget.navigation != null) {
                  //   Navigator.pop(context);
                  // } else {
                  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (context) => ServicesListScreen(),
                  //   ));
                  // }
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return DummyServiceScreen(orderId: widget.orderId);
                    },
                  ));

                  CommonWidgets().showDialog(context, state.message);
                }
                if (state is CreateCannedOrderServiceErrorState) {
                  CommonWidgets().showDialog(context, state.message);
                }
                if (state is EditCannedServiceSuccessState) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ServicesListScreen(),
                  ));
                  CommonWidgets().showDialog(context, state.message);
                }
                if (state is EditCannedServiceErrorState) {
                  CommonWidgets().showDialog(context, state.message);
                }
                if (state is GetClientErrorState) {
                  if (widget.navigation != null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ServicesListScreen(),
                    ));
                  }
                  CommonWidgets().showDialog(context, state.message);
                }
                if (state is GetClientSuccessState) {
                  client = state.client;
                  rateController.text = client?.baseLaborCost ?? '0';
                }
                if (state is GetTechnicianState) {
                  print("correct state");
                  if (widget.technicianId != null &&
                      widget.technicianId != "") {
                    state.technicianModel.data.forEach((element) {
                      if (element.id.toString() == widget.technicianId) {
                        print(element.firstName + "tecchhh");
                        technicianController.text =
                            element.firstName + " " + element.lastName;
                        technicianId = element.id.toString();
                      }
                    });
                  }
                }
              },
              child: BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  if (state is CreateCannedOrderServiceLoadingState ||
                      state is EditCannedServiceLoadingState ||
                      state is GetClientLoadingState) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [CupertinoActivityIndicator()],
                      ),
                    );
                  }
                  return ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      textBox(
                          'Enter Service Name',
                          serviceNameController,
                          'Service Name',
                          serviceNameError.isNotEmpty,
                          context,
                          true),
                      errorWidget(error: serviceNameError),
                      const SizedBox(height: 16),
                      textBox(
                          'Enter Notes',
                          laborDescriptionController,
                          'Notes',
                          laborDescriptionError.isNotEmpty,
                          context,
                          false),
                      errorWidget(error: laborDescriptionError),

                      const SizedBox(height: 16),

                      textBox(
                          'Select Technician',
                          technicianController,
                          'Technician',
                          technicianError.isNotEmpty,
                          context,
                          false),
                      errorWidget(error: technicianError),

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
                        itemCount: material.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = material[index];
                          return Column(
                            children: [
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(item.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  // const Expanded(child: SizedBox()),
                                  Row(
                                    children: [
                                      Text('\$${item.subTotal} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.service != null &&
                                              item.id.isNotEmpty) {
                                            deletedItems
                                                .add(item.id.toString());
                                          }
                                          material.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Color(0xFFFF5C5C),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                            ],
                          );
                        },
                      ),

                      addTileWidget("Part"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: part.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = part[index];
                          return Column(
                            children: [
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(item.itemName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Row(
                                    children: [
                                      Text('\$${item.subTotal} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.service != null &&
                                              item.id.isNotEmpty) {
                                            deletedItems
                                                .add(item.id.toString());
                                          }
                                          part.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Color(0xFFFF5C5C),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                      addTileWidget("Labor"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: labor.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = labor[index];
                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(item.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Row(
                                    children: [
                                      Text('\$${item.subTotal} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.service != null &&
                                              item.id.isNotEmpty) {
                                            deletedItems
                                                .add(item.id.toString());
                                          }
                                          labor.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Color(0xFFFF5C5C),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                      addTileWidget("Subcontract"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: subContract.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = subContract[index];
                          return Column(
                            children: [
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(item.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Row(
                                    children: [
                                      Text('\$${item.subTotal} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.service != null &&
                                              item.id.isNotEmpty) {
                                            deletedItems
                                                .add(item.id.toString());
                                          }
                                          subContract.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Color(0xFFFF5C5C),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                      addTileWidget("Fee"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: fee.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = fee[index];
                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(item.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  Row(
                                    children: [
                                      Text('\$${item.subTotal} ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          if (widget.service != null &&
                                              item.id.isNotEmpty) {
                                            deletedItems
                                                .add(item.id.toString());
                                          }
                                          fee.removeAt(index);
                                          setState(() {});
                                        },
                                        child: const Icon(
                                          CupertinoIcons.clear_thick_circled,
                                          color: Color(0xFFFF5C5C),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox(
                            "Enter Labor Rate",
                            rateController,
                            "Labor Rate *For this service",
                            rateError.isNotEmpty,
                            context,
                            true),
                      ),
                      errorWidget(error: rateError),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 16.0),
                      //   child: textBox("Enter Tax", taxController, "Tax",
                      //       taxError.isNotEmpty, context, true),
                      // ),
                      // errorWidget(error: taxError),

                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          final validate = validation();
                          if (validate) {
                            log('Here');
                            await AppUtils.getUserID().then((clientId) {
                              double subT = 0;
                              material.forEach((element) {
                                subT += double.parse(element.subTotal);
                              });
                              part.forEach((element) {
                                subT += double.parse(element.subTotal);
                              });
                              labor.forEach((element) {
                                subT += double.parse(element.subTotal);
                              });
                              subContract.forEach((element) {
                                subT += double.parse(element.subTotal);
                              });
                              fee.forEach((element) {
                                subT += double.parse(element.subTotal);
                              });
                              subT += double.tryParse(rateController.text) ?? 0;
                              subT += (double.tryParse(rateController.text) ??
                                      0) *
                                  (double.tryParse(taxController.text) ?? 0) /
                                  100;

                              service = CannedServiceCreateModel(
                                clientId: int.parse(clientId),
                                serviceName: serviceNameController.text,
                                serviceNote: laborDescriptionController.text,
                                servicePrice: rateController.text,
                                discount: '0',
                                tax: taxController.text,
                                subTotal: subT.toStringAsFixed(2),
                              );
                              log(subT.toString());
                              if (widget.service != null) {
                                BlocProvider.of<ServiceBloc>(context).add(
                                  EditOrderServiceEvent(
                                      id: widget.service!.id.toString(),
                                      service: service!,
                                      material: material.isEmpty
                                          ? null
                                          : material
                                              .where(
                                                  (element) => element.id == '')
                                              .toList(),
                                      part: part.isEmpty
                                          ? null
                                          : part
                                              .where(
                                                  (element) => element.id == '')
                                              .toList(),
                                      labor: labor.isEmpty
                                          ? null
                                          : labor
                                              .where(
                                                  (element) => element.id == '')
                                              .toList(),
                                      subcontract: subContract.isEmpty
                                          ? null
                                          : subContract
                                              .where(
                                                  (element) => element.id == '')
                                              .toList(),
                                      fee: fee.isEmpty
                                          ? null
                                          : fee
                                              .where(
                                                  (element) => element.id == '')
                                              .toList(),
                                      deletedItems: deletedItems,
                                      technicianId: technicianId),
                                );
                                log(deletedItems.toString());
                              } else {
                                BlocProvider.of<ServiceBloc>(context).add(
                                  CreateCannedOrderServiceEvent(
                                    service: service!,
                                    material:
                                        material.isEmpty ? null : material,
                                    part: part.isEmpty ? null : part,
                                    labor: labor.isEmpty ? null : labor,
                                    subcontract: subContract.isEmpty
                                        ? null
                                        : subContract,
                                    fee: fee.isEmpty ? null : fee,
                                  ),
                                );
                              }
                            });
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
                            widget.service != null ? 'Update' : "Confirm",
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
      String label, bool errorStatus, BuildContext context, bool isRequired,
      [StateSetter? setState]) {
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
            isRequired
                ? const Text(
                    " *",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xffD80027,
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: label == "Price" || label == "Cost" || label == "Quantity"
                ? MediaQuery.of(context).size.width / 2.6
                : MediaQuery.of(context).size.width,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: setState != null
                  ? (value) {
                      setState(() {});
                    }
                  : null,
              readOnly: label == "Vendor" || label == "Technician",
              onTap: label == "Vendor"
                  ? () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return vendorsBottomSheet(controller, vendorId);
                          },
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent);
                    }
                  : label == "Technician"
                      ? () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return technicianBottomSheet();
                            },
                          );
                        }
                      : null,
              controller: controller,
              keyboardType: label == 'Discount' ||
                      label == 'Cost' ||
                      label == 'Cost ' ||
                      label == 'Price' ||
                      label == 'Tax' ||
                      label.contains('Labor Rate') ||
                      label == "Hours" ||
                      label == 'Price ' ||
                      label == "Quantity"
                  ? TextInputType.number
                  : null,
              inputFormatters: label == "Hours"
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : label == 'Discount' ||
                          label == 'Cost' ||
                          label == 'Cost ' ||
                          label == 'Price' ||
                          label == 'Tax' ||
                          label.contains('Labor Rate') ||
                          label == 'Price ' ||
                          label == "Quantity"
                      ? [NumberInputFormatter()]
                      : [],
              maxLength: 50,
              decoration: InputDecoration(
                suffixIcon: label.contains("Labor Rate")
                    ? const Icon(
                        CupertinoIcons.money_dollar,
                        color: AppColors.primaryColors,
                      )
                    : label == "Vendor" || label == "Technician"
                        ? const Icon(
                            CupertinoIcons.chevron_down,
                            color: AppColors.primaryColors,
                          )
                        : label == "Tax"
                            ? const Icon(
                                Icons.percent,
                                color: AppColors.primaryColors,
                                // size: 18,
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

    if (laborDescriptionController.text.trim().isNotEmpty &&
        laborDescriptionController.text.trim().length < 2) {
      laborDescriptionError = 'Notes should be atleast 2 characters';
      status = false;
    } else if (laborDescriptionController.text.trim().isNotEmpty &&
        laborDescriptionController.text.trim().length > 50) {
      laborDescriptionError = "Notes can't be more than 50 characters";
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
    // if (technicianController.text.trim().isEmpty) {
    //   technicianError = 'Technician cannot be empty';
    //   status = false;
    // } else {
    //   technicianError = '';
    // }

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
              isPercentage = false;
              if (label == "Material") {
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
              } else if (label == "Fee") {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      content: addFeePopup(),
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      content: addSubContractPopup(),
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
    //Add material popup controllers
    final addMaterialNameController = TextEditingController();
    final addMaterialDescriptionController = TextEditingController();
    final addMaterialPriceController = TextEditingController();
    final addMaterialCostController = TextEditingController();
    final addMaterialDiscountController = TextEditingController(text: '0');
    final addMaterialBatchController = TextEditingController();

    //Add material errorstatus and error message variables
    String adddMaterialNameErrorStatus = '';
    String addMaterialDescriptionErrorStatus = '';
    String addMaterialPriceErrorStatus = '';
    String addMaterialCostErrorStatus = '';
    String addMaterialDiscountErrorStatus = '';
    String adddMaterialBatchErrorStatus = '';

    double subTotal = 0;
    double total = 0;

    addMaterialValidation(StateSetter setState) {
      bool status = true;
      if (addMaterialNameController.text.trim().isEmpty) {
        adddMaterialNameErrorStatus = "Material name can't be empty";
        status = false;
      } else {
        if (addMaterialNameController.text.trim().length < 2) {
          adddMaterialNameErrorStatus =
              "Material name must be alteast 2 characters";
          status = false;
        } else {
          adddMaterialNameErrorStatus = '';
        }
      }
      // if (addMaterialDescriptionController.text.trim().isEmpty) {
      //   addMaterialDescriptionErrorStatus = "Description can't be empty";
      //   status = false;
      // } else {
      //   addMaterialDescriptionErrorStatus = '';
      // }
      if (addMaterialPriceController.text.trim().isEmpty) {
        addMaterialPriceErrorStatus = "Price can't be empty";
        status = false;
      } else {
        addMaterialPriceErrorStatus = '';
      }
      if (addMaterialDiscountController.text.trim().isNotEmpty &&
          isPercentage &&
          double.parse(addMaterialDiscountController.text) > 100) {
        addMaterialDiscountErrorStatus = 'Discount should be less than 100';
        status = false;
      } else if (addMaterialDiscountController.text.trim().isNotEmpty &&
          subTotal < 0) {
        addMaterialDiscountErrorStatus = 'Discount should be less than price';
        status = false;
      } else {
        addMaterialDiscountErrorStatus = '';
      }
      // if (addMaterialBatchController.text.trim().isEmpty) {
      //   adddMaterialBatchErrorStatus = "Part Batch Number can't be empty";
      //   status = false;
      // } else {
      //   adddMaterialBatchErrorStatus = '';
      // }

      setState(() {});
      return status;
    }

    return StatefulBuilder(
      builder: (context, StateSetter newSetState) {
        if (addMaterialPriceController.text.isNotEmpty) {
          if (client?.taxOnMaterial == 'N') {
            if (addMaterialDiscountController.text.isEmpty) {
              subTotal =
                  (double.tryParse(addMaterialPriceController.text) ?? 0);
            } else {
              if (isPercentage) {
                subTotal = (double.tryParse(addMaterialPriceController.text) ??
                        0) -
                    ((double.tryParse(addMaterialPriceController.text) ?? 0) *
                            (double.tryParse(
                                    addMaterialDiscountController.text) ??
                                0)) /
                        100;
              } else {
                subTotal = ((double.tryParse(addMaterialPriceController.text) ??
                        0) -
                    (double.tryParse(addMaterialDiscountController.text) ?? 0));
              }
            }
            total = subTotal;
          } else {
            final tax =
                (double.tryParse(client?.materialTaxRate ?? '') ?? 0) / 100;

            if (addMaterialDiscountController.text.isEmpty) {
              subTotal =
                  (double.tryParse(addMaterialPriceController.text) ?? 0) *
                          tax +
                      (double.tryParse(addMaterialPriceController.text) ?? 0);
              total = (double.tryParse(addMaterialPriceController.text) ?? 0);
            } else {
              double discount =
                  double.tryParse(addMaterialDiscountController.text) ?? 0;
              if (isPercentage) {
                discount = ((double.tryParse(addMaterialPriceController.text) ??
                            0) *
                        (double.tryParse(addMaterialDiscountController.text) ??
                            0)) /
                    100;
              }

              subTotal =
                  ((double.tryParse(addMaterialPriceController.text) ?? 0) -
                              discount) *
                          tax +
                      ((double.tryParse(addMaterialPriceController.text) ?? 0) -
                          discount);
              total = (double.tryParse(addMaterialPriceController.text) ?? 0) -
                  (discount);
            }
          }
        }
        return Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox(
                            "Enter Material Name",
                            addMaterialNameController,
                            "Name",
                            adddMaterialNameErrorStatus.isNotEmpty,
                            context,
                            true),
                      ),
                      errorWidget(error: adddMaterialNameErrorStatus),
                      Padding(
                        padding: const EdgeInsets.only(top: 17.0),
                        child: textBox(
                            "Enter Material Description",
                            addMaterialDescriptionController,
                            "Description",
                            addMaterialDescriptionErrorStatus.isNotEmpty,
                            context,
                            false),
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
                              true,
                              newSetState,
                            ),
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
                            textBox(
                                "Amount",
                                addMaterialCostController,
                                "Cost",
                                addMaterialCostErrorStatus.isNotEmpty,
                                context,
                                false),
                            pricingModelDropDown()
                          ],
                        ),
                      ),
                      errorWidget(error: addMaterialCostErrorStatus),
                      Stack(
                        children: [
                          textBox(
                              "Enter Amount",
                              addMaterialDiscountController,
                              "Discount",
                              addMaterialDiscountErrorStatus.isNotEmpty,
                              context,
                              false,
                              newSetState),
                          Positioned(
                            right: 10,
                            top: 42,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    isPercentage = false;
                                    newSetState(() {});
                                  },
                                  child: Icon(
                                    CupertinoIcons.money_dollar,
                                    color: isPercentage
                                        ? AppColors.greyText
                                        : AppColors.primaryColors,
                                  ),
                                ),
                                Text(
                                  '  /  ',
                                  style: TextStyle(
                                    color: AppColors.greyText,
                                    fontSize: 18,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    isPercentage = true;
                                    newSetState(() {});
                                  },
                                  child: Icon(
                                    Icons.percent,
                                    color: !isPercentage
                                        ? AppColors.greyText
                                        : AppColors.primaryColors,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      errorWidget(error: addMaterialDiscountErrorStatus),
                      Padding(
                        padding: EdgeInsets.only(top: 17),
                        child: textBox(
                            "Enter Batch Number",
                            addMaterialBatchController,
                            "Part/Batch Number",
                            adddMaterialBatchErrorStatus.isNotEmpty,
                            context,
                            false),
                      ),
                      errorWidget(error: adddMaterialBatchErrorStatus),
                      Padding(
                        padding: EdgeInsets.only(top: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total :",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTitleColor),
                            ),
                            Text(
                              "\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTitleColor),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tax :",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTitleColor),
                            ),
                            Text(
                              "\$${(subTotal - total).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTitleColor),
                            )
                          ],
                        ),
                      ),
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
                              "\$${subTotal.toStringAsFixed(2)}",
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
                                discount: addMaterialDiscountController.text
                                        .trim()
                                        .isEmpty
                                    ? "0"
                                    : addMaterialDiscountController.text.trim(),
                                discountType: isPercentage &&
                                        addMaterialDiscountController
                                            .text.isNotEmpty
                                    ? "Percentage"
                                    : "Fixed",
                                itemType: "Material",
                                subTotal: subTotal.toStringAsFixed(2),
                                tax: client!.taxOnMaterial == "Y"
                                    ? client!.materialTaxRate ?? '0'
                                    : '0',
                              ));
                              setState(() {});
                              Navigator.pop(context);
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
              ),
            ),
          ],
        );
      },
    );
  }

  addPartPopup() {
    //Add part popup controllers
    final addPartNameController = TextEditingController();
    final addPartDescriptionController = TextEditingController();
    final addPartPriceController = TextEditingController();
    final addPartCostController = TextEditingController();
    final addPartDiscountController = TextEditingController(text: '0');
    final addPartPartNumberController = TextEditingController();
    final addPartQuantityController = TextEditingController(text: '1');

    //Add part errorstatus and error message variables
    String addPartNameErrorStatus = '';
    String addPartDescriptionErrorStatus = '';
    String addPartQuantityErrorStatus = '';
    String addPartPriceErrorStatus = '';
    String addPartCostErrorStatus = '';
    String addPartDiscountErrorStatus = '';
    String adddPartPartNumberErrorStatus = '';

    double subTotal = 0;
    double total = 0;

    addPartValidation(StateSetter setState) {
      bool status = true;
      if (addPartNameController.text.trim().isEmpty) {
        addPartNameErrorStatus = "Part name can't be empty";
        status = false;
      } else {
        if (addPartNameController.text.trim().length < 2) {
          addPartNameErrorStatus = "Part name must be atlest 2 characters";
          status = false;
        } else {
          addPartNameErrorStatus = '';
        }
      }
      // if (addPartDescriptionController.text.trim().isEmpty) {
      //   addPartDescriptionErrorStatus = "Description can't be empty";
      //   status = false;
      // } else {
      //   addPartDescriptionErrorStatus = '';
      // }
      if (addPartPriceController.text.trim().isEmpty) {
        addPartPriceErrorStatus = "Price can't be empty";
        status = false;
      } else {
        addPartPriceErrorStatus = '';
      }
      if (addPartQuantityController.text.trim().isEmpty) {
        addPartQuantityErrorStatus = "Quantity can't be empty";
        status = false;
      } else if (double.parse(addPartQuantityController.text.trim()) < 1) {
        addPartQuantityErrorStatus = "Enter a valid quantity";
        status = false;
      } else {
        addPartQuantityErrorStatus = '';
      }
      if (addPartDiscountController.text.trim().isNotEmpty &&
          isPercentage &&
          double.parse(addPartDiscountController.text) > 100) {
        addPartDiscountErrorStatus = 'Discount should be less than 100';
        status = false;
      } else if (addPartDiscountController.text.trim().isNotEmpty &&
          subTotal < 0) {
        addPartDiscountErrorStatus = "Discount cannot be greater than price";
        status = false;
      } else {
        addPartDiscountErrorStatus = '';
      }

      setState(() {});
      return status;
    }

    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      if (addPartPriceController.text.isNotEmpty) {
        if (addPartQuantityController.text.isNotEmpty) {
          double quantity =
              double.tryParse(addPartQuantityController.text) ?? 1;
          if (client?.taxOnParts == "N") {
            if (addPartDiscountController.text.isEmpty) {
              subTotal = (double.tryParse(addPartPriceController.text) ?? 0) *
                  quantity;
            } else {
              double discount =
                  double.tryParse(addPartDiscountController.text) ?? 0;
              if (isPercentage) {
                discount =
                    (((double.tryParse(addPartPriceController.text) ?? 0) *
                                quantity) *
                            (double.tryParse(addPartDiscountController.text) ??
                                0)) /
                        100;
              }
              subTotal = ((double.tryParse(addPartPriceController.text) ?? 0) *
                      quantity) -
                  discount;
            }
            total = subTotal;
          } else {
            final tax =
                (double.tryParse(client?.salesTaxRate ?? '') ?? 0) / 100;
            if (addPartDiscountController.text.isEmpty) {
              subTotal = ((double.tryParse(addPartPriceController.text) ?? 0) *
                          quantity) *
                      tax +
                  ((double.tryParse(addPartPriceController.text) ?? 0) *
                      quantity);
              total = ((double.tryParse(addPartPriceController.text) ?? 0) *
                  quantity);
            } else {
              double discount =
                  double.tryParse(addPartDiscountController.text) ?? 0;
              if (isPercentage) {
                discount =
                    (((double.tryParse(addPartPriceController.text) ?? 0) *
                                quantity) *
                            (double.tryParse(addPartDiscountController.text) ??
                                0)) /
                        100;
              }
              subTotal = (((double.tryParse(addPartPriceController.text) ?? 0) *
                              quantity) -
                          discount) *
                      tax +
                  (((double.tryParse(addPartPriceController.text) ?? 0) *
                          quantity) -
                      discount);
              total = (((double.tryParse(addPartPriceController.text) ?? 0) *
                      quantity) -
                  discount);
            }
          }
        }
      }
      return Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: textBox(
                          "Enter Part Name",
                          addPartNameController,
                          "Name",
                          addPartNameErrorStatus.isNotEmpty,
                          context,
                          true),
                    ),
                    errorWidget(error: addPartNameErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Enter Part Description",
                          addPartDescriptionController,
                          "Description",
                          addPartDescriptionErrorStatus.isNotEmpty,
                          context,
                          false),
                    ),
                    errorWidget(error: addPartDescriptionErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textBox(
                              "Enter Price",
                              addPartPriceController,
                              "Price",
                              addPartPriceErrorStatus.isNotEmpty,
                              context,
                              true,
                              newSetState),
                          textBox(
                              "Amount",
                              addPartQuantityController,
                              "Quantity",
                              addPartQuantityErrorStatus.isNotEmpty,
                              context,
                              true,
                              newSetState),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: errorWidget(
                            error: addPartPriceErrorStatus,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.7,
                          child: errorWidget(
                            error: addPartQuantityErrorStatus,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox("Amount", addPartCostController, "Cost ",
                          addPartCostErrorStatus.isNotEmpty, context, false),
                    ),
                    errorWidget(error: addPartCostErrorStatus),
                    Stack(
                      children: [
                        textBox(
                            "Enter Amount",
                            addPartDiscountController,
                            "Discount",
                            addPartDiscountErrorStatus.isNotEmpty,
                            context,
                            false,
                            newSetState),
                        Positioned(
                          right: 10,
                          top: 42,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  isPercentage = false;
                                  newSetState(() {});
                                },
                                child: Icon(
                                  CupertinoIcons.money_dollar,
                                  color: isPercentage
                                      ? AppColors.greyText
                                      : AppColors.primaryColors,
                                ),
                              ),
                              Text(
                                '  /  ',
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  isPercentage = true;
                                  newSetState(() {});
                                },
                                child: Icon(
                                  Icons.percent,
                                  color: !isPercentage
                                      ? AppColors.greyText
                                      : AppColors.primaryColors,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    errorWidget(error: addPartDiscountErrorStatus),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: textBox(
                          "Enter Part Number",
                          addPartPartNumberController,
                          "Part Number",
                          adddPartPartNumberErrorStatus.isNotEmpty,
                          context,
                          false),
                    ),
                    errorWidget(error: adddPartPartNumberErrorStatus),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tax :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${(subTotal - total).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
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
                            "\$${subTotal.toStringAsFixed(2)}",
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
                              quanityHours: addPartQuantityController.text,
                              discount:
                                  addPartDiscountController.text.trim().isEmpty
                                      ? "0"
                                      : addPartDiscountController.text.trim(),
                              discountType: isPercentage &&
                                      addPartDiscountController.text.isNotEmpty
                                  ? "Percentage"
                                  : "Fixed",
                              itemType: "Part",
                              subTotal: subTotal.toStringAsFixed(2),
                              tax: client!.taxOnParts == "Y"
                                  ? client!.salesTaxRate ?? '0'
                                  : '0',
                            ));
                            setState(() {});
                            Navigator.pop(context);
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
            ),
          ),
        ],
      );
    });
  }

  addLaborPopup() {
    //Add Labor popup controllers
    final addLaborNameController = TextEditingController();
    final addLaborDescriptionController = TextEditingController();
    final addLaborCostController = TextEditingController();
    final addLaborDiscountController = TextEditingController(text: '0');
    final addLaborHoursController = TextEditingController(text: '1');
    final addLaborBaseCostController =
        TextEditingController(text: client?.baseLaborCost ?? '');

    //Add Labor errorstatus and error message variables
    String addLaborNameErrorStatus = '';
    String addLaborDescriptionErrorStatus = '';
    String addLaborCostErrorStatus = '';
    String addLaborDiscountErrorStatus = '';
    String addLaborHoursErrorStatus = '';
    String addLaborBaseCostStatus = '';

    double subTotal = 0;
    double total = 0;

    addLaborValidation(StateSetter setState) {
      bool status = true;
      if (addLaborNameController.text.trim().isEmpty) {
        addLaborNameErrorStatus = "Labor name can't be empty";
        status = false;
      } else {
        if (addLaborNameController.text.trim().length < 2) {
          addLaborNameErrorStatus = "Labor name must be atleast 2 characters";
          status = false;
        } else {
          addLaborNameErrorStatus = '';
        }
      }
      if (addLaborBaseCostController.text.trim().isEmpty) {
        addLaborBaseCostStatus = "Base Cost can't be empty";
        status = false;
      } else {
        addLaborBaseCostStatus = '';
      }
      if (addLaborHoursController.text.trim().isEmpty) {
        addLaborHoursErrorStatus = "Hours can't be empty";
        status = false;
      } else {
        addLaborHoursErrorStatus = '';
      }

      if (addLaborDiscountController.text.isNotEmpty &&
          isPercentage &&
          double.parse(addLaborDiscountController.text) > 100) {
        addLaborDiscountErrorStatus = 'Discount should be less than 100';
        status = false;
      } else if (addLaborDiscountController.text.isNotEmpty && subTotal < 0) {
        addLaborDiscountErrorStatus = "Discount cannot be greater than price";
        status = false;
      } else {
        addLaborDiscountErrorStatus = '';
      }

      setState(() {});
      return status;
    }

    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      if (addLaborCostController.text.isNotEmpty) {
        if (client?.taxOnLabors == 'N') {
          if (addLaborDiscountController.text.isEmpty) {
            subTotal = (double.tryParse(addLaborCostController.text) ?? 0);
          } else {
            double discount =
                double.tryParse(addLaborDiscountController.text) ?? 0;
            if (isPercentage) {
              discount = ((double.tryParse(addLaborCostController.text) ?? 0) *
                      (double.tryParse(addLaborDiscountController.text) ?? 0)) /
                  100;
            }
            subTotal = ((double.tryParse(addLaborCostController.text) ?? 0) -
                discount);
          }
          total = subTotal;
        } else {
          final tax = (double.tryParse(client?.laborTaxRate ?? '') ?? 0) / 100;
          if (addLaborDiscountController.text.isEmpty) {
            subTotal = ((double.tryParse(addLaborHoursController.text) ?? 1) *
                        (double.tryParse(addLaborCostController.text) ?? 0)) *
                    tax +
                ((double.tryParse(addLaborHoursController.text) ?? 1) *
                    (double.tryParse(addLaborCostController.text) ?? 0));
            total = ((double.tryParse(addLaborHoursController.text) ?? 1) *
                (double.tryParse(addLaborCostController.text) ?? 0));
          } else {
            double discount =
                double.tryParse(addLaborDiscountController.text) ?? 0;
            if (isPercentage) {
              discount = ((double.tryParse(addLaborCostController.text) ?? 0) *
                      (double.tryParse(addLaborHoursController.text) ?? 0) *
                      (double.tryParse(addLaborDiscountController.text) ?? 0)) /
                  100;
            }
            subTotal = (((double.tryParse(addLaborHoursController.text) ?? 1) *
                            (double.tryParse(addLaborCostController.text) ??
                                0)) -
                        discount) *
                    tax +
                (((double.tryParse(addLaborHoursController.text) ?? 1) *
                        (double.tryParse(addLaborCostController.text) ?? 0)) -
                    discount);
            total = (((double.tryParse(addLaborHoursController.text) ?? 1) *
                    (double.tryParse(addLaborCostController.text) ?? 0)) -
                discount);
          }
        }
      }
      return Column(
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
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: textBox(
                          "Enter Labor Name",
                          addLaborNameController,
                          "Name",
                          addLaborNameErrorStatus.isNotEmpty,
                          context,
                          true),
                    ),
                    errorWidget(error: addLaborNameErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Enter Labor Description",
                          addLaborDescriptionController,
                          "Description",
                          addLaborDescriptionErrorStatus.isNotEmpty,
                          context,
                          true),
                    ),
                    errorWidget(error: addLaborDescriptionErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Hours",
                          addLaborHoursController,
                          "Hours",
                          addLaborHoursErrorStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addLaborHoursErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Amount",
                          addLaborBaseCostController,
                          "Base Cost",
                          addLaborBaseCostStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addLaborBaseCostStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Amount",
                          addLaborCostController,
                          "Cost ",
                          addLaborCostErrorStatus.isNotEmpty,
                          context,
                          false,
                          newSetState),
                    ),
                    errorWidget(error: addLaborCostErrorStatus),
                    Stack(
                      children: [
                        textBox(
                            "Enter Amount",
                            addLaborDiscountController,
                            "Discount",
                            addLaborDiscountErrorStatus.isNotEmpty,
                            context,
                            false,
                            newSetState),
                        Positioned(
                          right: 10,
                          top: 42,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  isPercentage = false;
                                  newSetState(() {});
                                },
                                child: Icon(
                                  CupertinoIcons.money_dollar,
                                  color: isPercentage
                                      ? AppColors.greyText
                                      : AppColors.primaryColors,
                                ),
                              ),
                              Text(
                                '  /  ',
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  isPercentage = true;
                                  newSetState(() {});
                                },
                                child: Icon(
                                  Icons.percent,
                                  color: !isPercentage
                                      ? AppColors.greyText
                                      : AppColors.primaryColors,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    errorWidget(error: addLaborDiscountErrorStatus),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tax :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${(subTotal - total).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
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
                            "\$${subTotal.toStringAsFixed(2)}",
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
                          final status = addLaborValidation(newSetState);
                          if (status) {
                            labor.add(CannedServiceAddModel(
                              cannedServiceId: int.parse(serviceId),
                              note: addLaborDescriptionController.text,
                              // part: addLaborLaborNumberController.text,
                              part: '',
                              itemName: addLaborNameController.text,
                              unitPrice: addLaborBaseCostController.text,
                              discount:
                                  addLaborDiscountController.text.trim().isEmpty
                                      ? "0"
                                      : addLaborDiscountController.text.trim(),
                              discountType: isPercentage &&
                                      addLaborDiscountController.text.isNotEmpty
                                  ? "Percentage"
                                  : "Fixed",
                              quanityHours: addLaborHoursController.text,
                              itemType: "Labor",
                              subTotal: subTotal.toStringAsFixed(2),
                              tax: client!.taxOnLabors == "Y"
                                  ? client!.laborTaxRate ?? '0'
                                  : '0',
                            ));
                            setState(() {});
                            Navigator.pop(context);
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
            ),
          ),
        ],
      );
    });
  }

  addFeePopup() {
    //Add Fee popup controllers
    final addFeeNameController = TextEditingController();
    final addFeeDescriptionController = TextEditingController();
    final addFeeCostController = TextEditingController();
    final addFeePriceController = TextEditingController();

    //Add Fee errorstatus and error message variables
    String addFeeNameErrorStatus = '';
    String addFeeDescriptionErrorStatus = '';
    String addFeePriceErrorStatus = '';
    String addFeeCostErrorStatus = '';

    double subTotal = 0;
    double total = 0;

    addFeeValidation(StateSetter setState) {
      bool status = true;
      if (addFeeNameController.text.trim().isEmpty) {
        addFeeNameErrorStatus = 'Fee name cannot be empty';
        status = false;
      } else {
        addFeeNameErrorStatus = '';
      }
      if (addFeePriceController.text.trim().isEmpty) {
        addFeePriceErrorStatus = 'Price cannot be empty';
        status = false;
      } else {
        addFeePriceErrorStatus = '';
      }

      setState(() {});
      return status;
    }

    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      if (addFeePriceController.text.isNotEmpty) {
        final tax = (double.tryParse(client?.laborTaxRate ?? '') ?? 0) / 100;

        if (client?.taxOnLabors == "N") {
          subTotal = (double.tryParse(addFeePriceController.text) ?? 0);
        } else {
          subTotal = (double.tryParse(addFeePriceController.text) ?? 0) * tax +
              (double.tryParse(addFeePriceController.text) ?? 0);
        }
        total = (double.tryParse(addFeePriceController.text) ?? 0);
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Add Fee",
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
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: textBox(
                          "Enter Fee Name",
                          addFeeNameController,
                          "Name",
                          addFeeNameErrorStatus.isNotEmpty,
                          context,
                          true),
                    ),
                    errorWidget(error: addFeeNameErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Enter Fee Description",
                          addFeeDescriptionController,
                          "Description",
                          addFeeDescriptionErrorStatus.isNotEmpty,
                          context,
                          false),
                    ),
                    errorWidget(error: addFeeDescriptionErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Amount",
                          addFeePriceController,
                          "Price ",
                          addFeePriceErrorStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addFeePriceErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox("Amount", addFeeCostController, "Cost ",
                          addFeeCostErrorStatus.isNotEmpty, context, false),
                    ),
                    errorWidget(error: addFeeCostErrorStatus),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tax :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${(subTotal - total).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
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
                            "\$${subTotal.toStringAsFixed(2)}",
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
                          final status = addFeeValidation(newSetState);
                          if (status) {
                            fee.add(CannedServiceAddModel(
                                cannedServiceId: int.parse(serviceId),
                                note: addFeeDescriptionController.text,
                                // part: addFeeFeeNumberController.text,
                                part: '',
                                itemName: addFeeNameController.text,
                                discount: '0',
                                unitPrice: addFeePriceController.text,
                                itemType: "Fee",
                                tax: client!.taxOnLabors == "Y"
                                    ? client!.laborTaxRate ?? '0'
                                    : '0',
                                subTotal: subTotal.toStringAsFixed(2)));
                            setState(() {});
                            Navigator.pop(context);
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
            ),
          ),
        ],
      );
    });
  }

  addSubContractPopup() {
    //Add SubContract popup controllers
    final addSubContractNameController = TextEditingController();
    final addSubContractDescriptionController = TextEditingController();
    final addSubContractCostController = TextEditingController();
    final addSubContractPriceController = TextEditingController();
    final addSubContractDiscountController = TextEditingController(text: '0');
    final addSubContractVendorController = TextEditingController();

    //Add SubContract errorstatus and error message variables
    String addSubContractNameErrorStatus = '';
    String addSubContractDescriptionErrorStatus = '';
    String addSubContractPriceErrorStatus = '';
    String addSubContractCostErrorStatus = '';
    String addSubContractDiscountErrorStatus = '';
    String addSubContractVendorErrorStatus = '';

    double subTotal = 0;
    double total = 0;

    addSubContractValidation(StateSetter setState) {
      bool status = true;
      if (addSubContractNameController.text.trim().isEmpty) {
        addSubContractNameErrorStatus = "Sub Contract name can't be empty";
        status = false;
      } else {
        if (addSubContractNameController.text.trim().length < 2) {
          addSubContractNameErrorStatus =
              "Sub Contract name must be atleast 2 characters";
          status = false;
        } else {
          addSubContractNameErrorStatus = '';
        }
      }
      if (addSubContractPriceController.text.trim().isEmpty) {
        addSubContractPriceErrorStatus = "Price can't be empty";
        status = false;
      } else {
        addSubContractPriceErrorStatus = '';
      }

      if (addSubContractDiscountController.text.isNotEmpty &&
          isPercentage &&
          double.parse(addSubContractDiscountController.text) > 100) {
        addSubContractDiscountErrorStatus = 'Discount should be less than 100';
        status = false;
      } else if (addSubContractDiscountController.text.isNotEmpty &&
          subTotal < 0) {
        addSubContractDiscountErrorStatus =
            "Discount cannot be greater than price";
        status = false;
      } else {
        addSubContractDiscountErrorStatus = '';
      }

      setState(() {});
      return status;
    }

    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      if (addSubContractPriceController.text.isNotEmpty) {
        if (client?.taxOnLabors == 'N') {
          if (addSubContractDiscountController.text.isEmpty) {
            subTotal =
                (double.tryParse(addSubContractPriceController.text) ?? 0);
          } else {
            double discount =
                double.tryParse(addSubContractDiscountController.text) ?? 0;
            if (isPercentage) {
              discount =
                  ((double.tryParse(addSubContractPriceController.text) ?? 0) *
                          (double.tryParse(
                                  addSubContractDiscountController.text) ??
                              0)) /
                      100;
            }
            subTotal =
                ((double.tryParse(addSubContractPriceController.text) ?? 0) -
                    discount);
          }
          total = subTotal;
        } else {
          final tax = (double.tryParse(client?.laborTaxRate ?? '') ?? 0) / 100;

          if (addSubContractDiscountController.text.isEmpty) {
            subTotal =
                (double.tryParse(addSubContractPriceController.text) ?? 0) *
                        tax +
                    (double.tryParse(addSubContractPriceController.text) ?? 0);
            total = (double.tryParse(addSubContractPriceController.text) ?? 0);
          } else {
            double discount =
                double.tryParse(addSubContractDiscountController.text) ?? 0;
            if (isPercentage) {
              discount =
                  ((double.tryParse(addSubContractPriceController.text) ?? 0) *
                          (double.tryParse(
                                  addSubContractDiscountController.text) ??
                              0)) /
                      100;
            }
            subTotal = ((double.tryParse(addSubContractPriceController.text) ??
                            0) -
                        discount) *
                    tax +
                ((double.tryParse(addSubContractPriceController.text) ?? 0) -
                    discount);
            total =
                ((double.tryParse(addSubContractPriceController.text) ?? 0) -
                    discount);
          }
        }
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Add SubContract",
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
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: textBox(
                          "Enter SubContract Name",
                          addSubContractNameController,
                          "Name",
                          addSubContractNameErrorStatus.isNotEmpty,
                          context,
                          true),
                    ),
                    errorWidget(error: addSubContractNameErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Enter SubContract Description",
                          addSubContractDescriptionController,
                          "Description",
                          addSubContractDescriptionErrorStatus.isNotEmpty,
                          context,
                          false),
                    ),
                    errorWidget(error: addSubContractDescriptionErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Amount",
                          addSubContractPriceController,
                          "Price ",
                          addSubContractPriceErrorStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addSubContractPriceErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Amount",
                          addSubContractCostController,
                          "Cost ",
                          addSubContractCostErrorStatus.isNotEmpty,
                          context,
                          false),
                    ),
                    errorWidget(error: addSubContractCostErrorStatus),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Checkbox(
                    //         value: isTax,
                    //         onChanged: (value) {
                    //           newSetState(() {
                    //             isTax = value!;
                    //           });
                    //         }),
                    //     Text('Allow Tax Charges On Sub Contract',
                    //         style: TextStyle(color: Color(0xFF6A7187))),
                    //   ],
                    // ),
                    Stack(
                      children: [
                        textBox(
                            "Enter Amount",
                            addSubContractDiscountController,
                            "Discount",
                            addSubContractDiscountErrorStatus.isNotEmpty,
                            context,
                            false,
                            newSetState),
                        Positioned(
                          right: 10,
                          top: 42,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  isPercentage = false;
                                  newSetState(() {});
                                },
                                child: Icon(
                                  CupertinoIcons.money_dollar,
                                  color: isPercentage
                                      ? AppColors.greyText
                                      : AppColors.primaryColors,
                                ),
                              ),
                              Text(
                                '  /  ',
                                style: TextStyle(
                                  color: AppColors.greyText,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  isPercentage = true;
                                  newSetState(() {});
                                },
                                child: Icon(
                                  Icons.percent,
                                  color: !isPercentage
                                      ? AppColors.greyText
                                      : AppColors.primaryColors,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    errorWidget(error: addSubContractDiscountErrorStatus),

                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Select existing",
                          addSubContractVendorController,
                          "Vendor",
                          addSubContractVendorErrorStatus.isNotEmpty,
                          context,
                          false),
                    ),
                    errorWidget(error: addSubContractVendorErrorStatus),

                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tax :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${(subTotal - total).toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          )
                        ],
                      ),
                    ),
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
                            "\$${subTotal.toStringAsFixed(2)}",
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
                          final status = addSubContractValidation(newSetState);
                          if (status) {
                            subContract.add(
                              CannedServiceAddModel(
                                cannedServiceId: int.parse(serviceId),
                                note: addSubContractDescriptionController.text,
                                // part: addSubContractSubContractNumberController.text,
                                part: '',
                                itemName: addSubContractNameController.text,
                                // discount: addSubContractDiscountController.text,
                                //tax: isTax == true ? 'Y' : 'N',
                                vendorId: vendorId,
                                unitPrice: addSubContractPriceController.text,
                                discount: addSubContractDiscountController.text
                                        .trim()
                                        .isEmpty
                                    ? "0"
                                    : addSubContractDiscountController.text
                                        .trim(),
                                discountType: isPercentage &&
                                        addSubContractDiscountController
                                            .text.isNotEmpty
                                    ? "Percentage"
                                    : "Fixed",

                                itemType: "SubContract",
                                subTotal: subTotal.toStringAsFixed(2),
                                tax: client!.taxOnLabors == "Y"
                                    ? client!.laborTaxRate ?? '0'
                                    : '0',
                              ),
                            );
                            setState(() {});
                            Navigator.pop(context);
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
            ),
          ),
        ],
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
                    color:
                        // addMaterialPricingErrorStatus.isNotEmpty
                        //     ? const Color(0xffD80027)
                        //     :
                        const Color(0xffC1C4CD)),
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

  Widget vendorsBottomSheet(
      TextEditingController addSubContractVendorController, int? vendorId) {
    final ScrollController vendorController = ScrollController();

    return BlocProvider(
      create: (context) => ServiceBloc()..add(GetAllVendorsEvent()),
      child: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is GetAllVendorsSuccessState) {
            if (context.read<ServiceBloc>().currentPage == 2 ||
                context.read<ServiceBloc>().currentPage == 1) {
              vendors.clear();
            }
            vendors.addAll(state.vendors);
          }
        },
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
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
                      "Vendors",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTitleColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height / 2 - 90,
                        child: vendors.isEmpty
                            ? const Center(
                                child: Text('No Vendors Found',
                                    style: TextStyle(
                                      color: AppColors.greyText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )))
                            : ListView.builder(
                                itemBuilder: (context, index) {
                                  if (index == vendors.length) {
                                    return BlocProvider.of<ServiceBloc>(context)
                                                    .currentPage <=
                                                BlocProvider.of<ServiceBloc>(
                                                        context)
                                                    .totalPages &&
                                            BlocProvider.of<ServiceBloc>(
                                                        context)
                                                    .currentPage !=
                                                0
                                        ? const SizedBox(
                                            height: 40,
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.primaryColors,
                                            ))
                                        : Container();
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        print("heyy");

                                        addSubContractVendorController.text =
                                            vendors[index].vendorName ?? '';
                                        vendorId = vendors[index].id;

                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            vendors[index].vendorName ?? '',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: vendors.length + 1,
                                controller: vendorController
                                  ..addListener(() {
                                    if ((BlocProvider.of<ServiceBloc>(context)
                                                .currentPage <=
                                            BlocProvider.of<ServiceBloc>(
                                                    context)
                                                .totalPages) &&
                                        vendorController.offset ==
                                            vendorController
                                                .position.maxScrollExtent &&
                                        BlocProvider.of<ServiceBloc>(context)
                                                .currentPage !=
                                            0 &&
                                        !BlocProvider.of<ServiceBloc>(context)
                                            .isVendorsPagenationLoading) {
                                      context.read<ServiceBloc>()
                                        ..isVendorsPagenationLoading = true
                                        ..add(GetAllVendorsEvent());
                                    }
                                  }),
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

  Widget technicianBottomSheet() {
    return BlocProvider(
      create: (context) => ServiceBloc()..add(GetTechnicianEvent()),
      child: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is GetTechnicianState) {
            technicianData.clear();
            technicianData.addAll(state.technicianModel.data);

            print(technicianData);
          }
          // TODO: implement listener
        },
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: state is GetTechnicianLoadingState
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : technicianData.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Technician",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryTitleColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: LimitedBox(
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 2 -
                                          90,
                                  child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            print("heyy");

                                            technicianController
                                                .text = technicianData[index]
                                                    .firstName +
                                                " " +
                                                technicianData[index].lastName;
                                            technicianId = technicianData[index]
                                                .id
                                                .toString();

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
                                                technicianData[index].firstName,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: technicianData.length,
                                  ),
                                ),
                              )
                            ],
                          )
                        : const Center(
                            child: Text("No Technician Found!"),
                          ),
              ),
            );
          },
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

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, allow it
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Use a regular expression to check for valid input
    final regExp = RegExp(r'^\d*\.?\d*$');
    if (!regExp.hasMatch(newValue.text)) {
      // If the input doesn't match the pattern, return the old value
      return oldValue;
    }

    // If the input is valid, allow it
    return newValue;
  }
}
