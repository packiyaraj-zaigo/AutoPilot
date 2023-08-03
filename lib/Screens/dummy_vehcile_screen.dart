import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DummyVehicleScreen extends StatefulWidget {
  const DummyVehicleScreen({super.key, required this.vehicleId});
  final String vehicleId;

  @override
  State<DummyVehicleScreen> createState() => _DummyVehicleScreenState();
}

class _DummyVehicleScreenState extends State<DummyVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(CreateEstimateEvent(id: widget.vehicleId, which: "vehicle")),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is CreateEstimateState) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel);
              },
            ));
          }
          // TODO: implement listener
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
