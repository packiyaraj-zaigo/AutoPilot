import 'dart:async';

import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Models/vechile_model.dart' as vm;
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:auto_pilot/Screens/vehicles_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/customer_bloc/customer_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';


class CreateEstimateScreen extends StatefulWidget {
  const CreateEstimateScreen({super.key});

  @override
  State<CreateEstimateScreen> createState() => _CreateEstimateScreenState();
}

class _CreateEstimateScreenState extends State<CreateEstimateScreen> {
  final List<String> tempItems = ["temp1", "temp2", "temp3"];
  final notesController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final dateController = TextEditingController();
  final appointmentController = TextEditingController();
  final customerController = TextEditingController();
  final vehicleController = TextEditingController();

  CustomerModel? customerModel;
  vm.VechileResponse?vehicleModel;

  bool noteErrorStatus = false;
  bool startTimeErrorStatus = false;
  bool endTimeErrorStatus = false;
  bool dateErrorStatus = false;
  bool appointmentErrorStatus = false;
  bool customerErrorStatus = false;
  bool vehicleErrorStatus = false;

  String noteErrorMsg = '';
  String dateErrorMsg = '';
  String appointmentErrorMsg = '';




   VechileBloc? _bloc;

  final _debouncer = Debouncer();

  int selectedIndex = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController subModelController = TextEditingController();
  final TextEditingController engineController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController licController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  final ScrollController Listcontroller = ScrollController();

  bool yearErrorStaus = false;
  bool modelErrorStatus = false;
  bool subModelErrorStatus = false;
  bool engineErrorStatus = false;
  bool colorErrorStatus = false;
  bool vinErrorStatus = false;
  bool licErrorStatus = false;
  bool nameErrorStatus = false;
  bool typeErrorStatus = false;
  bool makeErrorStatus = false;
  bool isChecked = false;

  bool isVechileLoading = false;

  String yearErrorMsg = '';
  String modelErrorMsg = '';
  String makeErrorMsg = '';
  String typeErrorMsg = '';
  String colorErrorMsg = '';
  String vinErrorMsg = '';
  String submodelErrorMsg = '';
  String licErrorMsg = '';
  String engineErrorMsg = '';

  final List<vm.Datum> vechile = [];

  List<String> states = [];
  List<DropdownDatum> dropdownData = [];
  dynamic _currentSelectedTypeValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.primaryColors,
        leading: const SizedBox(),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Estimate Details",
                style: TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Follow the steps to create an estimate.",
                  style: TextStyle(
                      color: AppColors.greyText,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              subTitleWidget("Customer Details"),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                // child:  Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Customer",style: TextStyle(
                //       color: AppColors.greyText,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500
                //     ),),
                //     Row(
                //       children: [
                //         Icon(Icons.add,color: AppColors.primaryColors,),
                //           Text("Add new",style: TextStyle(
                //       color: AppColors.primaryColors,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w600
                //     ),)

                //       ],
                //     )
                //   ],
                // ),

                child: textBox("Select Existing", customerController,
                    "Customer", customerErrorStatus),
              ),
              //  customerDropdown(),

              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                // child:  Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Vehicle",style: TextStyle(
                //       color: AppColors.greyText,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500
                //     ),),
                //     Row(
                //       children: [
                //         Icon(Icons.add,color: AppColors.primaryColors,),
                //           Text("Add new",style: TextStyle(
                //       color: AppColors.primaryColors,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w600
                //     ),)

                //       ],
                //     )
                //   ],
                // ),

                child: textBox("Select Existing", vehicleController, "Vehicle",
                    vehicleErrorStatus),
              ),
              // customerDropdown(),

              subTitleWidget("Estimate Notes"),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox(
                    "Enter note", notesController, "Note", noteErrorStatus),
              ),
              subTitleWidget("Appointment"),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    halfTextBox("Select time", startTimeController,
                        "Start time", startTimeErrorStatus),
                    halfTextBox("Select time", endTimeController, "End time",
                        endTimeErrorStatus)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox(
                    "Select date", dateController, "Date", dateErrorStatus),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox("Enter appointment note", appointmentController,
                    "Appointment note", appointmentErrorStatus),
              ),

              subTitleWidget("Inspection Photos"),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Upload photo",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff6A7187)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    inspectionPhotoWidget(),
                    inspectionPhotoWidget(),
                    inspectionPhotoWidget(),
                    inspectionPhotoWidget()
                  ],
                ),
              ),
              subTitleWidget("Services"),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Services",
                      style: TextStyle(
                          color: AppColors.greyText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryColors,
                        ),
                        Text(
                          "Add new",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
              ),
              customerDropdown(),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: taxDetailsWidget("Total Material", "0.00"),
              ),
              taxDetailsWidget("Total Labor", "0.00"),
              taxDetailsWidget("Tax", "0.00"),
              taxDetailsWidget("Discount", "0.00"),
              taxDetailsWidget("Total", "0.00"),
              taxDetailsWidget("Balance Due", "0.00"),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primaryColors,
                  ),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget subTitleWidget(String subTitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Text(
        subTitle,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTitleColor),
      ),
    );
  }

  //Customer dropdown
  Widget customerDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  const Text(
          //       "State",
          //       style:  TextStyle(
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //           color: Color(0xff6A7187)),
          //     ),
          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffC1C4CD)),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    menuMaxHeight: 380,
                    isExpanded: true,

                    value: tempItems[0],
                    style: const TextStyle(
                        color: Color(0xff6A7187),
                        overflow: TextOverflow.ellipsis),
                    items:
                        tempItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(overflow: TextOverflow.ellipsis),
                        ),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select Customer",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        //   _currentSelectedStateValue = value;
                      });
                    },
                    //isExpanded: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Common text box widget

  Widget textBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
            label == "Customer" || label == "Vehicle"
                ? GestureDetector(
                    onTap: () {
                      if(label=="Customer"){
                         showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return NewCustomerScreen();
                          },
                          isScrollControlled: true,
                          useSafeArea: true);

                      }else if(label=="Vehicle"){
                          _show(context);

                      }
                     
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryColors,
                        ),
                        Text(
                          "Add new",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              readOnly:
                  label == 'Date' || label == "Vehicle" || label == "Customer"
                      ? true
                      : false,
              onTap: () {
                if (label == 'Date') {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return datePicker("");
                    },
                  );
                } else if (label == "Customer") {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return customerBottomSheet();
                      },
                      backgroundColor: Colors.transparent);
                }else if(label=='Vehicle'){
                  showModalBottomSheet(context: context, builder: (context) {
                    return vehicleBottomSheet();
                  },);
                }
              },
              keyboardType:
                  label == 'Phone Number' ? TextInputType.number : null,
              maxLength: label == 'Phone Number'
                  ? 16
                  : label == 'Password'
                      ? 12
                      : 50,
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  suffixIcon: label == "Customer" || label == "Vehicle"
                      ? const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.greyText,
                        )
                      : const SizedBox(),
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

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6A7187)),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width / 2.4,
            child: TextField(
              controller: controller,
              maxLength: 50,
              readOnly: true,
              onTap: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return timerPicker("time_from");
                  },
                );
              },
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
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

  Widget timerPicker(String timeType) {
    return CupertinoPopupSurface(
      child: Container(
        color: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: const Duration(),
                onTimerDurationChanged: (Duration changeTimer) {
                  setState(() {
                    // initialTimer = changeTimer;

                    print(
                        '${changeTimer.inHours} hrs ${changeTimer.inMinutes % 60} mins ${changeTimer.inSeconds % 60} secs');
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget datePicker(String dateType) {
    return CupertinoPopupSurface(
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: CupertinoColors.white,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                      child: const Text("Done"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (DateTime newdate) {},
                  use24hFormat: true,
                  maximumDate: new DateTime(2030, 12, 30),
                  minimumYear: 2009,
                  maximumYear: 2030,
                  minuteInterval: 1,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ],
          )),
    );
  }

  Widget inspectionPhotoWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 4.8,
      height: 75,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE8EAED)),
          borderRadius: BorderRadius.circular(8)),
      child: const Icon(
        Icons.add,
        color: AppColors.primaryColors,
      ),
    );
  }

  Widget taxDetailsWidget(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "\$ $price",
            style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget customerBottomSheet() {
    return BlocProvider(
      create: (context) =>
          CustomerBloc(apiRepository: ApiRepository())..add(customerDetails()),
      child: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerReady) {
            customerModel = state.data;
          }
          // TODO: implement listener
        },
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Customers",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    state is CustomerLoading
                        ? Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 1.8 - 78,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        customerController.text =
                                            "${customerModel?.data.data[index].firstName ?? ""} ${customerModel?.data.data[index].lastName ?? ""}";
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            "${customerModel?.data.data[index].firstName ?? ""} ${customerModel?.data.data[index].lastName ?? ""}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: customerModel?.data.data.length ?? 0,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget vehicleBottomSheet() {
    return BlocProvider(
      create: (context) => VechileBloc()..add(GetAllVechile()),
      child: BlocListener<VechileBloc, VechileState>(
        listener: (context, state) {

          if(state is VechileDetailsSuccessStates){
            vehicleModel=state.vechile;
          }

          // TODO: implement listener
        },
        child: BlocBuilder<VechileBloc, VechileState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width / 1.8,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicles",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    state is VechileDetailsSuccessStates
                       
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 1.8 - 78,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        vehicleController.text =
                                            "${vehicleModel?.data.data[index].vehicleYear ?? ""} ${vehicleModel?.data.data[index].vehicleModel ?? ""}";
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            "${vehicleModel?.data.data[index].vehicleYear ?? ""} ${vehicleModel?.data.data[index].vehicleModel ?? ""}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: vehicleModel?.data.data.length??0,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                              ),
                            ),
                          ) : const Center(
                            child: CupertinoActivityIndicator(),
                          )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }






  // Add new vehicle bottom sheet 


  _show(BuildContext ctx) {
    showModalBottomSheet(
        isScrollControlled: true,
        useSafeArea: true,
        elevation: 10,
        context: ctx,
        builder: (ctx) => BlocProvider(
              create: (context) => VechileBloc()..add(DropDownVechile()),
              child: BlocListener<VechileBloc, VechileState>(
                listener: (context, state) {
                  if (state is AddVechileDetailsLoadingState) {
                    CommonWidgets().showDialog(
                        context, 'Something went wrong please try again later');
                    Navigator.pop(context);
                    // vechileList.addAll(state.vechile.data.data ?? []);
                  } else if (state is VechileDetailsErrorState) {
                   CommonWidgets().showDialog(context, state.message);
                  } else if (state is AddVechileDetailsSuccessState) {
                    // roles.clear();
                    // roles.addAll(state.roles);
                  } else if (state is DropdownVechileDetailsSuccessState) {
                    dropdownData.addAll(state.dropdownData.data.data);
                  } else if (state is AddVechileDetailsErrorState) {
                    if (BlocProvider.of<VechileBloc>(context)
                        .errorRes
                        .isNotEmpty) {
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vehicle_year")) {
                        print("vehicle_year");

                        yearErrorStaus = true;

                        print(yearErrorStaus);
                        yearErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vehicle_year'][0];
                        print(yearErrorMsg);
                        // }
                      } else {
                        yearErrorStaus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vehicle_model")) {
                        modelErrorStatus = true;
                        modelErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vehicle_model'][0];
                      } else {
                        modelErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vehicle_type")) {
                        print("vehicle_type");

                        typeErrorStatus = true;

                        print(typeErrorStatus);
                        typeErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vehicle_type'][0];
                        print(typeErrorMsg);
                        // }
                      } else {
                        typeErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vehicle_make")) {
                        print("vehicle_make");

                        makeErrorStatus = true;

                        print(makeErrorStatus);
                        makeErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vehicle_make'][0];
                        print(makeErrorMsg);
                        // }
                      } else {
                        makeErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vehicle_color")) {
                        print("vehicle_color");

                        colorErrorStatus = true;

                        print(colorErrorStatus);
                        colorErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vehicle_color'][0];
                        print(colorErrorMsg);
                        // }
                      } else {
                        colorErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vehicle_color")) {
                        print("vehicle_color");

                        colorErrorStatus = true;

                        print(colorErrorStatus);
                        colorErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vehicle_color'][0];
                        print(colorErrorMsg);
                        // }
                      } else {
                        colorErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vin")) {
                        print("vin");

                        vinErrorStatus = true;

                        print(vinErrorStatus);
                        vinErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vin'][0];
                        print(vinErrorMsg);
                        // }
                      } else {
                        vinErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("vin")) {
                        print("vin");

                        vinErrorStatus = true;

                        print(vinErrorStatus);
                        vinErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['vin'][0];
                        print(vinErrorMsg);
                        // }
                      } else {
                        vinErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("sub_model")) {
                        print("sub_model");

                        subModelErrorStatus = true;

                        print(subModelErrorStatus);
                        submodelErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['sub_model'][0];
                        print(submodelErrorMsg);
                        // }
                      } else {
                        subModelErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("licence_plate")) {
                        print("licence_plate");

                        licErrorStatus = true;

                        print(subModelErrorStatus);
                        licErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['licence_plate'][0];
                        print(licErrorMsg);
                        // }
                      } else {
                        licErrorStatus = false;
                      }
                      if (BlocProvider.of<VechileBloc>(context)
                          .errorRes
                          .containsKey("engine_size")) {
                        print("engine_size");

                        engineErrorStatus = true;

                        print(engineErrorStatus);
                        engineErrorMsg = BlocProvider.of<VechileBloc>(context)
                            .errorRes['engine_size'][0];
                        print(engineErrorMsg);
                        // }
                      } else {
                        engineErrorStatus = false;
                      }
                    }
                  }
                },
                child: BlocBuilder<VechileBloc, VechileState>(
                    builder: (context, state) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateUpdate) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: const SizedBox(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        foregroundColor: AppColors.primaryColors,
                        actions: [
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.close))
                        ],
                        title: const Text("New Vehicle",style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor
                        ),),
                        centerTitle: true,
                      ),

                    
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                                 
                              //     const Text(
                              //       "New Vehicle",
                              //       style: TextStyle(
                              //           fontSize: 16,
                              //           color: AppColors.primaryBlackColors,
                              //           fontWeight: FontWeight.w500),
                              //     ),
                              //     InkWell(
                              //       onTap: () {
                              //         Navigator.pop(context);
                              //       },
                              //       child: SvgPicture.asset(
                              //         "assets/images/close.svg",
                              //         color: AppColors.primaryColors,
                              //         height: 16,
                              //         width: 16,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Expanded(
                                  child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8,top:24),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   "Basic Details",
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       fontWeight: FontWeight.w600,
                                        //       color:
                                        //           AppColors.primaryTitleColor),
                                        // ),
                                        // textBox("Enter name...", nameController,
                                        //     "Owner", nameErrorStatus),
                                        textBox("Enter year...", yearController,
                                            "Year", yearErrorStaus),
                                        Visibility(
                                            visible: yearErrorStaus,
                                            child: Text(
                                              yearErrorMsg,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                  0xffD80027,
                                                ),
                                              ),
                                            )),

                                        textBox("Enter make...", makeController,
                                            "Make", makeErrorStatus),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        textBox(
                                            "Enter model...",
                                            modelController,
                                            "Model",
                                            modelErrorStatus),
                                        Visibility(
                                            visible: modelErrorStatus,
                                            child: Text(
                                              modelErrorMsg,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color(
                                                  0xffD80027,
                                                ),
                                              ),
                                            )),
                                        textBox(
                                            "Enter number...",
                                            vinController,
                                            "VIN",
                                            vinErrorStatus),
                                        ExpansionTile(
                                          title: Text(
                                            'Additional fields',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                                title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                textBox(
                                                    "Enter Sub-model...",
                                                    subModelController,
                                                    "Sub-Model",
                                                    subModelErrorStatus),
                                                textBox(
                                                    "Enter engin...",
                                                    engineController,
                                                    "Engine",
                                                    engineErrorStatus),
                                                // textBox(
                                                //     "Enter make...",
                                                //     makeController,
                                                //     "Make",
                                                //     makeErrorStatus),
                                                textBox(
                                                    "Enter color...",
                                                    colorController,
                                                    "Color",
                                                    colorErrorStatus),
                                                textBox(
                                                    "Enter number...",
                                                    licController,
                                                    "LIC",
                                                    licErrorStatus),
                                                Text(
                                                  "Type",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.greyText),
                                                ),
                                                vechileTypeDropDown(),
                                                // SizedBox(
                                                //   height: 50,
                                                //   child: CupertinoTextField(
                                                //     controller: typeController,
                                                //     readOnly: false,
                                                //     placeholder: 'Select',
                                                //     style: TextStyle(
                                                //         fontSize: 15,
                                                //         fontWeight:
                                                //             FontWeight.w400,
                                                //         color: AppColors
                                                //             .primaryBlackColors),
                                                //     suffix: Icon(Icons
                                                //         .arrow_drop_down_outlined),
                                                //     decoration: BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.all(
                                                //               Radius.circular(
                                                //                   10)),
                                                //       border: Border.all(
                                                //           color: AppColors
                                                //               .greyText),
                                                //     ),
                                                //   ),
                                                // ),
                                              ],
                                            )),
                                          ],
                                        ),
                                        Center(
                                          child: Row(
                                            children: <Widget>[
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Checkbox(
                                                checkColor: Colors.white,
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  stateUpdate(() {
                                                    isChecked = value!;
                                                  });
                                                },
                                              ),
                                              Text(
                                                "Create new estimate using this vehicle",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              validateVechile(
                                                yearController.text,
                                                modelController.text,
                                                typeController.text,
                                                context,
                                                stateUpdate,
                                              );
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             VechileInformation()));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: AppColors.primaryColors,
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0),
                                              ),
                                            ),
                                            child: state
                                                    is AddVechileDetailsLoadingState
                                                ? const CupertinoActivityIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    'Confirm',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ))
                            ],
                          ),
                        ));
                  });
                }),
              ),
            ));
  }

  validateVechile(
    String VechileYear,
    String VechileModel,
    String VechileType,
    BuildContext context,
    StateSetter stateUpdate,
  ) {
    if (VechileYear.isEmpty) {
      stateUpdate(() {
        yearErrorMsg = 'Year cant be empty.';
        yearErrorStaus = true;
      });
    } else {
      yearErrorStaus = false;
    }
    if (VechileModel.isEmpty) {
      stateUpdate(() {
        modelErrorMsg = 'Type cant be empty.';
        modelErrorStatus = true;
      });
    } else {
      if (VechileYear.length < 4) {
        setState(() {
          modelErrorStatus = true;
          modelErrorMsg = 'The vehicle model must be at least 2 characters.';
        });
      } else {
        setState(() {
          modelErrorStatus = false;
        });
      }
    }
    if (VechileType.isEmpty) {
      stateUpdate(() {
        typeErrorMsg = 'Type cant be empty.';
        typeErrorStatus = true;
      });
    } else {
      typeErrorStatus = false;
    }
    if (!yearErrorStaus && !modelErrorStatus) {
      context.read<VechileBloc>().add(AddVechile(
            context: context,
            email: nameController.text,
            year: yearController.text,
            model: modelController.text,
            submodel: subModelController.text,
            engine: engineController.text,
            color: colorController.text,
            vinNumber: vinController.text,
            licNumber: licController.text,
            make: makeController.text,
            type: _currentSelectedTypeValue.toString(),
          ));
    }
  }


   Widget vechileTypeDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              // margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
              // padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffC1C4CD)),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<DropdownDatum>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    menuMaxHeight: 380,
                    value: _currentSelectedTypeValue,
                    style: const TextStyle(color: Color(0xff6A7187)),
                    items: dropdownData.map<DropdownMenuItem<DropdownDatum>>(
                        (DropdownDatum value) {
                      return DropdownMenuItem<DropdownDatum>(
                        alignment: AlignmentDirectional.centerStart,
                        value: value,
                        child: Text(value.vehicleTypeName),
                      );
                    }).toList(),
                    hint: const Text(
                      "Select",
                      style: TextStyle(
                          color: Color(0xff6A7187),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (DropdownDatum? value) {
                      setState(() {
                        _currentSelectedTypeValue = value;
                      });
                    },
                    //isExpanded: true,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  
}
