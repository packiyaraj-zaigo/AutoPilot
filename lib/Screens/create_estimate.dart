import 'dart:async';

import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Models/vechile_dropdown_model.dart';
import 'package:auto_pilot/Models/vechile_model.dart' as vm;
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/Screens/estimate_details_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';

import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/customer_bloc/customer_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_bloc.dart';
import 'package:auto_pilot/bloc/vechile/vechile_event.dart';
import 'package:auto_pilot/bloc/vechile/vechile_state.dart';
import 'package:auto_pilot/utils/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

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
  vm.VechileResponse? vehicleModel;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  XFile? selectedImage;

  final vehicleScrollController = ScrollController();
  final customerScrollController = ScrollController();
  final _debouncer = Debouncer();
  List<vm.Datum> vehicleDataList = [];
  List<Datum> customerDataList = [];

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

  int selectedIndex = 0;

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
                    "Enter Note", notesController, "Note", noteErrorStatus),
              ),
              subTitleWidget("Appointment"),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    halfTextBox("Select Time", startTimeController,
                        "Start time", startTimeErrorStatus),
                    halfTextBox("Select Time", endTimeController, "End time",
                        endTimeErrorStatus)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox(
                    "Select Date", dateController, "Date", dateErrorStatus),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: textBox("Enter Appointment Note", appointmentController,
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
                    GestureDetector(
                        onTap: () {
                          showActionSheet(context);
                        },
                        child: inspectionPhotoWidget()),
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return EstimateDetailsScreen();
                      },
                    ));
                  },
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
                      if (label == "Customer") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return NewCustomerScreen();
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
                      } else if (label == "Vehicle") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CreateVehicleScreen();
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
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
                } else if (label == 'Vehicle') {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return vehicleBottomSheet();
                    },
                  );
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
      create: (context) => CustomerBloc()..add(customerDetails(query: "")),
      child: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerReady) {
            //    customerModel = state.customer;
            customerDataList.addAll(state.customer.data);
            print(customerDataList.length.toString() + "cus length");
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
                    state is CustomerLoading &&
                            !BlocProvider.of<CustomerBloc>(context)
                                .isPaginationLoading
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 1.8 - 78,
                              child: customerDataList.isEmpty
                                  ? const Center(
                                      child: Text(
                                        "No Customer Found!",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  customerController.text =
                                                      "${customerDataList[index].firstName} ${customerDataList[index].lastName}";
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      "${customerDataList[index].firstName} ${customerDataList[index].lastName}",
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            BlocProvider.of<CustomerBloc>(
                                                                context)
                                                            .currentPage <=
                                                        BlocProvider.of<
                                                                    CustomerBloc>(
                                                                context)
                                                            .totalPages &&
                                                    index ==
                                                        customerDataList
                                                                .length -
                                                            1
                                                ? const Column(
                                                    children: [
                                                      SizedBox(height: 24),
                                                      Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                                      SizedBox(height: 24),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ],
                                        );
                                      },
                                      controller: customerScrollController
                                        ..addListener(() {
                                          if (customerScrollController.offset ==
                                                  customerScrollController
                                                      .position
                                                      .maxScrollExtent &&
                                              !BlocProvider.of<CustomerBloc>(
                                                      context)
                                                  .isPaginationLoading &&
                                              BlocProvider.of<CustomerBloc>(
                                                          context)
                                                      .currentPage <=
                                                  BlocProvider.of<CustomerBloc>(
                                                          context)
                                                      .totalPages) {
                                            _debouncer.run(() {
                                              BlocProvider.of<CustomerBloc>(
                                                      context)
                                                  .isPaginationLoading = true;
                                              BlocProvider.of<CustomerBloc>(
                                                      context)
                                                  .add(customerDetails(
                                                      query: ''));
                                            });
                                          }
                                        }),
                                      itemCount: customerDataList.length,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
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
          if (state is VechileDetailsSuccessStates) {
            vehicleDataList.addAll(state.vechile.data.data);
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
                    state is VechileDetailsPageNationLoading
                        ? const Center(
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
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            vehicleController.text =
                                                "${vehicleDataList[index].vehicleYear} ${vehicleDataList[index].vehicleModel}";
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Text(
                                                "${vehicleDataList[index].vehicleYear} ${vehicleDataList[index].vehicleModel}",
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                        ),
                                        BlocProvider.of<VechileBloc>(context)
                                                        .currentPage <=
                                                    BlocProvider.of<
                                                                VechileBloc>(
                                                            context)
                                                        .totalPages &&
                                                index ==
                                                    vehicleDataList.length - 1
                                            ? const Column(
                                                children: [
                                                  SizedBox(height: 24),
                                                  Center(
                                                    child:
                                                        CupertinoActivityIndicator(),
                                                  ),
                                                  SizedBox(height: 24),
                                                ],
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: vehicleDataList.length,
                                shrinkWrap: true,
                                controller: vehicleScrollController
                                  ..addListener(() {
                                    if (vehicleScrollController.offset ==
                                            vehicleScrollController
                                                .position.maxScrollExtent &&
                                        !BlocProvider.of<VechileBloc>(context)
                                            .isPagenationLoading &&
                                        BlocProvider.of<VechileBloc>(context)
                                                .currentPage <=
                                            BlocProvider.of<VechileBloc>(
                                                    context)
                                                .totalPages) {
                                      _debouncer.run(() {
                                        BlocProvider.of<VechileBloc>(context)
                                            .isPagenationLoading = true;
                                        BlocProvider.of<VechileBloc>(context)
                                            .add(GetAllVechile());
                                      });
                                    }
                                  }),
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

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                selectImages("camera");
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/camera.svg",
                    width: 24,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text('Camera'),
                  ),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                selectImages("lib");
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/folder.svg",
                    width: 24,
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text('Choose from Library'),
                  ),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            // isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Cancel'),
          )),
    );
  }

  void selectImages(source) async {
    if (source == "camera") {
      selectedImage = await imagePicker.pickImage(source: ImageSource.camera);
      // if (imageFileList != null) {
      setState(() {
        imageFileList?.add(selectedImage!);
      });

      // }
    } else {
      final List<XFile> imageFile = await imagePicker.pickMultiImage();
      //  if (imageFile.isNotEmpty) {
      setState(() {
        imageFileList?.addAll(imageFile);
      });

      //  }
    }
    setState(() {});
  }
}
