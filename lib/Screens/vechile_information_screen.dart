import 'package:auto_pilot/Screens/dummy_vehcile_screen.dart';
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

class VechileInformation extends StatefulWidget {
  VechileInformation({
    Key? key,
    required this.vechile,
  }) : super(key: key);
  final Datum vechile;
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
  List<vn.Datum> noteList = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VechileBloc(),
      child: BlocListener<VechileBloc, VechileState>(
        listener: (context, state) {
          if (state is DeleteVechileDetailsSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const VehiclesScreen(),
                ),
                (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Vehicle Deleted Successfully'),
              backgroundColor: Colors.green,
            ));
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
                title: Text(
                  "Vehicle's Information",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryBlackColors),
                ),
                centerTitle: true,
                actions: widget.vechile.vehicleYear == ''
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
                      "${widget.vechile.vehicleYear} ${widget.vechile.vehicleMake} ${widget.vechile.vehicleModel}",
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
                                vehicleId: widget.vechile.id.toString()));
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
                          ? Column(
                              children: [Text("dateeeeeeeeeeeeeeeea")],
                            )
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
                                                                      .createdAt);
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
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height,
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
                                            "${widget.vechile.firstName ?? '-'}",
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
                                            "${widget.vechile.subModel ?? ""}",
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
                                            "${widget.vechile.engineSize ?? ""}",
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
                                            "${widget.vechile.vehicleColor ?? ""}",
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
                                            "${widget.vechile.vin?.toUpperCase() ?? ""}",
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
                                            "${widget.vechile.licencePlate ?? ""}",
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
                                            "${widget.vechile.vehicleType}",
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
                                      vehicleId:
                                          widget.vechile.id.toString()))),
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
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateVehicleScreen(
                                        editVehicle: widget.vechile,
                                      ))),
                        ),
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
                                              id: widget.vechile.id
                                                  .toString()));
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

  noteTileWidget(String note, DateTime date) {
    return Padding(
      padding: const EdgeInsets.only(top: 22.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            "${DateFormat('mm/dd/yyyy').format(date)} - ${DateFormat('HH:mm').format(date)}",
            style: TextStyle(
                color: AppColors.greyText,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            note,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.primaryTitleColor),
          ),
          // trailing: Icon(Icons.add),),
        ),
      ),
    );
  }

  addNotePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Add Note"),
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Icon(Icons.close, color: AppColors.primaryColors))
            ],
          ),
          insetPadding:
              const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
          content: SizedBox(
            height: 240,
            child: Column(
              children: [
                TextField(
                  maxLines: 6,
                  controller: addNoteController,
                  decoration: InputDecoration(
                      hintText: "Enter Note",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primaryColors),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
