import 'package:auto_pilot/Models/single_vehicle_info_model.dart';
import 'package:auto_pilot/Screens/dummy_vehcile_screen.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/Screens/vehicles_screen.dart';
import 'package:auto_pilot/bloc/vechile/vechile_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:auto_pilot/Models/vehicle_notes_model.dart' as vn;
import 'package:intl/intl.dart';

import '../Models/vechile_model.dart';
import '../utils/app_utils.dart';
import 'create_vehicle_screen.dart';

import 'package:auto_pilot/Models/estimate_model.dart' as em;

class VechileInformation extends StatefulWidget {
  VechileInformation(
      {Key? key,
      // required this.vechile,
      required this.vehicleId})
      : super(key: key);
  // final Datum vechile;
  final String vehicleId;
  @override
  State<VechileInformation> createState() => _VechileInformationState();
}

class _VechileInformationState extends State<VechileInformation> {
  final List _segmentTitles = [
    SvgPicture.asset(
      "assets/images/info.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/note.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/dollar.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;
  final addNoteController = TextEditingController();
  final scrollController = ScrollController();
  List<em.Datum> estimateData = [];
  Vehicle? vechile;

  String addNoteErrorMessage = "";

  List<vn.Datum> noteList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VechileBloc()..add(GetVehicleInfoEvent(vehicleId: widget.vehicleId)),
      child: BlocListener<VechileBloc, VechileState>(
        listener: (context, state) {
          if (state is DeleteVechileDetailsSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const VehiclesScreen(),
                ),
                (route) => false);
            CommonWidgets()
                .showSuccessDialog(context, "Vehicle Deleted Successfully");
          } else if (state is DeleteVechileDetailsErrorState) {
            Navigator.pop(context);
            CommonWidgets().showDialog(context, state.message);
          } else if (state is DeleteVechileDetailsLoadingState) {
            showCupertinoModalPopup(
                context: context,
                builder: (context) =>
                    Center(child: CupertinoActivityIndicator()));
          } else if (state is GetVehicleNoteState) {
            noteList.clear();
            noteList.addAll(state.vehicleModel.data);
          } else if (state is AddVehicleNoteState) {
            print("listner worked");
            context
                .read<VechileBloc>()
                .add(GetVehicleNoteEvent(vehicleId: widget.vehicleId));

            Navigator.pop(context);
          } else if (state is GetEstimateFromVehicleState) {
            estimateData.addAll(state.estimateData.data.data);
          } else if (state is GetEstimateFromVehicleLoadingState) {
            estimateData.clear();
          } else if (state is GetSingleEstimateFromVehicleState) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return EstimatePartialScreen(
                  estimateDetails: state.createEstimateModel,
                  navigation: "vehicle_info",
                );
              },
            )).then((value) {
              estimateData.clear();
              context.read<VechileBloc>().add(
                  GetEstimateFromVehicleEvent(vehicleId: widget.vehicleId));
            });
          } else if (state is GetVehicleInfoState) {
            vechile = state.vehicleInfo.vehicle;
          }
          // TODO: implement listener
        },
        child: BlocBuilder<VechileBloc, VechileState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: AppColors.primaryColors,
                  icon: Icon(Icons.arrow_back),
                ),
                title: const Text(
                  "Vehicle's Information",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlackColors),
                ),
                centerTitle: true,
                actions: vechile?.vehicleYear == ''
                    ? null
                    : [
                        IconButton(
                          onPressed: () {
                            showBottomSheet(scaffoldKey.currentContext!);
                          },
                          icon: Icon(Icons.more_horiz),
                          color: AppColors.primaryColors,
                        ),
                      ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${vechile?.vehicleYear ?? ""} ${vechile?.vehicleMake ?? ""} ${vechile?.vehicleModel ?? ""}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: AppColors.primaryTitleColor),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoSlidingSegmentedControl(
                        onValueChanged: (value) {
                          setState(() {
                            selectedIndex = value ?? 0;
                          });

                          if (value == 1) {
                            context.read<VechileBloc>().add(GetVehicleNoteEvent(
                                vehicleId: widget.vehicleId));
                          } else if (value == 2) {
                            estimateData.clear();
                            context.read<VechileBloc>().add(
                                GetEstimateFromVehicleEvent(
                                    vehicleId: widget.vehicleId));
                          } else if (value == 0) {
                            context.read<VechileBloc>().add(GetVehicleInfoEvent(
                                vehicleId: widget.vehicleId));
                          }
                        },
                        groupValue: selectedIndex,
                        backgroundColor: AppColors.primarySegmentColors,
                        children: {
                          for (int i = 0; i < _segmentTitles.length; i++)
                            i: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 42),
                              child: _segmentTitles[i],
                            )
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: selectedIndex == 2
                          ? state is GetEstimateFromVehicleLoadingState
                              ? const Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : estimateData.isNotEmpty
                                  ? ListView.builder(
                                      itemBuilder: (context, index) {
                                        if (index == estimateData.length) {
                                          return BlocProvider.of<VechileBloc>(
                                                              context)
                                                          .estimateCurrentPage <=
                                                      BlocProvider.of<
                                                                  VechileBloc>(
                                                              context)
                                                          .estimateTotalPage &&
                                                  BlocProvider.of<VechileBloc>(
                                                              context)
                                                          .estimateCurrentPage !=
                                                      0
                                              ? const SizedBox(
                                                  height: 40,
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    color:
                                                        AppColors.primaryColors,
                                                  ))
                                              : Container();
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            context.read<VechileBloc>().add(
                                                GetSingleEstimateFromVehicleEvent(
                                                    orderId: estimateData[index]
                                                        .id
                                                        .toString()));
                                          },
                                          child: estimateTileWidget(
                                              estimateData[index].orderStatus,
                                              estimateData[index].orderNumber,
                                              estimateData[index]
                                                      .customer
                                                      ?.firstName ??
                                                  "",
                                              "${estimateData[index].vehicle?.vehicleYear ?? ""} ${estimateData[index].vehicle?.vehicleModel ?? ""}",
                                              "",
                                              estimateData[index]
                                                      .dropSchedule ??
                                                  ""),
                                        );
                                      },
                                      itemCount: estimateData.length + 1,
                                      shrinkWrap: true,
                                      controller: scrollController
                                        ..addListener(() {
                                          if ((BlocProvider.of<VechileBloc>(
                                                          context)
                                                      .estimateCurrentPage <=
                                                  BlocProvider.of<VechileBloc>(
                                                          context)
                                                      .estimateTotalPage) &&
                                              scrollController.offset ==
                                                  scrollController.position
                                                      .maxScrollExtent &&
                                              BlocProvider.of<VechileBloc>(
                                                          context)
                                                      .estimateCurrentPage !=
                                                  0 &&
                                              !BlocProvider.of<VechileBloc>(
                                                      context)
                                                  .isEstimateFetching) {
                                            context.read<VechileBloc>()
                                              ..isEstimateFetching = true
                                              ..add(GetEstimateFromVehicleEvent(
                                                  vehicleId: widget.vehicleId));
                                          }
                                        }),
                                    )
                                  : const Center(
                                      child: Text("No Estimate Found"))
                          : selectedIndex == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 24),
                                  child: Container(
                                      color: CupertinoColors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                addNotePopup(context);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                primary: AppColors.buttonColors,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                              ),
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add_circle_outline,
                                                    color:
                                                        AppColors.primaryColors,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 12.0),
                                                    child: Text(
                                                      'Add New Note',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .primaryColors,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 32),
                                                child: state
                                                        is GetVehicleNoteLoadingState
                                                    ? const Center(
                                                        child:
                                                            CupertinoActivityIndicator())
                                                    : noteList.isEmpty
                                                        ? const Center(
                                                            child: Text(
                                                                "No Notes Found"),
                                                          )
                                                        : ListView.builder(
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return noteTileWidget(
                                                                  noteList[
                                                                          index]
                                                                      .notes,
                                                                  noteList[
                                                                          index]
                                                                      .createdAt,
                                                                  noteList[
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                            },
                                                            itemCount:
                                                                noteList.length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const ClampingScrollPhysics(),
                                                          )),
                                          )
                                        ],
                                      )),
                                )
                              : selectedIndex == 0
                                  ? state is GetVehicleInfoLoadingState
                                      ? const Center(
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          // color: const Color(0xffF9F9F9),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Owner",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.customer?.firstName ?? '-'}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text(
                                                "Sub-Model",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.subModel ?? ""}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                              const SizedBox(
                                                height: 14,
                                              ),
                                              const Text(
                                                "Engine",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.engineSize ?? ""}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                "Color",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.vehicleColor ?? ""}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                "VIN",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.vin?.toUpperCase() ?? ""}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                "LIC",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.licencePlate ?? ""}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                              SizedBox(
                                                height: 14,
                                              ),
                                              Text(
                                                "Type",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              Text(
                                                "${vechile?.vehicleType}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                              AppUtils.verticalDivider(),
                                            ],
                                          ))
                                  : SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [Text("data")],
                                              );
                                            },
                                            // itemCount: equipmentFormList.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(0),
                                            physics:
                                                const ClampingScrollPhysics(),
                                          ),
                                        ],
                                      ),
                                    ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Container(
                      height: 6,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: AppColors.primaryBoxtColors,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Text(
                    "Select an option",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTitleColor),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                AppUtils.verticalDivider(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primaryButtonColors,
                            elevation: 0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primaryColors,
                                size: 16,
                              ),
                              Text(
                                'New Estimate',
                                style: TextStyle(
                                    color: AppColors.primaryColors,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: '.SF Pro Text',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => DummyVehicleScreen(
                                      vehicleId: widget.vehicleId))),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // ElevatedButton(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.add),
                      //       Text('Add Vechile'),
                      //     ],
                      //   ),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.primaryButtonColors,
                              elevation: 0,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColors.primaryColors,
                                  size: 16,
                                ),
                                Text(
                                  'Edit Vehicle',
                                  style: TextStyle(
                                      color: AppColors.primaryColors,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: '.SF Pro Text',
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateVehicleScreen(
                                            editVehicle: vechile,
                                          )));
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.primaryButtonColors,
                            elevation: 0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: AppColors.primaryColors,
                                size: 16,
                              ),
                              Text(
                                'Delete Vehicle',
                                style: TextStyle(
                                    color: AppColors.primaryColors,
                                    fontFamily: '.SF Pro Text',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                            showDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text("Delete vehicle?"),
                                content: const Text(
                                    'Do you really want to delete this vehicle?'),
                                actions: [
                                  CupertinoButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                      BlocProvider.of<VechileBloc>(
                                              scaffoldKey.currentContext!)
                                          .add(DeleteVechile(
                                              id: widget.vehicleId));
                                    },
                                  ),
                                  CupertinoButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: AppColors.primaryColors,
                            fontWeight: FontWeight.w500,
                            fontFamily: '.SF Pro Text',
                            fontSize: 16),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  noteTileWidget(String note, DateTime date, String noteId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat("mm/dd/yyyy").format(date)} - ${DateFormat("HH:mm").format(date)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteVehicleNotePopup(context, "", noteId);
                        // showNoteDeleteDialog(notes[index].id.toString());
                      },
                      child: const Icon(
                        CupertinoIcons.clear,
                        size: 18,
                        color: AppColors.primaryColors,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.primaryTitleColor,
                  ),
                )
              ],
            ),
          )),
    );
  }

  addNotePopup(BuildContext context) {
    bool addNoteErrorStatus = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => VechileBloc(),
          child: BlocListener<VechileBloc, VechileState>(
            listener: (context, state) {
              if (state is AddVehicleNoteState) {
                print("listner worked");

                scaffoldKey.currentContext!
                    .read<VechileBloc>()
                    .add(GetVehicleNoteEvent(vehicleId: widget.vehicleId));

                Navigator.pop(context);
                addNoteController.clear();
              }

              // TODO: implement listener
            },
            child: BlocBuilder<VechileBloc, VechileState>(
              builder: (context, state) {
                return StatefulBuilder(builder: (context, newSetState) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryTitleColor,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      title: const Text(
                        "Add Vehicle Note",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.primaryColors,
                            ))
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text("Description"),
                                Text(
                                  " *",
                                  style: TextStyle(
                                      color: const Color(
                                    0xffD80027,
                                  )),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height -
                                    kToolbarHeight -
                                    220,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  expands: true,
                                  controller: addNoteController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Notes",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: addNoteErrorStatus
                                                  ? const Color(
                                                      0xffD80027,
                                                    )
                                                  : Colors.grey))),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: addNoteErrorStatus,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(addNoteErrorMessage,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(
                                          0xffD80027,
                                        ),
                                      )),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (addNoteController.text.isEmpty) {
                                    newSetState(() {
                                      addNoteErrorStatus = true;
                                      addNoteErrorMessage =
                                          "Note can't be empty";
                                    });
                                  } else {
                                    newSetState(() {
                                      addNoteErrorStatus = false;
                                    });
                                  }

                                  if (!addNoteErrorStatus) {
                                    context.read<VechileBloc>().add(
                                        AddVehicleNoteEvent(
                                            notes: addNoteController.text,
                                            vehicleId: widget.vehicleId));
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.primaryColors),
                                  child: state is AddVehicleNoteLoadingState
                                      ? const Center(
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : const Text(
                                          "Confirm",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }

  Future deleteVehicleNotePopup(BuildContext context, message, String noteId) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => VechileBloc(),
        child: BlocListener<VechileBloc, VechileState>(
          listener: (context, state) {
            if (state is DeleteVehicleNoteState) {
              scaffoldKey.currentContext!
                  .read<VechileBloc>()
                  .add(GetVehicleNoteEvent(vehicleId: widget.vehicleId));

              Navigator.pop(context);
            }
            // TODO: implement listener
          },
          child: BlocBuilder<VechileBloc, VechileState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Note?"),
                content: Text("Do you really want to remove this note?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context
                            .read<VechileBloc>()
                            .add(DeleteVehicleNotesEvent(vehicleId: noteId));
                      }),
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget estimateTileWidget(
      String estimateName,
      estimateId,
      String customerName,
      String carModel,
      String serviceName,
      String dropSchedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 1,
                blurRadius: 6,
                color: Color.fromRGBO(88, 88, 88, 0.178),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dropSchedule != ""
                  ? Row(
                      children: [
                        SvgPicture.asset(
                            "assets/images/calendar_estimate_icon.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            // dropSchedule.substring(0, 10),
                            dropSchedule,
                            style: const TextStyle(
                                color: AppColors.greyText,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        // SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                        // const Text(
                        //   " 3/7/23 9:00 Am",
                        //   style: TextStyle(
                        //       color: AppColors.greyText,
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w400),
                        // )
                      ],
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "${estimateName} #${estimateId} - ${serviceName}",
                  style: const TextStyle(
                      color: AppColors.primaryColors,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  customerName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  carModel,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
