import 'dart:developer';
import 'dart:io';

import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Models/estimate_appointment_model.dart' as ea;
import 'package:auto_pilot/Models/estimate_note_model.dart' as en;
import 'package:auto_pilot/Models/order_image_model.dart' as oi;
import 'package:auto_pilot/Models/canned_service_model.dart' as cs;
import 'package:auto_pilot/Screens/add_service_screen.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/customer_select_screen.dart';
import 'package:auto_pilot/Screens/edit_order_service_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:auto_pilot/Screens/select_service_screen.dart';
import 'package:auto_pilot/Screens/vehicle_select_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EstimatePartialScreen extends StatefulWidget {
  const EstimatePartialScreen(
      {super.key,
      required this.estimateDetails,
      this.navigation,
      this.controllerIndex});
  final CreateEstimateModel estimateDetails;
  final String? navigation;
  final int? controllerIndex;

  @override
  State<EstimatePartialScreen> createState() => _EstimatePartialScreenState();
}

class _EstimatePartialScreenState extends State<EstimatePartialScreen>
    with TickerProviderStateMixin {
  bool isEstimateNotes = false;
  bool isAppointment = false;
  bool isInspectionPhotos = false;
  bool isService = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Text Editing Controllers
  final vehicleController = TextEditingController();
  final customerController = TextEditingController();
  final estimateNoteController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final appointmentController = TextEditingController();
  final dateController = TextEditingController();
  final serviceController = TextEditingController();

  //Text Field Error Status Variables
  bool vehicleErrorStatus = false;
  bool customerErrorStatus = false;
  bool estimateNoteErrorStatus = false;
  bool startTimeErrorStatus = false;
  bool endTimeErrorStatus = false;
  bool appointmentErrorStatus = false;
  bool dateErrorStatus = false;
  bool serviceErrorStatus = false;

  //Text Field Error Message Variables
  String vehicleErrorMsg = "";
  String customerErrorMsg = '';
  String estimateNoteErrorMsg = '';

  //Estimate note model variables

  List<en.Datum> estimateNoteList = [];

  //Appoitment Details model variables
  ea.AppointmentDetailsModel? appointmentDetailsModel;

  //Image variables
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  File? selectedImage;
  List<String> networkImageList = ["", "", "", ""];
  List<oi.Datum> newOrderImageData = [];

  //Tax and total Amount variables
  double materialAmount = 0;
  double laborAmount = 0;
  double taxAmount = 0;
  double discountAmount = 0;
  double totalAmount = 0;
  double balanceDueAmount = 0;

  //Payment popup variables
  final paymentAmountController = TextEditingController();
  final cashDateController = TextEditingController();
  final cashNoteController = TextEditingController();
  final creditNameOnCardController = TextEditingController();
  final creditCardNumberController = TextEditingController();
  final creditRefNumberController = TextEditingController();
  bool paymentAmountErrorStatus = false;
  bool cashDateErrorStatus = false;
  bool cashNoteErrorStatus = false;
  bool creditNameErrorStatus = false;
  bool creditCardNumberErrorStatus = false;
  bool creditRefNumberErrorStatus = false;
  late TabController tabController;
  bool isDrop = false;

  bool isServiceCreate = false;
  bool isPaidFull = false;
  List<String> authorizedValues = [
    "Not Yet Authorized",
    "Authorized",
    "Declined"
  ];
  int authorizedIndex = 0;

  //Esitmate Edit variables
  bool isCustomerEdit = false;
  bool isVehicleEdit = false;
  bool isEstimateNoteEdit = false;
  bool isAppointmentEdit = false;

  String estimateNoteEditId = "";
  String estimateAppointmentEditId = "";

  @override
  void initState() {
    calculateAmount();
    print(materialAmount.toString() + "amount");
    tabController = TabController(length: 3, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(GetEstimateNoteEvent(
            orderId: widget.estimateDetails.data.id.toString()))
        ..add(GetEstimateAppointmentEvent(
            orderId: widget.estimateDetails.data.id.toString()))
        ..add(GetAllOrderImageEvent(
            orderId: widget.estimateDetails.data.id.toString())),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          log(state.toString());
          // if (state is AddEstimateNoteState) {
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //     builder: (context) {
          //       return BottomBarScreen();
          //     },
          //   ), (route) => false);
          // } else if (state is CreateAppointmentEstimateState) {
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //     builder: (context) {
          //       return BottomBarScreen();
          //     },
          //   ), (route) => false);
          // }
          if (state is GetEstimateNoteState) {
            estimateNoteList.addAll(state.estimateNoteModel.data);
          }
          if (state is GetEstimateAppointmentState) {
            appointmentDetailsModel = state.estimateAppointmentModel;
          } else if (state is EstimateUploadImageState) {
            print(state.imagePath);
            print("emitted ui");

            networkImageList[state.index] = state.imagePath;

            print(networkImageList.length);
            print(networkImageList);
          }
          //  else if (state is EstimateCreateOrderImageState) {
          //   print("image ui state emitted");
          //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //     builder: (context) {
          //       return BottomBarScreen();
          //     },
          //   ), (route) => false);
          // }
          if (state is GetOrderImageState) {
            newOrderImageData.addAll(state.orderImageModel.data);
          }
          if (state is EditEstimateNoteErrorState) {
            CommonWidgets().showDialog(context, state.errorMessage);
          }
          if (state is DeleteEstimateNoteState) {
            print("this statee");
            context.read<EstimateBloc>().add(GetEstimateNoteEvent(
                orderId: widget.estimateDetails.data.id.toString()));
          }
          if (state is SendEstimateToCustomerState) {
            showModalBottomSheet(
              isScrollControlled: true,
              useSafeArea: true,
              isDismissible: false,
              context: context,
              builder: (context) {
                return estimateSuccessSheet();
              },
            );
          }

          // TODO: implement listener
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            print(state);
            return WillPopScope(
              onWillPop: () async {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                  builder: (context) {
                    return BottomBarScreen(
                      currentIndex: 3,
                    );
                  },
                ), (route) => false);
                return false;
              },
              child: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        // if (widget.navigation == "bottom_nav") {
                        //   Navigator.pop(context);
                        // } else {
                        //   Navigator.pop(context);
                        //   Navigator.pop(context);
                        // }

                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                          builder: (context) {
                            return BottomBarScreen(
                              currentIndex: 3,
                              tabControllerIndex: widget.controllerIndex,
                            );
                          },
                        ), (route) => false);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColors,
                      )),
                  foregroundColor: AppColors.primaryColors,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          bool validateDurations(String firstDurationStr,
                              String secondDurationStr) {
                            // Parse the durations into hours and minutes
                            List<String> firstParts =
                                firstDurationStr.split(':');
                            List<String> secondParts =
                                secondDurationStr.split(':');
                            int firstHours = int.parse(firstParts[0]);
                            int firstMinutes = int.parse(firstParts[1]);
                            int secondHours = int.parse(secondParts[0]);
                            int secondMinutes = int.parse(secondParts[1]);

                            // Convert the durations to total minutes for comparison
                            int firstTotalMinutes =
                                firstHours * 60 + firstMinutes;
                            int secondTotalMinutes =
                                secondHours * 60 + secondMinutes;

                            // Compare the durations and return the result
                            return firstTotalMinutes < secondTotalMinutes;
                          }

                          bool isError = false;

                          if (startTimeController.text.isNotEmpty &&
                              endTimeController.text.isNotEmpty &&
                              dateController.text.isNotEmpty &&
                              appointmentController.text.isNotEmpty) {
                            final validate = validateDurations(
                                startTimeController.text.trim(),
                                endTimeController.text.trim());

                            if (!validate) {
                              CommonWidgets().showDialog(context,
                                  'Start time should be less than end time');
                              return;
                            }

                            if (isAppointmentEdit == false) {
                              context.read<EstimateBloc>().add(
                                    CreateAppointmentEstimateEvent(
                                      startTime: dateController.text +
                                          " " +
                                          startTimeController.text,
                                      endTime: dateController.text +
                                          " " +
                                          endTimeController.text,
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      appointmentNote:
                                          appointmentController.text,
                                      customerId: widget
                                          .estimateDetails.data.customerId
                                          .toString(),
                                      vehicleId: widget
                                              .estimateDetails.data.vehicle?.id
                                              .toString() ??
                                          "0",
                                    ),
                                  );

                              context.read<EstimateBloc>().add(
                                  EditEstimateEvent(
                                      id: widget
                                              .estimateDetails.data.vehicle?.id
                                              .toString() ??
                                          "0",
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      which: "vehicle",
                                      customerId: widget
                                              .estimateDetails.data.customer?.id
                                              .toString() ??
                                          "",
                                      dropScedule: dateController.text));
                            } else {
                              print("editteeddd");
                              // if (int.parse(startTimeController.text
                              //         .substring(0, 2)) <
                              //     int.parse(
                              //         endTimeController.text.substring(0, 2))) {
                              //   print(
                              //       startTimeController.text + "starttt timee");

                              //   print(endTimeController.text + "endddd timee");

                              //   CommonWidgets().showDialog(context,
                              //       'Appointment start time should be less than appointment end time');
                              //   isError = true;
                              // } else {
                              context.read<EstimateBloc>().add(
                                  EditAppointmentEstimateEvent(
                                      startTime: dateController.text +
                                          " " +
                                          startTimeController.text,
                                      endTime: dateController.text +
                                          " " +
                                          endTimeController.text,
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      appointmentNote:
                                          appointmentController.text,
                                      customerId: widget
                                          .estimateDetails.data.customerId
                                          .toString(),
                                      vehicleId: widget
                                              .estimateDetails.data.vehicle?.id
                                              .toString() ??
                                          "",
                                      id: estimateAppointmentEditId));

                              context.read<EstimateBloc>().add(
                                  EditEstimateEvent(
                                      id: widget
                                              .estimateDetails.data.vehicle?.id
                                              .toString() ??
                                          "0",
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      which: "vehicle",
                                      customerId: widget
                                              .estimateDetails.data.customer?.id
                                              .toString() ??
                                          "",
                                      dropScedule: dateController.text));
                            }
                          }

                          final validate = validateDurations(
                              startTimeController.text.trim(),
                              endTimeController.text.trim());

                          if (estimateNoteController.text.isNotEmpty &&
                              validate) {
                            if (!isEstimateNoteEdit) {
                              context.read<EstimateBloc>().add(
                                  AddEstimateNoteEvent(
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      comment: estimateNoteController.text));
                            } else {
                              context.read<EstimateBloc>().add(
                                  EditEstimateNoteEvent(
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      comment: estimateNoteController.text,
                                      id: estimateNoteEditId));
                            }
                          }
                          //  }
                          if (networkImageList.isNotEmpty) {
                            context.read<EstimateBloc>().add(
                                  CreateOrderImageEvent(
                                    imageUrlList:
                                        networkImageList.where((element) {
                                      return element != "";
                                    }).toList(),
                                    inspectionId: "",
                                    orderId: widget.estimateDetails.data.id
                                        .toString(),
                                  ),
                                );
                          }

                          if (!isError) {
                            if (isCustomerEdit) {
                              CommonWidgets().showDialog(
                                  context, "Please select a customer");
                            } else {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return BottomBarScreen(
                                    currentIndex: 3,
                                    tabControllerIndex: widget.controllerIndex,
                                  );
                                },
                              ), (route) => false);
                            }
                          }
                        },
                        child: const Row(
                          children: [
                            Text(
                              "Save & Close",
                              style: TextStyle(
                                  color: AppColors.primaryColors,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.close,
                              color: AppColors.primaryColors,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimate Details',
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w600),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Follow the step to create an estimate.',
                            style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 14,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Estimate #${widget.estimateDetails.data.orderNumber}',
                                style: const TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return authorizeEstimateSheet();
                                        },
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent);
                                  },
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: AppColors.primaryColors,
                                  ))
                            ],
                          ),
                        ),
                        widget.estimateDetails.data.customer != null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    subTitleWidget("Customer Details"),
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return editCustomerBottomSheet();
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.more_horiz,
                                        color: AppColors.primaryColors,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        widget.estimateDetails.data.customer != null &&
                                isCustomerEdit == false
                            ? customerDetailsWidget()
                            : textBox("Select Existing", customerController,
                                "Customer", customerErrorStatus),
                        widget.estimateDetails.data.vehicle != null &&
                                isVehicleEdit == false
                            ? vehicleDetailsWidget()
                            : Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: textBox(
                                    "Select Existing",
                                    vehicleController,
                                    "Vehicle",
                                    vehicleErrorStatus),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: subTitleWidget("Estimate Notes"),
                        ),
                        estimateNoteList.isNotEmpty &&
                                isEstimateNoteEdit == false
                            ? estimateNoteWidget()
                            : Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: textBox(
                                    "Enter Note",
                                    estimateNoteController,
                                    "Note",
                                    estimateNoteErrorStatus),
                              ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 20.0),
                        //   child: Row(
                        //     children: [
                        //       subTitleWidget("Estimate Notes"),
                        //       Padding(
                        //         padding: const EdgeInsets.only(left: 6.0),
                        //         child: GestureDetector(
                        //             onTap: () {
                        //               showEstimateNotes("estimate");
                        //             },
                        //             child: Icon(
                        //               isEstimateNotes
                        //                   ? Icons.keyboard_arrow_down_rounded
                        //                   : Icons.keyboard_arrow_up_rounded,
                        //               size: 32,
                        //             )),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // isEstimateNotes ? estimateNoteWidget() : const SizedBox(),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 20.0),
                        //   child: Row(
                        //     children: [
                        //       subTitleWidget("Appointment"),
                        //       Padding(
                        //         padding: const EdgeInsets.only(left: 6.0),
                        //         child: GestureDetector(
                        //             onTap: () {
                        //               showEstimateNotes("appointment");
                        //             },
                        //             child: Icon(
                        //               isAppointment
                        //                   ? Icons.keyboard_arrow_down_rounded
                        //                   : Icons.keyboard_arrow_up_rounded,
                        //               size: 32,
                        //             )),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // isAppointment
                        //     ? appointmentDetailsWidget()
                        //     : const SizedBox(),

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                subTitleWidget("Appointment"),
                                appointmentDetailsModel != null &&
                                        appointmentDetailsModel!
                                            .data.data.isNotEmpty
                                    ? GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return editAppointmentSheet(
                                                  appointmentDetailsModel!
                                                      .data.data[0]);
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.more_horiz,
                                          color: AppColors.primaryColors,
                                        ),
                                      )
                                    : const SizedBox()
                              ]),
                        ),
                        appointmentDetailsModel?.data != null &&
                                appointmentDetailsModel!.data.data.isNotEmpty &&
                                isAppointmentEdit == false
                            ? appointmentDetailsWidget()
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        halfTextBox(
                                            "Select Time",
                                            startTimeController,
                                            "Start Time",
                                            startTimeErrorStatus,
                                            "start_time"),
                                        halfTextBox(
                                            "Select Time",
                                            endTimeController,
                                            "End Time",
                                            endTimeErrorStatus,
                                            "end_time")
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: textBox(
                                        "Select Date",
                                        dateController,
                                        "Date",
                                        dateErrorStatus),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: textBox(
                                        "Enter Appointment Note",
                                        appointmentController,
                                        "Appointment Note",
                                        appointmentErrorStatus),
                                  ),
                                ],
                              ),

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: subTitleWidget("Inspection Photos"),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            "Upload Photo",
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
                            // children: [
                            //   GestureDetector(
                            //       onTap: () {
                            //         showActionSheet(context);
                            //       },
                            //       child: inspectionPhotoWidget(
                            //           networkImageList.length >= 1
                            //               ? networkImageList[0]
                            //               : "")),
                            //   GestureDetector(
                            //     onTap: () {
                            //       showActionSheet(context);
                            //     },
                            //     child: inspectionPhotoWidget(
                            //         networkImageList.length >= 2
                            //             ? networkImageList[1]
                            //             : ""),
                            //   ),
                            //   GestureDetector(
                            //       onTap: () {
                            //         showActionSheet(context);
                            //       },
                            //       child: inspectionPhotoWidget(
                            //           networkImageList.length >= 3
                            //               ? networkImageList[2]
                            //               : "")),
                            //   GestureDetector(
                            //       onTap: () {
                            //         showActionSheet(context);
                            //       },
                            //       child: inspectionPhotoWidget(
                            //           networkImageList.length >= 4
                            //               ? networkImageList[3]
                            //               : ""))
                            // ],

                            children: List.generate(4, (index) {
                              return GestureDetector(
                                  onTap: () {
                                    if (newOrderImageData.length > index ||
                                        networkImageList[index]
                                            .contains("http")) {
                                    } else {
                                      showActionSheet(context, index);
                                    }
                                  },
                                  child: newOrderImageData.length > index
                                      ? inspectionPhotoWidget(
                                          newOrderImageData[index].fileName,
                                          newOrderImageData[index]
                                              .id
                                              .toString(),
                                          index)
                                      : inspectionPhotoWidget(
                                          networkImageList[index], "", index));
                            }),
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.only(top: 16.0),
                        //   child: Row(
                        //     children: [
                        //       subTitleWidget("Services"),
                        //       Padding(
                        //         padding: const EdgeInsets.only(left: 6.0),
                        //         child: GestureDetector(
                        //             onTap: () {
                        //               showEstimateNotes("service");
                        //             },
                        //             child: Icon(
                        //               isService
                        //                   ? Icons.keyboard_arrow_down_rounded
                        //                   : Icons.keyboard_arrow_up_rounded,
                        //               size: 32,
                        //             )),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // isService ? serviceDetailsWidget() : const SizedBox(),

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: subTitleWidget("Services"),
                        ),

                        //Service dropdown

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: textBox("Select Existing", serviceController,
                              "Service", serviceErrorStatus),
                        ),
                        widget.estimateDetails.data.orderService != null &&
                                widget.estimateDetails.data.orderService!
                                    .isNotEmpty
                            ? serviceDetailsWidget()
                            : const SizedBox(),

                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: taxDetailsWidget(
                              "Material", "\$ ${materialAmount}"),
                        ),
                        taxDetailsWidget("Labor", "\$ ${laborAmount}"),
                        taxDetailsWidget("Tax", "\$ ${taxAmount}"),
                        taxDetailsWidget("Discount", "\$ ${discountAmount}"),
                        taxDetailsWidget("Total", "\$ ${totalAmount}"),
                        taxDetailsWidget("Balance due", "\$ ${totalAmount}"),
                        Padding(
                          padding: const EdgeInsets.only(top: 45.0),
                          child: GestureDetector(
                            onTap: () {
                              context.read<EstimateBloc>().add(
                                  SendEstimateToCustomerEvent(
                                      customerId: widget
                                              .estimateDetails.data.customer?.id
                                              .toString() ??
                                          "",
                                      orderId: widget.estimateDetails.data.id
                                          .toString(),
                                      subject: widget
                                          .estimateDetails.data.orderNumber
                                          .toString()));
                            },
                            child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade50,
                              ),
                              child: const Text(
                                "Send to customer",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColors,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) {
                              //     return AlertDialog(
                              //       contentPadding: EdgeInsets.all(20),
                              //       insetPadding: EdgeInsets.all(20),
                              //       content: paymentPopUp(),
                              //     );
                              //   },
                              // );
                              if (widget.estimateDetails.data.orderService !=
                                      null &&
                                  widget.estimateDetails.data.orderService!
                                      .isNotEmpty) {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return paymentPopUp();
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.primaryColors),
                              child: const Text(
                                "Collect Payment",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget subTitleWidget(String subTitle) {
    return Text(
      subTitle,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTitleColor),
    );
  }

  Widget customerDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/images/estimate_customer_icon.svg"),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Customer",
                  style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "${widget.estimateDetails.data.customer?.firstName ?? ""} ${widget.estimateDetails.data.customer?.lastName ?? ""}",
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.estimateDetails.data.customer?.email ?? "",
                  style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.w400),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.estimateDetails.data.customer?.email != null) {
                      String? encodeQueryParameters(
                          Map<String, String> params) {
                        return params.entries
                            .map((MapEntry<String, String> e) =>
                                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                            .join('&');
                      }

                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: widget.estimateDetails.data.customer?.email ?? "",
                        query: encodeQueryParameters(<String, String>{
                          'subject': ' ',
                        }),
                      );

                      launchUrl(emailLaunchUri);
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/images/mail_icons.svg",
                    color: AppColors.primaryColors,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '(${widget.estimateDetails.data.customer?.phone?.substring(0, 3)}) ${widget.estimateDetails.data.customer?.phone?.substring(3, 6)} - ${widget.estimateDetails.data.customer?.phone?.substring(6)}',
                  style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.w400),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (widget.estimateDetails.data.customer?.phone !=
                                null &&
                            widget.estimateDetails.data.customer?.phone != "") {
                          final Uri smsLaunchUri = Uri(
                            scheme: 'sms',
                            path: widget.estimateDetails.data.customer?.phone,
                          );
                          launchUrl(smsLaunchUri);
                        }
                      },
                      child: SvgPicture.asset(
                        "assets/images/sms_icons.svg",
                        color: AppColors.primaryColors,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 34.0),
                      child: GestureDetector(
                        onTap: () {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'tel',
                            path: widget.estimateDetails.data.customer?.phone ??
                                "",
                          );

                          launchUrl(emailLaunchUri);
                        },
                        child: SvgPicture.asset(
                          "assets/images/phone_icon.svg",
                          color: AppColors.primaryColors,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget vehicleDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/images/estimate_vehicle_icon.svg"),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Text(
                  "Vehicle",
                  style: TextStyle(
                      color: Color(0xff6A7187),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "${widget.estimateDetails.data.vehicle?.vehicleModel ?? ''} ${widget.estimateDetails.data.vehicle?.vehicleYear ?? ''}",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryTitleColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.estimateDetails.data.vehicle?.kilometers ?? '0'} km",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget estimateNoteWidget() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 0.6,
                      spreadRadius: 0.7,
                      offset: Offset(3, 2))
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${estimateNoteList[index].createdAt.month}/${estimateNoteList[index].createdAt.day}/${estimateNoteList[index].createdAt.year} -  ${DateFormat('hh:mm a').format(estimateNoteList[index].createdAt)}",
                        style: const TextStyle(
                            color: Color(0xff6A7187),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return editEstimateNoteSheet(
                                  estimateNoteList[index].id.toString(),
                                  estimateNoteList[index].comments.toString());
                            },
                          );
                        },
                        child: const Icon(
                          Icons.more_horiz,
                          color: AppColors.primaryColors,
                        ),
                      )
                    ],
                  ),
                  Text(
                    "${estimateNoteList[index].createdBy.firstName} ${estimateNoteList[index].createdBy.lastName}",
                    style: const TextStyle(
                        color: Color(0xff6A7187),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    estimateNoteList[index].comments,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.3),
                  )
                ],
              ),
            ),
          ),
        );
      },
      itemCount: estimateNoteList.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  void showEstimateNotes(String whichValue) {
    setState(() {
      if (whichValue == 'estimate') {
        if (isEstimateNotes) {
          isEstimateNotes = false;
        } else {
          isEstimateNotes = true;
        }
      } else if (whichValue == 'appointment') {
        if (isAppointment) {
          isAppointment = false;
        } else {
          isAppointment = true;
        }
      } else if (whichValue == "inspection") {
        if (isInspectionPhotos) {
          isInspectionPhotos = false;
        } else {
          isInspectionPhotos = true;
        }
      } else if (whichValue == 'service') {
        if (isService) {
          isService = false;
        } else {
          isService = true;
        }
      }
    });
  }

  Widget appointmentDetailsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appointmentLabelwithValue(
                  "Start Date",
                  appointmentDetailsModel?.data.data != null &&
                          appointmentDetailsModel?.data.data != []
                      ? "${appointmentDetailsModel?.data.data[0].startOn.month}/${appointmentDetailsModel?.data.data[0].startOn.day}/${appointmentDetailsModel?.data.data[0].startOn.year}"
                      : ""),
              appointmentLabelwithValue(
                  "Completion Date",
                  appointmentDetailsModel?.data.data != null &&
                          appointmentDetailsModel?.data.data != []
                      ? "${appointmentDetailsModel?.data.data[0].endOn.month}/${appointmentDetailsModel?.data.data[0].endOn.day}/${appointmentDetailsModel?.data.data[0].endOn.year}"
                      : "")
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appointmentLabelwithValue(
                    "Start Time",
                    appointmentDetailsModel?.data.data != null &&
                            appointmentDetailsModel?.data.data != []
                        ? DateFormat('hh:mm a').format(
                            appointmentDetailsModel!.data.data[0].startOn)
                        : ""),
                appointmentLabelwithValue(
                    "End Time",
                    appointmentDetailsModel?.data.data != null &&
                            appointmentDetailsModel?.data.data != []
                        ? DateFormat('hh:mm a')
                            .format(appointmentDetailsModel!.data.data[0].endOn)
                        : "")
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: appointmentLabelwithValue(
                "Date",
                appointmentDetailsModel?.data.data != null &&
                        appointmentDetailsModel?.data.data != []
                    ? "${appointmentDetailsModel?.data.data[0].startOn.month}/${appointmentDetailsModel?.data.data[0].startOn.day}/${appointmentDetailsModel?.data.data[0].startOn.year}"
                    : ""),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: appointmentLabelwithValue(
                "Appointment Note",
                appointmentDetailsModel?.data.data != null &&
                        appointmentDetailsModel?.data.data != []
                    ? appointmentDetailsModel?.data.data[0].notes ?? ""
                    : ""),
          ),
        ],
      ),
    );
  }

  Widget appointmentLabelwithValue(String label, String value) {
    return SizedBox(
      width: label == "Appointment Note"
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width / 2.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff6A7187)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTitleColor),
            ),
          )
        ],
      ),
    );
  }

  Widget inspectionSinglePhotoWidget() {
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

  Widget inspectionWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          inspectionSinglePhotoWidget(),
          inspectionSinglePhotoWidget(),
          inspectionSinglePhotoWidget(),
          inspectionSinglePhotoWidget(),
        ],
      ),
    );
  }

  Widget serviceDetailsWidget() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return serviceTileWidget(index);
      },
      shrinkWrap: true,
      itemCount: widget.estimateDetails.data.orderService?.length ?? 0,
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget serviceTileWidget(int serviceIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 0.6,
                  spreadRadius: 0.7,
                  offset: Offset(3, 2))
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.estimateDetails.data.orderService?[serviceIndex]
                            .serviceName ??
                        "",
                    style: const TextStyle(
                        color: AppColors.primaryTitleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return editServiceSheet(
                              widget.estimateDetails.data
                                      .orderService?[serviceIndex].id
                                      .toString() ??
                                  "",
                              serviceIndex);
                        },
                      );
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: AppColors.primaryColors,
                    ),
                  )
                ],
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget
                                    .estimateDetails
                                    .data
                                    .orderService?[serviceIndex]
                                    .orderServiceItems?[index]
                                    .itemName ??
                                "",
                            style: const TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        Text(
                            "\$ ${widget.estimateDetails.data.orderService?[serviceIndex].orderServiceItems?[index].subTotal ?? ""}",
                            style: const TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget
                        .estimateDetails
                        .data
                        .orderService?[serviceIndex]
                        .orderServiceItems
                        ?.length ??
                    0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget taxDetailsWidget(String title, String price) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
            " $price",
            style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  //common text field

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
            label == "Customer" || label == "Vehicle" || label == "Service"
                ? GestureDetector(
                    onTap: () {
                      if (label == "Customer") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return NewCustomerScreen(
                                navigation: "partial_estimate",
                              );
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
                      } else if (label == "Vehicle") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return CreateVehicleScreen(navigation: "partial_estimate",);
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
                      } else if (label == "Service") {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return AddServiceScreen(
                                navigation: "partial_estimate",
                              );
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
              textCapitalization: TextCapitalization.sentences,
              inputFormatters:
                  label == "Card Number" ? [CardNumberInputFormatter()] : [],
              readOnly: label == 'Date' ||
                      label == "Vehicle" ||
                      label == "Customer" ||
                      label == "Service"
                  ? true
                  : false,
              onTap: () async {
                if (label == 'Payment Date') {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return datePicker("payment");
                    },
                  );
                } else if (label == "Customer") {
                  // showModalBottomSheet(
                  //     context: context,
                  //     builder: (context) {
                  //       return customerBottomSheet();
                  //     },
                  //     backgroundColor: Colors.transparent);

                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return SelectCustomerScreen(
                        navigation: "partial",
                        orderId: widget.estimateDetails.data.id.toString(),
                      );
                    },
                  ));
                } else if (label == 'Vehicle') {
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   useSafeArea: true,
                  //   builder: (context) {
                  //     return SelectVehiclesScreen();
                  //   },
                  // );
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return SelectVehiclesScreen(
                        navigation: "partial",
                        orderId: widget.estimateDetails.data.id.toString(),
                        customerId:
                            widget.estimateDetails.data.customerId.toString(),
                      );
                    },
                  ));
                } else if (label == "Service") {
                  if (estimateNoteController.text.isEmpty &&
                      startTimeController.text.isEmpty &&
                      endTimeController.text.isEmpty &&
                      dateController.text.isEmpty &&
                      appointmentController.text.isEmpty) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SelectServiceScreen(
                          orderId: widget.estimateDetails.data.id.toString(),
                        );
                      },
                    ));
                  } else {
                    CommonWidgets().showDialog(context,
                        "Please save the unsaved changes before selecting the service");
                  }
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
                  suffixIcon: label == "Customer" ||
                          label == "Vehicle" ||
                          label == "Service"
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryColors,
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

  Widget datePicker(String dateType) {
    String selectedDate = "";
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
                        if (dateType == "payment") {
                          if (selectedDate != "") {
                            cashDateController.text = selectedDate;
                          } else {
                            cashDateController.text =
                                "${DateTime.now().year}-${DateTime.now().month > 10 ? DateTime.now().month : "0${DateTime.now().month}"}-${DateTime.now().day > 10 ? DateTime.now().day : "0${DateTime.now().day}"}";
                          }
                        } else {
                          if (selectedDate != "") {
                            dateController.text = selectedDate;
                          } else {
                            dateController.text =
                                "${DateTime.now().year}-${DateTime.now().month > 10 ? DateTime.now().month : "0${DateTime.now().month}"}-${DateTime.now().day > 10 ? DateTime.now().day : "0${DateTime.now().day}"}";
                          }
                        }

                        Navigator.pop(context);
                      })
                ],
              ),
              //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: isAppointmentEdit
                      ? appointmentDetailsModel?.data.data[0].startOn
                      : DateTime.now(),
                  onDateTimeChanged: (DateTime newdate) {
                    setState(() {
                      selectedDate =
                          "${newdate.year}-${newdate.month > 10 ? newdate.month : "0${newdate.month}"}-${newdate.day > 10 ? newdate.day : "0${newdate.day}"}";
                    });
                  },
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

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, String whichTime) {
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
                    return timerPicker(whichTime);
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
    String selectedTime = "00:00";
    if (timeType == "start_time" && isAppointmentEdit) {
      selectedTime = DateFormat('hh:mm')
          .format(appointmentDetailsModel!.data.data[0].startOn)
          .toString();
    } else if (timeType == "end_time" && isAppointmentEdit) {
      selectedTime = DateFormat('hh:mm')
          .format(appointmentDetailsModel!.data.data[0].endOn)
          .toString();
    }
    if (timeType == "start_time" && endTimeController.text.trim().isNotEmpty) {
      selectedTime = startTimeController.text;
    } else if (timeType == "end_time" &&
        endTimeController.text.trim().isNotEmpty) {
      selectedTime = endTimeController.text;
    } else if (timeType == "end_time" &&
        endTimeController.text.trim().isEmpty) {
      selectedTime = startTimeController.text;
    }

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
                      if (timeType == "start_time") {
                        startTimeController.text = selectedTime;
                      } else {
                        endTimeController.text = selectedTime;
                      }
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                minuteInterval: 1,
                secondInterval: 1,
                initialTimerDuration: isAppointmentEdit &&
                        timeType == "start_time"
                    ? Duration(
                        hours: appointmentDetailsModel?.data.data[0].startOn.hour ??
                            0,
                        minutes: appointmentDetailsModel
                                ?.data.data[0].startOn.minute ??
                            0)
                    : isAppointmentEdit && timeType == "end_time"
                        ? Duration(
                            hours: appointmentDetailsModel
                                    ?.data.data[0].endOn.hour ??
                                0,
                            minutes: appointmentDetailsModel
                                    ?.data.data[0].endOn.minute ??
                                0)
                        : timeType == 'end_time' &&
                                    startTimeController.text.isNotEmpty ||
                                timeType == 'start_time' &&
                                    startTimeController.text.isNotEmpty
                            ? Duration(
                                hours: int.parse(startTimeController.text
                                    .trim()
                                    .substring(0, 2)),
                                minutes: int.parse(startTimeController.text.trim().substring(3)))
                            : Duration(),
                onTimerDurationChanged: (Duration changeTimer) {
                  setState(() {
                    // initialTimer = changeTimer;

                    selectedTime =
                        ' ${changeTimer.inHours >= 10 ? changeTimer.inHours : "0${changeTimer.inHours}"}:${changeTimer.inMinutes % 60 >= 10 ? changeTimer.inMinutes % 60 : "0${changeTimer.inMinutes % 60}"}';

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

  void showActionSheet(BuildContext context, int index) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() {
                  selectedImage = null;
                });
                Navigator.pop(context);
                selectImages("camera").then((value) {
                  if (selectedImage != null) {
                    print("this works");
                    print(selectedImage);
                    _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                        EstimateUploadImageEvent(
                            imagePath: selectedImage!,
                            orderId: widget.estimateDetails.data.id.toString(),
                            index: index));
                  }
                });
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
                setState(() {
                  selectedImage = null;
                });
                Navigator.pop(context);
                selectImages("lib").then((value) {
                  if (selectedImage != null) {
                    print(selectedImage);
                    _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                        EstimateUploadImageEvent(
                            imagePath: selectedImage!,
                            orderId: widget.estimateDetails.data.id.toString(),
                            index: index));
                  }
                });
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

  Widget inspectionPhotoWidget(String networkUrl, String imageId, int index) {
    return Container(
      width: MediaQuery.of(context).size.width / 4.8,
      height: 75,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE8EAED)),
          borderRadius: BorderRadius.circular(8)),
      child: networkUrl != ""
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.loose,
                alignment: AlignmentDirectional.topEnd,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4.8,
                    height: 75,
                    child: Image.network(
                      networkUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: GestureDetector(
                        onTap: () {
                          showPopup(context, "", imageId, index);
                        },
                        child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ))),
                  )
                ],
              ),
            )
          : const Icon(
              Icons.add,
              color: AppColors.primaryColors,
            ),
    );
  }

  Future selectImages(source) async {
    if (source == "camera") {
      final tempImg = await imagePicker.pickImage(source: ImageSource.camera);
      // if (imageFileList != null) {
      if (tempImg != null) {
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          tempImg.path,
          '${tempImg.path}.jpg',
          quality: 80,
        );
        setState(() {
          if (compressedImage != null) {
            selectedImage = File(compressedImage.path);
          }
        });
      } else {
        return;
      }

      // }
    } else {
      final tempImg = await imagePicker.pickImage(source: ImageSource.gallery);
      // if (imageFileList != null) {
      if (tempImg != null) {
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          tempImg.path,
          '${tempImg.path}.jpg',
          quality: 80,
        );
        setState(() {
          if (compressedImage != null) {
            selectedImage = File(compressedImage.path);
          }
        });
      } else {
        return;
      }

      //  }
    }
    //  setState(() {});
  }

  Future showPopup(BuildContext context, message, String imageId, int index) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is DeleteImageState) {
              Navigator.pop(context);
              print("deleted");
              setState(() {
                newOrderImageData.removeAt(index);
              });
            }
            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Do You Really Want To Delete?"),
                content: const Text(
                    "Deleting this photo will permanently delete it from the database"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        if (imageId != "") {
                          context
                              .read<EstimateBloc>()
                              .add(DeleteOrderImageEvent(imageId: imageId));
                        } else {
                          print("heree");
                          print(index);
                          setState(() {
                            networkImageList[index] = "";
                          });

                          Navigator.pop(context);
                        }
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

  calculateAmount() {
    widget.estimateDetails.data.orderService?.forEach((element) {
      element.orderServiceItems!.forEach((element2) {
        if (element2.itemType.toLowerCase() == "material") {
          setState(() {
            materialAmount = materialAmount + double.parse(element2.subTotal);
          });
        }
        if (element2.itemType.toLowerCase() == "labor") {
          setState(() {
            laborAmount = laborAmount + double.parse(element2.subTotal);
          });
        }

        setState(() {
          taxAmount = taxAmount + double.parse(element2.tax);
          discountAmount = discountAmount + double.parse(element2.discount);
        });
      });
    });

    setState(() {
      totalAmount = (materialAmount + laborAmount + taxAmount) - discountAmount;
    });
  }

  paymentPopUp() {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository()),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state is CollectPaymentEstimateState) {
            isPaidFull = true;
            paymentAmountController.clear();
            cashDateController.clear();
            cashNoteController.clear();
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.2,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Payment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 27.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Balance Due",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTitleColor,
                                  ),
                                ),
                                Text(
                                  "\$ ${totalAmount}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryTitleColor,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: textBox(
                                  "Enter Amount",
                                  paymentAmountController,
                                  "Amount To Pay",
                                  paymentAmountErrorStatus),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TabBar(
                                controller: tabController,
                                enableFeedback: false,
                                labelPadding: EdgeInsets.all(0),
                                indicatorColor: AppColors.primaryColors,
                                unselectedLabelColor: const Color(0xFF9A9A9A),
                                labelColor: AppColors.primaryColors,
                                tabs: const [
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Cash',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Credit',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        'Cheque',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LimitedBox(
                              maxHeight:
                                  MediaQuery.of(context).size.height / 2.8,
                              maxWidth: MediaQuery.of(context).size.width,
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    cashTabWidget(),
                                    creditTabWidget(),
                                    cashTabWidget()
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 24.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.read<EstimateBloc>().add(
                                        CollectPaymentEstimateEvent(
                                            amount:
                                                paymentAmountController.text,
                                            customerId: widget.estimateDetails
                                                    .data.customer?.id
                                                    .toString() ??
                                                "",
                                            orderId: widget
                                                .estimateDetails.data.id
                                                .toString(),
                                            paymentMode:
                                                tabController.index == 0
                                                    ? "Cash"
                                                    : tabController.index == 1
                                                        ? "Credit Card"
                                                        : "Check",
                                            date: cashDateController.text,
                                            note: cashNoteController.text),
                                      );
                                },
                                child: Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.primaryColors),
                                  child: state
                                          is CollectPaymentEstimateLoadingState
                                      ? const Center(
                                          child: CupertinoActivityIndicator(),
                                        )
                                      : const Text(
                                          "Authorize",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
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

  Widget cashTabWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            textBox("Select Date", cashDateController, "Payment Date",
                cashDateErrorStatus),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: textBox("Enter Note", cashNoteController, "Note",
                  cashNoteErrorStatus),
            ),
          ],
        ),
      ),
    );
  }

  Widget creditTabWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            textBox("Enter Name on Card", creditNameOnCardController,
                "Name On Card", creditNameErrorStatus),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: textBox(
                  "Enter Last 4 Digits of Card",
                  creditCardNumberController,
                  "Card Number",
                  creditCardNumberErrorStatus),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: textBox("Enter Transaction Id", creditRefNumberController,
                  "Transaction Id", creditRefNumberErrorStatus),
            )
          ],
        ),
      ),
    );
  }

  Widget editCustomerBottomSheet() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select an option",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isCustomerEdit = true;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/edit_pen_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Edit Customer",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: GestureDetector(
                  onTap: () {
                    if (widget.estimateDetails.data.vehicle != null) {
                      setState(() {
                        isVehicleEdit = true;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                        color: const Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/edit_pen_icon.svg",
                          color: widget.estimateDetails.data.vehicle != null
                              ? AppColors.primaryColors
                              : Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Edit Vehicle",
                            style: TextStyle(
                                color:
                                    widget.estimateDetails.data.vehicle != null
                                        ? AppColors.primaryColors
                                        : Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editEstimateNoteSheet(String id, String oldNote) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select an option",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isEstimateNoteEdit = true;
                    estimateNoteEditId = id;
                    estimateNoteController.text = oldNote;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/edit_pen_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  print("ontapped");
                  deleteEstimatNotePopup(context, "", id);

                  // Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/delete_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Remove",
                          style: TextStyle(
                              color: Color(0xffFF5C5C),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editAppointmentSheet(ea.Datum appointmentDetails) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select an option",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAppointmentEdit = true;
                    startTimeController.text = DateFormat('hh:mm')
                        .format(appointmentDetails.startOn)
                        .toString();

                    endTimeController.text = DateFormat('hh:mm')
                        .format(appointmentDetails.endOn)
                        .toString();

                    appointmentController.text = appointmentDetails.notes;
                    dateController.text =
                        "${appointmentDetails.startOn.year}-${appointmentDetails.startOn.month}-${appointmentDetails.startOn.day}";

                    estimateAppointmentEditId =
                        appointmentDetails.id.toString();

                    print(estimateAppointmentEditId + "appointment idd");

                    // isEstimateNoteEdit = true;
                    // estimateNoteEditId = id;
                    // estimateNoteController.text = oldNote;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/edit_pen_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  print("ontapped");
                  deleteAppointmentPopup(
                      context, "", appointmentDetails.id.toString());

                  // Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/delete_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Remove",
                          style: TextStyle(
                              color: Color(0xffFF5C5C),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget editServiceSheet(String id, int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select an option",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  // setState(() {
                  //   // isEstimateNoteEdit = true;
                  //   // estimateNoteEditId = id;
                  //   // estimateNoteController.text = oldNote;
                  // });
                  List<CannedServiceAddModel> materialAddModel = [];
                  List<CannedServiceAddModel> partAddModel = [];
                  List<CannedServiceAddModel> laborAddModel = [];
                  List<CannedServiceAddModel> feeAddModel = [];
                  List<CannedServiceAddModel> subContractAddModel = [];

                  // print(widget.estimateDetails.data.orderService![index]
                  //         .orderServiceItems![2]
                  //         .toJson()
                  //         .toString() +
                  //     "lissttt");

                  if (widget.estimateDetails.data.orderService![index]
                      .orderServiceItems!.isNotEmpty) {
                    widget.estimateDetails.data.orderService![index]
                        .orderServiceItems!
                        .forEach((e) {
                      print("maapppp");

                      if (e.itemType == "Material") {
                        print("map in if");
                        materialAddModel.add(CannedServiceAddModel(
                            cannedServiceId: e.orderServiceId,
                            itemName: e.itemName,
                            unitPrice: e.unitPrice,
                            discount: e.discount,
                            subTotal: e.subTotal,
                            note: e.itemServiceNote ?? "",
                            part: e.partName ?? "",
                            discountType: e.discountType,
                            id: e.id.toString(),
                            itemType: e.itemType,
                            position: e.position,
                            quanityHours: e.quanityHours,
                            tax: e.tax,
                            vendorId: e.vendorId));
                      } else if (e.itemType.toLowerCase() == "part") {
                        partAddModel.add(CannedServiceAddModel(
                            cannedServiceId: e.orderServiceId,
                            itemName: e.itemName,
                            unitPrice: e.unitPrice,
                            discount: e.discount,
                            subTotal: e.subTotal,
                            note: e.itemServiceNote ?? '',
                            part: e.partName ?? "",
                            discountType: e.discountType,
                            id: e.id.toString(),
                            itemType: e.itemType,
                            position: e.position,
                            quanityHours: e.quanityHours,
                            tax: e.tax,
                            vendorId: e.vendorId));
                      } else if (e.itemType.toLowerCase() == "labor") {
                        laborAddModel.add(CannedServiceAddModel(
                            cannedServiceId: e.orderServiceId,
                            itemName: e.itemName,
                            unitPrice: e.unitPrice,
                            discount: e.discount,
                            subTotal: e.subTotal,
                            note: e.itemServiceNote ?? "",
                            part: e.partName ?? "",
                            discountType: e.discountType,
                            id: e.id.toString(),
                            itemType: e.itemType,
                            position: e.position,
                            quanityHours: e.quanityHours,
                            tax: e.tax,
                            vendorId: e.vendorId));
                      } else if (e.itemType.toLowerCase() == "fee") {
                        feeAddModel.add(CannedServiceAddModel(
                            cannedServiceId: e.orderServiceId,
                            itemName: e.itemName,
                            unitPrice: e.unitPrice,
                            discount: e.discount,
                            subTotal: e.subTotal,
                            note: e.itemServiceNote ?? "",
                            part: e.partName ?? "",
                            discountType: e.discountType,
                            id: e.id.toString(),
                            itemType: e.itemType,
                            position: e.position,
                            quanityHours: e.quanityHours,
                            tax: e.tax,
                            vendorId: e.vendorId));
                      } else if (e.itemType.toLowerCase() == "subcontract") {
                        subContractAddModel.add(CannedServiceAddModel(
                            cannedServiceId: e.orderServiceId,
                            itemName: e.itemName,
                            unitPrice: e.unitPrice,
                            discount: e.discount,
                            subTotal: e.subTotal,
                            note: e.itemServiceNote ?? "",
                            part: e.partName ?? "",
                            discountType: e.discountType,
                            id: e.id.toString(),
                            itemType: e.itemType,
                            position: e.position,
                            quanityHours: e.quanityHours,
                            tax: e.tax,
                            vendorId: e.vendorId));
                      }
                    });
                  }

                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return EditOrderServiceScreen(
                        material: materialAddModel,
                        fee: feeAddModel,
                        labor: laborAddModel,
                        part: partAddModel,
                        technicianId: widget.estimateDetails.data
                                    .orderService![index].technicianId !=
                                0
                            ? widget.estimateDetails.data.orderService![index]
                                .technicianId
                                .toString()
                            : "",
                        orderId: widget.estimateDetails.data.id.toString(),
                        subContract: subContractAddModel,
                        service: cs.Datum(
                            id: widget
                                .estimateDetails.data.orderService![index].id,
                            clientId: widget.estimateDetails.data.clientId,
                            serviceName: widget.estimateDetails.data
                                .orderService![index].serviceName,
                            servicePrice: widget.estimateDetails.data
                                .orderService![index].servicePrice,
                            discount: widget.estimateDetails.data
                                .orderService![index].discount,
                            serviceEpa: widget.estimateDetails.data
                                .orderService![index].serviceEpa,
                            shopSupplies: widget.estimateDetails.data
                                .orderService![index].shopSupplies,
                            tax: widget
                                .estimateDetails.data.orderService![index].tax,
                            subTotal: widget.estimateDetails.data
                                .orderService![index].subTotal,
                            maintenancePeriod: widget.estimateDetails.data
                                .orderService![index].maintenancePeriod,
                            maintenancePeriodType: widget.estimateDetails.data
                                .orderService![index].maintenancePeriodType,
                            communicationChannel: widget.estimateDetails.data
                                .orderService![index].communicationChannel,
                            createdAt: widget.estimateDetails.data
                                .orderService![index].createdAt,
                            updatedAt: widget.estimateDetails.data
                                .orderService![index].updatedAt),
                      );
                    },
                  ));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/edit_pen_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  deleteOrderServicePopup(context, "", id, index);
                  // print("ontapped");
                  // deleteEstimatNotePopup(context, "", id);

                  // Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/images/delete_icon.svg"),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Remove",
                          style: TextStyle(
                              color: Color(0xffFF5C5C),
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                      color: const Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future deleteEstimatNotePopup(BuildContext ctx, message, String id) {
    return showCupertinoDialog(
      context: ctx,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is DeleteEstimateNoteState) {
              log(state.toString() + "popppupp");
              context.read<EstimateBloc>().add(GetEstimateNoteEvent(
                  orderId: widget.estimateDetails.data.id.toString()));

              Navigator.pop(context);
            }
            if (state is GetEstimateNoteState) {
              estimateNoteList.clear();
              estimateNoteList.addAll(state.estimateNoteModel.data);
              setState(() {});
            }
            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Estimate Note?"),
                content:
                    const Text("Do you want to remove this estimate note?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context
                            .read<EstimateBloc>()
                            .add(DeleteEstimateNoteEvent(id: id));
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

  Future deleteAppointmentPopup(BuildContext ctx, message, String id) {
    return showCupertinoDialog(
      context: ctx,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is DeleteAppointmentEstimateState) {
              log(state.toString() + "popppupp");
              context.read<EstimateBloc>().add(GetEstimateAppointmentEvent(
                  orderId: widget.estimateDetails.data.id.toString()));

              Navigator.pop(context);
            }
            if (state is GetEstimateAppointmentState) {
              appointmentDetailsModel = state.estimateAppointmentModel;
              setState(() {});
            }
            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Appointment?"),
                content: const Text("Do you want to remove this appointment?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context.read<EstimateBloc>().add(
                            DeleteAppointmentEstimateEvent(appointmetId: id));
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

  Future deleteOrderServicePopup(
      BuildContext ctx, message, String id, int index) {
    return showCupertinoDialog(
      context: ctx,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is DeleteOrderServiceState) {
              log(state.toString() + "popppupp");
              widget.estimateDetails.data.orderService!.removeAt(index);
              setState(() {});

              Navigator.pop(context);
            }

            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Order Service?"),
                content: const Text(
                    "Do you want to remove this Order service from this estimate?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context
                            .read<EstimateBloc>()
                            .add(DeleteOrderServiceEvent(id: id));
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

  Widget estimateSuccessSheet() {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return BottomBarScreen(
                  currentIndex: 3,
                );
              },
            ), (route) => false);
          },
          child: Container(
            height: 56,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryColors),
            child: const Text(
              "Continue",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/success_icon.svg"),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  "Estimate Sent\nSuccessfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  "Fusce lacinia sed metus eu fringilla. Phasellus\nlobortis maximus posuere nunc placerat.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.greyText,
                      height: 1.5),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  authorizeEstimateSheet() {
    return StatefulBuilder(builder: (context, newSetState) {
      return Container(
        height: MediaQuery.of(context).size.height / 2.3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select Option",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTitleColor)),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            newSetState(() {
                              isDrop = true;
                            });
                          },
                          child: isDrop
                              ? authorizeDrop(newSetState)
                              : Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Color(0xffF6F6F6),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(),
                                        Text(
                                          authorizedValues[authorizedIndex],
                                          style: const TextStyle(
                                              color: AppColors.primaryColors,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.primaryColors,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              deleteEstimatePopup(context, "");

                              //  Navigator.pop(context);

                              // Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                      "assets/images/delete_icon.svg"),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(
                                          color: Color(0xffFF5C5C),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              decoration: BoxDecoration(
                                  color: const Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: AppColors.primaryTitleColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget authorizeDrop(StateSetter newSetState) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              newSetState(() {
                isDrop = false;
              });
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Color(0xffF6F6F6),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      authorizedValues[0],
                      style: const TextStyle(
                          color: AppColors.primaryColors,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primaryColors,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Color(0xffF0F0F0),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      newSetState(() {
                        final temp = authorizedValues[0];
                        authorizedValues[0] = authorizedValues[1];
                        authorizedValues[1] = temp;

                        isDrop = false;
                      });
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          authorizedValues[1],
                          style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      newSetState(() {
                        final temp = authorizedValues[0];
                        authorizedValues[0] = authorizedValues[2];
                        authorizedValues[2] = temp;

                        isDrop = false;
                      });
                    },
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          authorizedValues[2],
                          style: const TextStyle(
                              color: AppColors.primaryColors,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future deleteEstimatePopup(BuildContext context, message) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is DeleteEstimateState) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (context) {
                  return BottomBarScreen(
                    currentIndex: 3,
                  );
                },
              ), (route) => false);
            }
            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Remove Estimate?"),
                content:
                    const Text("Do you really want to remove this estimate?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context.read<EstimateBloc>().add(DeleteEstimateEvent(
                            id: widget.estimateDetails.data.id.toString()));
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
}
