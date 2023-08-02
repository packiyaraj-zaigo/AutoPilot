import 'dart:developer';

import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/canned_service_model.dart' as cs;
import 'package:auto_pilot/Models/client_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/vendor_response_model.dart';
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

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen(
      {super.key,
      this.service,
      this.material,
      this.part,
      this.labor,
      this.subContract,
      this.fee,
      this.navigation});
  final cs.Datum? service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subContract;
  final List<CannedServiceAddModel>? fee;

  final String? navigation;

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
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
            create: (context) => ServiceBloc()..add(GetClientByIdEvent()),
            child: BlocListener<ServiceBloc, ServiceState>(
              listener: (context, state) {
                if (state is CreateCannedOrderServiceSuccessState) {
                  if (widget.navigation != null) {
                    Navigator.pop(context);
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ServicesListScreen(),
                    ));
                  }

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
                          true),
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
                        itemCount: material.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = material[index];
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
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),

                      addTileWidget("Part"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: part.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = part[index];
                          return Column(
                            children: [
                              const SizedBox(height: 8),
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
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                      addTileWidget("Labor"),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: labor.length,
                        physics: const ClampingScrollPhysics(),
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
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = subContract[index];
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
                        physics: const ClampingScrollPhysics(),
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

                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: textBox("Enter Tax", taxController, "Tax",
                            taxError.isNotEmpty, context, true),
                      ),
                      errorWidget(error: taxError),

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
                                servicePrice: rateController.text,
                                serviceNote: laborDescriptionController.text,
                                discount: '0',
                                tax: taxController.text,
                                subTotal: subT.toStringAsFixed(2),
                              );
                              log(subT.toString());
                              if (widget.service != null) {
                                BlocProvider.of<ServiceBloc>(context).add(
                                  EditCannedOrderServiceEvent(
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
                                  ),
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
            width: label == "Price" || label == "Cost"
                ? MediaQuery.of(context).size.width / 2.6
                : MediaQuery.of(context).size.width,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: setState != null
                  ? (value) {
                      setState(() {});
                    }
                  : null,
              readOnly: label == "Vendor",
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
                  : null,
              controller: controller,
              keyboardType: label == 'Discount' ||
                      label == 'Cost' ||
                      label == 'Cost ' ||
                      label == 'Price' ||
                      label == 'Tax' ||
                      label.contains('Labor Rate') ||
                      label == "Hours" ||
                      label == 'Price '
                  ? TextInputType.number
                  : null,
              inputFormatters: label == 'Discount' ||
                      label == 'Cost' ||
                      label == 'Cost ' ||
                      label == 'Price' ||
                      label == 'Tax' ||
                      label.contains('Labor Rate') ||
                      label == "Hours" ||
                      label == 'Price '
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              maxLength: 50,
              decoration: InputDecoration(
                suffixIcon: label == 'Discount' || label.contains("Labor Rate")
                    ? const Icon(
                        CupertinoIcons.money_dollar,
                        color: AppColors.primaryColors,
                      )
                    : label == "Vendor"
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

    addMaterialValidation(StateSetter setState) {
      bool status = true;
      if (addMaterialNameController.text.trim().isEmpty) {
        adddMaterialNameErrorStatus = 'Material name cannot be empty';
        status = false;
      } else {
        adddMaterialNameErrorStatus = '';
      }
      if (addMaterialDescriptionController.text.trim().isEmpty) {
        addMaterialDescriptionErrorStatus = 'Description cannot be empty';
        status = false;
      } else {
        addMaterialDescriptionErrorStatus = '';
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
      } else if (subTotal < 0) {
        addMaterialDiscountErrorStatus = 'Discount should be less than price';
        status = false;
      } else {
        addMaterialDiscountErrorStatus = '';
      }
      if (addMaterialBatchController.text.trim().isEmpty) {
        adddMaterialBatchErrorStatus = 'Part/Batch Number cannot be empty';
        status = false;
      } else {
        adddMaterialBatchErrorStatus = '';
      }

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
              subTotal = ((double.tryParse(addMaterialPriceController.text) ??
                      0) -
                  (double.tryParse(addMaterialDiscountController.text) ?? 0));
            }
          } else {
            final tax =
                (double.tryParse(client?.materialTaxRate ?? '') ?? 0) / 100;

            if (addMaterialDiscountController.text.isEmpty) {
              subTotal =
                  (double.tryParse(addMaterialPriceController.text) ?? 0) *
                          tax +
                      (double.tryParse(addMaterialPriceController.text) ?? 0);
            } else {
              subTotal = ((double.tryParse(addMaterialPriceController.text) ??
                              0) -
                          (double.tryParse(
                                  addMaterialDiscountController.text) ??
                              0)) *
                      tax +
                  ((double.tryParse(addMaterialPriceController.text) ?? 0) -
                      (double.tryParse(addMaterialDiscountController.text) ??
                          0));
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
                            true),
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
                      Padding(
                        padding: EdgeInsets.only(top: 17),
                        child: textBox(
                            "Enter Amount",
                            addMaterialDiscountController,
                            "Discount",
                            addMaterialDiscountErrorStatus.isNotEmpty,
                            context,
                            true,
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                //  maxCrossAxisExtent: 150,
                                mainAxisSpacing: 20,
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                childAspectRatio: 3),
                        itemBuilder: (context, index) {
                          return tagWidget(
                              tagDataList[index], index, newSetState);
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
                            context,
                            true),
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
                                discount: addMaterialDiscountController.text,
                                itemType: "Material",
                                subTotal: subTotal.toStringAsFixed(2),
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

    //Add part errorstatus and error message variables
    String addPartNameErrorStatus = '';
    String addPartDescriptionErrorStatus = '';
    String addPartPriceErrorStatus = '';
    String addPartCostErrorStatus = '';
    String addPartDiscountErrorStatus = '';
    String adddPartPartNumberErrorStatus = '';

    double subTotal = 0;

    addPartValidation(StateSetter setState) {
      bool status = true;
      if (addPartNameController.text.trim().isEmpty) {
        addPartNameErrorStatus = 'Part name cannot be empty';
        status = false;
      } else {
        addPartNameErrorStatus = '';
      }
      if (addPartDescriptionController.text.trim().isEmpty) {
        addPartDescriptionErrorStatus = 'Description cannot be empty';
        status = false;
      } else {
        addPartDescriptionErrorStatus = '';
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
      if (addPartPartNumberController.text.trim().isEmpty) {
        adddPartPartNumberErrorStatus = 'Part Number cannot be empty';
        status = false;
      } else {
        adddPartPartNumberErrorStatus = '';
      }

      setState(() {});
      return status;
    }

    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      if (addPartPriceController.text.isNotEmpty) {
        if (client?.taxOnParts == "N") {
          if (addPartDiscountController.text.isEmpty) {
            subTotal = (double.tryParse(addPartPriceController.text) ?? 0);
          } else {
            subTotal = ((double.tryParse(addPartPriceController.text) ?? 0) -
                (double.tryParse(addPartDiscountController.text) ?? 0));
          }
        } else {
          final tax = (double.tryParse(client?.salesTaxRate ?? '') ?? 0) / 100;
          if (addPartDiscountController.text.isEmpty) {
            subTotal =
                (double.tryParse(addPartPriceController.text) ?? 0) * tax +
                    (double.tryParse(addPartPriceController.text) ?? 0);
          } else {
            subTotal = ((double.tryParse(addPartPriceController.text) ?? 0) -
                        (double.tryParse(addPartDiscountController.text) ??
                            0)) *
                    tax +
                ((double.tryParse(addPartPriceController.text) ?? 0) -
                    (double.tryParse(addPartDiscountController.text) ?? 0));
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
                          true),
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
                              true,
                              newSetState),
                          pricingModelDropDown()
                        ],
                      ),
                    ),
                    errorWidget(error: addPartPriceErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox("Amount", addPartCostController, "Cost ",
                          addPartCostErrorStatus.isNotEmpty, context, false),
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
                        true,
                        newSetState,
                      ),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              //  maxCrossAxisExtent: 150,
                              mainAxisSpacing: 20,
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3),
                      itemBuilder: (context, index) {
                        return tagWidget(
                            tagDataList[index], index, newSetState);
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
                          context,
                          true),
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
                              discount: addPartDiscountController.text,
                              itemType: "Part",
                              subTotal: subTotal.toStringAsFixed(2),
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

    //Add Labor errorstatus and error message variables
    String addLaborNameErrorStatus = '';
    String addLaborDescriptionErrorStatus = '';
    String addLaborCostErrorStatus = '';
    String addLaborDiscountErrorStatus = '';
    String addLaborHoursErrorStatus = '';

    double subTotal = 0;

    addLaborValidation(StateSetter setState) {
      bool status = true;
      if (addLaborNameController.text.trim().isEmpty) {
        addLaborNameErrorStatus = 'Labor name cannot be empty';
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
      if (addLaborHoursController.text.trim().isEmpty) {
        addLaborHoursErrorStatus = 'Hours cannot be empty';
        status = false;
      } else {
        addLaborHoursErrorStatus = '';
      }
      if (addLaborDescriptionController.text.trim().isEmpty) {
        addLaborDescriptionErrorStatus = 'Description cannot be empty';
        status = false;
      } else {
        addLaborDescriptionErrorStatus = '';
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

    return StatefulBuilder(builder: (context, StateSetter newSetState) {
      if (addLaborCostController.text.isNotEmpty) {
        if (client?.taxOnLabors == 'N') {
          if (addLaborDiscountController.text.isEmpty) {
            subTotal = (double.tryParse(addLaborCostController.text) ?? 0);
          } else {
            subTotal = ((double.tryParse(addLaborCostController.text) ?? 0) -
                (double.tryParse(addLaborDiscountController.text) ?? 0));
          }
        } else {
          final tax = (double.tryParse(client?.laborTaxRate ?? '') ?? 0) / 100;
          if (addLaborDiscountController.text.isEmpty) {
            subTotal = ((double.tryParse(addLaborHoursController.text) ?? 1) *
                        (double.tryParse(addLaborCostController.text) ?? 0)) *
                    tax +
                ((double.tryParse(addLaborHoursController.text) ?? 1) *
                    (double.tryParse(addLaborCostController.text) ?? 0));
          } else {
            subTotal = (((double.tryParse(addLaborHoursController.text) ?? 1) *
                            (double.tryParse(addLaborCostController.text) ??
                                0)) -
                        (double.tryParse(addLaborDiscountController.text) ??
                            0)) *
                    tax +
                (((double.tryParse(addLaborHoursController.text) ?? 1) *
                        (double.tryParse(addLaborCostController.text) ?? 0)) -
                    (double.tryParse(addLaborDiscountController.text) ?? 0));
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
                          "Hours ",
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
                          addLaborCostController,
                          "Cost ",
                          addLaborCostErrorStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
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
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addLaborDiscountErrorStatus),
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
                              unitPrice: addLaborCostController.text,
                              discount: addLaborDiscountController.text,
                              quanityHours: addLaborHoursController.text,
                              itemType: "Labor",
                              subTotal: subTotal.toStringAsFixed(2),
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
      if (addFeeDescriptionController.text.trim().isEmpty) {
        addFeeDescriptionErrorStatus = 'Description cannot be empty';
        status = false;
      } else {
        addFeeDescriptionErrorStatus = '';
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
                          true),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              //  maxCrossAxisExtent: 150,
                              mainAxisSpacing: 20,
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3),
                      itemBuilder: (context, index) {
                        return tagWidget(
                            tagDataList[index], index, newSetState);
                      },
                      itemCount: tagDataList.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
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

    addSubContractValidation(StateSetter setState) {
      bool status = true;
      if (addSubContractNameController.text.trim().isEmpty) {
        addSubContractNameErrorStatus = 'Sub Contract name cannot be empty';
        status = false;
      } else {
        addSubContractNameErrorStatus = '';
      }
      if (addSubContractPriceController.text.trim().isEmpty) {
        addSubContractPriceErrorStatus = 'Price cannot be empty';
        status = false;
      } else {
        addSubContractPriceErrorStatus = '';
      }
      if (addSubContractDescriptionController.text.trim().isEmpty) {
        addSubContractDescriptionErrorStatus = 'Description cannot be empty';
        status = false;
      } else {
        addSubContractDescriptionErrorStatus = '';
      }
      if (addSubContractDiscountController.text.trim().isEmpty) {
        addSubContractDiscountErrorStatus = 'Discount cannot be empty';
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
            subTotal = ((double.tryParse(addSubContractPriceController.text) ??
                    0) -
                (double.tryParse(addSubContractDiscountController.text) ?? 0));
          }
        } else {
          final tax = (double.tryParse(client?.laborTaxRate ?? '') ?? 0) / 100;

          if (addSubContractDiscountController.text.isEmpty) {
            subTotal =
                (double.tryParse(addSubContractPriceController.text) ?? 0) *
                        tax +
                    (double.tryParse(addSubContractPriceController.text) ?? 0);
          } else {
            subTotal = ((double.tryParse(addSubContractPriceController.text) ??
                            0) -
                        (double.tryParse(
                                addSubContractDiscountController.text) ??
                            0)) *
                    tax +
                ((double.tryParse(addSubContractPriceController.text) ?? 0) -
                    (double.tryParse(addSubContractDiscountController.text) ??
                        0));
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
                          true),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: isTax,
                            onChanged: (value) {
                              newSetState(() {
                                isTax = value!;
                              });
                            }),
                        Text('Allow Tax Charges On Sub Contract',
                            style: TextStyle(color: Color(0xFF6A7187))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 17.0),
                      child: textBox(
                          "Amount",
                          addSubContractDiscountController,
                          "Discount",
                          addSubContractDiscountErrorStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addSubContractDiscountErrorStatus),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              //  maxCrossAxisExtent: 150,
                              mainAxisSpacing: 20,
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3),
                      itemBuilder: (context, index) {
                        return tagWidget(
                            tagDataList[index], index, newSetState);
                      },
                      itemCount: tagDataList.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                    ),
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
                                discount: addSubContractDiscountController.text,
                                tax: isTax == true ? 'Y' : 'N',
                                vendorId: vendorId,
                                unitPrice: addSubContractPriceController.text,
                                itemType: "SubContract",
                                subTotal: subTotal.toStringAsFixed(2),
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
