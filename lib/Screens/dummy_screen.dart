import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key,required this.name});
  final String name;

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Center(
        child: Text(widget.name),
      )),
    );
  }
}