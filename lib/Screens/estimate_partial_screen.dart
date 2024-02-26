import 'dart:developer';
import 'dart:io';

import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/create_estimate_model.dart';
import 'package:auto_pilot/Models/estimate_appointment_model.dart' as ea;
import 'package:auto_pilot/Models/estimate_note_model.dart' as en;
import 'package:auto_pilot/Models/order_image_model.dart' as oi;
import 'package:auto_pilot/Models/canned_service_model.dart' as cs;
import 'package:auto_pilot/Models/customer_model.dart' as cm;
import 'package:auto_pilot/Screens/add_order_service_scree.dart';
import 'package:auto_pilot/Screens/add_service_screen.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/customer_information_screen.dart';
import 'package:auto_pilot/Screens/customer_select_screen.dart';
import 'package:auto_pilot/Screens/edit_order_service_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:auto_pilot/Screens/payment_list_screen.dart';
import 'package:auto_pilot/Screens/select_service_screen.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/Screens/vehicle_select_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/customer_bloc/customer_bloc.dart' as cb;
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Models/order_image_model.dart';

class EstimatePartialScreen extends StatefulWidget {
  const EstimatePartialScreen(
      {super.key,
      required this.estimateDetails,
      this.navigation,
      this.controllerIndex,
      this.customerId});
  final CreateEstimateModel estimateDetails;
  final String? navigation;
  final int? controllerIndex;
  final int? customerId;

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
  CarouselController buttonCarouselController = CarouselController();

  //Text Editing Controllers
  final vehicleController = TextEditingController();
  final customerController = TextEditingController();
  final estimateNoteController = TextEditingController();
  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final appointmentController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final serviceController = TextEditingController();

  //Text Field Error Status Variables
  bool vehicleErrorStatus = false;
  bool customerErrorStatus = false;
  bool estimateNoteErrorStatus = false;
  bool startTimeErrorStatus = false;
  bool endTimeErrorStatus = false;
  bool appointmentErrorStatus = false;
  bool startDateErrorStatus = false;
  bool endDateErrorStatus = false;
  bool serviceErrorStatus = false;

  //Text Field Error Message Variables
  String vehicleErrorMsg = "";
  String customerErrorMsg = '';
  String estimateNoteErrorMsg = '';
  String authStatus = "";
  String startTimeErrorMsg = "";
  String endTimeErrorMsg = "";
  String appointmentErrorMsg = "";
  String startDateErrorMsg = "";
  String endDateErrorMsg = "";

  String startTimeToServer = "";
  String endTimeToServer = "";
  String startDateToServer = "";
  String endDateToServer = "";
  String cashDateToServer = "";

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
  double feeAmount = 0;
  double subContractAmount = 0;
  double partAmount = 0;
  double costAmount = 0;
  double profitAmount = 0;

  //Payment popup variables
  final paymentAmountController = TextEditingController();
  final cashDateController = TextEditingController();
  final cashNoteController = TextEditingController();
  final creditNameOnCardController = TextEditingController();
  final creditCardNumberController = TextEditingController();
  final creditRefNumberController = TextEditingController();
  final creditDateController = TextEditingController();
  bool paymentAmountErrorStatus = false;
  bool cashDateErrorStatus = false;
  bool cashNoteErrorStatus = false;
  bool creditNameErrorStatus = false;
  bool creditCardNumberErrorStatus = false;
  bool creditRefNumberErrorStatus = false;
  bool creditDateErrorStatus = false;
  late TabController tabController;
  bool isDrop = false;

  String paymentAmountErrorMessage = "";
  String cashDateErrorMessage = "";
  String creditCardNumberErrorMessage = "";
  String creditCardTransIdErrorMessage = '';

  bool isServiceCreate = false;
  bool isPaidFull = false;
  List<String> authorizedValues = [
    "Not Yet Authorized",
    "Authorize",
    "Decline"
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
    tabController = TabController(length: 4, vsync: this);

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
            estimateNoteList.clear();
            estimateNoteList.addAll(state.estimateNoteModel.data);
            isEstimateNoteEdit = false;
          }
          if (state is GetEstimateAppointmentState) {
            isAppointmentEdit = false;
            appointmentDetailsModel = state.estimateAppointmentModel;
          } else if (state is EstimateUploadImageState) {
            print(state.imagePath);
            print("emitted ui");

            networkImageList[state.index] = state.imagePath;

            print(networkImageList.length);
            print(networkImageList);
          } else if (state is AddEstimateNoteErrorState) {
            CommonWidgets().showDialog(context, state.errorMessage);
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
            networkImageList.clear();
            networkImageList.addAll(["", "", "", ""]);
            newOrderImageData.clear();
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
          if (state is GetSingleCustomerDetailsState) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return NewCustomerScreen(
                  customerEdit: state.customerData,
                  navigation: "partial_estimate_customer_edit",
                  orderId: widget.estimateDetails.data.id.toString(),
                );
              },
            ));
          }
          if (state is GetSingleVehicleDetailsState) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CreateVehicleScreen(
                  editVehicle: state.vehicleDate.vehicle,
                  orderId: widget.estimateDetails.data.id.toString(),
                  navigation: "estimate_partial_vehicle_edit",
                );
              },
            ));
          }

          // TODO: implement listener
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            print(state);
            return WillPopScope(
              onWillPop: () async {
                if (widget.navigation == "customer_navigation") {
                  final estimate = widget.estimateDetails.data;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => CustomerInformationScreen(
                        id: estimate.customerId.toString(),
                      ),
                    ),
                  );
                } else if (widget.navigation == 'search') {
                  Navigator.pop(context);
                } else if (widget.navigation == 'workflow') {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return BottomBarScreen(
                        currentIndex: 1,
                        tabControllerIndex: 0,
                      );
                    },
                  ), (route) => false);
                } else {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                    builder: (context) {
                      return BottomBarScreen(
                        currentIndex: 3,
                      );
                    },
                  ), (route) => false);
                }
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

                        if (widget.navigation == "customer_navigation") {
                          final estimate = widget.estimateDetails.data;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => CustomerInformationScreen(
                                id: widget.estimateDetails.data.customerId
                                    .toString(),
                              ),
                            ),
                          );
                        } else if (widget.navigation == "vehicle_info") {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return VechileInformation(
                                vehicleId: widget
                                        .estimateDetails.data.vehicle?.id
                                        .toString() ??
                                    "",
                              );
                            },
                          ));
                        } else if (widget.navigation == 'search') {
                          Navigator.pop(context);
                        } else if (widget.navigation == "appointment_details") {
                          Navigator.pop(context);
                        } else if (widget.navigation == 'workflow') {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return BottomBarScreen(
                                currentIndex: 1,
                                tabControllerIndex: 0,
                              );
                            },
                          ), (route) => false);
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
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (appointmentValidation() &&
                              noteValidation() &&
                              startTimeController.text.isNotEmpty &&
                              !isCustomerEdit &&
                              !isVehicleEdit) {
                            if (isAppointmentEdit == false) {
                              context.read<EstimateBloc>().add(
                                    CreateAppointmentEstimateEvent(
                                      startTime: startDateToServer +
                                          " " +
                                          startTimeToServer,
                                      endTime: endDateToServer +
                                          " " +
                                          endTimeToServer,
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
                                      dropScedule: endDateToServer,
                                      vehicleCheckin: startDateToServer));
                            } else {
                              context.read<EstimateBloc>().add(
                                  EditAppointmentEstimateEvent(
                                      startTime: startDateToServer +
                                          " " +
                                          startTimeToServer,
                                      endTime: endDateToServer +
                                          " " +
                                          endTimeToServer,
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
                                      dropScedule: endDateToServer,
                                      vehicleCheckin: startDateToServer));
                            }
                          }

                          if ((noteValidation() &&
                                  appointmentValidation() &&
                                  estimateNoteController.text
                                      .trim()
                                      .isNotEmpty) &&
                              !isCustomerEdit &&
                              !isVehicleEdit) {
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
                          if (noteValidation() &&
                              appointmentValidation() &&
                              networkImageList.isNotEmpty &&
                              !isCustomerEdit &&
                              !isVehicleEdit) {
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

                          if (appointmentValidation() && noteValidation()) {
                            if (isCustomerEdit && isVehicleEdit) {
                              CommonWidgets().showDialog(context,
                                  "Please select a customer and vehicle");
                            } else if (isCustomerEdit) {
                              CommonWidgets().showDialog(
                                  context, "Please select a customer");
                            } else if (isVehicleEdit) {
                              CommonWidgets().showDialog(
                                  context, "Please select a vehicle");
                            } else if (widget.navigation ==
                                "customer_navigation") {
                              final estimate = widget.estimateDetails.data;
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomerInformationScreen(
                                    id: estimate.customerId.toString(),
                                  ),
                                ),
                              );
                            } else if (widget.navigation == 'search') {
                              Navigator.pop(context);
                            } else if (widget.navigation == 'workflow') {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(
                                builder: (context) {
                                  return BottomBarScreen(
                                    currentIndex: 1,
                                    tabControllerIndex: 0,
                                  );
                                },
                              ), (route) => false);
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
                        child: Container(
                          height: kToolbarHeight,
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
                        Text(
                          '${widget.estimateDetails.data.orderStatus} Details',
                          style: const TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w600),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Follow the steps to create an estimate.',
                            style: TextStyle(
                                color: AppColors.greyText,
                                fontSize: 14.5,
                                // letterSpacing: 1.5,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.estimateDetails.data.orderStatus} #${widget.estimateDetails.data.orderNumber}',
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
                                            return editCustomerBottomSheet(
                                                context, state);
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
                        estimateNoteList.isNotEmpty &&
                                isEstimateNoteEdit == false
                            ? const SizedBox()
                            : errorWidget(
                                estimateNoteErrorMsg, estimateNoteErrorStatus),

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
                                            .data.data.isNotEmpty &&
                                        !isAppointmentEdit
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        halfTextBox(
                                            "Select Date",
                                            startDateController,
                                            "Start Date",
                                            startDateErrorStatus,
                                            "start_time",
                                            startDateErrorMsg),
                                        halfTextBox(
                                            "Select Date",
                                            endDateController,
                                            "End Date",
                                            endDateErrorStatus,
                                            "end_time",
                                            endDateErrorMsg)
                                      ],
                                    ),
                                  ),
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
                                            "start_time",
                                            startTimeErrorMsg),
                                        halfTextBox(
                                            "Select Time",
                                            endTimeController,
                                            "End Time",
                                            endTimeErrorStatus,
                                            "end_time",
                                            endTimeErrorMsg)
                                      ],
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 16.0),
                                  //   child: textBox(
                                  //       "Select Date",
                                  //       dateController,
                                  //       "Date",
                                  //       dateErrorStatus),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: textBox(
                                        "Enter Appointment Note",
                                        appointmentController,
                                        "Appointment Note",
                                        appointmentErrorStatus),
                                  ),
                                  errorWidget(appointmentErrorMsg,
                                      appointmentErrorStatus),
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
                                    List<String> combList = [];
                                    log(networkImageList.toString() +
                                        "Image List network");
                                    log(newOrderImageData.toString() +
                                        "Image List");
                                    if (newOrderImageData.length > index ||
                                        networkImageList[index]
                                            .contains("http")) {
                                      newOrderImageData.forEach((element) {
                                        combList.add(element.fileName);
                                      });
                                      networkImageList.forEach((element) {
                                        combList.add(element);
                                      });
                                      // }
                                      showImageView(
                                          combList[index], index, combList);
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
                          child: taxDetailsWidget("Material",
                              "\$ ${materialAmount.toStringAsFixed(2)}"),
                        ),
                        taxDetailsWidget(
                            "Part", "\$ ${partAmount.toStringAsFixed(2)}"),

                        taxDetailsWidget(
                            "Labor", "\$ ${laborAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget("Sub Contract",
                            "\$ ${subContractAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget(
                            "Fee", "\$ ${feeAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget(
                            "Tax", "\$ ${taxAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget("Discount",
                            "\$ ${discountAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget("Total Cost",
                            "\$ ${costAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget(
                            "Total", "\$ ${totalAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget(
                            "Profit", "\$ ${profitAmount.toStringAsFixed(2)}"),
                        taxDetailsWidget("Balance due",
                            "\$ ${balanceDueAmount.toStringAsFixed(2)}"),

                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return PaymentListScreen(
                                      orderId: widget.estimateDetails.data.id
                                          .toString());
                                },
                              ));
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "View Payment History",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.primaryColors,
                                      decoration: TextDecoration.underline),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45.0),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.estimateDetails.data.customer !=
                                      null &&
                                  isCustomerEdit == false) {
                                context.read<EstimateBloc>().add(
                                    SendEstimateToCustomerEvent(
                                        customerId: widget.estimateDetails.data
                                                .customer?.id
                                                .toString() ??
                                            "",
                                        orderId: widget.estimateDetails.data.id
                                            .toString(),
                                        subject: widget
                                            .estimateDetails.data.orderNumber
                                            .toString()));
                              }
                            },
                            child: Container(
                              height: 56,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade50,
                              ),
                              child: state is SendEstimateToCustomerLoadingState
                                  ? const Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                  : Text(
                                      "Send to customer",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: widget.estimateDetails.data
                                                        .customer !=
                                                    null &&
                                                isCustomerEdit == false
                                            ? AppColors.primaryColors
                                            : Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.estimateDetails.data.orderStatus !=
                                  "Estimate") {
                                if (balanceDueAmount <= 0 &&
                                        widget.estimateDetails.data
                                                .orderService !=
                                            null &&
                                        widget.estimateDetails.data
                                            .orderService!.isNotEmpty &&
                                        widget
                                                .estimateDetails
                                                .data
                                                .orderService![0]
                                                .orderServiceItems !=
                                            null
                                    //     &&
                                    // widget.estimateDetails.data.orderService![0]
                                    //     .orderServiceItems!.isNotEmpty
                                    ) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return PaymentListScreen(
                                        orderId: widget.estimateDetails.data.id
                                            .toString(),
                                      );
                                    },
                                  ));
                                } else {
                                  if (widget.estimateDetails.data
                                              .orderService !=
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
                                }
                              }
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
                            },
                            child: widget.estimateDetails.data.orderStatus ==
                                    "Estimate"
                                ? Container(
                                    height: 56,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade300),
                                    child: Text(
                                      "Collect Payment",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 56,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: balanceDueAmount <= 0 &&
                                                widget.estimateDetails.data
                                                        .orderService !=
                                                    null &&
                                                widget.estimateDetails.data
                                                    .orderService!.isNotEmpty &&
                                                widget
                                                        .estimateDetails
                                                        .data
                                                        .orderService![0]
                                                        .orderServiceItems !=
                                                    null &&
                                                widget.estimateDetails.data
                                                        .orderStatus !=
                                                    "Estimate"
                                            //      &&
                                            // widget
                                            //     .estimateDetails
                                            //     .data
                                            //     .orderService![0]
                                            //     .orderServiceItems!
                                            //     .isNotEmpty
                                            ? const Color(0xff12A58C)
                                            : AppColors.primaryColors),
                                    child: Text(
                                      balanceDueAmount <= 0 &&
                                              widget.estimateDetails.data
                                                      .orderService !=
                                                  null &&
                                              widget.estimateDetails.data
                                                  .orderService!.isNotEmpty &&
                                              widget
                                                      .estimateDetails
                                                      .data
                                                      .orderService![0]
                                                      .orderServiceItems !=
                                                  null
                                          //  &&
                                          // widget
                                          //     .estimateDetails
                                          //     .data
                                          //     .orderService![0]
                                          //     .orderServiceItems!
                                          //     .isNotEmpty
                                          ? "Paid In Full"
                                          : "Collect Payment",
                                      style: const TextStyle(
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

  noteValidation() {
    bool status = true;
    if (estimateNoteController.text.trim().isNotEmpty) {
      if (estimateNoteController.text.trim().length < 5) {
        estimateNoteErrorMsg = "Note should be atleast 5 characters";
        estimateNoteErrorStatus = true;
        status = false;
      } else {
        estimateNoteErrorStatus = false;
      }
    } else {
      estimateNoteErrorStatus = false;
    }
    setState(() {});
    return status;
  }

  appointmentValidation() {
    if (startTimeController.text.isEmpty &&
        endTimeController.text.isEmpty &&
        startDateController.text.isEmpty &&
        endDateController.text.isEmpty &&
        appointmentController.text.isEmpty) {
      startDateErrorStatus = false;
      endDateErrorStatus = false;
      startTimeErrorStatus = false;
      endTimeErrorStatus = false;
      appointmentErrorStatus = false;
      setState(() {});
      return true;
    }
    bool validateDurations(String firstDurationStr, String secondDurationStr) {
      if (firstDurationStr.isEmpty && secondDurationStr.isEmpty) {
        return true;
      }
      log(secondDurationStr + "FIRST DUR");
      // Parse the durations into hours and minutes
      List<String> firstParts = firstDurationStr.split(':');
      List<String> secondParts = secondDurationStr.split(':');
      int firstHours = int.parse(firstParts[0]);
      int firstMinutes = int.parse(firstParts[1]);
      int secondHours = int.parse(secondParts[0]);
      int secondMinutes = int.parse(secondParts[1]);

      // Convert the durations to total minutes for comparison
      int firstTotalMinutes = firstHours * 60 + firstMinutes;
      int secondTotalMinutes = secondHours * 60 + secondMinutes;

      // Compare the durations and return the result
      return firstTotalMinutes < secondTotalMinutes;
    }

    bool status = true;

    if (startDateController.text.isEmpty) {
      startDateErrorMsg = "Start Date can't be empty";
      startDateErrorStatus = true;
      status = false;
    } else {
      startDateErrorStatus = false;
    }

    if (endDateController.text.isEmpty) {
      endDateErrorMsg = "End Date can't be empty";
      endDateErrorStatus = true;
      status = false;
    } else {
      endDateErrorStatus = false;
    }

    if (startTimeController.text.isEmpty) {
      startTimeErrorMsg = "Start Time can't be empty";
      startTimeErrorStatus = true;
      status = false;
    } else {
      startTimeErrorStatus = false;
    }

    if (endTimeController.text.isEmpty) {
      endTimeErrorMsg = "End Time can't be empty";
      endTimeErrorStatus = true;
      status = false;
    } else if (startTimeController.text.isNotEmpty &&
        endTimeController.text.isNotEmpty &&
        !validateDurations(startTimeToServer, endTimeToServer)) {
      endTimeErrorMsg = "End Time should be valid";
      endTimeErrorStatus = true;
      status = false;
    } else {
      endTimeErrorStatus = false;
    }

    if (appointmentController.text.trim().isEmpty) {
      appointmentErrorMsg = "Appointment note can't be empty";
      appointmentErrorStatus = true;
      status = false;
    } else if (appointmentController.text.trim().length < 5) {
      appointmentErrorMsg = "Appointment note should be atleast 5 characters";
      appointmentErrorStatus = true;
      status = false;
    } else {
      appointmentErrorStatus = false;
    }
    setState(() {});
    return status;
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
    print(widget.estimateDetails.data.customer?.email);
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
          widget.estimateDetails.data.customer?.email != null &&
                  widget.estimateDetails.data.customer?.email != ""
              ? Padding(
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
                          if (widget.estimateDetails.data.customer?.email !=
                              null) {
                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path:
                                  widget.estimateDetails.data.customer?.email ??
                                      "",
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
                )
              : const SizedBox(),
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
              "${widget.estimateDetails.data.vehicle?.vehicleYear ?? ''} ${widget.estimateDetails.data.vehicle?.vehicleMake ?? ''} ${widget.estimateDetails.data.vehicle?.vehicleModel ?? ''} ",
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
                  "${widget.estimateDetails.data.vehicle?.kilometers.split(".").first ?? '0'} mi",
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
                        ? DateFormat('hh : mm a').format(
                            appointmentDetailsModel!.data.data[0].startOn)
                        : ""),
                appointmentLabelwithValue(
                    "End Time",
                    appointmentDetailsModel?.data.data != null &&
                            appointmentDetailsModel?.data.data != []
                        ? DateFormat('hh: mm a')
                            .format(appointmentDetailsModel!.data.data[0].endOn)
                        : "")
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 16.0),
          //   child: appointmentLabelwithValue(
          //       "Date",
          //       appointmentDetailsModel?.data.data != null &&
          //               appointmentDetailsModel?.data.data != []
          //           ? "${appointmentDetailsModel?.data.data[0].startOn.month}/${appointmentDetailsModel?.data.data[0].startOn.day}/${appointmentDetailsModel?.data.data[0].startOn.year}"
          //           : ""),
          // ),
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
    log((widget.estimateDetails.data.orderService?.length).toString() +
        "loooooo");
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
    double sumAmount = 0;
    widget.estimateDetails.data.orderService![serviceIndex].orderServiceItems!
        .forEach((element) {
      sumAmount += double.tryParse(element.subTotal) ?? 0;
    });

    if (widget.estimateDetails.data.orderService![serviceIndex]
        .orderServiceItems!.isEmpty) {
      sumAmount = double.tryParse(widget
              .estimateDetails.data.orderService![serviceIndex].servicePrice) ??
          0;
    }

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
                  Flexible(
                    child: Text(
                      widget.estimateDetails.data.orderService?[serviceIndex]
                              .serviceName ??
                          "",
                      style: const TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: [
                      widget.estimateDetails.data.orderService![serviceIndex]
                              .orderServiceItems!.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    changeAuthIndex(
                                        widget
                                            .estimateDetails
                                            .data
                                            .orderService![serviceIndex]
                                            .isAuthorized,
                                        widget
                                            .estimateDetails
                                            .data
                                            .orderService![serviceIndex]
                                            .isAuthorizedCustomer);
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
                          : Row(
                              children: [
                                Text(
                                  "\$ ${widget.estimateDetails.data.orderService?[serviceIndex].servicePrice ?? ""}  ",
                                  style: const TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return editServiceSheet(
                                            widget
                                                    .estimateDetails
                                                    .data
                                                    .orderService?[serviceIndex]
                                                    .id
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
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  widget.estimateDetails.data.orderService?[serviceIndex]
                          .serviceNote ??
                      "",
                  style: const TextStyle(
                      color: AppColors.primaryTitleColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  dynamic parsedValue = double.parse(widget
                      .estimateDetails
                      .data
                      .orderService![serviceIndex]
                      .orderServiceItems![index]
                      .subTotal);
                  sumAmount = sumAmount + parsedValue;
                  return Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3.1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
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
                                    Text(
                                      "(${widget.estimateDetails.data.orderService?[serviceIndex].orderServiceItems?[index].itemType ?? ""})",
                                      style: const TextStyle(
                                          color: AppColors.primaryTitleColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      widget
                                              .estimateDetails
                                              .data
                                              .orderService?[serviceIndex]
                                              .orderServiceItems?[index]
                                              .quanityHours ??
                                          "",
                                      style: const TextStyle(
                                          color: AppColors.primaryTitleColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    widget
                                                .estimateDetails
                                                .data
                                                .orderService?[serviceIndex]
                                                .orderServiceItems?[index]
                                                .itemType ==
                                            "Labor"
                                        ? const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "hrs",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .primaryTitleColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
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
                        ),
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.estimateDetails.data.orderService?[serviceIndex]
                                      .isAuthorized ==
                                  "Y" &&
                              widget
                                      .estimateDetails
                                      .data
                                      .orderService?[serviceIndex]
                                      .isAuthorizedCustomer ==
                                  "Y"
                          ? "Authorized"
                          : widget
                                          .estimateDetails
                                          .data
                                          .orderService?[serviceIndex]
                                          .isAuthorized ==
                                      "Y" &&
                                  widget
                                          .estimateDetails
                                          .data
                                          .orderService?[serviceIndex]
                                          .isAuthorizedCustomer ==
                                      "N"
                              ? "Declined"
                              : "Not Yet Authorized",
                      style: TextStyle(
                          color: widget
                                          .estimateDetails
                                          .data
                                          .orderService?[serviceIndex]
                                          .isAuthorized ==
                                      "Y" &&
                                  widget
                                          .estimateDetails
                                          .data
                                          .orderService?[serviceIndex]
                                          .isAuthorizedCustomer ==
                                      "Y"
                              ? Color(0xff12A58C)
                              : Color(0xffFF5C5C)),
                    ),
                    Text(" \$ ${sumAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.primaryTitleColor)),
                  ],
                ),
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
            style: TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: title == "Total" ||
                        title == "Profit" ||
                        title == "Balance due"
                    ? 17
                    : 16,
                fontWeight: title == "Total" ||
                        title == "Profit" ||
                        title == "Balance due"
                    ? FontWeight.w600
                    : FontWeight.w500),
          ),
          Text(
            " $price",
            style: TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: title == "Total" ||
                        title == "Profit" ||
                        title == "Balance due"
                    ? 17
                    : 16,
                fontWeight: title == "Total" ||
                        title == "Profit" ||
                        title == "Balance due"
                    ? FontWeight.w600
                    : FontWeight.w500),
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
                                orderId:
                                    widget.estimateDetails.data.id.toString(),
                              );
                            },
                            isScrollControlled: true,
                            useSafeArea: true);
                      } else if (label == "Vehicle") {
                        if ((appointmentValidation() &&
                                startTimeController.text.isNotEmpty) ||
                            (noteValidation() &&
                                estimateNoteController.text.isNotEmpty) ||
                            networkImageList
                                .where((element) => element.isNotEmpty)
                                .toList()
                                .isEmpty) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CreateVehicleScreen(
                                  navigation: "partial_estimate",
                                  customerId: widget
                                          .estimateDetails.data.customer?.id
                                          .toString() ??
                                      "0",
                                  orderId:
                                      widget.estimateDetails.data.id.toString(),
                                );
                              },
                              isScrollControlled: true,
                              useSafeArea: true);
                        } else {
                          showPopUpBeforeService(
                              context,
                              SelectVehiclesScreen(
                                navigation: "partial",
                                subNavigation: widget.navigation,
                                orderId:
                                    widget.estimateDetails.data.id.toString(),
                                customerId: widget
                                    .estimateDetails.data.customerId
                                    .toString(),
                              ),
                              "");
                        }
                      } else if (label == "Service") {
                        if (widget.estimateDetails.data.customer != null) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                // return AddServiceScreen(
                                //   navigation: "partial_estimate",
                                // );

                                return AddOrderServiceScreen(
                                    orderId: widget.estimateDetails.data.id
                                        .toString());
                              },
                              isScrollControlled: true,
                              useSafeArea: true);
                        } else {
                          //show dialog
                          CommonWidgets().showDialog(context,
                              "Please select a customer before adding a service");
                        }
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: AppColors.primaryColors,
                        ),
                        Text(
                          "Add New",
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
            height: label == "Note" || label == "Appointment Note" ? null : 56,
            width: MediaQuery.of(context).size.width,
            child: TextField(
              controller: controller,
              textInputAction: label == "Note" ? TextInputAction.done : null,
              textCapitalization: TextCapitalization.sentences,
              inputFormatters: label == "Card Number"
                  ? [CardNumberInputFormatter()]
                  : label == "Amount To Pay"
                      ? [FilteringTextInputFormatter.deny(RegExp(r'[,-]'))]
                      : [],
              readOnly: label == 'Date' ||
                      label == "Vehicle" ||
                      label == "Customer" ||
                      label == "Service" ||
                      label == "Payment Date"
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
                  if (isVehicleEdit) {
                    CommonWidgets()
                        .showDialog(context, "Please select a vehicle");
                    return;
                  }
                  if ((appointmentValidation() &&
                          startTimeController.text.isEmpty) &&
                      (noteValidation() &&
                          estimateNoteController.text.isEmpty) &&
                      networkImageList
                          .where((element) => element.isNotEmpty)
                          .toList()
                          .isEmpty) {
                    log('here i am 1');
                    //   if (widget.estimateDetails.data.customer != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return SelectCustomerScreen(
                          navigation: "partial",
                          subNavigation: widget.navigation,
                          orderId: widget.estimateDetails.data.id.toString(),
                        );
                      },
                    ));
                    //  } else {
                    //   CommonWidgets().showDialog(context,
                    //       "Please select a customer before adding a service");
                    // }
                  } else {
                    // CommonWidgets().showDialog(context,
                    //     "Please save the unsaved changes before selecting the service");
                    // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                    if ((appointmentValidation() &&
                            startTimeController.text.isNotEmpty) ||
                        (noteValidation() &&
                            estimateNoteController.text.isNotEmpty) ||
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isNotEmpty) {
                      showPopUpBeforeService(
                          context,
                          SelectCustomerScreen(
                            navigation: "partial",
                            subNavigation: widget.navigation,
                            orderId: widget.estimateDetails.data.id.toString(),
                          ),
                          "");
                    }
                  }
                } else if (label == 'Vehicle') {
                  // showModalBottomSheet(
                  //   context: context,
                  //   isScrollControlled: true,
                  //   useSafeArea: true,
                  //   builder: (context) {
                  //     return SelectVehiclesScreen();
                  //   },
                  // );
                  if (isCustomerEdit) {
                    CommonWidgets()
                        .showDialog(context, "Please select a customer");
                    return;
                  }
                  if ((appointmentValidation() &&
                          startTimeController.text.isEmpty) &&
                      (noteValidation() &&
                          estimateNoteController.text.isEmpty) &&
                      networkImageList
                          .where((element) => element.isNotEmpty)
                          .toList()
                          .isEmpty) {
                    log('here i am her');
                    if (widget.estimateDetails.data.customer != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return SelectVehiclesScreen(
                            navigation: "partial",
                            subNavigation: widget.navigation,
                            orderId: widget.estimateDetails.data.id.toString(),
                            customerId: widget.estimateDetails.data.customerId
                                .toString(),
                          );
                        },
                      ));
                    } else {
                      print("hereee");
                      CommonWidgets().showDialog(context,
                          "Please select a customer before adding a service");
                    }
                  } else {
                    // CommonWidgets().showDialog(context,
                    //     "Please save the unsaved changes before selecting the service");
                    // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                    if ((appointmentValidation() &&
                            startTimeController.text.isNotEmpty) ||
                        (noteValidation() &&
                            estimateNoteController.text.isNotEmpty) ||
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isNotEmpty) {
                      showPopUpBeforeService(
                          context,
                          SelectVehiclesScreen(
                            navigation: "partial",
                            subNavigation: widget.navigation,
                            orderId: widget.estimateDetails.data.id.toString(),
                            customerId: widget.estimateDetails.data.customerId
                                .toString(),
                          ),
                          "");
                    }
                  }
                } else if (label == "Service") {
                  if (!appointmentValidation() && !noteValidation()) {
                    return;
                  }
                  if (isCustomerEdit && isVehicleEdit) {
                    CommonWidgets().showDialog(
                        context, "Please select a customer and vehicle");
                    return;
                  } else if (isCustomerEdit) {
                    CommonWidgets()
                        .showDialog(context, "Please select a customer");
                    return;
                  } else if (isVehicleEdit) {
                    CommonWidgets()
                        .showDialog(context, "Please select a vehicle");
                    return;
                  }
                  if ((appointmentValidation() &&
                          startTimeController.text.isEmpty) &&
                      (noteValidation() &&
                          estimateNoteController.text.isEmpty) &&
                      networkImageList
                          .where((element) => element.isNotEmpty)
                          .toList()
                          .isEmpty) {
                    log('here i am 2');
                    if (widget.estimateDetails.data.customer != null) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SelectServiceScreen(
                            orderId: widget.estimateDetails.data.id.toString(),
                            navigation: widget.navigation,
                          );
                        },
                      ));
                    } else {
                      CommonWidgets().showDialog(context,
                          "Please select a customer before adding a service");
                    }
                  } else {
                    // CommonWidgets().showDialog(context,
                    //     "Please save the unsaved changes before selecting the service");
                    // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                    if ((appointmentValidation() &&
                            startTimeController.text.isNotEmpty) ||
                        (noteValidation() &&
                            estimateNoteController.text.isNotEmpty) ||
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isNotEmpty) {
                      showPopUpBeforeService(
                          context,
                          SelectServiceScreen(
                            orderId: widget.estimateDetails.data.id.toString(),
                            navigation: widget.navigation,
                          ),
                          "");
                    }
                  }
                }
              },
              keyboardType: label == 'Phone Number'
                  ? TextInputType.number
                  : label == "Amount To Pay"
                      ? TextInputType.numberWithOptions(decimal: true)
                      : null,
              maxLines: label == "Note" || label == "Appointment Note" ? 6 : 1,
              minLines:
                  label == "Note" || label == "Appointment Note" ? 1 : null,
              maxLength: label == 'Phone Number'
                  ? 16
                  : label == "Notes"
                      ? 150
                      : label == 'Password'
                          ? 12
                          : label == "Note"
                              ? null
                              : label == "Appointment Note"
                                  ? null
                                  : 50,
              // expands: label == "Note" ? true : false,
              decoration: InputDecoration(
                  hintText: placeHolder,
                  counterText: "",
                  suffix: label == "Amount To Pay"
                      ? GestureDetector(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();

                            paymentAmountController.text =
                                balanceDueAmount.toStringAsFixed(2);
                          },
                          child: const Text(
                            "Full Amount",
                            style: TextStyle(
                                color: AppColors.primaryColors,
                                fontWeight: FontWeight.w600),
                          ))
                      : null,
                  suffixIcon: label == "Customer" ||
                          label == "Vehicle" ||
                          label == "Service"
                      ? const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primaryColors,
                        )
                      : null,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text("Clear"),
                    onPressed: () {
                      if (dateType == "payment") {
                        cashDateController.text = "";
                        cashDateToServer = "";
                      } else if (dateType == "start_date") {
                        startDateController.text = "";
                        startDateToServer = "";
                      } else if (dateType == "end_date") {
                        endDateController.text = "";
                        endDateToServer = "";
                      }

                      Navigator.pop(context);
                    },
                  ),
                  CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      if (dateType == "payment") {
                        if (selectedDate != "") {
                          cashDateController.text = selectedDate;
                          cashDateToServer = cashDateToServer;
                        } else {
                          cashDateController.text =
                              "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().year}";
                          cashDateToServer =
                              "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
                        }
                      } else if (dateType == "start_date") {
                        if (selectedDate != "") {
                          startDateController.text = selectedDate;
                          startDateToServer = startDateToServer;
                        } else {
                          startDateController.text =
                              "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().year}";

                          startDateToServer =
                              "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
                        }
                      } else if (dateType == "end_date") {
                        if (selectedDate != "") {
                          endDateController.text = selectedDate;
                          endDateToServer = endDateToServer;
                        } else {
                          endDateController.text =
                              "${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().year}";
                          endDateToServer =
                              "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
                        }
                      }

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              //   CommonWidgets().commonDividerLine(context),
              Flexible(
                child: CupertinoDatePicker(
                  initialDateTime: isAppointmentEdit
                      ? dateType == "end_date"
                          ? appointmentDetailsModel?.data.data[0].endOn
                          : appointmentDetailsModel?.data.data[0].startOn
                      : dateType == "end_date" && startDateController.text != ""
                          ? DateTime.parse(startDateToServer)
                          : DateTime.now(),
                  onDateTimeChanged: (DateTime newdate) {
                    setState(() {
                      selectedDate =
                          "${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}-${newdate.year}";
                      if (dateType == "end_date") {
                        endDateToServer =
                            "${newdate.year}-${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}";
                      } else if (dateType == "start_date") {
                        endDateController.text = "";
                        endDateToServer = "";

                        startDateToServer =
                            "${newdate.year}-${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}";
                      } else if (dateType == "payment") {
                        cashDateToServer =
                            "${newdate.year}-${newdate.month.toString().padLeft(2, '0')}-${newdate.day.toString().padLeft(2, '0')}";
                      }
                    });
                  },
                  use24hFormat: true,
                  maximumDate: new DateTime(2030, 12, 30),
                  minimumYear: 2009,
                  maximumYear: 2030,
                  minuteInterval: 1,
                  minimumDate:
                      dateType == "end_date" && startDateController.text != ""
                          ? DateTime.parse(startDateToServer)
                          : null,
                  mode: CupertinoDatePickerMode.date,
                ),
              ),
            ],
          )),
    );
  }

  Widget halfTextBox(String placeHolder, TextEditingController controller,
      String label, bool errorStatus, String whichTime, String errorMsg) {
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
                if (label == "Start Date") {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return datePicker("start_date");
                      });
                } else if (label == "End Date") {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return datePicker("end_date");
                      });
                } else {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return timerPicker(whichTime);
                    },
                  );
                }
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
        errorWidget(errorMsg, errorStatus),
      ],
    );
  }

  Widget timerPicker(String timeType) {
    String selectedTime = "${DateTime.now().hour}:${DateTime.now().minute}";
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
      selectedTime = startTimeToServer;
    } else if (timeType == "end_time" &&
        endTimeController.text.trim().isNotEmpty) {
      selectedTime = endTimeToServer;
    } else if (timeType == "end_time" &&
        endTimeController.text.trim().isEmpty) {
      selectedTime = startTimeToServer;
    }

    return CupertinoPopupSurface(
      child: Container(
        color: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text("Clear"),
                  onPressed: () {
                    if (timeType == "start_time") {
                      startTimeController.text = "";
                      startTimeToServer = "";
                    } else {
                      endTimeController.text = "";
                      endTimeToServer = "";
                    }
                    Navigator.pop(context);
                  },
                ),
                CupertinoButton(
                    child: const Text("Done"),
                    onPressed: () {
                      if (timeType == "start_time") {
                        startTimeToServer = selectedTime;
                        startTimeController
                            .text = AppUtils.getTimeMinFormatted(Duration(
                                hours: int.parse(
                                  selectedTime.substring(0, 2),
                                ),
                                minutes: int.parse(selectedTime.substring(3)))
                            .toString());
                      } else {
                        endTimeToServer = selectedTime;
                        endTimeController
                            .text = AppUtils.getTimeMinFormatted(Duration(
                                hours: int.parse(
                                  selectedTime.substring(0, 2),
                                ),
                                minutes: int.parse(selectedTime.substring(3)))
                            .toString());
                      }
                      Navigator.pop(context);
                    })
              ],
            ),
            Flexible(
              child: CupertinoDatePicker(
                // mode: CupertinoTimerPickerMode.hm,
                mode: CupertinoDatePickerMode.time,
                minuteInterval: 1,
                initialDateTime: isAppointmentEdit && timeType == "start_time"
                    ? DateTime(
                        2023,
                        1,
                        1,
                        appointmentDetailsModel?.data.data[0].startOn.hour ?? 0,
                        appointmentDetailsModel?.data.data[0].startOn.minute ??
                            0)
                    : isAppointmentEdit && timeType == "end_time"
                        ? DateTime(
                            2023,
                            1,
                            1,
                            appointmentDetailsModel?.data.data[0].endOn.hour ??
                                0,
                            appointmentDetailsModel
                                    ?.data.data[0].endOn.minute ??
                                0)
                        : timeType == 'end_time' &&
                                    startTimeToServer.isNotEmpty ||
                                timeType == 'start_time' &&
                                    startTimeToServer.isNotEmpty
                            ? DateTime(
                                2023,
                                1,
                                1,
                                int.parse(
                                    startTimeToServer.trim().substring(0, 2)),
                                int.parse(
                                  startTimeToServer.trim().substring(3),
                                ),
                              )
                            : DateTime.now(),

                onDateTimeChanged: (DateTime dateTime) {
                  setState(() {
                    selectedTime =
                        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
                  });
                },
              ),
            ),
            // Flexible(
            //   child: CupertinoTimerPicker(
            //     mode: CupertinoTimerPickerMode.hm,
            //     minuteInterval: 1,
            //     secondInterval: 1,
            //     initialTimerDuration: isAppointmentEdit &&
            //             timeType == "start_time"
            //         ? Duration(
            //             hours: appointmentDetailsModel?.data.data[0].startOn.hour ??
            //                 0,
            //             minutes: appointmentDetailsModel
            //                     ?.data.data[0].startOn.minute ??
            //                 0)
            //         : isAppointmentEdit && timeType == "end_time"
            //             ? Duration(
            //                 hours: appointmentDetailsModel
            //                         ?.data.data[0].endOn.hour ??
            //                     0,
            //                 minutes: appointmentDetailsModel
            //                         ?.data.data[0].endOn.minute ??
            //                     0)
            //             : timeType == 'end_time' &&
            //                         startTimeController.text.isNotEmpty ||
            //                     timeType == 'start_time' &&
            //                         startTimeController.text.isNotEmpty
            //                 ? Duration(
            //                     hours: int.parse(startTimeController.text
            //                         .trim()
            //                         .substring(0, 2)),
            //                     minutes: int.parse(startTimeController.text.trim().substring(3)))
            //                 : Duration(),
            //     onTimerDurationChanged: (Duration changeTimer) {
            //       setState(() {
            //         // initialTimer = changeTimer;

            //         selectedTime =
            //             ' ${changeTimer.inHours >= 10 ? changeTimer.inHours : "0${changeTimer.inHours}"}:${changeTimer.inMinutes % 60 >= 10 ? changeTimer.inMinutes % 60 : "0${changeTimer.inMinutes % 60}"}';

            //         print(
            //             '${changeTimer.inHours} hrs ${changeTimer.inMinutes % 60} mins ${changeTimer.inSeconds % 60} secs');
            //       });
            //     },
            //   ),
            // ),
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
                    child: CachedNetworkImage(
                      imageUrl: networkUrl,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, progress) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 8.8,
                          height: 37,
                          child: const CupertinoActivityIndicator(),
                        );
                      },
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
    materialAmount = 0;
    partAmount = 0;
    laborAmount = 0;
    subContractAmount = 0;
    feeAmount = 0;
    taxAmount = 0;
    discountAmount = 0;
    totalAmount = 0;
    balanceDueAmount = 0;
    profitAmount = 0;
    costAmount = 0;
    widget.estimateDetails.data.orderService?.forEach((element) {
      if ((element.isAuthorized == "Y" &&
              element.isAuthorizedCustomer == "Y") ||
          (element.isAuthorized == "N" &&
              element.isAuthorizedCustomer == "N")) {
        if (element.orderServiceItems!.isEmpty) {
          laborAmount += double.parse(element.servicePrice);
          taxAmount += double.parse(element.tax) *
              double.parse(element.servicePrice) /
              100;
        }
        element.orderServiceItems!.forEach((element2) {
          if (element2.itemType.toLowerCase() == "material") {
            materialAmount = materialAmount +
                (double.parse(element2.unitPrice) *
                    double.parse(element2.quanityHours));
          }
          if (element2.itemType.toLowerCase() == "labor") {
            laborAmount = laborAmount +
                (double.parse(element2.unitPrice) *
                    double.parse(element2.quanityHours));
          }
          if (element2.itemType.toLowerCase() == "subcontract") {
            subContractAmount =
                subContractAmount + double.parse(element2.unitPrice);
          }
          if (element2.itemType.toLowerCase() == "fee") {
            feeAmount = feeAmount + double.parse(element2.unitPrice);
          }
          if (element2.itemType.toLowerCase() == "part") {
            partAmount = partAmount +
                (double.parse(element2.unitPrice) *
                    double.parse(element2.quanityHours));
          }

          double tempPrice = 0.00;
          if (element2.discountType == "Fixed") {
            if (element2.itemType.toLowerCase() == "part" ||
                element2.itemType.toLowerCase() == "labor" ||
                element2.itemType.toLowerCase() == "material") {
              tempPrice = (double.parse(element2.unitPrice) *
                      double.parse(element2.quanityHours)) -
                  double.parse(element2.discount);
            } else {
              tempPrice = double.parse(element2.unitPrice) -
                  double.parse(element2.discount);
            }

            log(tempPrice.toString() + "tempp");
          } else {
            if (element2.itemType.toLowerCase() == "part" ||
                element2.itemType.toLowerCase() == "labor" ||
                element2.itemType.toLowerCase() == "material") {
              tempPrice = (double.parse(element2.unitPrice) *
                      double.parse(element2.quanityHours)) -
                  (double.parse(element2.discount) *
                          (double.parse(element2.unitPrice) *
                              double.parse(element2.quanityHours))) /
                      100;
            } else {
              tempPrice = double.parse(element2.unitPrice) -
                  (double.parse(element2.discount) *
                          double.parse(element2.unitPrice)) /
                      100;
            }
          }

          if (element2.itemType.toLowerCase() == "part" ||
              element2.itemType.toLowerCase() == "labor" ||
              element2.itemType.toLowerCase() == "material") {
            taxAmount =
                taxAmount + (tempPrice * double.parse(element2.tax)) / 100;
          } else {
            taxAmount =
                taxAmount + (double.parse(element2.tax) * tempPrice / 100);
          }

          if (element2.discountType == "Fixed") {
            discountAmount = discountAmount + double.parse(element2.discount);
          } else {
            discountAmount = discountAmount +
                (double.parse(element2.discount) *
                        double.parse(element2.unitPrice) *
                        double.parse(element2.quanityHours)) /
                    100;
          }

          costAmount = costAmount +
              ((double.tryParse(element2.markup) ?? 0) *
                  (double.tryParse(element2.quanityHours) ?? 1));
        });
      }
    });

    totalAmount = (materialAmount +
            laborAmount +
            taxAmount +
            partAmount +
            subContractAmount +
            feeAmount) -
        discountAmount;

    balanceDueAmount =
        totalAmount - double.parse(widget.estimateDetails.data.paidAmount);
    double tempProfit = (materialAmount +
            laborAmount +
            partAmount +
            subContractAmount +
            feeAmount) -
        discountAmount;
    profitAmount = tempProfit - costAmount;

    setState(() {});
  }

  paymentPopUp() {
    paymentAmountErrorStatus = false;
    cashDateErrorStatus = false;

    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository()),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) {
          if (state is CollectPaymentEstimateState) {
            widget.estimateDetails.data.paidAmount =
                (double.parse(widget.estimateDetails.data.paidAmount) +
                        double.parse(paymentAmountController.text))
                    .toString();

            calculateAmount();
            paymentAmountController.clear();
            cashDateController.clear();
            cashNoteController.clear();

            Navigator.pop(context);
            CommonWidgets().showSuccessDialog(
                _scaffoldKey.currentContext!, "Payment Successful");
          } else if (state is CollectPaymentEstimateErrorState) {
            CommonWidgets()
                .showDialog(_scaffoldKey.currentContext!, "Payment Failed");
          }
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            return StatefulBuilder(builder: (context, newSetState) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
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
                                tabController.index = 0;

                                paymentAmountController.clear();
                                cashDateController.clear();
                                cashNoteController.clear();
                                creditCardNumberController.clear();
                                creditRefNumberController.clear();

                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 27.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    "\$ ${balanceDueAmount.toStringAsFixed(2)}",
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
                              errorWidget(paymentAmountErrorMessage,
                                  paymentAmountErrorStatus),
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
                                          'Check',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'Others',
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
                                      cashTabWidget(),
                                      cashTabWidget(),
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (tabController.index == 0) {
                                      if (paymentAmountController
                                          .text.isEmpty) {
                                        newSetState(() {
                                          paymentAmountErrorStatus = true;
                                          paymentAmountErrorMessage =
                                              "Amount can't be empty";
                                        });
                                      } else {
                                        if (paymentAmountController.text ==
                                            "0") {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Please enter a valid amount";
                                          });
                                        } else if (double.parse(
                                                paymentAmountController.text) >
                                            balanceDueAmount) {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Amount can't be greater than balance due amount";
                                          });
                                        } else {
                                          newSetState(() {
                                            paymentAmountErrorStatus = false;
                                          });
                                        }
                                      }
                                      if (cashDateController.text.isEmpty) {
                                        newSetState(() {
                                          cashDateErrorStatus = true;
                                          cashDateErrorMessage =
                                              "Payment date can't be empty";
                                        });
                                      } else {
                                        newSetState(() {
                                          cashDateErrorStatus = false;
                                        });
                                      }
                                      if (!paymentAmountErrorStatus &&
                                          !cashDateErrorStatus) {
                                        context.read<EstimateBloc>().add(
                                              CollectPaymentEstimateEvent(
                                                  amount:
                                                      paymentAmountController
                                                          .text,
                                                  customerId: widget
                                                          .estimateDetails
                                                          .data
                                                          .customer
                                                          ?.id
                                                          .toString() ??
                                                      "",
                                                  orderId: widget
                                                      .estimateDetails.data.id
                                                      .toString(),
                                                  paymentMode: "Cash",
                                                  // tabController.index == 0
                                                  //     ? "Cash"
                                                  //     : tabController.index == 1
                                                  //         ? "Credit Card"
                                                  //         : "Check",
                                                  date: cashDateToServer,
                                                  note:
                                                      cashNoteController.text),
                                            );
                                      }
                                    } else if (tabController.index == 1) {
                                      if (paymentAmountController
                                          .text.isEmpty) {
                                        newSetState(() {
                                          paymentAmountErrorStatus = true;
                                          paymentAmountErrorMessage =
                                              "Amount can't be empty";
                                        });
                                      } else {
                                        if (paymentAmountController.text ==
                                            "0") {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Please enter a valid amount";
                                          });
                                        } else if (double.parse(
                                                paymentAmountController.text) >
                                            balanceDueAmount) {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Amount can't be greater than balance due amount";
                                          });
                                        } else {
                                          newSetState(() {
                                            paymentAmountErrorStatus = false;
                                          });
                                        }
                                      }
                                      if (cashDateController.text.isEmpty) {
                                        newSetState(() {
                                          cashDateErrorStatus = true;
                                          cashDateErrorMessage =
                                              "Payment date can't be empty";
                                        });
                                      } else {
                                        newSetState(() {
                                          cashDateErrorStatus = false;
                                        });
                                      }
                                      if (creditCardNumberController
                                          .text.isEmpty) {
                                        newSetState(() {
                                          creditCardNumberErrorStatus = true;
                                          creditCardNumberErrorMessage =
                                              "Card number can't be empty";
                                        });
                                      } else {
                                        if (creditCardNumberController.text
                                                .trim()
                                                .replaceAll("X", "")
                                                .replaceAll(" ", "")
                                                .length <
                                            4) {
                                          newSetState(() {
                                            creditCardNumberErrorStatus = true;
                                            creditCardNumberErrorMessage =
                                                "Please enter last four digits";
                                          });
                                        } else {
                                          newSetState(() {
                                            creditCardNumberErrorStatus = false;
                                          });
                                        }
                                      }

                                      if (!paymentAmountErrorStatus &&
                                          !cashDateErrorStatus &&
                                          !creditCardNumberErrorStatus) {
                                        context.read<EstimateBloc>().add(
                                              CollectPaymentEstimateEvent(
                                                  amount:
                                                      paymentAmountController
                                                          .text,
                                                  customerId: widget
                                                          .estimateDetails
                                                          .data
                                                          .customer
                                                          ?.id
                                                          .toString() ??
                                                      "",
                                                  orderId: widget
                                                      .estimateDetails.data.id
                                                      .toString(),
                                                  paymentMode: "creditcard",
                                                  // tabController.index == 0
                                                  //     ? "Cash"
                                                  //     : tabController.index == 1
                                                  //         ? "Credit Card"
                                                  //         : "Check",
                                                  date: cashDateToServer,
                                                  note:
                                                      creditCardNumberController
                                                          .text
                                                          .replaceAll("X", "")
                                                          .trim(),
                                                  transactionId:
                                                      creditRefNumberController
                                                          .text),
                                            );
                                      }
                                    } else if (tabController.index == 2) {
                                      if (paymentAmountController
                                          .text.isEmpty) {
                                        newSetState(() {
                                          paymentAmountErrorStatus = true;
                                          paymentAmountErrorMessage =
                                              "Amount can't be empty";
                                        });
                                      } else {
                                        if (paymentAmountController.text ==
                                            "0") {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Please enter a valid amount";
                                          });
                                        } else if (double.parse(
                                                paymentAmountController.text) >
                                            balanceDueAmount) {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Amount can't be greater than balance due amount";
                                          });
                                        } else {
                                          newSetState(() {
                                            paymentAmountErrorStatus = false;
                                          });
                                        }
                                      }
                                      if (cashDateController.text.isEmpty) {
                                        newSetState(() {
                                          cashDateErrorStatus = true;
                                          cashDateErrorMessage =
                                              "Payment date can't be empty";
                                        });
                                      } else {
                                        newSetState(() {
                                          cashDateErrorStatus = false;
                                        });
                                      }

                                      if (!paymentAmountErrorStatus &&
                                          !cashDateErrorStatus) {
                                        context.read<EstimateBloc>().add(
                                              CollectPaymentEstimateEvent(
                                                  amount:
                                                      paymentAmountController
                                                          .text,
                                                  customerId: widget
                                                          .estimateDetails
                                                          .data
                                                          .customer
                                                          ?.id
                                                          .toString() ??
                                                      "",
                                                  orderId: widget
                                                      .estimateDetails.data.id
                                                      .toString(),
                                                  paymentMode: "check",
                                                  // tabController.index == 0
                                                  //     ? "Cash"
                                                  //     : tabController.index == 1
                                                  //         ? "Credit Card"
                                                  //         : "Check",
                                                  date: cashDateToServer,
                                                  note:
                                                      cashNoteController.text),
                                            );
                                      }
                                    } else {
                                      if (paymentAmountController
                                          .text.isEmpty) {
                                        newSetState(() {
                                          paymentAmountErrorStatus = true;
                                          paymentAmountErrorMessage =
                                              "Amount can't be empty";
                                        });
                                      } else {
                                        if (paymentAmountController.text ==
                                            "0") {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Please enter a valid amount";
                                          });
                                        } else if (double.parse(
                                                paymentAmountController.text) >
                                            balanceDueAmount) {
                                          newSetState(() {
                                            paymentAmountErrorStatus = true;
                                            paymentAmountErrorMessage =
                                                "Amount can't be greater than balance due amount";
                                          });
                                        } else {
                                          newSetState(() {
                                            paymentAmountErrorStatus = false;
                                          });
                                        }
                                      }
                                      if (cashDateController.text.isEmpty) {
                                        newSetState(() {
                                          cashDateErrorStatus = true;
                                          cashDateErrorMessage =
                                              "Payment date can't be empty";
                                        });
                                      } else {
                                        newSetState(() {
                                          cashDateErrorStatus = false;
                                        });
                                      }

                                      if (!paymentAmountErrorStatus &&
                                          !cashDateErrorStatus) {
                                        context.read<EstimateBloc>().add(
                                              CollectPaymentEstimateEvent(
                                                  amount:
                                                      paymentAmountController
                                                          .text,
                                                  customerId: widget
                                                          .estimateDetails
                                                          .data
                                                          .customer
                                                          ?.id
                                                          .toString() ??
                                                      "",
                                                  orderId: widget
                                                      .estimateDetails.data.id
                                                      .toString(),
                                                  paymentMode: "Other",
                                                  // tabController.index == 0
                                                  //     ? "Cash"
                                                  //     : tabController.index == 1
                                                  //         ? "Credit Card"
                                                  //         : "Check",
                                                  date: cashDateToServer,
                                                  note:
                                                      cashNoteController.text),
                                            );
                                      }
                                    }
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
            });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textBox("Select Date", cashDateController, "Payment Date",
                cashDateErrorStatus),
            errorWidget(cashDateErrorMessage, cashDateErrorStatus),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // textBox("Enter Name on Card", creditNameOnCardController,
            //     "Name On Card", creditNameErrorStatus),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: textBox(
                  "Enter Last 4 Digits of Card",
                  creditCardNumberController,
                  "Card Number",
                  creditCardNumberErrorStatus),
            ),
            errorWidget(
                creditCardNumberErrorMessage, creditCardNumberErrorStatus),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: textBox("Enter Transaction Id", creditRefNumberController,
                  "Transaction Id", creditRefNumberErrorStatus),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: textBox("Select Date", cashDateController, "Payment Date",
                  cashDateErrorStatus),
            ),
            errorWidget(cashDateErrorMessage, cashDateErrorStatus)
          ],
        ),
      ),
    );
  }

  Widget editCustomerBottomSheet(BuildContext context, state) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.7,
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
                  if ((appointmentValidation() &&
                          startTimeController.text.isEmpty) &&
                      (noteValidation() &&
                          estimateNoteController.text.isEmpty) &&
                      networkImageList
                          .where((element) => element.isNotEmpty)
                          .toList()
                          .isEmpty) {
                    if (!isVehicleEdit) {
                      setState(() {
                        isCustomerEdit = true;
                      });
                      Navigator.pop(context);
                    }
                  } else {
                    // CommonWidgets().showDialog(context,
                    //     "Please save the unsaved changes before selecting the service");
                    // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                    if ((appointmentValidation() &&
                            startTimeController.text.isNotEmpty) ||
                        (noteValidation() &&
                            estimateNoteController.text.isNotEmpty) ||
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isNotEmpty) {
                      showPopUpBeforeService(context, null, "", false);
                    }
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
                      // SvgPicture.asset("assets/images/edit_pen_icon.svg",
                      //     color: !isVehicleEdit
                      //         ? AppColors.primaryColors
                      //         : Colors.grey),
                      Icon(Icons.change_circle_outlined,
                          color: !isVehicleEdit
                              ? AppColors.primaryColors
                              : Colors.grey),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Change Customer",
                          style: TextStyle(
                              color: !isVehicleEdit
                                  ? AppColors.primaryColors
                                  : Colors.grey,
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
                  if ((appointmentValidation() &&
                          startTimeController.text.isEmpty) &&
                      (noteValidation() &&
                          estimateNoteController.text.isEmpty) &&
                      networkImageList
                          .where((element) => element.isNotEmpty)
                          .toList()
                          .isEmpty) {
                    if (!isVehicleEdit &&
                        widget.estimateDetails.data.customer != null) {
                      // setState(() {
                      //   isCustomerEdit = true;
                      // });
                      // Navigator.pop(context);
                      //Navigate to edit customer screeen.
                      _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                          GetSingleCustomerDetailsEvent(
                              customerId: widget.estimateDetails.data.customerId
                                  .toString()));
                    }
                  } else {
                    // CommonWidgets().showDialog(context,
                    //     "Please save the unsaved changes before selecting the service");
                    // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                    if ((appointmentValidation() &&
                            startTimeController.text.isNotEmpty) ||
                        (noteValidation() &&
                            estimateNoteController.text.isNotEmpty) ||
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isNotEmpty) {
                      showPopUpBeforeService(context, null, "customer", false);
                    }
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
                      SvgPicture.asset("assets/images/edit_pen_icon.svg",
                          color: !isVehicleEdit &&
                                  widget.estimateDetails.data.customer != null
                              ? AppColors.primaryColors
                              : Colors.grey),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: state is GetSingleCustomerDetailsLoadingState
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : Text(
                                "Edit Customer",
                                style: TextStyle(
                                    color: !isVehicleEdit &&
                                            widget.estimateDetails.data
                                                    .customer !=
                                                null
                                        ? AppColors.primaryColors
                                        : Colors.grey,
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
                    if ((appointmentValidation() &&
                            startTimeController.text.isEmpty) &&
                        (noteValidation() &&
                            estimateNoteController.text.isEmpty) &&
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isEmpty) {
                      if (widget.estimateDetails.data.vehicle != null &&
                          !isCustomerEdit) {
                        setState(() {
                          isVehicleEdit = true;
                        });

                        Navigator.pop(context);
                      }
                    } else {
                      // CommonWidgets().showDialog(context,
                      //     "Please save the unsaved changes before selecting the service");
                      // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                      if ((appointmentValidation() &&
                              startTimeController.text.isNotEmpty) ||
                          (noteValidation() &&
                              estimateNoteController.text.isNotEmpty) ||
                          networkImageList
                              .where((element) => element.isNotEmpty)
                              .toList()
                              .isNotEmpty) {
                        showPopUpBeforeService(context, null, "", true);
                      }
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
                        // SvgPicture.asset(
                        //   "assets/images/edit_pen_icon.svg",
                        //   color: widget.estimateDetails.data.vehicle != null &&
                        //           !isCustomerEdit
                        //       ? AppColors.primaryColors
                        //       : Colors.grey,
                        // ),

                        Icon(
                          Icons.change_circle_outlined,
                          color: widget.estimateDetails.data.vehicle != null &&
                                  !isCustomerEdit
                              ? AppColors.primaryColors
                              : Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Change Vehicle",
                            style: TextStyle(
                                color: widget.estimateDetails.data.vehicle !=
                                            null &&
                                        !isCustomerEdit
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
                    if ((appointmentValidation() &&
                            startTimeController.text.isEmpty) &&
                        (noteValidation() &&
                            estimateNoteController.text.isEmpty) &&
                        networkImageList
                            .where((element) => element.isNotEmpty)
                            .toList()
                            .isEmpty) {
                      if (widget.estimateDetails.data.vehicle != null &&
                          !isCustomerEdit) {
                        // setState(() {
                        //   isVehicleEdit = true;

                        // });

                        // Navigator.pop(context);

                        //Navigate to vehicle edit screen.

                        _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                            GetSingleVehicleDetailsEvent(
                                vehicleId: widget.estimateDetails.data.vehicleId
                                    .toString()));
                      }
                    } else {
                      // CommonWidgets().showDialog(context,
                      //     "Please save the unsaved changes before selecting the service");
                      // if(appointmentValidation() && noteValidation() && startTImeController.text.isEmpty)
                      if ((appointmentValidation() &&
                              startTimeController.text.isNotEmpty) ||
                          (noteValidation() &&
                              estimateNoteController.text.isNotEmpty) ||
                          networkImageList
                              .where((element) => element.isNotEmpty)
                              .toList()
                              .isNotEmpty) {
                        showPopUpBeforeService(context, null, "vehicle", true);
                      }
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
                          color: widget.estimateDetails.data.vehicle != null &&
                                  !isCustomerEdit
                              ? AppColors.primaryColors
                              : Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Edit Vehicle",
                            style: TextStyle(
                                color: widget.estimateDetails.data.vehicle !=
                                            null &&
                                        !isCustomerEdit
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
                    startTimeController.text = DateFormat('hh : mm a')
                        .format(appointmentDetails.startOn)
                        .toString();
                    startTimeToServer = DateFormat('HH:mm')
                        .format(appointmentDetails.startOn)
                        .toString();

                    endTimeController.text = DateFormat('hh : mm a')
                        .format(appointmentDetails.endOn)
                        .toString();
                    endTimeToServer = DateFormat('HH:mm')
                        .format(appointmentDetails.endOn)
                        .toString();

                    appointmentController.text = appointmentDetails.notes;
                    startDateController.text =
                        "${appointmentDetails.startOn.month.toString().padLeft(2, '0')}-${appointmentDetails.startOn.day.toString().padLeft(2, '0')}-${appointmentDetails.startOn.year}";
                    startDateToServer =
                        "${appointmentDetails.startOn.year}-${appointmentDetails.startOn.month.toString().padLeft(2, '0')}-${appointmentDetails.startOn.day.toString().padLeft(2, '0')}";
                    endDateController.text =
                        "${appointmentDetails.endOn.month.toString().padLeft(2, '0')}-${appointmentDetails.endOn.day.toString().padLeft(2, '0')}-${appointmentDetails.endOn.year}";
                    endDateToServer =
                        "${appointmentDetails.endOn.year}-${appointmentDetails.endOn.month.toString().padLeft(2, '0')}-${appointmentDetails.endOn.day.toString().padLeft(2, '0')}";

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
    return StatefulBuilder(builder: (context, newSetState) {
      return SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
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
                  padding: const EdgeInsets.only(top: 24.0),
                  child: GestureDetector(
                    onTap: () {
                      newSetState(() {
                        isDrop = true;
                      });
                    },
                    child: isDrop
                        ? authorizeDrop(
                            newSetState,
                            context,
                            widget.estimateDetails.data.orderService![index].id
                                .toString(),
                            widget.estimateDetails.data.orderService![index]
                                .serviceName,
                            widget.estimateDetails.data.orderService![index]
                                .technicianId
                                .toString(),
                            authStatus)
                        : Container(
                            height: 56,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Color(0xffF6F6F6),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
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
                            materialAddModel.add(
                              CannedServiceAddModel(
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
                                vendorId: e.vendorId,
                                cost: e.markup,
                              ),
                            );
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
                              vendorId: e.vendorId,
                              cost: e.markup,
                            ));
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
                              vendorId: e.vendorId,
                              cost: e.markup,
                            ));
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
                              vendorId: e.vendorId,
                              cost: e.markup,
                            ));
                          } else if (e.itemType.toLowerCase() ==
                              "subcontract") {
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
                              vendorId: e.vendorId,
                              cost: e.markup,
                            ));
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
                                ? widget.estimateDetails.data
                                    .orderService![index].technicianId
                                    .toString()
                                : "",
                            orderId: widget.estimateDetails.data.id.toString(),
                            subContract: subContractAddModel,
                            service: cs.Datum(
                                id: widget.estimateDetails.data
                                    .orderService![index].id,
                                clientId: widget.estimateDetails.data.clientId,
                                serviceNote: widget.estimateDetails.data
                                    .orderService![index].serviceNote,
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
                                tax: widget.estimateDetails.data
                                    .orderService![index].tax,
                                subTotal: widget.estimateDetails.data
                                    .orderService![index].subTotal,
                                maintenancePeriod: widget.estimateDetails.data
                                    .orderService![index].maintenancePeriod,
                                maintenancePeriodType: widget
                                    .estimateDetails
                                    .data
                                    .orderService![index]
                                    .maintenancePeriodType,
                                communicationChannel: widget
                                    .estimateDetails
                                    .data
                                    .orderService![index]
                                    .communicationChannel,
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
                isDrop
                    ? const SizedBox()
                    : Padding(
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
                isDrop
                    ? const SizedBox()
                    : Padding(
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
      );
    });
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
              setState(() {
                isEstimateNoteEdit = false;
              });
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

              // Navigator.pop(context);
              // setState(() {

              // });
            }
            if (state is GetEstimateAppointmentState) {
              appointmentDetailsModel = state.estimateAppointmentModel;
              setState(() {});
              Navigator.pop(context);
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
              calculateAmount();

              //here calculation

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
            if (widget.navigation == "customer_navigation") {
              final estimate = widget.estimateDetails.data;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => CustomerInformationScreen(
                    id: estimate.customerId.toString(),
                  ),
                ),
              );
            } else if (widget.navigation == 'search') {
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
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
              // const Padding(
              //   padding: EdgeInsets.only(top: 16.0),
              //   child: Text(
              //     "Fusce lacinia sed metus eu fringilla. Phasellus\nlobortis maximus posuere nunc placerat.",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w400,
              //         color: AppColors.greyText,
              //         height: 1.5),
              //   ),
              // )
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
                        // GestureDetector(
                        //   onTap: () {
                        //     newSetState(() {
                        //       isDrop = true;
                        //     });
                        //   },
                        //   child: isDrop
                        //       ? authorizeDrop(newSetState)
                        //       : Container(
                        //           height: 56,
                        //           alignment: Alignment.center,
                        //           width: MediaQuery.of(context).size.width,
                        //           decoration: BoxDecoration(
                        //               color: Color(0xffF6F6F6),
                        //               borderRadius: BorderRadius.circular(8)),
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 24.0),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 const SizedBox(),
                        //                 Text(
                        //                   authorizedValues[authorizedIndex],
                        //                   style: const TextStyle(
                        //                       color: AppColors.primaryColors,
                        //                       fontSize: 16,
                        //                       fontWeight: FontWeight.w600),
                        //                 ),
                        //                 const Icon(
                        //                   Icons.keyboard_arrow_down_rounded,
                        //                   color: AppColors.primaryColors,
                        //                 )
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        // ),
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

  Widget authorizeDrop(StateSetter newSetState, BuildContext context, serviceId,
      serviceName, technicianId, auth) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
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
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // newSetState(() {
                      //   final temp = authorizedValues[0];
                      //   authorizedValues[0] = authorizedValues[1];
                      //   authorizedValues[1] = temp;

                      //   isDrop = false;
                      // });
                      newSetState(() {
                        authStatus = authorizedValues[1];
                        isDrop = false;
                      });

                      showAuthPopup(
                          authStatus == "Authorize"
                              ? "Authorize Service?"
                              : authStatus == "Decline"
                                  ? "Decline Service?"
                                  : "Unauthorize Service?",
                          authStatus == "Authorize"
                              ? "Do you want to authorize this service"
                              : authStatus == "Decline"
                                  ? "Do you want to decline the service?"
                                  : "Do you want to unauthorize this service?",
                          context,
                          authStatus,
                          serviceId,
                          technicianId,
                          serviceName);
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
                      // newSetState(() {
                      //   final temp = authorizedValues[0];
                      //   authorizedValues[0] = authorizedValues[2];
                      //   authorizedValues[2] = temp;

                      //   isDrop = false;
                      // });
                      newSetState(() {
                        authStatus = authorizedValues[2];
                        isDrop = false;
                      });
                      showAuthPopup(
                          authStatus == "Authorize"
                              ? "Authorize Service?"
                              : authStatus == "Decline"
                                  ? "Decline Service?"
                                  : "Unauthorize Service?",
                          authStatus == "Authorize"
                              ? "Do you want to authorize this service"
                              : authStatus == "Decline"
                                  ? "Do you want to decline the service?"
                                  : "Do you want to unauthorize this service?",
                          context,
                          authStatus,
                          serviceId,
                          technicianId,
                          serviceName);
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
              if (widget.navigation == "customer_navigation") {
                final estimate = widget.estimateDetails.data;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CustomerInformationScreen(
                      id: estimate.customerId.toString(),
                    ),
                  ),
                );
              } else if (widget.navigation == 'search') {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) {
                    return BottomBarScreen(
                      currentIndex: 3,
                    );
                  },
                ), (route) => false);
              }
            }
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

  Future showPopUpBeforeService(BuildContext ctx, constructor, String edit,
      [bool? isVehicle]) {
    return showCupertinoDialog(
      context: ctx,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is AddEstimateNoteState ||
                state is CreateAppointmentEstimateState ||
                state is EditEstimateNoteState ||
                state is EditAppointmentEstimateState ||
                state is EstimateCreateOrderImageState) {
              startTimeController.clear();
              endTimeController.clear();
              startDateController.clear();
              endDateController.clear();
              appointmentController.clear();
              estimateNoteController.clear();
              networkImageList.clear();
              networkImageList.addAll(["", "", "", ""]);
              if (constructor == null && edit == "") {
                if (widget.estimateDetails.data.vehicle != null) {
                  setState(() {
                    if (isVehicle == true) {
                      isVehicleEdit = true;
                    } else if (isVehicle == false) {
                      isCustomerEdit = true;
                    }
                  });
                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetEstimateAppointmentEvent(
                          orderId: widget.estimateDetails.data.id.toString()));

                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetEstimateNoteEvent(
                          orderId: widget.estimateDetails.data.id.toString()));
                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetAllOrderImageEvent(
                          orderId: widget.estimateDetails.data.id.toString()));

                  Navigator.pop(context);
                  Navigator.pop(context);
                }

                return;
              } else if (constructor == null && edit != "") {
                if (edit == "customer") {
                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetSingleCustomerDetailsEvent(
                          customerId: widget.estimateDetails.data.customerId
                              .toString()));
                } else if (edit == "vehicle") {
                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetSingleVehicleDetailsEvent(
                          vehicleId: widget.estimateDetails.data.vehicleId
                              .toString()));
                }
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return constructor;
                  },
                )).then((value) {
                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetEstimateAppointmentEvent(
                          orderId: widget.estimateDetails.data.id.toString()));

                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetEstimateNoteEvent(
                          orderId: widget.estimateDetails.data.id.toString()));
                  _scaffoldKey.currentContext!.read<EstimateBloc>().add(
                      GetAllOrderImageEvent(
                          orderId: widget.estimateDetails.data.id.toString()));
                  Navigator.pop(context);
                });
              }

              //  context.read<EstimateBloc>().add(GetSingleEstimateEvent(orderId: widget.estimateDetails.data.id.toString()));
            }
            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Save Changes?"),
                content: const Text(
                    "Save the unsaved changes before creating a service"),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text("Yes"),
                    onPressed: () {
                      if (!appointmentValidation() || !noteValidation()) {
                        Navigator.pop(context);
                        return;
                      }
                      if (appointmentValidation() &&
                          noteValidation() &&
                          startTimeController.text.isNotEmpty &&
                          !isCustomerEdit &&
                          !isVehicleEdit) {
                        if (isAppointmentEdit == false) {
                          context.read<EstimateBloc>().add(
                                CreateAppointmentEstimateEvent(
                                  startTime: startDateToServer +
                                      " " +
                                      startTimeToServer,
                                  endTime:
                                      endDateToServer + " " + endTimeToServer,
                                  orderId:
                                      widget.estimateDetails.data.id.toString(),
                                  appointmentNote: appointmentController.text,
                                  customerId: widget
                                      .estimateDetails.data.customerId
                                      .toString(),
                                  vehicleId: widget
                                          .estimateDetails.data.vehicle?.id
                                          .toString() ??
                                      "0",
                                ),
                              );

                          context.read<EstimateBloc>().add(EditEstimateEvent(
                              id: widget.estimateDetails.data.vehicle?.id
                                      .toString() ??
                                  "0",
                              orderId:
                                  widget.estimateDetails.data.id.toString(),
                              which: "vehicle",
                              customerId: widget
                                      .estimateDetails.data.customer?.id
                                      .toString() ??
                                  "",
                              dropScedule: endDateToServer,
                              vehicleCheckin: startDateToServer));
                        } else {
                          context
                              .read<EstimateBloc>()
                              .add(
                                  EditAppointmentEstimateEvent(
                                      startTime: startDateToServer +
                                          " " +
                                          startTimeToServer,
                                      endTime: endDateToServer +
                                          " " +
                                          endTimeToServer,
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

                          context.read<EstimateBloc>().add(EditEstimateEvent(
                              id: widget.estimateDetails.data.vehicle?.id
                                      .toString() ??
                                  "0",
                              orderId:
                                  widget.estimateDetails.data.id.toString(),
                              which: "vehicle",
                              customerId: widget
                                      .estimateDetails.data.customer?.id
                                      .toString() ??
                                  "",
                              dropScedule: endDateToServer,
                              vehicleCheckin: startDateToServer));
                        }
                      }

                      if ((noteValidation() &&
                              appointmentValidation() &&
                              estimateNoteController.text.trim().isNotEmpty) &&
                          !isCustomerEdit &&
                          !isVehicleEdit) {
                        if (!isEstimateNoteEdit) {
                          context.read<EstimateBloc>().add(AddEstimateNoteEvent(
                              orderId:
                                  widget.estimateDetails.data.id.toString(),
                              comment: estimateNoteController.text));
                        } else {
                          context.read<EstimateBloc>().add(
                              EditEstimateNoteEvent(
                                  orderId:
                                      widget.estimateDetails.data.id.toString(),
                                  comment: estimateNoteController.text,
                                  id: estimateNoteEditId));
                        }
                      }
                      //  }
                      if (networkImageList.isNotEmpty &&
                          noteValidation() &&
                          appointmentValidation() &&
                          !isCustomerEdit &&
                          !isVehicleEdit) {
                        log("Heree");
                        context.read<EstimateBloc>().add(
                              CreateOrderImageEvent(
                                imageUrlList: networkImageList.where((element) {
                                  return element != "";
                                }).toList(),
                                inspectionId: "",
                                orderId:
                                    widget.estimateDetails.data.id.toString(),
                              ),
                            );
                      }

                      if (appointmentValidation() && noteValidation()) {
                        if (isCustomerEdit && isVehicleEdit) {
                          CommonWidgets().showDialog(
                              context, "Please select a customer and vehicle");
                        } else if (isCustomerEdit) {
                          CommonWidgets()
                              .showDialog(context, "Please select a customer");
                        } else if (isVehicleEdit) {
                          CommonWidgets()
                              .showDialog(context, "Please select a vehicle");
                        }
                      }
                    },
                  ),
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

  Future showAuthPopup(String title, String message, BuildContext context,
      String auth, String serviceId, String technicianId, String serviceName) {
    bool changeStatus = false;
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is AuthServiceByTechnicianState) {
              // context.read<EstimateBloc>().add(GetSingleEstimateEvent(
              //     orderId: widget.estimateDetails.data.id.toString()));
              for (int i = 0;
                  i < widget.estimateDetails.data.orderService!.length;
                  i++) {
                print("in for");
                if (widget.estimateDetails.data.orderService![i].isAuthorized ==
                        "Y" &&
                    widget.estimateDetails.data.orderService![i]
                            .isAuthorizedCustomer ==
                        "Y") {
                  print("bteak");
                  changeStatus = true;
                  break;
                }
              }

              if (auth == "Decline" || auth == "Not Yet Authorized") {
                if (changeStatus) {
                  print("correct");
                  context.read<EstimateBloc>().add(ChangeEstimateStatusEvent(
                      orderId: widget.estimateDetails.data.id.toString(),
                      status: "Authorize"));
                } else {
                  context.read<EstimateBloc>().add(ChangeEstimateStatusEvent(
                      orderId: widget.estimateDetails.data.id.toString(),
                      status: auth));
                }
              } else {
                print("heree");
                context.read<EstimateBloc>().add(ChangeEstimateStatusEvent(
                    orderId: widget.estimateDetails.data.id.toString(),
                    status: auth));
              }
            }
            if (state is ChangeEstimateStatusState) {
              context.read<EstimateBloc>().add(GetSingleEstimateEvent(
                  orderId: widget.estimateDetails.data.id.toString()));
            }
            if (state is GetSingleEstimateState) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: widget.navigation,
                  );
                },
              ));
            }
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: Text(title),
                content: Text(message),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        context.read<EstimateBloc>().add(
                            AuthServiceByTechnicianEvent(
                                auth: auth,
                                serviceId: serviceId,
                                serviceName: serviceName,
                                technicianId: technicianId));
                      }),
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () => Navigator.of(context).pop(false),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  changeAuthIndex(String auth, String customerAuth) {
    if (auth == "Y" && customerAuth == "Y") {
      String temp = "";

      temp = authorizedValues[0];
      authorizedValues[0] = authorizedValues[1];
      authorizedValues[1] = temp;
    } else if (auth == "Y" && customerAuth == "N") {
      String temp = "";

      temp = authorizedValues[0];
      authorizedValues[0] = authorizedValues[2];
      authorizedValues[2] = temp;
    }
    // else{
    //     String temp = "";

    //   temp = authorizedValues[0];
    //   authorizedValues[0] = authorizedValues[2];
    //   authorizedValues[2] = temp;

    // }
  }

  Padding errorWidget(String errorString, bool errorStatus) {
    //log(errorStatus.toString() + errorString);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Visibility(
          visible: errorStatus,
          child: Text(
            errorString,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(
                0xffD80027,
              ),
            ),
          )),
    );
  }

  showImageView(String imageUrl, int index, List<dynamic> imageList) {
    List<String> newImageUrlList = [];
    imageList.forEach((element) {
      if (element is Datum) {
        newImageUrlList.add(element.fileName);
      } else {
        if (element.contains("http://")) {
          newImageUrlList.add(element);
        }
      }
    });
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter newSetState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            titlePadding: EdgeInsets.only(top: 18, left: 16, right: 20),
            contentPadding: EdgeInsets.only(top: 18, left: 0, right: 0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Inspection Photos ",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black)),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.close))
                  ],
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Container(
                height: 380,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  carouselController: buttonCarouselController,
                  options: CarouselOptions(
                      initialPage: index,
                      enableInfiniteScroll: false,
                      height: 380.0,
                      aspectRatio: 9 / 16,
                      viewportFraction: 1),
                  items: newImageUrlList.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: CachedNetworkImage(
                              imageUrl: i,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 8.8,
                                  height: 37,
                                  child: const CupertinoActivityIndicator(),
                                );
                              },
                            ));
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            insetPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).size.height * 0.15),
          );
        });
      },
    );
  }
}
