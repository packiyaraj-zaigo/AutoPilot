import 'package:auto_pilot/Screens/create_parts.dart';
import 'package:auto_pilot/Screens/parts_list_screen.dart';
import 'package:auto_pilot/bloc/parts_model/parts_bloc.dart';
import 'package:auto_pilot/bloc/parts_model/parts_event.dart';
import 'package:auto_pilot/bloc/parts_model/parts_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/parts_model.dart';
import '../Models/vechile_model.dart';
import '../utils/app_utils.dart';

class PartsInformation extends StatefulWidget {
  PartsInformation({
    Key? key,
    required this.parts,
  }) : super(key: key);
  final PartsDatum parts;
  @override
  State<PartsInformation> createState() => _PartsInformationState();
}

class _PartsInformationState extends State<PartsInformation> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    changeQuantity();
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    changeQuantity();
  }

  changeQuantity() {
    widget.parts.quantityInHand = _counter;
    BlocProvider.of<PartsBloc>(context).add(ChangeQuantity(part: widget.parts));
  }

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
  ];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _counter = widget.parts.quantityInHand;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PartsBloc, PartsState>(
      listener: (context, state) {
        if (state is DeletePartSuccessState) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => PartsScreen(),
          ));
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(SnackBar(
            content: Text("Part Deleted Succefully"),
            backgroundColor: CupertinoColors.activeGreen,
          ));
        }
        if (state is DeletePartErrorState) {
          CommonWidgets().showDialog(context, state.message);
        }
        if (state is DeletePartLoadingState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => const CupertinoActivityIndicator());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: AppColors.primaryColors,
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text(
            "Parts Information",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryBlackColors),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => moreOptionsSheet());
                },
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.primaryColors,
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.parts.itemName,
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
                  },
                  backgroundColor: AppColors.primarySegmentColors,
                  groupValue: selectedIndex,
                  children: {
                    for (int i = 0; i < _segmentTitles.length; i++)
                      i: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 65),
                        child: _segmentTitles[i],
                      )
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: selectedIndex == 1
                      ? Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  print("object");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonColors,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_circle_outline,
                                      color: AppColors.primaryColors,
                                    ),
                                    Text(
                                      'Add New Note',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColors,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(
                                          0, 7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${widget.parts.createdAt}',
                                    style: const TextStyle(
                                        color: AppColors.greyText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    widget.parts.itemServiceNote,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.primaryTitleColor),
                                  ),
                                  // trailing: Icon(Icons.add),),
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Serial Number",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyText),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.parts.partName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryTitleColor),
                            ),
                            AppUtils.verticalDivider(),
                            const SizedBox(
                              height: 14,
                            ),
                            const Text(
                              "Type",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyText),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.parts.itemName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryTitleColor),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            AppUtils.verticalDivider(),
                            const SizedBox(
                              height: 14,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Quantity",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.greyText),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '$_counter'.padLeft(2, '0'),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.primaryTitleColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _decrementCounter();
                                      },
                                      child: const CircleAvatar(
                                        radius: 11,
                                        child: Center(
                                            child: Icon(
                                          CupertinoIcons.minus,
                                          size: 15,
                                        )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 35,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _incrementCounter();
                                      },
                                      child: const CircleAvatar(
                                        radius: 11,
                                        child: Center(
                                            child: Icon(
                                          CupertinoIcons.add,
                                          size: 15,
                                        )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            AppUtils.verticalDivider(),
                            const SizedBox(
                              height: 14,
                            ),
                            const Text(
                              "Fee",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGrayColors),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.parts.subTotal,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryTitleColor),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            AppUtils.verticalDivider(),
                            const SizedBox(
                              height: 14,
                            ),
                            const Text(
                              "Cost",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.greyText),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.parts.taxRate,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryTitleColor),
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                  // : SingleChildScrollView(
                  //     child: Column(
                  //       children: [
                  //         ListView.builder(
                  //           itemBuilder: (context, index) {
                  //             return Column(
                  //               children: [Text("data")],
                  //             );
                  //           },
                  //           // itemCount: equipmentFormList.length,
                  //           shrinkWrap: true,
                  //           padding: const EdgeInsets.all(0),
                  //           physics: const ClampingScrollPhysics(),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget moreOptionsSheet() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              bottomSheetTile(
                'Edit',
                Icons.edit,
                CreatePartsScreen(part: widget.parts),
              ),
              bottomSheetTile(
                'Delete',
                Icons.delete,
                null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColors),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetTile(String title, IconData icon, constructor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () async {
          if (title == 'Delete') {
            Navigator.of(context).pop(true);
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Delete Part?"),
                content: const Text('Do you really want to delete this part?'),
                actions: [
                  CupertinoButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      BlocProvider.of<PartsBloc>(context).add(
                        DeletePart(id: widget.parts.id.toString()),
                      );
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
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => constructor,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: const Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: title == 'Delete'
                    ? CupertinoColors.destructiveRed
                    : AppColors.primaryColors,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: title == 'Delete'
                        ? CupertinoColors.destructiveRed
                        : AppColors.primaryColors,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
