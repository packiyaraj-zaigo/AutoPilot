import 'dart:async';
import 'dart:developer';

import 'package:auto_pilot/Models/vechile_model.dart';
import 'package:auto_pilot/Models/vehicle_estimate_reponse.dart';
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/bloc/scanner/scanner_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late final controller = TabController(length: 3, vsync: this);
  final TextEditingController searchController = TextEditingController();
  String vinNumber = '';
  final _debouncer = Debouncer();
  late ScannerBloc bloc;
  final List<VehicleEstimateResponseModel> estimates = [];
  final scrollController = ScrollController();
  Datum? vehicle;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<ScannerBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'Scanner',
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
              color: Colors.black87,
              // size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 60),
          child: TabBar(
            controller: controller,
            enableFeedback: false,
            indicatorColor: AppColors.primaryColors,
            unselectedLabelColor: const Color(0xFF9A9A9A),
            labelColor: AppColors.primaryColors,
            tabs: const [
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'VIN Code',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'VIN Scan',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'LIC Plate',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width - 120,
                width: MediaQuery.of(context).size.width - 120,
                child: Stack(
                  children: [
                    kDebugMode
                        ? const SizedBox()
                        : Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width - 150,
                              width: MediaQuery.of(context).size.width - 150,
                              child: MobileScanner(
                                onDetect: (value) {
                                  vinNumber =
                                      value.barcodes.last.rawValue.toString();

                                  searchController.text = vinNumber;
                                  bloc.add(GetVehiclesFromVin(vin: vinNumber));
                                  controller.animateTo(1);

                                  log(value.barcodes[0].rawValue.toString());
                                },
                              ),
                            ),
                          ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                color: AppColors.primaryColors, width: 5),
                            top: BorderSide(
                              color: AppColors.primaryColors,
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: AppColors.primaryColors, width: 5),
                            top: BorderSide(
                              color: AppColors.primaryColors,
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                color: AppColors.primaryColors, width: 5),
                            bottom: BorderSide(
                              color: AppColors.primaryColors,
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: AppColors.primaryColors, width: 5),
                            bottom: BorderSide(
                              color: AppColors.primaryColors,
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('$vinNumber'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: CupertinoTextField(
                    controller: searchController,
                    onChanged: (value) {
                      _debouncer.run(() {
                        if (value.isNotEmpty) {
                          estimates.clear();
                          bloc.currentEstimatePage = 1;
                          bloc.add(GetVehiclesFromVin(vin: value));
                        }
                      });
                    },
                    padding: const EdgeInsets.only(top: 14, left: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                BlocListener<ScannerBloc, ScannerState>(
                  listener: (context, state) {
                    if (state is VinCodeInShopState) {
                      estimates.addAll(state.estimates);
                      vehicle = state.vehicle;
                    }
                    if (state is PageNationSucessState) {
                      estimates.addAll(state.estimates);
                    }
                  },
                  child: BlocBuilder<ScannerBloc, ScannerState>(
                      builder: (context, state) {
                    String vehicleStatus = '';
                    Color color = Colors.red;
                    Icon icon = const Icon(Icons.check);
                    if (state is VinCodeNotInShopState) {
                      vehicleStatus = "Vehicle found but not in shop history";
                      color = Colors.red;
                      icon = Icon(Icons.info, size: 20, color: color);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              color == Colors.red
                                  ? Transform.flip(flipY: true, child: icon)
                                  : icon,
                              const SizedBox(width: 5),
                              Text(
                                vehicleStatus,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, color: color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Vehicle',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF061237),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '${state.vehicle.modelYear ?? ''} ${state.vehicle.model}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    '${state.vehicle.driveType}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    searchController.text,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateVehicleScreen(
                                    vehicle: state.vehicle,
                                    vin: searchController.text,
                                  ),
                                ),
                              );
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
                                "Add Vehicle & Create Estimate",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is VehicleNotFoundState) {
                      vehicleStatus = "No vehicle found";
                      color = Colors.red;
                      icon = Icon(Icons.info, size: 20, color: color);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              color == Colors.red
                                  ? Transform.flip(flipY: true, child: icon)
                                  : icon,
                              const SizedBox(width: 5),
                              Text(
                                vehicleStatus,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, color: color),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateVehicleScreen(),
                              ));
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
                                "Add new vehicle",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is VinSearchErrorState) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is VinSearchLoadingState &&
                        !bloc.isEstimatePagenationLoading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (searchController.text.isEmpty) {
                      return const Center(
                          child: Text('Please enter a VIN number to check'));
                    } else {
                      vehicleStatus = "Vehicle found in shop history";

                      color = Colors.green;
                      icon = Icon(Icons.check, size: 20, color: color);
                      return vehicleInShopWidget(color, icon, vehicleStatus);
                    }
                  }),
                ),
              ],
            ),
          ),
          const Column(
            children: [Text('Vehicle found but not in shop')],
          ),
        ],
      ),
    );
  }

  Widget vehicleInShopWidget(Color color, Icon icon, String vehicleStatus) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: SingleChildScrollView(
          controller: scrollController
            ..addListener(() {
              if (scrollController.offset ==
                      scrollController.position.maxScrollExtent &&
                  !bloc.isEstimatePagenationLoading &&
                  bloc.currentEstimatePage < bloc.totalEstimatePages) {
                _debouncer.run(() {
                  log('here');
                  bloc.isEstimatePagenationLoading = true;
                  bloc.add(EstimatePageNation());
                });
              }
            }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  color == Colors.red
                      ? Transform.flip(flipY: true, child: icon)
                      : icon,
                  const SizedBox(width: 5),
                  Text(
                    vehicleStatus,
                    style: TextStyle(fontWeight: FontWeight.w400, color: color),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Vehicle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF061237),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          VechileInformation(vechile: vehicle!)));
                },
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${vehicle?.vehicleYear ?? ''}  ${vehicle?.vehicleModel ?? ''}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${vehicle?.vehicleColor == null ? '' : '${vehicle?.vehicleColor!},'} ${vehicle?.vehicleType}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          '${vehicle?.vin}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Estimates',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF061237),
                ),
              ),
              const SizedBox(height: 24),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final VehicleEstimateResponseModel estimate =
                        estimates[index];
                    return Container(
                      width: double.infinity,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            offset: const Offset(0, 4),
                            blurRadius: 10,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(children: [
                              Icon(
                                CupertinoIcons.calendar,
                                size: 18,
                                color: Color(0xFF9A9A9A),
                              ),
                              SizedBox(width: 3),
                              Text(
                                estimate.createdAt == null
                                    ? ''
                                    : AppUtils.getFormatted(
                                        estimate.createdAt.toString(),
                                      ),
                                style: TextStyle(
                                  color: Color(0xFF9A9A9A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                CupertinoIcons.minus,
                                size: 18,
                                color: Color(0xFF9A9A9A),
                              ),
                              Icon(
                                CupertinoIcons.calendar,
                                size: 18,
                                color: Color(0xFF9A9A9A),
                              ),
                              SizedBox(width: 3),
                              Text(
                                estimate.completionDate == null
                                    ? ''
                                    : AppUtils.getFormatted(
                                        estimate.createdAt.toString(),
                                      ),
                                style: TextStyle(
                                  color: Color(0xFF9A9A9A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                            Text(
                              'Estimate #${estimate.id ?? ''} - ${estimate.estimationName}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              '${estimate.customer?.firstName ?? ""} ${estimate.customer?.lastName ?? ""}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              '${estimate.vehicle?.vehicleYear ?? ''} ${estimate.vehicle?.vehicleModel ?? ''}',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: estimates.length),
              SizedBox(height: 16),
              bloc.currentEstimatePage < bloc.totalEstimatePages
                  ? const Center(child: CupertinoActivityIndicator())
                  : const SizedBox(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
