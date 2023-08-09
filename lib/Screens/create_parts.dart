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
  const CreatePartsScreen({super.key, this.part, this.navigation});

  final PartsDatum? part;
  final String? navigation;

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
        title: Text(
          widget.navigation == "edit" ? "New Item" : "Edit Item",
          style: const TextStyle(
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
                    builder: (context) => const PartsScreen(),
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
                        textBox("Enter Item Name", itemnameController,
                            "Item Name", itemnameErrorStaus, true),
                        errorMessageWidget(
                            itemnameErrorMsg, itemnameErrorStaus),
                        textBox("Enter Serial Number", serialnumberController,
                            "Serial Number", serialnumberErrorStatus, true),
                        errorMessageWidget(
                            serialnumberErrorMsg, serialnumberErrorStatus),
                        textBox("Enter Quantity Number", quantityController,
                            "Quantity", quantityErrorStatus, true),
                        errorMessageWidget(
                            quantityErrorMsg, quantityErrorStatus),
                        textBox("Enter Fee", feeController, "Fee",
                            feeErrorStatus, false),
                        errorMessageWidget(feeErrorMsg, feeErrorStatus),
                        textBox("Enter Supplies", suppliesController,
                            "Supplies", suppliesErrorStatus, false),
                        errorMessageWidget(
                            suppliesErrorMsg, suppliesErrorStatus),
                        textBox("Enter EPA Number", epaController, "EPA",
                            epaErrorStatus, false),
                        errorMessageWidget(epaErrorMsg, epaErrorStatus),
                        textBox("Enter Cost", costController, "Cost",
                            costErrorStatus, true),
                        errorMessageWidget(costErrorMsg, costErrorStatus),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              final status = validateParts();
                              if (status) {
                                if (widget.part != null) {
                                  context.read<PartsBloc>().add(
                                        EditPartEvent(
                                          itemname: itemnameController.text,
                                          quantity: quantityController.text,
                                          serialnumber:
                                              serialnumberController.text,
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
                                          serialnumber:
                                              serialnumberController.text,
                                          fee: feeController.text,
                                          supplies: suppliesController.text,
                                          epa: epaController.text,
                                          cost: costController.text,
                                          type: _currentSelectedTypeValue
                                              .toString(),
                                        ),
                                      );
                                }
                              }
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
                                : const Text(
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

  bool validateParts() {
    bool status = true;
    if (itemnameController.text.isEmpty) {
      itemnameErrorMsg = "Item name can't be empty.";
      itemnameErrorStaus = true;
      status = false;
    } else {
      itemnameErrorStaus = false;
    }
    if (serialnumberController.text.isEmpty) {
      serialnumberErrorMsg = "Serial number can't be empty.";
      serialnumberErrorStatus = true;
      status = false;
    } else {
      serialnumberErrorStatus = false;
    }
    if (quantityController.text.isEmpty) {
      quantityErrorMsg = "Quantity can't be empty.";
      quantityErrorStatus = true;
      status = false;
    } else {
      quantityErrorStatus = false;
    }
    if (costController.text.isEmpty) {
      costErrorMsg = "Cost can't be empty.";
      costErrorStatus = true;
      status = false;
    } else {
      costErrorStatus = false;
    }
    setState(() {});
    return status;
  }

  Widget errorMessageWidget(String errorMsg, bool isVisible) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, bottom: 16),
      child: Visibility(
        visible: isVisible,
        child: Text(
          errorMsg,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFD80027),
          ),
        ),
      ),
    );
  }

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            Text(
              isRequired ? ' *' : '',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 6.0,
          ),
          child: SizedBox(
            height: 56,
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
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
}
