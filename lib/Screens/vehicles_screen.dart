import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/vechile_dropdown_model.dart';
import '../Models/vechile_model.dart';
import '../bloc/vechile/vechile_bloc.dart';
import '../bloc/vechile/vechile_event.dart';
import '../bloc/vechile/vechile_state.dart';
import '../utils/app_utils.dart';
import 'app_drawer.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({Key? key}) : super(key: key);

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  VechileBloc? _bloc;

  final _debouncer = Debouncer();

  int selectedIndex = 0;

  final ScrollController Listcontroller = ScrollController();

  final List<Datum> vechile = [];

  List<String> states = [];
  List<DropdownDatum> dropdownData = [];
  dynamic _currentSelectedTypeValue;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<VechileBloc>(context);
    _bloc?.currentPage = 1;
    _bloc?.add(GetAllVechile());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomBarScreen()),
            (route) => false);
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          drawer: showDrawer(context),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            // automaticallyImplyLeading: false,
            foregroundColor: AppColors.primaryColors,
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CreateVehicleScreen(
                        navigation: 'vehicle_list',
                      ),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add),
              ),
              const SizedBox(width: 10),
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
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicles',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryBlackColors),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 7), // changes position of shadow
                          ),
                        ],
                      ),
                      height: 50,
                      child: CupertinoSearchTextField(
                        onChanged: (value) {
                          _debouncer.run(() {
                            vechile.clear();
                            _bloc?.currentPage = 1;
                            _bloc?.add(GetAllVechile(query: value));
                          });
                        },
                        backgroundColor: Colors.white,
                        placeholder: 'Search Vehicles',
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
                const SizedBox(height: 16),
                BlocListener<VechileBloc, VechileState>(
                  listener: (context, state) {
                    if (state is VechileDetailsSuccessStates) {
                      print(
                          "-----------=============111111111111111111111111111=================");
                      vechile.addAll(state.vechile.data.data);
                    }
                  },
                  child: BlocBuilder<VechileBloc, VechileState>(
                    builder: (context, state) {
                      if (state is VechileDetailsLoadingState &&
                          !_bloc!.isPagenationLoading) {
                        print("-----------==============================");
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else {
                        return vechile.isEmpty
                            ? SingleChildScrollView(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 280,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'No Vehicle Found',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryTextColors),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ScrollConfiguration(
                                  behavior: const ScrollBehavior(),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      controller: Listcontroller
                                        ..addListener(() {
                                          print('object');
                                          if (Listcontroller.offset ==
                                                  Listcontroller.position
                                                      .maxScrollExtent &&
                                              !_bloc!.isPagenationLoading &&
                                              _bloc!.currentPage <=
                                                  _bloc!.totalPages) {
                                            _debouncer.run(() {
                                              _bloc?.isPagenationLoading = true;
                                              _bloc?.add(GetAllVechile());
                                            });
                                          }
                                        }),
                                      itemBuilder: (context, index) {
                                        final item = vechile[index];
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VechileInformation(
                                                      vechile: item,
                                                    ),
                                                  ),
                                                );
                                              },
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
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${item.vehicleYear} ${item.vehicleModel}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .primaryTitleColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          (item.firstName ??
                                                                  "") +
                                                              (item.lastName ??
                                                                  ''),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            color: AppColors
                                                                .greyText,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            _bloc!.currentPage <=
                                                        _bloc!.totalPages &&
                                                    index == vechile.length - 1
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
                                            index == vechile.length - 1
                                                ? const SizedBox(height: 24)
                                                : const SizedBox(),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 16),
                                      itemCount: vechile.length),
                                ),
                              );
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
