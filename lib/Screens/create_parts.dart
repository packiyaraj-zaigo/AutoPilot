import 'package:auto_pilot/Models/parts_model.dart';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Screens/parts_list_screen.dart';
import 'package:auto_pilot/bloc/parts_model/parts_bloc.dart';
import 'package:auto_pilot/bloc/parts_model/parts_event.dart';
import 'package:auto_pilot/bloc/parts_model/parts_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CreatePartsScreen extends StatefulWidget {
  const CreatePartsScreen({super.key, this.part});

  final PartsDatum? part;

  @override
  State<CreatePartsScreen> createState() => _CreatePartsScreenState();
}

class _CreatePartsScreenState extends State<CreatePartsScreen> {
  final TextEditingController itemnameController = TextEditingController();
  final TextEditingController serialnumberController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController suppliesController = TextEditingController();
  final TextEditingController epaController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  bool itemnameErrorStaus = false;
  bool serialnumberErrorStatus = false;
  bool quantityErrorStatus = false;
  bool feeErrorStatus = false;
  bool suppliesErrorStatus = false;
  bool epaErrorStatus = false;
  bool costErrorStatus = false;
  bool typeErrorStatus = false;

  String itemnameErrorMsg = '';
  String serialnumberErrorMsg = '';
  String quantityErrorMsg = '';
  String feeErrorMsg = '';
  String suppliesErrorMsg = '';
  String epaErrorMsg = '';
  String costErrorMsg = '';
  String typeErrorMsg = '';

  final List<PartsDatum> parts = [];

  List<String> states = [];
  List<DropdownDatum> dropdownData = [];
  dynamic _currentSelectedTypeValue;

  populateData() {
    itemnameController.text = widget.part!.itemName;
    serialnumberController.text = widget.part!.itemServiceNote;
    quantityController.text = widget.part!.quantityInHand.toString();
    costController.text = widget.part!.unitPrice;
  }

  @override
  initState() {
    super.initState();
    if (widget.part != null) {
      populateData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "New Item",
          style: TextStyle(
              fontSize: 16,
              color: AppColors.primaryBlackColors,
              fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                CupertinoIcons.clear,
                color: AppColors.primaryColors,
              ))
        ],
      ),
      body: BlocProvider(
        create: (context) => PartsBloc(),
        child: BlocListener<PartsBloc, PartsState>(
          listener: (context, state) {
            if (state is AddPartDetailsErrorState) {
              CommonWidgets().showDialog(context, state.message);
            } else if (state is AddPardDetailsSuccessState) {
              Navigator.pop(context, true);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartsScreen(),
                  ));
              ScaffoldMessenger.of((context)).showSnackBar(
                SnackBar(
                  content: Text(widget.part == null
                      ? 'Part Created Successfully'
                      : "Part Updated Successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          child: BlocBuilder<PartsBloc, PartsState>(builder: (context, state) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter stateUpdate) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Basic Details",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryTitleColor),
                        ),
                        const SizedBox(height: 16),
                        // textBox("Enter name...", nameController,
                        //     "Owner", nameErrorStatus),
                        textBox("Enter Item Name", itemnameController,
                            "Item Name", itemnameErrorStaus),

                        // Visibility(
                        //     visible: yearErrorStaus,
                        //     child: Text(
                        //       yearErrorMsg,
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w500,
                        //         color: Color(
                        //           0xffD80027,
                        //         ),
                        //       ),
                        //     )),

                        textBox("Enter Serial Number", serialnumberController,
                            "Serial Number", serialnumberErrorStatus),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        textBox("Enter Quanity Number", quantityController,
                            "Quantity", quantityErrorStatus),
                        textBox(
                            "Enter Fee", feeController, "Fee", feeErrorStatus),
                        textBox("Enter Supplies", suppliesController,
                            "Supplies", suppliesErrorStatus),
                        textBox("Enter EPA Number", epaController, "EPA",
                            epaErrorStatus),
                        textBox("Enter Cost", costController, "Cost",
                            costErrorStatus),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              validateParts(
                                context,
                                itemnameController.text,
                                serialnumberController.text,
                                stateUpdate,
                              );

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             VechileInformation()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColors,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: state is PartsDetailsSuccessStates
                                ? const CupertinoActivityIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Confirm',
                                    style: TextStyle(fontSize: 15),
                                  ),
                          ),
                        ),
                      ]),
                ),
              );
            });
          }),
        ),
      ),
    );
  }

  validateParts(
    BuildContext context,
    String PartsItemname,
    String serialnumber,
    StateSetter stateUpdate,
  ) {
    if (PartsItemname.isEmpty) {
      stateUpdate(() {
        itemnameErrorMsg = 'Itemname cant be empty.';
        itemnameErrorStaus = true;
      });
    } else {
      itemnameErrorStaus = false;
    }
    if (serialnumber.isEmpty) {
      stateUpdate(() {
        serialnumberErrorMsg = 'Itemname cant be empty.';
        serialnumberErrorStatus = true;
      });
    } else {
      serialnumberErrorStatus = false;
    }

    if (!itemnameErrorStaus && !serialnumberErrorStatus) {
      if (widget.part != null) {
        context.read<PartsBloc>().add(
              EditPartEvent(
                itemname: itemnameController.text,
                quantity: quantityController.text,
                serialnumber: serialnumberController.text,
                fee: feeController.text,
                cost: costController.text,
                id: widget.part!.id.toString(),
              ),
            );
      } else {
        context.read<PartsBloc>().add(
              AddParts(
                context: context,
                itemname: itemnameController.text,
                quantity: quantityController.text,
                serialnumber: serialnumberController.text,
                fee: feeController.text,
                supplies: suppliesController.text,
                epa: epaController.text,
                cost: costController.text,
                type: _currentSelectedTypeValue.toString(),
              ),
            );
      }
    }
  }
}

Widget textBox(String placeHolder, TextEditingController controller,
    String label, bool errorStatus) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff6A7187)),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6.0, bottom: 15),
        child: SizedBox(
          height: 56,
          child: TextField(
            keyboardType:
                label == 'Fee' || label == "Quantity" || label == "Cost"
                    ? TextInputType.number
                    : null,
            inputFormatters:
                label == 'Fee' || label == "Quantity" || label == "Cost"
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : [],
            controller: controller,
            decoration: InputDecoration(
                hintText: placeHolder,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: errorStatus == true
                            ? Color(0xffD80027)
                            : Color(0xffC1C4CD))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: errorStatus == true
                            ? Color(0xffD80027)
                            : Color(0xffC1C4CD))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                        color: errorStatus == true
                            ? Color(0xffD80027)
                            : Color(0xffC1C4CD)))),
          ),
        ),
      ),
    ],
  );
}
