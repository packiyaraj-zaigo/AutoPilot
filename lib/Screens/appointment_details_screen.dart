import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.eventId});
  final String eventId;

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  CreateEstimateModel? createEstimateModel;
  DateTime? beginDate;
  DateTime? endDate;
  String notes = "";
  double totalAmount = 0.00;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(GetEventDetailsByIdEvent(eventId: widget.eventId)),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is GetEventDetailsByIdState) {
            beginDate = state.beginDate;
            endDate = state.endDate;
            notes = state.notes;

            context
                .read<EstimateBloc>()
                .add(GetSingleEstimateEvent(orderId: state.orderId));
          }
          if (state is GetSingleEstimateState) {
            createEstimateModel = state.createEstimateModel;

            calculateAmount();
          }
          // TODO: implement listener
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.primaryColors,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Appointment",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTitleColor),
                ),
                automaticallyImplyLeading: true,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_horiz,
                        color: AppColors.primaryColors,
                      ))
                ],
              ),
              body: state is AppointmentDetailsLoadingState &&
                      state is GetSingleEstimateLoadingState
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Date and status row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                appointmentTileWidget(
                                    "Date",
                                    beginDate != null
                                        ? DateFormat("mm/dd/yyyy")
                                            .format(beginDate!)
                                        : "",
                                    MediaQuery.of(context).size.width / 2.8),
                                appointmentTileWidget("Status", "In Progress",
                                    MediaQuery.of(context).size.width / 2.8)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  dividerLine(
                                      MediaQuery.of(context).size.width / 2.8),
                                  dividerLine(
                                      MediaQuery.of(context).size.width / 2.8)
                                ],
                              ),
                            ),

                            //Start and End time row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                appointmentTileWidget(
                                    "Start Time",
                                    beginDate != null
                                        ? DateFormat("hh:mm").format(beginDate!)
                                        : "",
                                    MediaQuery.of(context).size.width / 2.8),
                                appointmentTileWidget(
                                    "End Time",
                                    endDate != null
                                        ? DateFormat("hh:mm").format(endDate!)
                                        : "",
                                    MediaQuery.of(context).size.width / 2.8)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  dividerLine(
                                      MediaQuery.of(context).size.width / 2.8),
                                  dividerLine(
                                      MediaQuery.of(context).size.width / 2.8)
                                ],
                              ),
                            ),

                            //Customer name tile
                            appointmentTileWidget(
                                "Customer Name",
                                "${createEstimateModel?.data.customer?.firstName ?? ""} ${createEstimateModel?.data.customer?.firstName ?? ""}",
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            //Estimate tile
                            appointmentTileWidget(
                                "Estimate",
                                createEstimateModel?.data.orderNumber != null
                                    ? "#${createEstimateModel?.data.orderNumber ?? ""}"
                                    : "No Estimate",
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            //Vehicle tile
                            appointmentTileWidget(
                                "Vehicle",
                                "${createEstimateModel?.data.vehicle?.vehicleYear ?? ""} ${createEstimateModel?.data.vehicle?.vehicleMake ?? ""} ${createEstimateModel?.data.vehicle?.vehicleModel ?? ""}",
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            // Notes Tile
                            appointmentTileWidget("Notes", notes,
                                MediaQuery.of(context).size.width),
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: dividerLine(
                                  MediaQuery.of(context).size.width),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 64.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Total",
                                    style: TextStyle(
                                        color: AppColors.primaryTitleColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "\$ ${totalAmount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: AppColors.primaryTitleColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return EstimatePartialScreen(
                                          estimateDetails:
                                              createEstimateModel!);
                                    },
                                  ));
                                },
                                child: Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.primaryColors),
                                  child: const Text(
                                    "Go to Estimate",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget appointmentTileWidget(String title, String value, boxWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: SizedBox(
        width: boxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTitleColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dividerLine(double linewidth) {
    return Container(
      height: 1,
      width: linewidth,
      color: const Color(0xffE8EAED),
    );
  }

  calculateAmount() {
    createEstimateModel?.data.orderService?.forEach((element) {
      element.orderServiceItems?.forEach((element2) {
        totalAmount = totalAmount + double.parse(element2.subTotal);
      });
    });
  }
}
