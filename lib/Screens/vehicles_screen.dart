import 'dart:developer';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/vechile_dropdown_model.dart';
import '../Models/vechile_model.dart';
import '../api_provider/api_repository.dart';
import '../bloc/vechile/vechile_bloc.dart';
import '../bloc/vechile/vechile_event.dart';
import '../bloc/vechile/vechile_state.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({Key? key}) : super(key: key);

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
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

  String yearErrorMsg = '';
  String modelErrorMsg = '';
  String makeErrorMsg = '';
  String typeErrorMsg = '';

  final List<Datum> vechile = [];

  List<String> states = [];
  List<DropdownDatum> dropdownData = [];
  dynamic _currentSelectedTypeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Autopilot',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              _show(context);
            },
            child: SvgPicture.asset(
              "assets/images/add_icon.svg",
              color: AppColors.primaryBlackColors,
              height: 20,
              width: 20,
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {},
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            VechileBloc(apiRepository: ApiRepository())..add(GetAllVechile()),
        child: BlocListener<VechileBloc, VechileState>(
          listener: (context, state) {
            if (state is VechileDetailsSuccessState) {
              // vechileList.addAll(state.vechile.data.data ?? []);
            }
          },
          child:
              BlocBuilder<VechileBloc, VechileState>(builder: (context, state) {
            if (state is VechileDetailsLoadingState) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state is VechileDetailsSuccessState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 34, top: 24, bottom: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicles',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlackColors),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          height: 50,
                          child: CupertinoSearchTextField(
                            backgroundColor: Colors.white,
                            placeholder: 'Search Vehicles...',
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 24, right: 16),
                              child: Icon(
                                CupertinoIcons.search,
                                color: AppColors.primaryTextColors,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: AlphabetScrollView(
                      list: state.vechile.data.data
                          .map((e) => AlphaModel(e.vehicleMake))
                          .toList(),
                      isAlphabetsFiltered: false,
                      alignment: LetterAlignment.right,
                      itemExtent: 200,
                      unselectedTextStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                      selectedTextStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      itemBuilder: (_, k, id) {
                        // final item = vechile[k];
                        return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 34, left: 24),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VechileInformation(
                                                vechile: state
                                                    .vechile.data.data[k])));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        '${state.vechile.data.data[k].vehicleYear}',
                                        style: TextStyle(
                                            color: AppColors.primaryTitleColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '$id',
                                        style: TextStyle(
                                            color: AppColors.primaryTitleColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${state.vechile.data.data[k].vehicleModel}',
                                        style: TextStyle(
                                            color: AppColors.primaryTitleColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    '${state.vechile.data.data[0].firstName ?? ""}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: AppColors.greyText),
                                  ),
                                  // trailing: Icon(Icons.add),),
                                ),
                              ),
                            ));
                      },
                    ),
                    // Text("${state.vechile.data.data[0].vehicleModel}")
                  )
                ],
              );
            } else {
              return const Text("data");
            }
          }),
        ),
      ),
    );
  }

  _show(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 10,
        context: ctx,
        builder: (ctx) => BlocProvider(
              create: (context) => VechileBloc(apiRepository: ApiRepository())
                ..add(DropDownVechile()),
              child: BlocListener<VechileBloc, VechileState>(
                listener: (context, state) {
                  if (state is AddVechileDetailsLoadingState) {
                    // vechileList.addAll(state.vechile.data.data ?? []);
                  } else if (state is DropdownVechileDetailsSuccessState) {
                    dropdownData.addAll(state.dropdownData.data.data);
                  }
                },
                child: BlocBuilder<VechileBloc, VechileState>(
                    builder: (context, state) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateUpdate) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.95,
                        color: Colors.white54,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(),
                                  Text(
                                    "New Vehicle",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primaryBlackColors,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/close.svg",
                                      color: AppColors.primaryColors,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Basic Details",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppColors.primaryTitleColor),
                                        ),
                                        textBox(
                                            "Enter email...",
                                            nameController,
                                            "Owner",
                                            nameErrorStatus),
                                        textBox("Enter year...", yearController,
                                            "Year", yearErrorStaus),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                  visible: yearErrorStaus,
                                                  child: Text(
                                                    yearErrorMsg,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(
                                                        0xffD80027,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        textBox("Enter make...", makeController,
                                            "Make", makeErrorStatus),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        textBox(
                                            "Enter model...",
                                            modelController,
                                            "Model",
                                            modelErrorStatus),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Visibility(
                                                  visible: modelErrorStatus,
                                                  child: Text(
                                                    modelErrorMsg,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(
                                                        0xffD80027,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                        textBox(
                                            "Enter number...",
                                            vinController,
                                            "VIN",
                                            vinErrorStatus),
                                        ExpansionTile(
                                          title: Text(
                                            'Additional fields',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                                title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                textBox(
                                                    "Enter Sub-model...",
                                                    subModelController,
                                                    "Sub-Model",
                                                    subModelErrorStatus),
                                                textBox(
                                                    "Enter engin...",
                                                    engineController,
                                                    "Engine",
                                                    engineErrorStatus),
                                                textBox(
                                                    "Enter make...",
                                                    makeController,
                                                    "Make",
                                                    makeErrorStatus),
                                                textBox(
                                                    "Enter color...",
                                                    colorController,
                                                    "Color",
                                                    colorErrorStatus),
                                                textBox(
                                                    "Enter number...",
                                                    licController,
                                                    "LIC",
                                                    licErrorStatus),
                                                Text(
                                                  "Type",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.greyText),
                                                ),
                                                vechiledropDown()
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
                                              validateVechile(
                                                context,
                                                yearController.text,
                                                modelController.text,
                                              );
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
                                                    new BorderRadius.circular(
                                                        10.0),
                                              ),
                                            ),
                                            child: const Text(
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
                        ));
                  });
                }),
              ),
            ));
  }

  validateVechile(
      BuildContext context, String VechileYear, String VechileModel) {
    if (VechileYear.isEmpty) {
      print("djjjjjjjjjjjjjjjjjhgwjjjjjjjjjjjjjjjjjjjjjjj");
      setState(() {
        yearErrorMsg = 'Year cant be empty.';
        yearErrorStaus = true;
      });
    } else {
      print("dkllllllllaaaaaaaaaaaaaaaaaaaaaa");
      if (VechileYear.length < 4) {
        setState(() {
          yearErrorStaus = true;
          yearErrorMsg = 'Please enter a valid phone number';
        });
      } else {
        setState(() {
          yearErrorStaus = false;
        });
      }
    }

    // if (VechileType.isEmpty) {
    //   setState(() {
    //     typeErrorMsg = 'Type cant be empty.';
    //     typeErrorStatus = true;
    //   });
    // } else {
    //   if (VechileYear.length < 4) {
    //     setState(() {
    //       typeErrorStatus = true;
    //       typeErrorMsg = 'Please enter a valid phone number';
    //     });
    //   } else {
    //     setState(() {
    //       typeErrorStatus = false;
    //     });
    //   }
    // }
    //
    // if (VechileMake.isEmpty) {
    //   setState(() {
    //     makeErrorMsg = 'Type cant be empty.';
    //     makeErrorStatus = true;
    //   });
    // } else {
    //   if (VechileYear.length < 4) {
    //     setState(() {
    //       makeErrorStatus = true;
    //       makeErrorMsg = 'Please enter a valid phone number';
    //     });
    //   } else {
    //     setState(() {
    //       makeErrorStatus = false;
    //     });
    //   }
    // }

    if (VechileModel.isEmpty) {
      setState(() {
        modelErrorMsg = 'Type cant be empty.';
        modelErrorStatus = true;
      });
    } else {
      if (VechileYear.length < 4) {
        setState(() {
          modelErrorStatus = true;
          modelErrorMsg = 'Please enter a valid phone number';
        });
      } else {
        setState(() {
          modelErrorStatus = false;
        });
      }
    }
    if (!yearErrorStaus && !modelErrorStatus) {
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
            type: _currentSelectedTypeValue,
          ));
    }
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff6A7187)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, bottom: 15),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
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
    return Padding(
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
                    items: dropdownData.map<DropdownMenuItem<DropdownDatum>>(
                        (DropdownDatum value) {
                      return DropdownMenuItem<DropdownDatum>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value.vehicleTypeName),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (DropdownDatum? value) {
                      setState(() {
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
