import 'package:flutter/material.dart';

class EstimateScreen extends StatelessWidget {
  const EstimateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: 
      Column(
        children: [
          Text("Estimate screen")
        ],
      )),
    );
  }
}