import 'dart:developer';

import 'package:auto_pilot/Models/canned_service_create.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/canned_service_model.dart' as cs;
import 'package:auto_pilot/Models/client_model.dart';
import 'package:auto_pilot/Models/technician_only_model.dart';
import 'package:auto_pilot/Models/vendor_response_model.dart';
import 'package:auto_pilot/Screens/add_vendor_screen.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/Screens/services_list_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
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

class AddOrderServiceScreen extends StatefulWidget {
  const AddOrderServiceScreen(
      {super.key,
      this.service,
      this.material,
      this.part,
      this.labor,
      this.subContract,
      this.fee,
      this.navigation,
      required this.orderId});
  final cs.Datum? service;
  final List<CannedServiceAddModel>? material;
  final List<CannedServiceAddModel>? part;
  final List<CannedServiceAddModel>? labor;
  final List<CannedServiceAddModel>? subContract;
  final List<CannedServiceAddModel>? fee;
  final String orderId;

  final String? navigation;

  @override
  State<AddOrderServiceScreen> createState() => _AddOrderServiceScreenState();
}

class _AddOrderServiceScreenState extends State<AddOrderServiceScreen> {
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

  final technicianController = TextEditingController();
  String technicianError = '';

  String technicianId = '0';

  CannedServiceCreateModel? service;
  List<CannedServiceAddModel> material = [];
  List<CannedServiceAddModel> part = [];
  List<CannedServiceAddModel> labor = [];
  List<CannedServiceAddModel> subContract = [];
  List<CannedServiceAddModel> fee = [];

  final addSubContractVendorController = TextEditingController();
  bool isCannedService = false;

  dynamic _currentPricingModelSelectedValue;
  List<String> pricingModelList = ['Per Sqrt', 'Per Roll'];

  String taxRateError = '';
  var dropdownValue;
  String categoryError = '';
  List<Datum> technicianData = [];

  CountryCode? selectedCountry;
  final countryPicker = const FlCountryCodePicker();
  List<String> tagDataList = [];
  List<String> deletedItems = [];
  List<CannedServiceAddModel> editedItems = [];

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

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
            create: (context) => EstimateBloc(apiRepository: ApiRepository())
              ..add(GetClientByIdInEstimateEvent())
              ..add(GetAllVendorsEstimateEvent()),
            child: BlocListener<EstimateBloc, EstimateState>(
              listener: (context, state) {
                if (state is GetAllVendorsSuccessEstimateState) {
                  if (context.read<ServiceBloc>().currentPage == 2 ||
                      context.read<ServiceBloc>().currentPage == 1) {
                    vendors.clear();
                  }
                  vendors.addAll(state.vendors);
                }
                // if (state is CreateCannedOrderServiceSuccessState) {
                //   if (widget.navigation != null) {
                //     Navigator.pop(context);
                //   } else {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (context) => ServicesListScreen(),
                //     ));
                //   }

                //   CommonWidgets().showDialog(context, state.message);
                // }
                // if (state is CreateCannedOrderServiceErrorState) {
                //   CommonWidgets().showDialog(context, state.message);
                // }
                // if (state is EditCannedServiceSuccessState) {
                //   Navigator.of(context).pop();
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => ServicesListScreen(),
                //   ));
                //   CommonWidgets().showDialog(context, state.message);
                // }
                // if (state is EditCannedServiceErrorState) {
                //   CommonWidgets().showDialog(context, state.message);
                // }
                // if (state is GetClientErrorState) {
                //   if (widget.navigation != null) {
                //     Navigator.pop(context);
                //   } else {
                //     Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (context) => ServicesListScreen(),
                //     ));
                //   }
                //   CommonWidgets().showDialog(context, state.message);
                // }
                if (state is GetClientByIdInEstimateState) {
                  client = state.clientModel;
                  log(client!.toJson().toString());
                  rateController.text = client?.baseLaborCost ?? '0';
                } else if (state is GetEstimateErrorState) {
                  CommonWidgets().showDialog(context, state.errorMsg);
                } else if (state is CreateOrderServiceState) {
                  if (material.isEmpty &&
                      part.isEmpty &&
                      labor.isEmpty &&
                      subContract.isEmpty &&
                      fee.isEmpty) {
                    if (!isCannedService) {
                      context
                          .read<EstimateBloc>()
                          .add(GetSingleEstimateEvent(orderId: widget.orderId));
                    } else {
                      context.read<EstimateBloc>().add(
                          CreateCannedOrderServiceEstimateEvent(
                              service: service!,
                              fee: fee,
                              labor: labor,
                              material: material,
                              part: part,
                              subcontract: subContract));
                    }
                  }
                  if (material.isNotEmpty) {
                    material.forEach((element) {
                      context
                          .read<EstimateBloc>()
                          .add(CreateOrderServiceItemEvent(
                            cannedServiceId: state.orderServiceId,
                            item: element,
                          ));
                    });
                  }
                  if (part.isNotEmpty) {
                    part.forEach((element) {
                      context
                          .read<EstimateBloc>()
                          .add(CreateOrderServiceItemEvent(
                            cannedServiceId: state.orderServiceId,
                            item: element,
                          ));
                    });
                  }
                  if (fee.isNotEmpty) {
                    fee.forEach((element) {
                      context
                          .read<EstimateBloc>()
                          .add(CreateOrderServiceItemEvent(
                            cannedServiceId: state.orderServiceId,
                            item: element,
                          ));
                    });
                  }
                  if (labor.isNotEmpty) {
                    labor.forEach((element) {
                      context
                          .read<EstimateBloc>()
                          .add(CreateOrderServiceItemEvent(
                            cannedServiceId: state.orderServiceId,
                            item: element,
                          ));
                    });
                  }
                  if (subContract.isNotEmpty) {
                    subContract.forEach((element) {
                      context
                          .read<EstimateBloc>()
                          .add(CreateOrderServiceItemEvent(
                            cannedServiceId: state.orderServiceId,
                            item: element,
                          ));
                    });
                  }
                } else if (state is CreateOrderServiceItemState) {
                  if (isCannedService) {
                    context.read<EstimateBloc>().add(
                        CreateCannedOrderServiceEstimateEvent(
                            service: service!,
                            fee: fee,
                            labor: labor,
                            material: material,
                            part: part,
                            subcontract: subContract));
                  } else {
                    context
                        .read<EstimateBloc>()
                        .add(GetSingleEstimateEvent(orderId: widget.orderId));
                  }
                } else if (state is GetSingleEstimateState) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return EstimatePartialScreen(
                        estimateDetails: state.createEstimateModel,
                      );
                    },
                  ));
                } else if (state is CreateCannedServiceEstimateState) {
                  context
                      .read<EstimateBloc>()
                      .add(GetSingleEstimateEvent(orderId: widget.orderId));
                }
              },
              child: BlocBuilder<EstimateBloc, EstimateState>(
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
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = material[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(20),
                                    insetPadding: const EdgeInsets.all(20),
                                    content: addMaterialPopup(
                                        item: item, index: index),
                                  );
                                },
                              );
                            },
                            child: Column(
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
                            ),
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
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(20),
                                    insetPadding: const EdgeInsets.all(20),
                                    content:
                                        addPartPopup(item: item, index: index),
                                  );
                                },
                              );
                            },
                            child: Column(
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
                            ),
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
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(20),
                                    insetPadding: const EdgeInsets.all(20),
                                    content:
                                        addLaborPopup(item: item, index: index),
                                  );
                                },
                              );
                            },
                            child: Column(
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
                            ),
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
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(20),
                                    insetPadding: const EdgeInsets.all(20),
                                    content: addSubContractPopup(
                                        item: item, index: index),
                                  );
                                },
                              );
                            },
                            child: Column(
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
                            ),
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
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(20),
                                    insetPadding: const EdgeInsets.all(20),
                                    content:
                                        addFeePopup(item: item, index: index),
                                  );
                                },
                              );
                            },
                            child: Column(
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
                            ),
                          );
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: [
                            Checkbox(
                                value: isCannedService,
                                onChanged: (value) {
                                  setState(() {
                                    isCannedService = value!;
                                  });
                                }),
                            Text("Create a canned service with these details")
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 16.0),
                      //   child: textBox(
                      //       "Enter Labor Rate",
                      //       rateController,
                      //       "Labor Rate *For this service",
                      //       rateError.isNotEmpty,
                      //       context,
                      //       true),
                      // ),
                      // errorWidget(error: rateError),

                      // Padding(
                      //   padding: const EdgeInsets.only(top: 16.0),
                      //   child: textBox("Enter Tax", taxController, "Tax",
                      //       taxError.isNotEmpty, context, true),
                      // ),
                      // errorWidget(error: taxError),

                      const SizedBox(height: 20),
                      // const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();

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
                              // subT += double.tryParse(rateController.text) ?? 0;
                              service = CannedServiceCreateModel(
                                clientId: int.parse(clientId),
                                serviceName: serviceNameController.text,
                                servicePrice: rateController.text,
                                serviceNote: laborDescriptionController.text,
                                discount: '0',
                                // tax: client!.taxOnLabors == "Y" ? client!.laborTaxRate : '0',
                                tax: client!.taxOnLabors == "Y"
                                    ? client!.laborTaxRate ?? '0'
                                    : '0',
                                subTotal: subT.toStringAsFixed(2),
                              );
                              log(subT.toStringAsFixed(2));
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
                                if (state is! CreateOrderServiceLoadingState &&
                                    state
                                        is! CreateOrderServiceItemLoadingState) {
                                  BlocProvider.of<EstimateBloc>(context).add(
                                    CreateOrderServiceEvent(
                                        serviceName: serviceNameController.text,
                                        orderId: widget.orderId,
                                        serviceNotes:
                                            laborDescriptionController.text,
                                        laborRate: client?.baseLaborCost ?? "0",
                                        servicePrice: rateController.text,
                                        tax: client!.taxOnLabors == "Y"
                                            ? client!.laborTaxRate ?? '0'
                                            : '0',
                                        technicianId: technicianId == ""
                                            ? "0"
                                            : technicianId),
                                  );
                                }
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
                          child: state is CreateOrderServiceLoadingState ||
                                  state is CreateOrderServiceItemLoadingState
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : Text(
                                  widget.service != null ? 'Update' : "Confirm",
                                  style: const TextStyle(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            label == "Vendor"
                ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (context) => const AddVendorScreen())
                          .then((value) {
                        // do something
                        if (value != null) {
                          print(value.toString() + "heloooo");

                          setState!(() {
                            addSubContractVendorController.text = value[1];
                            vendorId = int.parse(value[0]);
                          });
                        }
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
                            color: AppColors.primaryColors,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: label == "Notes" || label == "Description" ? null : 56,
            width: label == "Price" || label == "Quantity"
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
              keyboardType: label == 'Tax' ||
                      label.contains('Labor Rate') ||
                      label == "Hours" ||
                      label == "Quantity " ||
                      label == "Quantity"
                  ? TextInputType.number
                  : label == "Base Cost" ||
                          label == 'Discount' ||
                          label == 'Cost' ||
                          label == 'Cost ' ||
                          label == 'Price' ||
                          label == 'Price ' ||
                          label == "Base Cost" ||
                          label == "Labor Tax"
                      ? TextInputType.numberWithOptions(decimal: true)
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
                          label == "Quantity" ||
                          label == "Base Cost" ||
                          label == "Labor Tax"
                      ? [NumberInputFormatter()]
                      : [],
              maxLength: label == 'Cost' ||
                      label == 'Cost ' ||
                      label == 'Price' ||
                      label == 'Tax' ||
                      label.contains('Labor Rate') ||
                      label == "Hours" ||
                      label == 'Price ' ||
                      label == "Quantity"
                  ? 7
                  : label == "Service Name" ||
                          label == "Notes" ||
                          label == "Description"
                      ? null
                      : 100,
              maxLines: label == "Notes" || label == "Description" ? 10 : 1,
              minLines: 1,
              decoration: InputDecoration(
                suffixIcon: label.contains("Labor Rate")
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
      serviceNameError = "Service name can't be empty";
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
    }
    //  else if (laborDescriptionController.text.trim().isNotEmpty &&
    //     laborDescriptionController.text.trim().length > 150) {
    //   laborDescriptionError = "Notes can't be more than 150 characters";
    //   status = false;
    // }
    else {
      laborDescriptionError = '';
    }

    if (rateController.text.trim().isEmpty) {
      rateError = "Rate can't be empty";
      status = false;
    } else {
      rateError = '';
    }
    // if (taxController.text.trim().isEmpty) {
    //   taxError = "Tax can't be empty";
    //   status = false;
    // } else {
    //   taxError = '';
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
                addSubContractVendorController.clear();
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

  addMaterialPopup({CannedServiceAddModel? item, int? index}) {
    //Add material popup controllers
    final addMaterialNameController =
        TextEditingController(text: item?.itemName);
    final addMaterialDescriptionController =
        TextEditingController(text: item?.note);
    final addMaterialPriceController =
        TextEditingController(text: item?.unitPrice);
    final addMaterialQuantityController =
        TextEditingController(text: item?.quanityHours ?? '1');
    final addMaterialCostController = TextEditingController(text: item?.cost);
    final addMaterialDiscountController =
        TextEditingController(text: item?.discount ?? '0');
    final addMaterialBatchController = TextEditingController(text: item?.part);

    //Add material errorstatus and error message variables
    String adddMaterialNameErrorStatus = '';
    String addMaterialDescriptionErrorStatus = '';
    String addMaterialPriceErrorStatus = '';
    String addMaterialQuantityErrorStatus = '';
    String addMaterialCostErrorStatus = '';
    String addMaterialDiscountErrorStatus = '';
    String adddMaterialBatchErrorStatus = '';

    double subTotal = 0;
    double total = 0;
    double materialCost = 0;
    bool isPercentage = item?.discountType == "Percentage" ? true : false;

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
      if (addMaterialQuantityController.text.trim().isEmpty) {
        addMaterialQuantityErrorStatus = "Quantity can't be empty";
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
        // if (addMaterialPriceController.text.isNotEmpty &&
        //     addMaterialQuantityController.text.isNotEmpty) {
        //   if (client?.taxOnMaterial == 'N') {
        //     if (addMaterialDiscountController.text.isEmpty) {
        //       subTotal = (double.tryParse(addMaterialPriceController.text) ??
        //               0) *
        //           (double.tryParse(addMaterialQuantityController.text) ?? 1);
        //     } else {
        //       if (isPercentage) {
        //         subTotal =
        //             ((double.tryParse(addMaterialPriceController.text) ?? 0) *
        //                     (double.tryParse(
        //                             addMaterialQuantityController.text) ??
        //                         1)) -
        //                 ((double.tryParse(addMaterialPriceController.text) ??
        //                             0) *
        //                         (double.tryParse(
        //                                 addMaterialQuantityController.text) ??
        //                             1) *
        //                         (double.tryParse(
        //                                 addMaterialDiscountController.text) ??
        //                             0)) /
        //                     100;
        //       } else {
        //         subTotal = ((double.tryParse(addMaterialPriceController.text) ??
        //                     0) *
        //                 (double.tryParse(addMaterialQuantityController.text) ??
        //                     1)) -
        //             (double.tryParse(addMaterialDiscountController.text) ?? 0);
        //       }
        //     }
        //     total = subTotal;
        //   } else {
        //     final tax =
        //         (double.tryParse(client?.materialTaxRate ?? '') ?? 0) / 100;

        //     if (addMaterialDiscountController.text.isEmpty) {
        //       subTotal = (double.tryParse(addMaterialPriceController.text) ??
        //                   0) *
        //               (double.tryParse(addMaterialQuantityController.text) ??
        //                   1) *
        //               tax +
        //           (double.tryParse(addMaterialPriceController.text) ?? 0) *
        //               (double.tryParse(addMaterialQuantityController.text) ??
        //                   1);
        //       total = (double.tryParse(addMaterialPriceController.text) ?? 0) *
        //           (double.tryParse(addMaterialQuantityController.text) ?? 1);
        //     } else {
        //       double discount =
        //           double.tryParse(addMaterialDiscountController.text) ?? 0;
        //       if (isPercentage) {
        //         discount = ((double.tryParse(addMaterialPriceController.text) ??
        //                     0) *
        //                 (double.tryParse(addMaterialQuantityController.text) ??
        //                     1) *
        //                 (double.tryParse(addMaterialDiscountController.text) ??
        //                     0)) /
        //             100;
        //       }

        //       subTotal = (double.tryParse(addMaterialPriceController.text) ??
        //               0) -
        //           discount *
        //               (double.tryParse(addMaterialQuantityController.text) ??
        //                   1) *
        //               tax +
        //           ((double.tryParse(addMaterialPriceController.text) ?? 0) *
        //                   (double.tryParse(
        //                           addMaterialQuantityController.text) ??
        //                       1) -
        //               discount);
        //       total = ((double.tryParse(addMaterialPriceController.text) ?? 0) *
        //               (double.tryParse(addMaterialQuantityController.text) ??
        //                   1)) -
        //           (discount);
        //     }
        //   }
        // }

        if (addMaterialPriceController.text.isNotEmpty &&
            addMaterialQuantityController.text.isNotEmpty) {
          materialCost =
              ((double.tryParse(addMaterialQuantityController.text) ?? 1) *
                  (double.tryParse(addMaterialCostController.text) ?? 0));
          if (client?.taxOnMaterial == 'N') {
            if (addMaterialDiscountController.text.isEmpty) {
              subTotal = (double.tryParse(addMaterialPriceController.text) ??
                      0) *
                  (double.tryParse(addMaterialQuantityController.text) ?? 1);
            } else {
              double discount =
                  double.tryParse(addMaterialDiscountController.text) ?? 0;
              if (isPercentage) {
                discount = ((double.tryParse(addMaterialPriceController.text) ??
                            0) *
                        (double.tryParse(addMaterialQuantityController.text) ??
                            1) *
                        (double.tryParse(addMaterialDiscountController.text) ??
                            0)) /
                    100;
              }
              subTotal = (((double.tryParse(addMaterialPriceController.text) ??
                          0) *
                      (double.tryParse(addMaterialQuantityController.text) ??
                          1)) -
                  discount);
            }
            total = subTotal;
          } else {
            //  log((client?.laborTaxRate).toString());
            final tax =
                (double.tryParse(client?.materialTaxRate ?? '') ?? 0) / 100;
            if (addMaterialDiscountController.text.isEmpty) {
              subTotal = ((double.tryParse(
                                  addMaterialQuantityController.text) ??
                              1) *
                          (double.tryParse(addMaterialPriceController.text) ??
                              0)) *
                      tax +
                  ((double.tryParse(addMaterialQuantityController.text) ?? 1) *
                      (double.tryParse(addMaterialPriceController.text) ?? 0));
              total =
                  ((double.tryParse(addMaterialQuantityController.text) ?? 1) *
                      (double.tryParse(addMaterialPriceController.text) ?? 0));
            } else {
              double discount =
                  double.tryParse(addMaterialDiscountController.text) ?? 0;
              if (isPercentage) {
                discount = ((double.tryParse(addMaterialPriceController.text) ??
                            0) *
                        (double.tryParse(addMaterialQuantityController.text) ??
                            0) *
                        (double.tryParse(addMaterialDiscountController.text) ??
                            0)) /
                    100;
              }
              subTotal = (((double.tryParse(
                                      addMaterialQuantityController.text) ??
                                  1) *
                              (double.tryParse(
                                      addMaterialPriceController.text) ??
                                  0)) -
                          discount) *
                      tax +
                  (((double.tryParse(addMaterialQuantityController.text) ?? 1) *
                          (double.tryParse(addMaterialPriceController.text) ??
                              0)) -
                      discount);
              total = (((double.tryParse(addMaterialQuantityController.text) ??
                          1) *
                      (double.tryParse(addMaterialPriceController.text) ?? 0)) -
                  discount);
            }
          }
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item == null ? "Add" : "Edit"} Material",
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
                        child: textBox(
                            "Amount",
                            addMaterialQuantityController,
                            "Quantity ",
                            addMaterialQuantityErrorStatus.isNotEmpty,
                            context,
                            true,
                            newSetState),
                      ),
                      errorWidget(error: addMaterialQuantityErrorStatus),
                      Padding(
                        padding: const EdgeInsets.only(top: 17.0),
                        child: textBox(
                            "Amount",
                            addMaterialCostController,
                            "Cost",
                            addMaterialCostErrorStatus.isNotEmpty,
                            context,
                            false,
                            newSetState),
                      ),
                      errorWidget(error: addMaterialCostErrorStatus),
                      Padding(
                        padding: EdgeInsets.only(top: 17),
                        child: Stack(
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
                      ),
                      errorWidget(error: addMaterialDiscountErrorStatus),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 17),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       const Text(
                      //         "Label",
                      //         style: TextStyle(
                      //           fontSize: 14,
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(0xff6A7187),
                      //         ),
                      //       ),
                      //       GestureDetector(
                      //         onTap: () {
                      //           newSetState(() {
                      //             tagDataList.add("Tag");
                      //           });
                      //         },
                      //         child: const Row(
                      //           children: [
                      //             Icon(
                      //               Icons.add,
                      //               color: AppColors.primaryColors,
                      //             ),
                      //             Text(
                      //               "Add New",
                      //               style: TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w600,
                      //                 color: AppColors.primaryColors,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
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
                            false,
                            newSetState),
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
                              "Cost :",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryTitleColor),
                            ),
                            Text(
                              "\$${materialCost.toStringAsFixed(2)}",
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
                        padding: const EdgeInsets.only(top: 17),
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
                            FocusManager.instance.primaryFocus?.unfocus();

                            final status = addMaterialValidation(newSetState);
                            if (status) {
                              final focus = FocusNode().requestFocus();
                              if (index != null) {
                                material[index] = CannedServiceAddModel(
                                  id: item!.id,
                                  cannedServiceId: int.parse(serviceId),
                                  note: addMaterialDescriptionController.text,
                                  part: addMaterialBatchController.text,
                                  itemName: addMaterialNameController.text,
                                  unitPrice: addMaterialPriceController.text,
                                  discount: addMaterialDiscountController.text
                                          .trim()
                                          .isEmpty
                                      ? "0"
                                      : addMaterialDiscountController.text
                                          .trim(),
                                  discountType: isPercentage &&
                                          addMaterialDiscountController
                                              .text.isNotEmpty
                                      ? "Percentage"
                                      : "Fixed",
                                  quanityHours:
                                      addMaterialQuantityController.text.trim(),
                                  itemType: "Material",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addMaterialCostController.text.trim(),
                                );
                                if (item.id != '') {
                                  final ind = editedItems.indexWhere(
                                      (element) => element.id == item.id);
                                  if (ind != -1) {
                                    editedItems[index] = material[index];
                                  } else {
                                    editedItems.add(material[index]);
                                  }
                                }
                              } else {
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
                                        : addMaterialDiscountController.text
                                            .trim(),
                                    discountType: isPercentage &&
                                            addMaterialDiscountController
                                                .text.isNotEmpty
                                        ? "Percentage"
                                        : "Fixed",
                                    quanityHours: addMaterialQuantityController
                                        .text
                                        .trim(),
                                    itemType: "Material",
                                    subTotal: subTotal.toStringAsFixed(2),
                                    cost:
                                        addMaterialCostController.text.trim()));
                                log(material.last.toJson().toString());
                              }
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

  addPartPopup({CannedServiceAddModel? item, int? index}) {
    //Add part popup controllers
    final addPartNameController = TextEditingController(text: item?.itemName);
    final addPartDescriptionController =
        TextEditingController(text: item?.note);
    final addPartPriceController = TextEditingController(text: item?.unitPrice);
    final addPartQuantityController =
        TextEditingController(text: item?.quanityHours ?? '1');
    final addPartCostController = TextEditingController(text: item?.cost);
    final addPartDiscountController =
        TextEditingController(text: item?.discount ?? '0');
    final addPartPartNumberController = TextEditingController(text: item?.part);

    //Add part errorstatus and error message variables
    String addPartNameErrorStatus = '';
    String addPartDescriptionErrorStatus = '';
    String addPartPriceErrorStatus = '';
    String addPartQuantityErrorStatus = '';
    String addPartCostErrorStatus = '';
    String addPartDiscountErrorStatus = '';
    String adddPartPartNumberErrorStatus = '';

    double subTotal = 0;
    double total = 0;
    bool isPercentage = item?.discountType == "Percentage" ? true : false;
    double partCost = 0;

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
          partCost = ((double.tryParse(addPartQuantityController.text) ?? 1) *
              (double.tryParse(addPartCostController.text) ?? 0));
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
              Text(
                "${item == null ? "Add" : "Edit"} Part",
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
                      child: textBox(
                          "Amount",
                          addPartCostController,
                          "Cost ",
                          addPartCostErrorStatus.isNotEmpty,
                          context,
                          false,
                          newSetState),
                    ),
                    errorWidget(error: addPartCostErrorStatus),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 17),
                          child: textBox(
                            "Enter Amount",
                            addPartDiscountController,
                            "Discount",
                            addPartDiscountErrorStatus.isNotEmpty,
                            context,
                            false,
                            newSetState,
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 58,
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
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 17),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         "Label",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //           color: Color(0xff6A7187),
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           newSetState(() {
                    //             tagDataList.add("Tag");
                    //           });
                    //         },
                    //         child: const Row(
                    //           children: [
                    //             Icon(
                    //               Icons.add,
                    //               color: AppColors.primaryColors,
                    //             ),
                    //             Text(
                    //               "Add New",
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: AppColors.primaryColors,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
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
                            "Cost :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${partCost.toStringAsFixed(2)}",
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
                          FocusManager.instance.primaryFocus?.unfocus();

                          final status = addPartValidation(newSetState);
                          if (status) {
                            final focus = FocusNode().requestFocus();

                            if (index != null) {
                              part[index] = CannedServiceAddModel(
                                  id: item!.id,
                                  cannedServiceId: int.parse(serviceId),
                                  note: addPartDescriptionController.text,
                                  part: addPartPartNumberController.text,
                                  itemName: addPartNameController.text,
                                  unitPrice: addPartPriceController.text,
                                  discount: addPartDiscountController.text
                                          .trim()
                                          .isEmpty
                                      ? "0"
                                      : addPartDiscountController.text.trim(),
                                  discountType: isPercentage &&
                                          addPartDiscountController
                                              .text.isNotEmpty
                                      ? "Percentage"
                                      : "Fixed",
                                  quanityHours: addPartQuantityController.text,
                                  itemType: "Part",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addPartCostController.text.trim());
                              if (item.id != '') {
                                final ind = editedItems.indexWhere(
                                    (element) => element.id == item.id);
                                if (ind != -1) {
                                  editedItems[index] = part[index];
                                } else {
                                  editedItems.add(part[index]);
                                }
                              }
                            } else {
                              part.add(CannedServiceAddModel(
                                  cannedServiceId: int.parse(serviceId),
                                  note: addPartDescriptionController.text,
                                  part: addPartPartNumberController.text,
                                  itemName: addPartNameController.text,
                                  unitPrice: addPartPriceController.text,
                                  discount: addPartDiscountController.text
                                          .trim()
                                          .isEmpty
                                      ? "0"
                                      : addPartDiscountController.text.trim(),
                                  discountType: isPercentage &&
                                          addPartDiscountController
                                              .text.isNotEmpty
                                      ? "Percentage"
                                      : "Fixed",
                                  quanityHours: addPartQuantityController.text,
                                  itemType: "Part",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addPartCostController.text.trim()));
                            }
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

  addLaborPopup({CannedServiceAddModel? item, int? index}) {
    //Add Labor popup controllers
    final addLaborNameController = TextEditingController(text: item?.itemName);
    final addLaborDescriptionController =
        TextEditingController(text: item?.note);
    final addLaborCostController = TextEditingController(text: item?.cost);
    final addLaborDiscountController =
        TextEditingController(text: item?.discount ?? '0');
    final addLaborHoursController =
        TextEditingController(text: item?.quanityHours ?? '1');
    final addLaborBaseCostController =
        TextEditingController(text: item?.unitPrice ?? client?.baseLaborCost);
    final addLaborTaxController =
        TextEditingController(text: item?.tax ?? client?.laborTaxRate);

    //Add Labor errorstatus and error message variables
    String addLaborNameErrorStatus = '';
    String addLaborDescriptionErrorStatus = '';
    String addLaborCostErrorStatus = '';
    String addLaborDiscountErrorStatus = '';
    String addLaborHoursErrorStatus = '';
    String addLaborBaseCostStatus = '';
    String addLaborTaxStatus = '';

    double subTotal = 0;
    double total = 0;
    bool isPercentage = item?.discountType == "Percentage" ? true : false;
    double laborCost = 0;

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
      if (addLaborBaseCostController.text.isNotEmpty) {
        laborCost = ((double.tryParse(addLaborHoursController.text) ?? 1) *
            (double.tryParse(addLaborCostController.text) ?? 0));
        if (client?.taxOnLabors == 'N' &&
            addLaborTaxController.text.trim().isEmpty) {
          if (addLaborDiscountController.text.isEmpty) {
            subTotal = (double.tryParse(addLaborBaseCostController.text) ?? 0) *
                (double.tryParse(addLaborHoursController.text) ?? 1);
          } else {
            double discount =
                double.tryParse(addLaborDiscountController.text) ?? 0;
            if (isPercentage) {
              discount = ((double.tryParse(addLaborBaseCostController.text) ??
                          0) *
                      (double.tryParse(addLaborHoursController.text) ?? 1) *
                      (double.tryParse(addLaborDiscountController.text) ?? 0)) /
                  100;
            }
            subTotal =
                (((double.tryParse(addLaborBaseCostController.text) ?? 0) *
                        (double.tryParse(addLaborHoursController.text) ?? 1)) -
                    discount);
          }
          total = subTotal;
        } else {
          double tax = (double.tryParse(client?.laborTaxRate ?? '') ?? 0) / 100;
          if (addLaborTaxController.text.trim().isNotEmpty) {
            tax =
                (double.tryParse(addLaborTaxController.text.trim()) ?? 0) / 100;
          }
          if (addLaborDiscountController.text.isEmpty) {
            subTotal = ((double.tryParse(addLaborHoursController.text) ?? 1) *
                        (double.tryParse(addLaborBaseCostController.text) ??
                            0)) *
                    tax +
                ((double.tryParse(addLaborHoursController.text) ?? 1) *
                    (double.tryParse(addLaborBaseCostController.text) ?? 0));
            total = ((double.tryParse(addLaborHoursController.text) ?? 1) *
                (double.tryParse(addLaborBaseCostController.text) ?? 0));
          } else {
            double discount =
                double.tryParse(addLaborDiscountController.text) ?? 0;
            if (isPercentage) {
              discount = ((double.tryParse(addLaborBaseCostController.text) ??
                          0) *
                      (double.tryParse(addLaborHoursController.text) ?? 0) *
                      (double.tryParse(addLaborDiscountController.text) ?? 0)) /
                  100;
            }
            subTotal = (((double.tryParse(addLaborHoursController.text) ?? 1) *
                            (double.tryParse(addLaborBaseCostController.text) ??
                                0)) -
                        discount) *
                    tax +
                (((double.tryParse(addLaborHoursController.text) ?? 1) *
                        (double.tryParse(addLaborBaseCostController.text) ??
                            0)) -
                    discount);
            total = (((double.tryParse(addLaborHoursController.text) ?? 1) *
                    (double.tryParse(addLaborBaseCostController.text) ?? 0)) -
                discount);
          }
        }
      }
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item == null ? "Add" : "Edit"} Labor",
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
                          false),
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
                          addLaborTaxController,
                          "Labor Tax",
                          addLaborTaxStatus.isNotEmpty,
                          context,
                          true,
                          newSetState),
                    ),
                    errorWidget(error: addLaborTaxStatus),
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
                        Padding(
                          padding: EdgeInsets.only(top: 17),
                          child: textBox(
                              "Enter Amount",
                              addLaborDiscountController,
                              "Discount",
                              addLaborDiscountErrorStatus.isNotEmpty,
                              context,
                              false,
                              newSetState),
                        ),
                        Positioned(
                          right: 10,
                          top: 58,
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
                            "Cost :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${laborCost.toStringAsFixed(2)}",
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
                          FocusManager.instance.primaryFocus?.unfocus();

                          final status = addLaborValidation(newSetState);
                          if (status) {
                            final focus = FocusNode().requestFocus();

                            if (index != null) {
                              labor[index] = CannedServiceAddModel(
                                  id: item!.id,
                                  cannedServiceId: int.parse(serviceId),
                                  note: addLaborDescriptionController.text,
                                  // part: addLaborLaborNumberController.text,
                                  part: '',
                                  itemName: addLaborNameController.text,
                                  unitPrice: addLaborBaseCostController.text,
                                  discount: addLaborDiscountController.text
                                          .trim()
                                          .isEmpty
                                      ? "0"
                                      : addLaborDiscountController.text.trim(),
                                  discountType: isPercentage &&
                                          addLaborDiscountController
                                              .text.isNotEmpty
                                      ? "Percentage"
                                      : "Fixed",
                                  tax: (double.tryParse(addLaborTaxController
                                              .text
                                              .trim()) ??
                                          0.0)
                                      .toStringAsFixed(2),
                                  quanityHours: addLaborHoursController.text,
                                  itemType: "Labor",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addLaborCostController.text.trim());
                              if (item.id != '') {
                                final ind = editedItems.indexWhere(
                                    (element) => element.id == item.id);
                                if (ind != -1) {
                                  editedItems[index] = labor[index];
                                } else {
                                  editedItems.add(labor[index]);
                                }
                              }
                            } else {
                              labor.add(CannedServiceAddModel(
                                  cannedServiceId: int.parse(serviceId),
                                  note: addLaborDescriptionController.text,
                                  // part: addLaborLaborNumberController.text,
                                  part: '',
                                  itemName: addLaborNameController.text,
                                  unitPrice: addLaborBaseCostController.text,
                                  discount: addLaborDiscountController.text
                                          .trim()
                                          .isEmpty
                                      ? "0"
                                      : addLaborDiscountController.text.trim(),
                                  discountType: isPercentage &&
                                          addLaborDiscountController
                                              .text.isNotEmpty
                                      ? "Percentage"
                                      : "Fixed",
                                  tax: (double.tryParse(addLaborTaxController
                                              .text
                                              .trim()) ??
                                          0.0)
                                      .toStringAsFixed(2),
                                  quanityHours: addLaborHoursController.text,
                                  itemType: "Labor",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addLaborCostController.text.trim()));
                            }
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

  addFeePopup({CannedServiceAddModel? item, int? index}) {
    //Add Fee popup controllers
    final addFeeNameController = TextEditingController(text: item?.itemName);
    final addFeeDescriptionController = TextEditingController(text: item?.note);
    final addFeeCostController = TextEditingController(text: item?.cost);
    final addFeePriceController = TextEditingController(text: item?.unitPrice);

    //Add Fee errorstatus and error message variables
    String addFeeNameErrorStatus = '';
    String addFeeDescriptionErrorStatus = '';
    String addFeePriceErrorStatus = '';
    String addFeeCostErrorStatus = '';

    double subTotal = 0;
    double total = 0;
    double feeCost = 0;

    addFeeValidation(StateSetter setState) {
      bool status = true;
      if (addFeeNameController.text.trim().isEmpty) {
        addFeeNameErrorStatus = "Fee name can't be empty";
        status = false;
      } else {
        if (addFeeNameController.text.trim().length < 2) {
          addFeeNameErrorStatus = "Fee name must be atleast 2 characters";
          status = false;
        } else {
          addFeeNameErrorStatus = '';
        }
      }
      if (addFeePriceController.text.trim().isEmpty) {
        addFeePriceErrorStatus = "Price can't be empty";
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
        feeCost = double.tryParse(addFeeCostController.text) ?? 0;

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
              Text(
                "${item == null ? "Add" : "Edit"} Fee",
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
                      child: textBox(
                          "Amount",
                          addFeeCostController,
                          "Cost ",
                          addFeeCostErrorStatus.isNotEmpty,
                          context,
                          false,
                          newSetState),
                    ),
                    errorWidget(error: addFeeCostErrorStatus),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 17),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         "Label",
                    //         style: TextStyle(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //           color: Color(0xff6A7187),
                    //         ),
                    //       ),
                    //       GestureDetector(
                    //         onTap: () {
                    //           newSetState(() {
                    //             tagDataList.add("Tag");
                    //           });
                    //         },
                    //         child: const Row(
                    //           children: [
                    //             Icon(
                    //               Icons.add,
                    //               color: AppColors.primaryColors,
                    //             ),
                    //             Text(
                    //               "Add New",
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: AppColors.primaryColors,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
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
                            "Cost :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryTitleColor),
                          ),
                          Text(
                            "\$${feeCost.toStringAsFixed(2)}",
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
                          FocusManager.instance.primaryFocus?.unfocus();

                          final status = addFeeValidation(newSetState);
                          if (status) {
                            final focus = FocusNode().requestFocus();

                            if (index != null) {
                              fee[index] = CannedServiceAddModel(
                                  id: item!.id,
                                  cannedServiceId: int.parse(serviceId),
                                  note: addFeeDescriptionController.text,
                                  // part: addFeeFeeNumberController.text,
                                  part: '',
                                  itemName: addFeeNameController.text,
                                  discount: '0',
                                  unitPrice: addFeePriceController.text,
                                  itemType: "Fee",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addFeeCostController.text.trim());

                              if (item.id != '') {
                                final ind = editedItems.indexWhere(
                                    (element) => element.id == item.id);
                                if (ind != -1) {
                                  editedItems[index] = fee[index];
                                } else {
                                  editedItems.add(fee[index]);
                                }
                              }
                            } else {
                              fee.add(CannedServiceAddModel(
                                  cannedServiceId: int.parse(serviceId),
                                  note: addFeeDescriptionController.text,
                                  // part: addFeeFeeNumberController.text,
                                  part: '',
                                  itemName: addFeeNameController.text,
                                  discount: '0',
                                  unitPrice: addFeePriceController.text,
                                  itemType: "Fee",
                                  subTotal: subTotal.toStringAsFixed(2),
                                  cost: addFeeCostController.text.trim()));
                            }
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

  addSubContractPopup({CannedServiceAddModel? item, int? index}) {
    //Add SubContract popup controllers
    final addSubContractNameController =
        TextEditingController(text: item?.itemName);
    final addSubContractDescriptionController =
        TextEditingController(text: item?.note);
    final addSubContractCostController =
        TextEditingController(text: item?.cost);
    final addSubContractPriceController =
        TextEditingController(text: item?.unitPrice);
    final addSubContractDiscountController =
        TextEditingController(text: item?.discount ?? '0');

    final vendor =
        vendors.where((element) => element.id == item?.vendorId).toList();
    if (vendor.isNotEmpty) {
      addSubContractVendorController.text = vendor[0].vendorName.toString();
      vendorId = vendor[0].id;
    }

    //Add SubContract errorstatus and error message variables
    String addSubContractNameErrorStatus = '';
    String addSubContractDescriptionErrorStatus = '';
    String addSubContractPriceErrorStatus = '';
    String addSubContractCostErrorStatus = '';
    String addSubContractDiscountErrorStatus = '';
    String addSubContractVendorErrorStatus = '';

    double subTotal = 0;
    double total = 0;
    bool isPercentage = false;
    double subContractCost = 0;

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
        subContractCost =
            double.tryParse(addSubContractCostController.text) ?? 0;
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
            // TODO: implement listener
          },
          child: BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${item == null ? "Add" : "Edit"} SubContract",
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
                                  "Enter Subcontract Name",
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
                                  "Enter Subcontract Description",
                                  addSubContractDescriptionController,
                                  "Description",
                                  addSubContractDescriptionErrorStatus
                                      .isNotEmpty,
                                  context,
                                  false),
                            ),
                            errorWidget(
                                error: addSubContractDescriptionErrorStatus),
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
                                  false,
                                  newSetState),
                            ),
                            errorWidget(error: addSubContractCostErrorStatus),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: textBox(
                                      "Amount",
                                      addSubContractDiscountController,
                                      "Discount",
                                      addSubContractDiscountErrorStatus
                                          .isNotEmpty,
                                      context,
                                      false,
                                      newSetState),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 58,
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
                            errorWidget(
                                error: addSubContractDiscountErrorStatus),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 17),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       const Text(
                            //         "Label",
                            //         style: TextStyle(
                            //           fontSize: 14,
                            //           fontWeight: FontWeight.w500,
                            //           color: Color(0xff6A7187),
                            //         ),
                            //       ),
                            //       GestureDetector(
                            //         onTap: () {
                            //           newSetState(() {
                            //             tagDataList.add("Tag");
                            //           });
                            //         },
                            //         child: const Row(
                            //           children: [
                            //             Icon(
                            //               Icons.add,
                            //               color: AppColors.primaryColors,
                            //             ),
                            //             Text(
                            //               "Add New",
                            //               style: TextStyle(
                            //                 fontSize: 14,
                            //                 fontWeight: FontWeight.w600,
                            //                 color: AppColors.primaryColors,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
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
                                  "Select Existing",
                                  addSubContractVendorController,
                                  "Vendor",
                                  addSubContractVendorErrorStatus.isNotEmpty,
                                  context,
                                  false,
                                  newSetState),
                            ),
                            errorWidget(error: addSubContractVendorErrorStatus),
                            Padding(
                              padding: EdgeInsets.only(top: 17),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Cost :",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryTitleColor),
                                  ),
                                  Text(
                                    "\$${subContractCost.toStringAsFixed(2)}",
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  FocusManager.instance.primaryFocus?.unfocus();

                                  final status =
                                      addSubContractValidation(newSetState);
                                  if (status) {
                                    final focus = FocusNode().requestFocus();

                                    if (index != null) {
                                      subContract[index] =
                                          CannedServiceAddModel(
                                              id: item!.id,
                                              cannedServiceId:
                                                  int.parse(serviceId),
                                              note:
                                                  addSubContractDescriptionController
                                                      .text,
                                              // part: addSubContractSubContractNumberController.text,
                                              part: '',
                                              itemName:
                                                  addSubContractNameController
                                                      .text,
                                              discount:
                                                  addSubContractDiscountController
                                                          .text
                                                          .trim()
                                                          .isEmpty
                                                      ? "0"
                                                      : addSubContractDiscountController
                                                          .text
                                                          .trim(),
                                              discountType: isPercentage &&
                                                      addSubContractDiscountController
                                                          .text.isNotEmpty
                                                  ? "Percentage"
                                                  : "Fixed",
                                              tax: isTax == true ? 'Y' : 'N',
                                              vendorId: vendorId,
                                              unitPrice:
                                                  addSubContractPriceController
                                                      .text,
                                              itemType: "SubContract",
                                              subTotal:
                                                  subTotal.toStringAsFixed(2),
                                              cost: addSubContractCostController
                                                  .text
                                                  .trim());
                                      if (item.id != '') {
                                        final ind = editedItems.indexWhere(
                                            (element) => element.id == item.id);
                                        if (ind != -1) {
                                          editedItems[index] =
                                              subContract[index];
                                        } else {
                                          editedItems.add(subContract[index]);
                                        }
                                      }
                                    } else {
                                      subContract.add(
                                        CannedServiceAddModel(
                                            cannedServiceId: int
                                                .parse(serviceId),
                                            note:
                                                addSubContractDescriptionController
                                                    .text,
                                            // part: addSubContractSubContractNumberController.text,
                                            part: '',
                                            itemName:
                                                addSubContractNameController
                                                    .text,
                                            discount:
                                                addSubContractDiscountController
                                                        .text
                                                        .trim()
                                                        .isEmpty
                                                    ? "0"
                                                    : addSubContractDiscountController
                                                        .text
                                                        .trim(),
                                            discountType: isPercentage &&
                                                    addSubContractDiscountController
                                                        .text.isNotEmpty
                                                ? "Percentage"
                                                : "Fixed",
                                            tax: isTax == true ? 'Y' : 'N',
                                            vendorId: vendorId,
                                            unitPrice:
                                                addSubContractPriceController
                                                    .text,
                                            itemType: "SubContract",
                                            subTotal:
                                                subTotal.toStringAsFixed(2),
                                            cost: addSubContractCostController
                                                .text
                                                .trim()),
                                      );
                                    }
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width, 56),
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
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
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

                                            print(technicianId + "techhh iddd");

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

    // Use a regular expression to check for valid input with up to 2 decimal places
    final regExp = RegExp(r'^\d*\.?\d{0,2}$');
    if (!regExp.hasMatch(newValue.text)) {
      // If the input doesn't match the pattern, return the old value
      return oldValue;
    }

    // If the input is valid, allow it
    return newValue;
  }
}
