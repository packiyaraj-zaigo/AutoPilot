import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late final controller = TabController(length: 3, vsync: this);
  final TextEditingController searchController = TextEditingController();
  String vinNumber = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'Scanner',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.black87,
              // size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 60),
          child: TabBar(
            controller: controller,
            enableFeedback: false,
            indicatorColor: const Color(0xFF333333),
            unselectedLabelColor: const Color(0xFF9A9A9A),
            labelColor: const Color(0xFF333333),
            tabs: const [
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'VIN Code',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'VIN Scan',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'LIC Plate',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width - 120,
                width: MediaQuery.of(context).size.width - 120,
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width - 150,
                        width: MediaQuery.of(context).size.width - 150,
                        child: MobileScanner(
                          onDetect: (value) {
                            setState(() {
                              vinNumber =
                                  value.barcodes.last.rawValue.toString();
                              searchController.text = vinNumber;
                              controller.animateTo(1);
                            });
                            log(value.barcodes[0].rawValue.toString());
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            left:
                                BorderSide(color: Color(0xFF333333), width: 5),
                            top: BorderSide(
                              color: Color(0xFF333333),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            right:
                                BorderSide(color: Color(0xFF333333), width: 5),
                            top: BorderSide(
                              color: Color(0xFF333333),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            left:
                                BorderSide(color: Color(0xFF333333), width: 5),
                            bottom: BorderSide(
                              color: Color(0xFF333333),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 57,
                        width: 57,
                        decoration: const BoxDecoration(
                          border: Border(
                            right:
                                BorderSide(color: Color(0xFF333333), width: 5),
                            bottom: BorderSide(
                              color: Color(0xFF333333),
                              width: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text('$vinNumber'),
            ],
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: CupertinoTextField(
                      controller: searchController,
                      padding: const EdgeInsets.only(top: 14, left: 14),
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
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Vehicle found in shop history',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF061237),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '2020 Tesla Model S',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            'Electric Blue, Sedan',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            'WPDA94775475KNFEJE',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Estimates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF061237),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(children: [
                                    Icon(
                                      CupertinoIcons.calendar,
                                      size: 18,
                                      color: Color(0xFF9A9A9A),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      '3/7/23 9:00 AM',
                                      style: TextStyle(
                                        color: Color(0xFF9A9A9A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      CupertinoIcons.minus,
                                      size: 18,
                                      color: Color(0xFF9A9A9A),
                                    ),
                                    Icon(
                                      CupertinoIcons.calendar,
                                      size: 18,
                                      color: Color(0xFF9A9A9A),
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      '3/10/23 12:00 PM',
                                      style: TextStyle(
                                        color: Color(0xFF9A9A9A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                  Text(
                                    'Estimate #1847 - Satin Black Wrap',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    'James Smith',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                  Text(
                                    '2022 Tesla Model Y',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemCount: 10)
                ],
              ),
            ),
          ),
          const Column(
            children: [Text('Vehicle found but not in shop')],
          ),
        ],
      ),
    );
  }
}
