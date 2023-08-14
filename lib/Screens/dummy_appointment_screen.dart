import 'dart:developer';

import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DummyAppointmentScreen extends StatefulWidget {
  const DummyAppointmentScreen({
    super.key,
    required this.customerId,
    required this.vehicleId,
    required this.appointmentId,
    required this.startTime,
    required this.endTime,
    required this.appointmentNote,
  });
  final String customerId;
  final String vehicleId;
  final String appointmentId;
  final String startTime;
  final String endTime;
  final String appointmentNote;

  @override
  State<DummyAppointmentScreen> createState() => _DummyAppointmentScreenState();
}

class _DummyAppointmentScreenState extends State<DummyAppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    log("customer_id=${widget.customerId}");
    log("vehicle_id=${widget.vehicleId}");
    log("appointment_id=${widget.appointmentId}");
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(
          CreateEstimateFromAppointmentEvent(
            customerId: widget.customerId,
            vehicleId: widget.vehicleId,
            appointmentId: widget.appointmentId,
            startTime: widget.startTime,
            endTime: widget.endTime,
            appointmentNote: widget.appointmentNote,
          ),
        ),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is CreateEstimateState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                  );
                },
              ),
            );
          } else if (state is CreateEstimateErrorState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => BottomBarScreen()),
                (route) => false);
            CommonWidgets().showDialog(context, state.errorMessage);
          }
        },
        child: const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CupertinoActivityIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
