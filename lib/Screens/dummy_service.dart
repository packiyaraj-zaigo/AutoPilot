import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DummyServiceScreen extends StatefulWidget {
  final String orderId;
  const DummyServiceScreen({super.key, required this.orderId});

  @override
  State<DummyServiceScreen> createState() => _DummyServiceScreenState();
}

class _DummyServiceScreenState extends State<DummyServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(GetSingleEstimateEvent(orderId: widget.orderId)),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is GetSingleEstimateState) {
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
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CupertinoActivityIndicator(),
            ),
          ],
        )),
      ),
    );
  }
}
