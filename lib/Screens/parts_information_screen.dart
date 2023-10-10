import 'package:auto_pilot/Models/parts_notes_model.dart';
import 'package:auto_pilot/Screens/create_parts.dart';
import 'package:auto_pilot/Screens/parts_list_screen.dart';
import 'package:auto_pilot/bloc/parts_bloc/parts_bloc.dart';
import 'package:auto_pilot/bloc/parts_bloc/parts_event.dart';
import 'package:auto_pilot/bloc/parts_bloc/parts_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../Models/parts_model.dart';

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
  List<Datum> partsNotesData = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
          CommonWidgets()
              .showSuccessDialog(context, "Part Deleted Successfully");
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
        if (state is GetPartsNoteState) {
          partsNotesData.clear();
          partsNotesData.addAll(state.partsNotesModel.data);
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return PartsScreen();
            },
          ));

          return false;
        },
        child: BlocBuilder<PartsBloc, PartsState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return PartsScreen();
                      },
                    ));
                  },
                  color: AppColors.primaryColors,
                  icon: const Icon(Icons.arrow_back),
                ),
                centerTitle: true,
                title: const Text(
                  "Part's Information",
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

                          if (selectedIndex == 1) {
                            context.read<PartsBloc>().add(GetPartsNotesEvent(
                                partsId: widget.parts.id.toString()));
                          }
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
                    selectedIndex == 1
                        ? Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      addNotePopup(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.buttonColors,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: state is GetPartsNoteLoadingState
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : partsNotesData.isNotEmpty
                                            ? ListView.builder(
                                                itemBuilder: (context, index) {
                                                  return noteTileWidget(
                                                      partsNotesData[index]
                                                          .notes,
                                                      partsNotesData[index]
                                                          .createdAt,
                                                      partsNotesData[index]
                                                          .id
                                                          .toString());
                                                },
                                                itemCount:
                                                    partsNotesData.length,
                                                shrinkWrap: true,
                                                physics:
                                                    const ClampingScrollPhysics(),
                                              )
                                            : const Center(
                                                child: Text("No Notes Found",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .greyText)),
                                              ),
                                  ),
                                )
                              ],
                            ),
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
                                widget.parts.itemServiceNote,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryTitleColor),
                              ),
                              // AppUtils.verticalDivider(),
                              // const SizedBox(
                              //   height: 14,
                              // ),
                              // const Text(
                              //   "Type",
                              //   style: TextStyle(
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w500,
                              //       color: AppColors.greyText),
                              // ),
                              // const SizedBox(height: 8),
                              // Text(
                              //   widget.parts.itemName,
                              //   style: const TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.w400,
                              //       color: AppColors.primaryTitleColor),
                              // ),
                              const SizedBox(
                                height: 12,
                              ),
                              AppUtils.verticalDivider(),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              const Text(
                                "0.00",
                                style: TextStyle(
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
                                widget.parts.subTotal,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primaryTitleColor),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                  ],
                ),
              ),
            );
          },
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
                CreatePartsScreen(part: widget.parts, navigation: "edit"),
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

  noteTileWidget(String note, DateTime date, String noteId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${DateFormat("MM/dd/yyyy").format(date)} - ${DateFormat("HH:mm").format(date)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        deletePartsNotePopup(context, "", noteId);
                        //  deleteVehicleNotePopup(context, "", noteId);
                        // showNoteDeleteDialog(notes[index].id.toString());
                      },
                      child: const Icon(
                        CupertinoIcons.clear,
                        size: 18,
                        color: AppColors.primaryColors,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: AppColors.primaryTitleColor,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future deletePartsNotePopup(BuildContext context, message, String noteId) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => PartsBloc(),
        child: BlocListener<PartsBloc, PartsState>(
          listener: (context, state) {
            if (state is DeletePartsNoteState) {
              scaffoldKey.currentContext!
                  .read<PartsBloc>()
                  .add(GetPartsNotesEvent(partsId: widget.parts.id.toString()));

              Navigator.pop(context);
            }
            if (state is GetPartsNoteState) {
              partsNotesData.clear();
              partsNotesData.addAll(state.partsNotesModel.data);
            }
            // TODO: implement listener
          },
          child: BlocBuilder<PartsBloc, PartsState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Note?"),
                content: Text("Do you really want to remove this note?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context
                            .read<PartsBloc>()
                            .add(DeletePartsNoteEvent(partsId: noteId));
                      }),
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  addNotePopup(BuildContext context) {
    bool addNoteErrorStatus = false;
    final addNoteController = TextEditingController();
    String addNoteErrorMessage = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return BlocProvider(
          create: (context) => PartsBloc(),
          child: BlocListener<PartsBloc, PartsState>(
            listener: (context, state) {
              if (state is AddPartsNoteState) {
                print("listner worked");

                scaffoldKey.currentContext!.read<PartsBloc>().add(
                    GetPartsNotesEvent(partsId: widget.parts.id.toString()));

                Navigator.pop(context);
                addNoteController.clear();
              } else if (state is AddPartsNoteErrorState) {
                //show error message here
                addNoteErrorStatus = true;
                addNoteErrorMessage = state.errorMessage;
              }

              // TODO: implement listener
            },
            child: BlocBuilder<PartsBloc, PartsState>(
              builder: (context, state) {
                return StatefulBuilder(builder: (context, newSetState) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primaryTitleColor,
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      title: const Text(
                        "Add Part Note",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: AppColors.primaryColors,
                            ))
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text("Description"),
                                Text(
                                  " *",
                                  style: TextStyle(
                                      color: const Color(
                                    0xffD80027,
                                  )),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height -
                                    kToolbarHeight -
                                    220,
                                child: TextField(
                                  textAlignVertical: TextAlignVertical.top,
                                  maxLines: null,
                                  maxLength: null,
                                  expands: true,
                                  controller: addNoteController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Notes",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: addNoteErrorStatus
                                                  ? const Color(
                                                      0xffD80027,
                                                    )
                                                  : Colors.grey))),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: addNoteErrorStatus,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(addNoteErrorMessage,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(
                                          0xffD80027,
                                        ),
                                      )),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (addNoteController.text.trim().isEmpty) {
                                    newSetState(() {
                                      addNoteErrorStatus = true;
                                      addNoteErrorMessage =
                                          "Note can't be empty";
                                    });
                                  } else {
                                    newSetState(() {
                                      addNoteErrorStatus = false;
                                    });
                                  }

                                  if (!addNoteErrorStatus) {
                                    context.read<PartsBloc>().add(
                                        AddPartsNoteEvent(
                                            notes: addNoteController.text,
                                            partsId:
                                                widget.parts.id.toString()));
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.primaryColors),
                                  child: state is AddPartsNoteLoadingState
                                      ? const Center(
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : const Text(
                                          "Confirm",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        );
      },
    );
  }
}
