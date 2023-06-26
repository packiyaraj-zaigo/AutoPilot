import 'dart:developer';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/Screens/parts_information_screen.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/bloc/parts_model/parts_bloc.dart';
import 'package:auto_pilot/bloc/parts_model/parts_event.dart';
import 'package:auto_pilot/bloc/parts_model/parts_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/parts_model.dart';
import '../Models/vechile_dropdown_model.dart';
import '../bloc/vechile/vechile_bloc.dart';
import '../bloc/vechile/vechile_event.dart';
import '../utils/app_utils.dart';
import '../utils/common_widgets.dart';
import 'app_drawer.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({Key? key}) : super(key: key);

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PartsBloc? _bloc;

  final _debouncer = Debouncer();

  int selectedIndex = 0;

  final ScrollController Listcontroller = ScrollController();

  final TextEditingController itemnameController = TextEditingController();
  final TextEditingController serialnumberController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController suppliesController = TextEditingController();
  final TextEditingController epaController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  bool itemnameErrorStaus = false;
  bool serialnumberErrorStatus = false;
  bool quantityErrorStatus = false;
  bool feeErrorStatus = false;
  bool suppliesErrorStatus = false;
  bool epaErrorStatus = false;
  bool costErrorStatus = false;
  bool typeErrorStatus = false;

  String itemnameErrorMsg = '';
  String serialnumberErrorMsg = '';
  String quantityErrorMsg = '';
  String feeErrorMsg = '';
  String suppliesErrorMsg = '';
  String epaErrorMsg = '';
  String costErrorMsg = '';
  String typeErrorMsg = '';

  final List<PartsDatum> parts = [];

  List<String> states = [];
  List<DropdownDatum> dropdownData = [];
  dynamic _currentSelectedTypeValue;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PartsBloc>(context);
    _bloc?.currentPage = 1;
    _bloc?.add(GetAllParts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        drawer: showDrawer(context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 34, top: 24, bottom: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parts',
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
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 50,
                    child: CupertinoSearchTextField(
                      onChanged: (value) {
                        _debouncer.run(() {
                          parts.clear();
                          _bloc?.currentPage = 1;
                          _bloc?.add(GetAllParts(query: value));
                        });
                      },
                      backgroundColor: Colors.white,
                      placeholder: 'Search Inventory...',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 16),
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
            BlocListener<PartsBloc, PartsState>(
              listener: (context, state) {
                if (state is PartsDetailsSuccessStates) {
                  print(
                      "-----------=============111111111111111111111111111=================");
                  parts.addAll(state.part.data.data);
                }
              },
              child: BlocBuilder<PartsBloc, PartsState>(
                builder: (context, state) {
                  if (state is PartsDetailsLoadingState &&
                      !_bloc!.isPagenationLoading) {
                    print("-----------==============================");
                    return const Center(child: CupertinoActivityIndicator());
                  } else {
                    return parts.isEmpty
                        ? const Center(
                            child: Text(
                            'No Parts found',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryTextColors),
                          ))
                        : Expanded(
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior(),
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  controller: Listcontroller
                                    ..addListener(() {
                                      print('object');
                                      if (Listcontroller.offset ==
                                              Listcontroller
                                                  .position.maxScrollExtent &&
                                          !_bloc!.isPagenationLoading &&
                                          _bloc!.currentPage <=
                                              _bloc!.totalPages) {
                                        _debouncer.run(() {
                                          _bloc?.isPagenationLoading = true;
                                          _bloc?.add(GetAllParts());
                                        });
                                      }
                                    }),
                                  itemBuilder: (context, index) {
                                    final item = parts[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PartsInformation(
                                                  parts: item,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Container(
                                              height: 77,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.07),
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          item.itemName ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF061237),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          item.itemName ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF061237),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          item.isDisplayPartNumber ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF061237),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          item.itemServiceNote ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF061237),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          item.subTotal ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xFF061237),
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        _bloc!.currentPage <=
                                                    _bloc!.totalPages &&
                                                index == parts.length - 1
                                            ? const Column(
                                                children: [
                                                  SizedBox(height: 24),
                                                  Center(
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  ),
                                                  SizedBox(height: 24),
                                                ],
                                              )
                                            : const SizedBox(),
                                        index == parts.length - 1
                                            ? const SizedBox(height: 24)
                                            : const SizedBox(),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 24),
                                  itemCount: parts.length),
                            ),
                          );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ));
  }

  _show(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 10,
        context: ctx,
        builder: (ctx) => BlocProvider(
              create: (context) => PartsBloc(),
              child: BlocListener<PartsBloc, PartsState>(
                listener: (context, state) {
                  if (state is PartsDetailsLoadingState) {
                    CommonWidgets().showDialog(
                        context, 'Something went wrong please try again later');
                    Navigator.pop(context);
                    // vechileList.addAll(state.vechile.data.data ?? []);
                  } else if (state is PartsDetailsErrorState) {
                    CommonWidgets().showDialog(context, state.message);
                  } else if (state is PartsDetailsSuccessStates) {
                    // roles.clear();
                    // roles.addAll(state.roles);
                  }
                },
                child: BlocBuilder<PartsBloc, PartsState>(
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
                                    "New Item",
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
                                        // textBox("Enter name...", nameController,
                                        //     "Owner", nameErrorStatus),
                                        textBox(
                                            "Enter ItemName...",
                                            itemnameController,
                                            "Item Name",
                                            itemnameErrorStaus),

                                        // Visibility(
                                        //     visible: yearErrorStaus,
                                        //     child: Text(
                                        //       yearErrorMsg,
                                        //       style: const TextStyle(
                                        //         fontSize: 14,
                                        //         fontWeight: FontWeight.w500,
                                        //         color: Color(
                                        //           0xffD80027,
                                        //         ),
                                        //       ),
                                        //     )),

                                        textBox(
                                            "Enter number...",
                                            serialnumberController,
                                            "Serial Number",
                                            serialnumberErrorStatus),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        textBox(
                                            "Enter quanitynumber...",
                                            quantityController,
                                            "Quantity",
                                            quantityErrorStatus),
                                        textBox("Enter fee...", feeController,
                                            "Fee", feeErrorStatus),
                                        textBox(
                                            "Enter supplies...",
                                            suppliesController,
                                            "Supplies",
                                            suppliesErrorStatus),
                                        textBox(
                                            "Enter epanumber...",
                                            epaController,
                                            "Supplies",
                                            epaErrorStatus),
                                        textBox("Enter cost...", costController,
                                            "Supplies", costErrorStatus),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print("ApiCall");
                                              validateParts(
                                                context,
                                                itemnameController.text,
                                                serialnumberController.text,
                                                stateUpdate,
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
                                            child: state
                                                    is PartsDetailsSuccessStates
                                                ? const CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    'Confirm',
                                                    style:
                                                        TextStyle(fontSize: 15),
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

  validateParts(
    BuildContext context,
    String PartsItemname,
    String serialnumber,
    StateSetter stateUpdate,
  ) {
    if (PartsItemname.isEmpty) {
      stateUpdate(() {
        itemnameErrorMsg = 'Itemname cant be empty.';
        itemnameErrorStaus = true;
      });
    } else {
      itemnameErrorStaus = false;
    }
    if (serialnumber.isEmpty) {
      stateUpdate(() {
        serialnumberErrorMsg = 'Itemname cant be empty.';
        serialnumberErrorStatus = true;
      });
    } else {
      serialnumberErrorStatus = false;
    }

    if (!itemnameErrorStaus && !serialnumberErrorStatus) {
      context.read<PartsBloc>().add(AddParts(
            context: context,
            itemname: itemnameController.text,
            quantity: quantityController.text,
            serialnumber: serialnumberController.text,
            fee: feeController.text,
            supplies: suppliesController.text,
            epa: epaController.text,
            cost: costController.text,
            type: _currentSelectedTypeValue.toString(),
          ));
    }
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
