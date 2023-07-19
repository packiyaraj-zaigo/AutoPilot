import 'dart:developer';

import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Models/vechile_model.dart';
import 'package:auto_pilot/Models/vin_global_response.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/Screens/vehicles_screen.dart';
import 'package:auto_pilot/bloc/vechile/vechile_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreateVehicleScreen extends StatefulWidget {
  CreateVehicleScreen(
      {super.key,
      this.vehicle,
      this.vin = '',
      this.Editvechile,
      this.navigation});
  final String vin;
  final VinGlobalSearchResponseModel? vehicle;
  final Datum? Editvechile;
  String? navigation;

  @override
  State<CreateVehicleScreen> createState() => _CreateVehicleScreenState();
}

class _CreateVehicleScreenState extends State<CreateVehicleScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  VechileBloc? _bloc;

  final _debouncer = Debouncer();

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

  final ScrollController Listcontroller = ScrollController();

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

  @override
  void initState() {
    super.initState();
    vinController.text = widget.vin;
    if (widget.vehicle != null) {
      addDataToFields();
    }
    if (widget.Editvechile != null) {
      yearController.text = widget.Editvechile?.vehicleYear ?? "";
      yearController.text = widget.Editvechile?.vehicleMake ?? "";
      yearController.text = widget.Editvechile?.vehicleModel ?? "";
      // yearController.text = widget.Editvechile?.subModel ?? "";
      // yearController.text = widget.Editvechile?.engineSize ?? "";
      yearController.text = widget.Editvechile?.vehicleColor ?? "";
      // yearController.text = widget.Editvechile?.licencePlate ?? "";
      // yearController.text = widget.Editvechile?.vehicleType ?? "";
    }
    _bloc = BlocProvider.of<VechileBloc>(context);
    _bloc?.currentPage = 1;
    _bloc?.add(GetAllVechile());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.navigation != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => VehiclesScreen()));
          return false;
        } else {
          Navigator.pop(context);
          return false;
        }
      },
      child: Scaffold(
          body: SafeArea(
        child: BlocProvider(
          create: (ctx) => VechileBloc()..add(DropDownVechile()),
          child: BlocListener<VechileBloc, VechileState>(
            listener: (ctx, state) {
              if (state is AddVechileDetailsLoadingState) {
                CommonWidgets().showDialog(
                    context, 'Something went wrong please try again later');
                if (widget.navigation != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => VehiclesScreen()));
                } else {
                  Navigator.pop(context);
                }
                // vechileList.addAll(state.vechile.data.data ?? []);
              } else if (state is VechileDetailsErrorState) {
                CommonWidgets().showDialog(context, state.message);
              } else if (state is AddVechileDetailsPageNationLoading) {
                if (widget.navigation != null) {
                  log('here');
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => VehiclesScreen()));
                } else {
                  Navigator.pop(context, vinController.text);
                }
                // roles.clear();
                // roles.addAll(state.roles);
              } else if (state is DropdownVechileDetailsSuccessState) {
                dropdownData.addAll(state.dropdownData.data.data);
              } else if (state is AddVechileDetailsErrorState) {
                if (BlocProvider.of<VechileBloc>(context).errorRes.isNotEmpty) {
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vehicle_year")) {
                    print("vehicle_year");

                    yearErrorStaus = true;

                    print(yearErrorStaus);
                    yearErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vehicle_year'][0];
                    print(yearErrorMsg);
                    // }
                  } else {
                    yearErrorStaus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vehicle_model")) {
                    modelErrorStatus = true;
                    modelErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vehicle_model'][0];
                  } else {
                    modelErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vehicle_type")) {
                    print("vehicle_type");

                    typeErrorStatus = true;

                    print(typeErrorStatus);
                    typeErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vehicle_type'][0];
                    print(typeErrorMsg);
                    // }
                  } else {
                    typeErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vehicle_make")) {
                    print("vehicle_make");

                    makeErrorStatus = true;

                    print(makeErrorStatus);
                    makeErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vehicle_make'][0];
                    print(makeErrorMsg);
                    // }
                  } else {
                    makeErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vehicle_color")) {
                    print("vehicle_color");

                    colorErrorStatus = true;

                    print(colorErrorStatus);
                    colorErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vehicle_color'][0];
                    print(colorErrorMsg);
                    // }
                  } else {
                    colorErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vehicle_color")) {
                    print("vehicle_color");

                    colorErrorStatus = true;

                    print(colorErrorStatus);
                    colorErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vehicle_color'][0];
                    print(colorErrorMsg);
                    // }
                  } else {
                    colorErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vin")) {
                    print("vin");

                    vinErrorStatus = true;

                    print(vinErrorStatus);
                    vinErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vin'][0];
                    print(vinErrorMsg);
                    // }
                  } else {
                    vinErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("vin")) {
                    print("vin");

                    vinErrorStatus = true;

                    print(vinErrorStatus);
                    vinErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['vin'][0];
                    print(vinErrorMsg);
                    // }
                  } else {
                    vinErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("sub_model")) {
                    print("sub_model");

                    subModelErrorStatus = true;

                    print(subModelErrorStatus);
                    submodelErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['sub_model'][0];
                    print(submodelErrorMsg);
                    // }
                  } else {
                    subModelErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("licence_plate")) {
                    print("licence_plate");

                    licErrorStatus = true;

                    print(subModelErrorStatus);
                    licErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['licence_plate'][0];
                    print(licErrorMsg);
                    // }
                  } else {
                    licErrorStatus = false;
                  }
                  if (BlocProvider.of<VechileBloc>(context)
                      .errorRes
                      .containsKey("engine_size")) {
                    print("engine_size");

                    engineErrorStatus = true;

                    print(engineErrorStatus);
                    engineErrorMsg = BlocProvider.of<VechileBloc>(context)
                        .errorRes['engine_size'][0];
                    print(engineErrorMsg);
                    // }
                  } else {
                    engineErrorStatus = false;
                  }
                }
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
                          "New Vehicle",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryBlackColors,
                              fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          IconButton(
                              onPressed: () {
                                if (widget.navigation != null) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VehiclesScreen()));
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
                          padding: const EdgeInsets.only(left: 24.0, right: 24),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Basic Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryTitleColor),
                                ),
                                SizedBox(height: 16),
                                // textBox("Enter name...", nameController,
                                //     "Owner", nameErrorStatus),
                                textBox(
                                    "Enter Year",
                                    yearController,
                                    "Year",
                                    yearErrorStaus,
                                    widget.vehicle != null &&
                                        widget.vehicle!.modelYear!.isNotEmpty),
                                Visibility(
                                    visible: yearErrorStaus,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
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
                                      padding:
                                          const EdgeInsets.only(bottom: 6.0),
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
                                SizedBox(
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
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        modelErrorMsg,
                                        style: TextStyle(
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
                                    tilePadding: EdgeInsets.all(0),
                                    childrenPadding: EdgeInsets.all(0),
                                    title: const Text(
                                      'Additional Fields',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.primaryTitleColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    children: <Widget>[
                                      ListTile(
                                          contentPadding: EdgeInsets.all(0),
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
                                                  ? SizedBox()
                                                  : Text(
                                                      "Type",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                Center(
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
                                      Text(
                                        "Create new estimate using this vehicle",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: AppColors.primaryTitleColor),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      validateVechile(
                                        yearController.text,
                                        modelController.text,
                                        typeController.text,
                                        context,
                                        stateUpdate,
                                      );
                                      print("${yearController.text}");
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             VechileInformation()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors.primaryColors,
                                      shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child:
                                        state is AddVechileDetailsLoadingState
                                            ? const CupertinoActivityIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                'Confirm',
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
        ),
      )),
    );
  }

  validateVechile(
    String VechileYear,
    String VechileModel,
    String VechileType,
    BuildContext context,
    StateSetter stateUpdate,
  ) {
    if (VechileYear.isEmpty) {
      setState(() {
        yearErrorMsg = "Year can't be empty.";
        yearErrorStaus = true;
      });
    } else {
      if (VechileYear.length < 4) {
        setState(() {
          yearErrorMsg = "Please enter a valid year";
          yearErrorStaus = true;
        });
      } else {
        setState(() {
          yearErrorStaus = false;
        });
      }
    }
    if (VechileModel.isEmpty) {
      setState(() {
        modelErrorMsg = "Model can't be empty.";
        modelErrorStatus = true;
      });
    } else {
      if (VechileModel.length < 2) {
        setState(() {
          modelErrorMsg = "Please enter a valid model";
          modelErrorStatus = true;
        });
      } else {
        setState(() {
          modelErrorStatus = false;
        });
      }
    }
    if (VechileType.isEmpty) {
      stateUpdate(() {
        typeErrorMsg = "Type can't be empty.";
        typeErrorStatus = true;
      });
    } else {
      typeErrorStatus = false;
    }
    if (makeController.text.isEmpty) {
      setState(() {
        makeErrorStatus = true;
        makeErrorMsg = "Make can't be empty";
      });
    } else {
      if (makeController.text.length < 2) {
        setState(() {
          makeErrorStatus = true;
          makeErrorMsg = "Please enter a valid make";
        });
      } else {
        setState(() {
          makeErrorStatus = false;
        });
      }
    }
    if (!yearErrorStaus && !modelErrorStatus && !makeErrorStatus) {
      context.read<VechileBloc>().add(AddVechile(
            context: context,
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
            navigation: widget.navigation,
          ));
    }
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
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: errorStatus == true
                              ? Color(0xffD80027)
                              : Color(0xffC1C4CD)))),
            ),
          ),
        ),
      ],
    );
  }

  Widget vechiledropDown() {
    return typeController.text.isNotEmpty
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
                          hint: const Text(
                            "Select Type",
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
