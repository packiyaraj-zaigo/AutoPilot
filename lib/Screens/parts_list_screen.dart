import 'dart:developer';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/Screens/create_parts.dart';
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
          title: const Text(
            'Autopilot',
            style: TextStyle(
                color: AppColors.primaryBlackColors,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => const CreatePartsScreen(),
                ))
                    .then((value) {
                  if (value == true) {
                    BlocProvider.of<PartsBloc>(context).add(GetAllParts());
                  }
                });
              },
              icon: const Icon(
                CupertinoIcons.add,
                color: AppColors.primaryColors,
              ),
            )
          ],
          leading: IconButton(
            icon: const Icon(
              Icons.menu,
              color: AppColors.primaryColors,
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Parts',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlackColors),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        )
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
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 24, right: 16),
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
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24),
                                              child: Container(
                                                height: 77,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.07),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 10,
                                                    )
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 15),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.itemName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF061237),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'ID: ${item.id.toString().padLeft(3, '0')}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .greyText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'QTY: ${item.quantityInHand.toString().padLeft(3, '0')}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .greyText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            'MSRP: \$${item.subTotal}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: AppColors
                                                                  .greyText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
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
                            ),
                          );
                  }
                },
              ),
            ),
          ],
        ));
  }

  _show() async {
    await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CreatePartsScreen()));
  }
}
