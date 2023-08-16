import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DummyCustomerScreen extends StatefulWidget {
  const DummyCustomerScreen(
      {super.key, required this.customerId, this.navigation, this.orderId});
  final String customerId;
  final String? navigation;
  final String? orderId;

  @override
  State<DummyCustomerScreen> createState() => _DummyCustomerScreenState();
}

class _DummyCustomerScreenState extends State<DummyCustomerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(widget.orderId == null
            ? CreateEstimateEvent(id: widget.customerId, which: "customer")
            : EditEstimateEvent(
                id: widget.customerId,
                orderId: widget.orderId ?? "",
                which: "customer",
                customerId: widget.customerId)),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is CreateEstimateState) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return EstimatePartialScreen(
                  estimateDetails: state.createEstimateModel,
                  navigation: widget.navigation,
                );
              },
            ));
          } else if (state is EditEstimateState) {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return EstimatePartialScreen(
                  estimateDetails: state.createEstimateModel,
                  navigation: widget.navigation,
                );
              },
            ));
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
