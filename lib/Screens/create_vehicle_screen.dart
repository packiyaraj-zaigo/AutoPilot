import 'dart:developer';

import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Models/vechile_model.dart';
import 'package:auto_pilot/Models/vin_global_response.dart';
import 'package:auto_pilot/Screens/dummy_vehcile_screen.dart';
import 'package:auto_pilot/Screens/vehicles_screen.dart';
import 'package:auto_pilot/bloc/vechile/vechile_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateVehicleScreen extends StatefulWidget {
  const CreateVehicleScreen({
    super.key,
    this.vehicle,
    this.vin = '',
    this.editVehicle,
    this.navigation,
    this.customerId,
  });
  final String vin;
  final VinGlobalSearchResponseModel? vehicle;
  final Datum? editVehicle;
  final String? navigation;
  final String? customerId;

  @override
  State<CreateVehicleScreen> createState() => _CreateVehicleScreenState();
}

class _CreateVehicleScreenState extends State<CreateVehicleScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController subModelController = TextEditingController();
  final TextEditingController engineController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController licController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  bool yearErrorStaus = false;
  bool modelErrorStatus = false;
  bool subModelErrorStatus = false;
  bool engineErrorStatus = false;
  bool colorErrorStatus = false;
  bool vinErrorStatus = false;
  bool licErrorStatus = false;
  bool nameErrorStatus = false;
  bool typeErrorStatus = false;
  bool makeErrorStatus = false;
  bool isChecked = false;

  bool isVechileLoading = false;

  String yearErrorMsg = '';
  String modelErrorMsg = '';
  String makeErrorMsg = '';
  String typeErrorMsg = '';
  String colorErrorMsg = '';
  String vinErrorMsg = '';
  String submodelErrorMsg = '';
  String licErrorMsg = '';
  String engineErrorMsg = '';

  final List<Datum> vechile = [];

  List<String> states = [];
  List<DropdownDatum> dropdownData = [];
  dynamic _currentSelectedTypeValue;

  addDataToFields() {
    // nameController.text = widget.vehicle!.
    yearController.text = widget.vehicle!.modelYear ?? '';
    modelController.text = widget.vehicle!.model ?? '';
    engineController.text = widget.vehicle!.displacementCc ?? '';
    makeController.text = widget.vehicle!.make ?? '';
    typeController.text = widget.vehicle!.vehicleType ?? '';
  }

  editVehicleDataIntegration() {
    yearController.text = widget.editVehicle!.vehicleYear;
    makeController.text = widget.editVehicle!.vehicleMake;
    modelController.text = widget.editVehicle!.vehicleModel;
    subModelController.text = widget.editVehicle!.subModel ?? "";
    engineController.text = widget.editVehicle!.engineSize ?? "";
    colorController.text = widget.editVehicle!.vehicleColor ?? "";
    licController.text = widget.editVehicle!.licencePlate ?? "";
    typeController.text = widget.editVehicle!.vehicleType;
    vinController.text = widget.editVehicle!.vin ?? '';
  }

  @override
  void initState() {
    super.initState();
    vinController.text = widget.vin;
    if (widget.vehicle != null) {
      addDataToFields();
    } else if (widget.editVehicle != null) {
      editVehicleDataIntegration();
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
    return WillPopScope(
      onWillPop: () async {
        if (widget.navigation != null &&
            widget.navigation != "estimate_screen") {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const VehiclesScreen()));
          return false;
        } else {
          Navigator.pop(context);
          return false;
        }
      },
      child: BlocProvider(
        create: (context) => VechileBloc()..add(DropDownVechile()),
        child: Scaffold(
            key: scaffoldKey,
            body: SafeArea(
              child: BlocListener<VechileBloc, VechileState>(
                listener: (context, state) {
                  log(state.toString());
                  if (state is CreateVehicleErrorState) {
                    CommonWidgets().showDialog(context, state.message);
                  } else if (state is CreateVehicleSuccessState) {
                    if (widget.navigation != null &&
                        !isChecked &&
                        widget.navigation != "estimate_screen") {
                      log('here');
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const VehiclesScreen()),
                        (route) => false,
                      );
                    } else if (widget.navigation != null &&
                        isChecked &&
                        widget.navigation != "estimate_screen") {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return DummyVehicleScreen(
                            vehicleId: state.createdId.toString(),
                          );
                        },
                      ));
                    } else {
                      Navigator.pop(context, vinController.text);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vehicle Created Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is EditVehicleErrorState) {
                    CommonWidgets().showDialog(context, state.message);
                  } else if (state is EditVehicleSuccessState) {
                    log('here');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const VehiclesScreen()),
                      (route) => false,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vehicle Updated Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is DropdownVechileDetailsSuccessState) {
                    dropdownData.addAll(state.dropdownData.data.data);
                  }
                },
                child: BlocBuilder<VechileBloc, VechileState>(
                    builder: (context, state) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateUpdate) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
                            centerTitle: true,
                            backgroundColor: Colors.transparent,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            title: Text(
                              widget.editVehicle != null
                                  ? "Edit Vehicle"
                                  : "New Vehicle",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primaryBlackColors,
                                  fontWeight: FontWeight.w500),
                            ),
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    if (widget.navigation != null &&
                                        widget.navigation !=
                                            'estimate_screen') {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const VehiclesScreen()));
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.clear,
                                    color: AppColors.primaryColors,
                                  ))
                            ],
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24.0, right: 24),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Basic Details",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                    const SizedBox(height: 16),
                                    // textBox("Enter name...", nameController,
                                    //     "Owner", nameErrorStatus),
                                    textBox(
                                        "Enter Year",
                                        yearController,
                                        "Year",
                                        yearErrorStaus,
                                        widget.vehicle != null &&
                                            widget.vehicle!.modelYear!
                                                .isNotEmpty),
                                    Visibility(
                                        visible: yearErrorStaus,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 6.0),
                                          child: Text(
                                            yearErrorMsg,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                0xffD80027,
                                              ),
                                            ),
                                          ),
                                        )),

                                    textBox(
                                        "Enter Make",
                                        makeController,
                                        "Make",
                                        makeErrorStatus,
                                        widget.vehicle != null &&
                                            widget.vehicle!.make!.isNotEmpty),

                                    Visibility(
                                        visible: makeErrorStatus,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 6.0),
                                          child: Text(
                                            makeErrorMsg,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                0xffD80027,
                                              ),
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    textBox(
                                        "Enter Model",
                                        modelController,
                                        "Model",
                                        modelErrorStatus,
                                        widget.vehicle != null &&
                                            widget.vehicle!.model!.isNotEmpty),
                                    Visibility(
                                        visible: modelErrorStatus,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Text(
                                            modelErrorMsg,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(
                                                0xffD80027,
                                              ),
                                            ),
                                          ),
                                        )),
                                    textBox(
                                        "Enter Number",
                                        vinController,
                                        "VIN",
                                        vinErrorStatus,
                                        widget.vehicle != null &&
                                            widget.vin.isNotEmpty),
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent),
                                      child: ExpansionTile(
                                        tilePadding: const EdgeInsets.all(0),
                                        childrenPadding:
                                            const EdgeInsets.all(0),
                                        title: const Text(
                                          'Additional Fields',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  AppColors.primaryTitleColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        children: <Widget>[
                                          ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  textBox(
                                                      "Enter Sub-Model",
                                                      subModelController,
                                                      "Sub-Model",
                                                      subModelErrorStatus),
                                                  textBox(
                                                      "Enter Engine",
                                                      engineController,
                                                      "Engine",
                                                      engineErrorStatus,
                                                      widget.vehicle != null &&
                                                          widget
                                                              .vehicle!
                                                              .displacementCc!
                                                              .isNotEmpty),
                                                  // textBox(
                                                  //     "Enter make...",
                                                  //     makeController,
                                                  //     "Make",
                                                  //     makeErrorStatus),
                                                  textBox(
                                                    "Enter Color",
                                                    colorController,
                                                    "Color",
                                                    colorErrorStatus,
                                                  ),
                                                  textBox(
                                                      "Enter Number",
                                                      licController,
                                                      "LIC",
                                                      licErrorStatus),
                                                  typeController.text.isNotEmpty
                                                      ? const SizedBox()
                                                      : const Text(
                                                          "Type",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .greyText),
                                                        ),
                                                  vechiledropDown(),
                                                  // SizedBox(
                                                  //   height: 50,
                                                  //   child: CupertinoTextField(
                                                  //     controller: typeController,
                                                  //     readOnly: false,
                                                  //     placeholder: 'Select',
                                                  //     style: TextStyle(
                                                  //         fontSize: 15,
                                                  //         fontWeight:
                                                  //             FontWeight.w400,
                                                  //         color: AppColors
                                                  //             .primaryBlackColors),
                                                  //     suffix: Icon(Icons
                                                  //         .arrow_drop_down_outlined),
                                                  //     decoration: BoxDecoration(
                                                  //       borderRadius:
                                                  //           BorderRadius.all(
                                                  //               Radius.circular(
                                                  //                   10)),
                                                  //       border: Border.all(
                                                  //           color: AppColors
                                                  //               .greyText),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                    widget.navigation == "estimate_screen" ||
                                            widget.navigation ==
                                                "partial_estimate" ||
                                            widget.editVehicle != null
                                        ? const SizedBox(height: 16)
                                        : Center(
                                            child: Row(
                                              children: <Widget>[
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                Checkbox(
                                                  checkColor: Colors.white,
                                                  value: isChecked,
                                                  onChanged: (bool? value) {
                                                    stateUpdate(() {
                                                      isChecked = value!;
                                                    });
                                                  },
                                                ),
                                                const Text(
                                                  "Create new estimate using this vehicle",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .primaryTitleColor),
                                                )
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          validateVechile();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColors,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: state
                                                is AddVechileDetailsLoadingState
                                            ? const CupertinoActivityIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                widget.editVehicle != null
                                                    ? 'Update'
                                                    : 'Confirm',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ))
                        ],
                      ),
                    );
                  });
                }),
              ),
            )),
      ),
    );
  }

  validateVechile() {
    if (yearController.text.trim().isEmpty) {
      yearErrorMsg = "Year can't be empty.";
      yearErrorStaus = true;
    } else {
      if (yearController.text.trim().length < 4) {
        yearErrorMsg = "Please enter a valid year";
        yearErrorStaus = true;
      } else {
        yearErrorStaus = false;
      }
    }
    if (modelController.text.trim().isEmpty) {
      modelErrorMsg = "Model can't be empty.";
      modelErrorStatus = true;
    } else {
      if (modelController.text.trim().length < 2) {
        modelErrorMsg = "Please enter a valid model";
        modelErrorStatus = true;
      } else {
        modelErrorStatus = false;
      }
    }
    if (typeController.text.trim().isEmpty) {
      typeErrorMsg = "Type can't be empty.";
      typeErrorStatus = true;
    } else {
      typeErrorStatus = false;
    }
    if (makeController.text.isEmpty) {
      makeErrorStatus = true;
      makeErrorMsg = "Make can't be empty";
    } else {
      if (makeController.text.length < 2) {
        makeErrorStatus = true;
        makeErrorMsg = "Please enter a valid make";
      } else {
        makeErrorStatus = false;
      }
    }
    setState(() {});
    networkCheck().then(
      (value) {
        if (!yearErrorStaus &&
            !modelErrorStatus &&
            !makeErrorStatus &&
            !value) {
          CommonWidgets().showDialog(
              context, 'Please check your internet connection and try again');
        }
        if (!yearErrorStaus && !modelErrorStatus && !makeErrorStatus) {
          if (widget.editVehicle != null) {
            scaffoldKey.currentContext!.read<VechileBloc>().add(
                  EditVehicleEvent(
                    id: widget.editVehicle!.id.toString(),
                    email: nameController.text,
                    year: yearController.text,
                    model: modelController.text,
                    submodel: subModelController.text,
                    engine: engineController.text,
                    color: colorController.text,
                    vinNumber: vinController.text,
                    licNumber: licController.text,
                    make: makeController.text,
                    type: typeController.text,
                    customerId: widget.editVehicle!.customerId.toString(),
                  ),
                );
          } else {
            scaffoldKey.currentContext!.read<VechileBloc>().add(
                  AddVechile(
                    email: nameController.text,
                    year: yearController.text,
                    model: modelController.text,
                    submodel: subModelController.text,
                    engine: engineController.text,
                    color: colorController.text,
                    vinNumber: vinController.text,
                    licNumber: licController.text,
                    make: makeController.text,
                    type: typeController.text,
                    customerId: widget.customerId ?? '0',
                  ),
                );
          }
        }
      },
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus,
      [bool readOnly = false]) {
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
                  color: Color(0xff6A7187)),
            ),
            label == 'Year' || label == 'Model' || label == "Make"
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
                : const Text('')
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 6),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              readOnly: readOnly,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              inputFormatters: label == "Year"
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              keyboardType: label == 'Year' ? TextInputType.number : null,
              maxLength: label == 'Year'
                  ? 4
                  : label == "Make" || label == "Model" || label == "Sub-Model"
                      ? 100
                      : label == "VIN"
                          ? 30
                          : label == "LIC"
                              ? 20
                              : 100,
              decoration: InputDecoration(
                  counterText: '',
                  hintText: placeHolder,
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

  Widget vechiledropDown() {
    return widget.vehicle != null
        ? textBox('Type', typeController, 'Type', false, true)
        : Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
                    // padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xffC1C4CD)),
                        borderRadius: BorderRadius.circular(12)),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButtonFormField<DropdownDatum>(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          menuMaxHeight: 380,
                          value: _currentSelectedTypeValue,
                          style: const TextStyle(color: Color(0xff6A7187)),
                          items: dropdownData
                              .map<DropdownMenuItem<DropdownDatum>>(
                                  (DropdownDatum value) {
                            return DropdownMenuItem<DropdownDatum>(
                              alignment: AlignmentDirectional.centerStart,
                              value: value,
                              child: Text(value.vehicleTypeName),
                            );
                          }).toList(),
                          hint: Text(
                            widget.editVehicle == null ||
                                    widget.editVehicle!.vehicleType.isEmpty
                                ? "Select Type"
                                : widget.editVehicle!.vehicleType.toString(),
                            style: TextStyle(
                                color: Color(0xff6A7187),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                          onChanged: (DropdownDatum? value) {
                            setState(() {
                              typeController.text =
                                  value?.vehicleTypeName ?? '';
                              _currentSelectedTypeValue = value;
                            });
                          },
                          //isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
