import 'package:flutter/material.dart';

class WorkFlowScreen extends StatelessWidget {
  const WorkFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: 
      Column(
        children: [
          Text("Workflow screen")
        ],
      )),
    );
  }
}