// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Models/customer_note_model.dart';
import 'package:auto_pilot/Models/cutomer_message_model.dart' as cm;
import 'package:auto_pilot/Models/estimate_model.dart' as em;
import 'package:auto_pilot/Models/vechile_model.dart' as vm;
import 'package:auto_pilot/Screens/create_vehicle_screen.dart';
import 'package:auto_pilot/Screens/customers_screen.dart' as cs;
import 'package:auto_pilot/Screens/dummy_customer_screen.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:auto_pilot/Screens/vechile_information_screen.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_utils.dart';

class CustomerInformationScreen extends StatefulWidget {
  const CustomerInformationScreen({
    Key? key,
    required this.id,
    this.navigation,
  }) : super(key: key);
  final String id;
  final String? navigation;

  @override
  State<CustomerInformationScreen> createState() =>
      _CustomerInformationScreenState();
}

class _CustomerInformationScreenState extends State<CustomerInformationScreen> {
  Datum? customerData;

  final List<CustomerNoteModel> notes = [];
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
    SvgPicture.asset(
      "assets/images/chat_icon.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/car_icon.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/dollar.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
  ];
  int? selectedIndex = 0;
  List<Widget> messageChatWidgetList = [];
  List<cm.Datum> customerMessageList = [];
  List<em.Datum> estimateData = [];
  List<vm.Datum> vehicles = [];
  final messageController = TextEditingController();
  final chatScrollController = ScrollController();
  final estimateScrollController = ScrollController();
  final vehicleScrollController = ScrollController();
  int newIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CustomerBloc()..add(GetSingleCustomerEvent(id: widget.id)),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.primaryBackgroundColors,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (widget.navigation != null) {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const cs.CustomersScreen()),
                    (route) => false);
              }
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColors,
              size: AppStrings.fontSize16,
            ),
          ),
          title: Text(
            'Customer Information',
            style: TextStyle(
                color: AppColors.primaryBlackColors,
                fontSize: AppStrings.fontSize16,
                fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  showBottomSheet();
                },
                icon: Icon(
                  Icons.more_horiz,
                  size: AppStrings.fontSize20,
                  color: AppColors.primaryColors,
                )),
            const SizedBox(
              width: 20,
            )
          ],
        ),
        body: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerError) {
            } else if (state is DeleteCustomer) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return const cs.CustomersScreen();
                },
              ));
            } else if (state is DeleteCustomerErrorState) {
              Navigator.of(context).pop();
              CommonWidgets().showDialog(context, state.errorMsg);
            } else if (state is DeleteCustomerLoading) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => CupertinoActivityIndicator(),
              );
            } else if (state is CreateCustomerNoteSuccessState) {
              BlocProvider.of<CustomerBloc>(context).add(
                  GetAllCustomerNotesEvent(id: customerData!.id.toString()));
              Navigator.pop(context);
              CommonWidgets()
                  .showSuccessDialog(context, "Note Created Successfully");
            } else if (state is CreateCustomerNoteErrorState) {
              CommonWidgets().showDialog(context, state.message);
            } else if (state is DeleteCustomerNoteSuccessState) {
              BlocProvider.of<CustomerBloc>(context).add(
                  GetAllCustomerNotesEvent(id: customerData!.id.toString()));
              CommonWidgets()
                  .showSuccessDialog(context, "Note Deleted Successfully");
            } else if (state is DeleteCustomerNoteErrorState) {
              CommonWidgets().showDialog(context, state.message);
            } else if (state is GetCustomerNotesSuccessState) {
              notes.clear();
              notes.addAll(state.notes);
            } else if (state is GetCustomerNotesErrorState) {
              CommonWidgets().showDialog(context, state.message);
            }
            if (state is GetCustomerEstimatesSuccessState) {
              log('here');
              estimateData.addAll(state.estimateData.data.data);
            } else if (state is GetCustomerEstimatesLoadingState) {
              estimateData.clear();
            } else if (state is GetSingleEstimateState) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: 'customer_navigation',
                    customerId:
                        state.createEstimateModel.data.customer?.id ?? 0,
                  );
                },
              ));
            } else if (state is GetSingleCustomerErrorState) {
              CommonWidgets().showDialog(
                  context, "Something went wrong please try again later");
            } else if (state is GetSingleCustomerSuccessState) {
              customerData = state.customer;
            } else if (state is GetCustomerVehiclesSuccessState) {
              vehicles = state.vehicles.data.data;
            }
          },
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state is GetSingleCustomerErrorState) {
                return const Center(
                  child: Text(
                    "Something went wrong",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyText,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${customerData?.firstName ?? ''} ${customerData?.lastName ?? ''}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryTitleColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CupertinoSlidingSegmentedControl(
                        onValueChanged: (value) {
                          setState(() {
                            selectedIndex = value ?? 0;
                            customerMessageList.clear();
                          });
                          if (value == 0) {
                            BlocProvider.of<CustomerBloc>(context).add(
                                GetSingleCustomerEvent(
                                    id: customerData!.id.toString()));
                          }
                          if (value == 1) {
                            BlocProvider.of<CustomerBloc>(context).add(
                                GetAllCustomerNotesEvent(
                                    id: customerData!.id.toString()));
                          } else if (value == 2) {
                            BlocProvider.of<CustomerBloc>(context)
                                .messageCurrentPage = 1;
                            BlocProvider.of<CustomerBloc>(context)
                                .messageTotalPage = 1;
                            BlocProvider.of<CustomerBloc>(context)
                                .add(GetCustomerMessageEvent());
                          } else if (value == 3) {
                            BlocProvider.of<CustomerBloc>(context).currentPage =
                                1;
                            BlocProvider.of<CustomerBloc>(context).add(
                                GetCustomerVehiclesEvent(
                                    id: customerData!.id.toString()));
                          } else if (value == 4) {
                            BlocProvider.of<CustomerBloc>(context).currentPage =
                                1;
                            estimateData.clear();
                            BlocProvider.of<CustomerBloc>(context).add(
                                GetCustomerEstimatesEvent(
                                    customerId: customerData!.id.toString()));
                          }
                        },
                        groupValue: selectedIndex,
                        children: {
                          for (int i = 0; i < _segmentTitles.length; i++)
                            i: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 25),
                              child: _segmentTitles[i],
                            )
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      selectedIndex == 0
                          ? detailsWidget(context, state)
                          : selectedIndex == 1
                              ? Expanded(
                                  child: notesWidget(state),
                                )
                              : selectedIndex == 2
                                  ? chatWidget(context)
                                  : selectedIndex == 3
                                      ? vehiclesWidget(state)
                                      : estimateWidget(state, context)
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget vehiclesWidget(state) {
    if (state is GetCustomerVehiclesLoadingState) {
      return const Expanded(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      );
    }
    return vehicles.isEmpty
        ? Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 280,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Vehicle Found',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTextColors),
                  ),
                ],
              ),
            ),
          )
        : Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: ListView.separated(
                  shrinkWrap: true,
                  controller: vehicleScrollController
                    ..addListener(() {
                      print('object');
                      if (vehicleScrollController.offset ==
                              vehicleScrollController
                                  .position.maxScrollExtent &&
                          !BlocProvider.of<CustomerBloc>(context)
                              .isPagenationLoading &&
                          BlocProvider.of<CustomerBloc>(context).currentPage <=
                              BlocProvider.of<CustomerBloc>(context)
                                  .totalPages) {
                        BlocProvider.of<CustomerBloc>(context)
                            .isPagenationLoading = true;
                        BlocProvider.of<CustomerBloc>(context).add(
                            GetCustomerVehiclesEvent(
                                id: customerData!.id.toString()));
                      }
                    }),
                  itemBuilder: (context, index) {
                    final item = vehicles[index];
                    return Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VechileInformation(
                                  vehicleId: item.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 77,
                            width: double.infinity,
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${item.vehicleYear} ${item.vehicleModel}',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.primaryTitleColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      (item.firstName ?? "") +
                                          " " +
                                          (item.lastName ?? ''),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.greyText,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        BlocProvider.of<CustomerBloc>(context).currentPage <=
                                    BlocProvider.of<CustomerBloc>(context)
                                        .totalPages &&
                                index == vehicles.length - 1
                            ? const Column(
                                children: [
                                  SizedBox(height: 24),
                                  Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  SizedBox(height: 24),
                                ],
                              )
                            : const SizedBox(),
                        index == vehicles.length - 1
                            ? const SizedBox(height: 24)
                            : const SizedBox(),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemCount: vehicles.length),
            ),
          );
  }

  Expanded detailsWidget(BuildContext context, state) {
    return Expanded(
      child: state is GetSingleCustomerLoadingState
          ? Center(child: CupertinoActivityIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              color: const Color(0xffF9F9F9),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Phone",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGrayColors),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              customerData != null &&
                                      customerData!.phone.isEmpty
                                  ? ''
                                  : '(${customerData?.phone.substring(0, 3)}) ${customerData?.phone.substring(3, 6)}-${customerData?.phone.substring(6)}'
                              // customerData!.phone.toString()
                              ,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryTitleColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                final Uri smsLaunchUri = Uri(
                                  scheme: 'sms',
                                  path: customerData!.phone,
                                  queryParameters: <String, String>{
                                    'body': Uri.encodeComponent(' '),
                                  },
                                );
                                launchUrl(smsLaunchUri);
                              },
                              icon: SizedBox(
                                height: 27,
                                width: 18,
                                child: SvgPicture.asset(
                                  'assets/images/sms_icons.svg',
                                  height: 27,
                                  color: AppColors.primaryColors,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            IconButton(
                              onPressed: () {
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'tel',
                                  path: customerData!.phone ?? '',
                                );

                                launchUrl(emailLaunchUri);
                              },
                              icon: SizedBox(
                                height: 27,
                                width: 18,
                                child: SvgPicture.asset(
                                  'assets/images/phone_icon.svg',
                                  height: 27,
                                  color: AppColors.primaryColors,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    AppUtils.verticalDivider(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Email",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGrayColors),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              (customerData?.email ?? '').toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryTitleColor),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            String? encodeQueryParameters(
                                Map<String, String> params) {
                              return params.entries
                                  .map((MapEntry<String, String> e) =>
                                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                  .join('&');
                            }

                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: customerData!.email,
                              query: encodeQueryParameters(<String, String>{
                                'subject': ' ',
                              }),
                            );

                            launchUrl(emailLaunchUri);
                          },
                          icon: Container(
                            // color: Colors.red,
                            height: 18,
                            width: 18,
                            child: SvgPicture.asset(
                              'assets/images/mail_icons.svg',
                              height: 27,
                              color: AppColors.primaryColors,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppUtils.verticalDivider(),
                    const SizedBox(
                      height: 14,
                    ),
                    const Text(
                      "Address",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryGrayColors),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      customerData != null && customerData!.addressLine1 == null
                          ? ''
                          : (customerData?.addressLine1).toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTitleColor),
                    ),
                    AppUtils.verticalDivider(),
                    const SizedBox(
                      height: 14,
                    ),
                    // const Text(
                    //   "License Number",
                    //   style: TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w400,
                    //       color: AppColors.primaryGrayColors),
                    // ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // const Text(
                    //   "Need to change",
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w500,
                    //       color: AppColors.primaryTitleColor),
                    // ),
                    // AppUtils.verticalDivider(),
                    // const SizedBox(
                    //   height: 14,
                    // ),
                    const Text(
                      "Customer Created",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primaryGrayColors),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      customerData == null || customerData!.createdAt == null
                          ? ""
                          : AppUtils.getFormattedForInformationScreen(
                                  (customerData?.createdAt).toString())
                              .toString(),
                      // customerData!.createdAt.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryTitleColor),
                    ),
                    AppUtils.verticalDivider(),
                    const SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              )),
    );
  }

  Expanded estimateWidget(CustomerState state, BuildContext context) {
    return Expanded(
      child: state is GetCustomerEstimatesSuccessState
          ? estimateData.isEmpty
              ? const Center(
                  child: Text(
                    "No Estimate Found!",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == estimateData.length) {
                      return BlocProvider.of<CustomerBloc>(context)
                                      .currentPage <=
                                  BlocProvider.of<CustomerBloc>(context)
                                      .totalPages &&
                              BlocProvider.of<CustomerBloc>(context)
                                      .currentPage !=
                                  0
                          ? const SizedBox(
                              height: 40,
                              child: CupertinoActivityIndicator(
                                color: AppColors.primaryColors,
                              ))
                          : Container();
                    }

                    return BlocProvider(
                      create: (context) => CustomerBloc(),
                      child: GestureDetector(
                        onTap: () {
                          context.read<CustomerBloc>().add(
                              GetSingleEstimateEvent(
                                  orderId: estimateData[index].id.toString()));
                        },
                        child: tileWidget(
                          estimateData[index].orderStatus,
                          estimateData[index].orderNumber ?? "",
                          estimateData[index].customer?.firstName ?? "",
                          "${estimateData[index].vehicle?.vehicleYear ?? ""} ${estimateData[index].vehicle?.vehicleMake ?? ""} ${estimateData[index].vehicle?.vehicleModel ?? ""}",
                          estimateData[index].estimationName ?? "",
                          estimateData[index].dropSchedule ?? "",
                        ),
                      ),
                    );
                  },
                  controller: estimateScrollController
                    ..addListener(() {
                      if ((BlocProvider.of<CustomerBloc>(context).currentPage <=
                              BlocProvider.of<CustomerBloc>(context)
                                  .totalPages) &&
                          estimateScrollController.offset ==
                              estimateScrollController
                                  .position.maxScrollExtent &&
                          BlocProvider.of<CustomerBloc>(context).currentPage !=
                              0 &&
                          !BlocProvider.of<CustomerBloc>(context).isFetching) {
                        context.read<CustomerBloc>()
                          ..isFetching = true
                          ..add(GetCustomerEstimatesEvent(
                              customerId: customerData!.id.toString()));
                      }
                    }),
                  itemCount: estimateData.length + 1,
                )
          : const Center(
              child: CupertinoActivityIndicator(),
            ),
    );
  }

  Widget tileWidget(String estimateName, estimateId, String customerName,
      String carModel, String serviceName, String dropSchedule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 1,
                blurRadius: 6,
                color: Color.fromRGBO(88, 88, 88, 0.178),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dropSchedule != ""
                  ? Row(
                      children: [
                        SvgPicture.asset(
                            "assets/images/calendar_estimate_icon.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            dropSchedule.substring(0, 10),
                            style: const TextStyle(
                                color: AppColors.greyText,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        // SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                        // const Text(
                        //   " 3/7/23 9:00 Am",
                        //   style: TextStyle(
                        //       color: AppColors.greyText,
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w400),
                        // )
                      ],
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "${estimateName} #${estimateId} - ${serviceName}",
                  style: const TextStyle(
                      color: AppColors.primaryColors,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  customerName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  carModel,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column notesWidget(CustomerState state) {
    return Column(
      mainAxisAlignment: state is GetCustomerNotesLoadingState
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: state is GetCustomerNotesLoadingState
          ? [
              const Center(child: CupertinoActivityIndicator()),
            ]
          : [
              addNoteButton(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: notes.isEmpty
                    ? const Center(
                        child: Text('No Notes Found',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyText)))
                    : ScrollConfiguration(
                        behavior: const ScrollBehavior(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: notes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return noteCard(notes[index]);
                          },
                        ),
                      ),
              )
            ],
    );
  }

  Padding noteCard(CustomerNoteModel note) {
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
                      AppUtils.getFormattedForNotesScreen(
                          note.createdAt.toString()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showNoteDeleteDialog(note.id.toString());
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
                  note.notes,
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

  GestureDetector addNoteButton() {
    return GestureDetector(
      onTap: () {
        addNotePopup();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.buttonColors),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primaryColors,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'Add New Note',
              style: AppUtils.cardStyle(),
            )
          ],
        ),
      ),
    );
  }

  showNoteDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Delete note?"),
        content: const Text('Do you really want to delete this note?'),
        actions: [
          CupertinoButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
              BlocProvider.of<CustomerBloc>(scaffoldKey.currentContext!).add(
                DeleteCustomerNoteEvent(
                  id: id,
                ),
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
  }

  showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: Container(
                      height: 6,
                      width: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: AppColors.buttonColors,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text(
                      "Select an option",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppUtils.verticalDivider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18),
                    child: Column(
                      children: [
                        estimatePopUpTile(
                          context,
                          Icons.add,
                          "New Vehicle",
                          CreateVehicleScreen(
                            customerId: customerData!.id.toString(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        estimatePopUpTile(
                          context,
                          Icons.add,
                          "New Estimate",
                          DummyCustomerScreen(
                            customerId: customerData!.id.toString(),
                            navigation: 'customer_navigation',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        estimatePopUpTile(
                          context,
                          Icons.edit,
                          "Edit Customer",
                          NewCustomerScreen(
                            customerEdit: customerData!,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        deleteCustomerWidget(context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.primaryColors,
                              fontWeight: FontWeight.w500,
                              fontFamily: '.SF Pro Text',
                              fontSize: 16),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox deleteCustomerWidget(BuildContext context) {
    return SizedBox(
        height: 57,
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.buttonColors,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: AppColors.primaryColors,
                  size: 16,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Delete Customer',
                  style: TextStyle(
                      color: AppColors.primaryColors,
                      fontFamily: '.SF Pro Text',
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
            onPressed: () async {
              Navigator.of(context).pop(true);
              showDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Delete customer?"),
                  content:
                      const Text('Do you really want to delete this customer?'),
                  actions: [
                    CupertinoButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        BlocProvider.of<CustomerBloc>(context).add(
                            DeleteCustomerEvent(
                                customerId: customerData!.id.toString(),
                                context: context));
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
            }));
  }

  SizedBox estimatePopUpTile(
      BuildContext context, IconData icon, String title, constructor) {
    return SizedBox(
      height: 57,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: AppColors.buttonColors,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppColors.primaryColors,
              size: 16,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w500,
                  fontFamily: '.SF Pro Text',
                  fontSize: 16),
            ),
          ],
        ),
        onPressed: title == "New Vehicle" ||
                title == "New Estimate" ||
                title == "Edit Customer"
            ? () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => constructor),
                );
                setState(() {
                  if (title == "New Vehicle") {
                    BlocProvider.of<CustomerBloc>(context).currentPage = 1;
                  }
                });
              }
            : () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => constructor),
                (route) => false),
      ),
    );
  }

  Widget chatWidget(BuildContext context) {
    log("re build");
    return BlocListener<CustomerBloc, CustomerState>(
      listener: (context, state) async {
        if (state is GetCustomerMessageState) {
          customerMessageList.addAll(state.messageModel.data.data);
          customerMessageList.sort((a, b) {
            return a.createdAt.compareTo(b.createdAt);
          });
          if (state.messageModel.data.currentPage == 1) {
            Future.delayed(Duration(milliseconds: 300)).then((value) {
              chatScrollController.animateTo(
                  chatScrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear);
            });
          }
        } else if (state is SendCustomerMessageState) {
        } else if (state is GetCustomerMessagePaginationState) {
          customerMessageList.insertAll(0, state.messageModel.data.data);
          Future.delayed(Duration(milliseconds: 300)).then((value) {
            chatScrollController.animateTo(50 * 15,
                duration: Duration(milliseconds: 300), curve: Curves.linear);
          });

          print("pagniation state emited");
          print(customerMessageList.length);
        }
        // TODO: implement listener
      },
      child: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          log(BlocProvider.of<CustomerBloc>(context)
                  .messageCurrentPage
                  .toString() +
              "in char widget");
          return Expanded(
            // width: MediaQuery.of(context).size.width,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                chatBoxWidget(customerMessageList, context),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          messageChipWidget("Ready for pickup"),
                          messageChipWidget("Working on.."),
                          messageChipWidget("We are delayed")
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 0.7,
                              spreadRadius: 1.2,
                              offset: Offset(3, 2))
                        ]),

                    // child: Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal:22.0),
                    //   child: Row(
                    //     children: [
                    //       SvgPicture.asset("assets/images/attachment_icon.svg"),

                    //       TextField(
                    //         decoration: InputDecoration(
                    //           hintText: "Enter your message..",
                    //           contentPadding: EdgeInsets.all(0)
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 18),
                          hintText: "Enter your messsage..",
                          // prefixIcon: Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: SizedBox(
                          //       height: 20,
                          //       width: 20,
                          //       child: SvgPicture.asset(
                          //           "assets/images/attachment_icon.svg")),
                          // ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                // setState(() {
                                //   messageChatWidgetList.add(chatBubleWidget(
                                //       messageController.text,""));

                                //   messageController.clear();
                                // });

                                if (messageController.text.trim().isNotEmpty) {
                                  context.read<CustomerBloc>().add(
                                      SendCustomerMessageEvent(
                                          customerId:
                                              customerData!.id.toString(),
                                          messageBody: messageController.text));

                                  cm.Datum localMessage = cm.Datum(
                                      clientId: customerData!.clientId,
                                      createdAt: DateTime.now(),
                                      id: customerData!.id,
                                      messageBody: messageController.text,
                                      messageType: "",
                                      receiverCustomerId: null,
                                      status: "Open",
                                      updatedAt: DateTime.now(),
                                      sendCustomer: "",
                                      senderUserId: null);
                                  customerMessageList.add(localMessage);
                                  messageController.clear();
                                  await Future.delayed(
                                          Duration(milliseconds: 500))
                                      .then((_) {
                                    chatScrollController.animateTo(
                                        chatScrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
                                  });
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.primaryColors,
                                child: SvgPicture.asset(
                                    "assets/images/send_icon.svg"),
                              ),
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget messageChipWidget(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0),
      child: GestureDetector(
        onTap: () {
          messageController.text = text;
        },
        child: Container(
          // height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryColors)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13),
            child: Text(
              text,
              style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget chatBoxWidget(List<cm.Datum> messsageModelList, BuildContext context) {
    log("re build");
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        log(messsageModelList.length.toString());
        return Expanded(
          child: ListView.builder(
              reverse: true,
              // messagemobileList
              itemBuilder: (context2, index) {
                final messages = messsageModelList.reversed.toList();
                newIndex = index;

                return chatBubleWidget(
                    messages[index].messageBody,
                    AppUtils.getTimeFormattedForMessage(
                        messages[index].createdAt.toString()));
              },
              itemCount: messsageModelList.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              controller: chatScrollController
                ..addListener(() {
                  if ((BlocProvider.of<CustomerBloc>(context)
                              .messageCurrentPage <=
                          BlocProvider.of<CustomerBloc>(context)
                              .messageTotalPage) &&
                      chatScrollController.offset ==
                          chatScrollController.position.maxScrollExtent &&
                      BlocProvider.of<CustomerBloc>(context)
                              .messageCurrentPage !=
                          0 &&
                      !BlocProvider.of<CustomerBloc>(context).isFetching) {
                    print("here");
                    context.read<CustomerBloc>()
                      ..isFetching = true
                      ..add(GetCustomerMessageEvent());
                  }
                })),
        );
      },
    );
  }

  Widget chatBubleWidget(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.primaryColors,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.7,
                        minWidth: 80),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        //  Expanded(child: SizedBox()),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 6.0),
                        //   child: SvgPicture.asset(
                        //       "assets/images/Double_tick_icon.svg"),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //   ),
          //  ),
        ],
      ),
    );
  }

  addNotePopup() {
    final TextEditingController addNoteController = TextEditingController();
    String addNoteErrorStatus = '';
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text("New Customer Note",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryTitleColor,
                    height: 1.7,
                    letterSpacing: 0.3)),
            actions: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.clear,
                  size: 18,
                  color: AppColors.primaryColors,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: StatefulBuilder(builder: (context, setDialog) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6A7187),
                          ),
                        ),
                        Text(
                          " *",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(
                              0xffD80027,
                            ),
                          ),
                        ),
                      ],
                    ),
                    notesTextBox(addNoteController, addNoteErrorStatus),
                    errorWidget(addNoteErrorStatus),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: BlocListener<CustomerBloc, CustomerState>(
                        listener: (context, state) {
                          if (state is CreateCustomerNoteSuccessState) {
                            BlocProvider.of<CustomerBloc>(
                                    scaffoldKey.currentContext!)
                                .add(GetAllCustomerNotesEvent(id: widget.id));
                            Navigator.of(context).pop();
                            CommonWidgets().showSuccessDialog(
                                context, 'Note Crated Successfully');
                          }
                        },
                        child: BlocBuilder<CustomerBloc, CustomerState>(
                          builder: (context, state) {
                            if (state is CreateCustomerNoteLoadingState) {
                              return const Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child:
                                    Center(child: CupertinoActivityIndicator()),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                if (addNoteController.text.isEmpty) {
                                  addNoteErrorStatus = "Note can't be empty";
                                } else {
                                  addNoteErrorStatus = '';
                                  BlocProvider.of<CustomerBloc>(context).add(
                                      CreateCustomerNoteEvent(
                                          customerId:
                                              customerData!.id.toString(),
                                          notes:
                                              addNoteController.text.trim()));
                                }
                                setDialog(() {});
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 56,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primaryColors),
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
      isScrollControlled: true,
      useSafeArea: true,
    );

    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return StatefulBuilder(builder: (context, setDialog) {
    //       return AlertDialog(
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    //         title: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             const Text("Add Note"),
    //             GestureDetector(
    //                 onTap: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child:
    //                     const Icon(Icons.close, color: AppColors.primaryColors))
    //           ],
    //         ),
    //         insetPadding:
    //             const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
    //         content: SizedBox(
    //           height: addNoteErrorStatus.isNotEmpty ? 290 : 270,
    //           width: MediaQuery.of(context).size.width - 32,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               notesTextBox(addNoteController, addNoteErrorStatus),
    //               errorWidget(addNoteErrorStatus),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 24.0),
    //                 child: BlocBuilder<CustomerBloc, CustomerState>(
    //                   builder: (context, state) {
    //                     if (state is CreateCustomerNoteLoadingState) {
    //                       return const Padding(
    //                         padding: EdgeInsets.only(top: 24.0),
    //                         child: Center(child: CupertinoActivityIndicator()),
    //                       );
    //                     }
    //                     return GestureDetector(
    //                       onTap: () {
    //                         if (addNoteController.text.isEmpty) {
    //                           addNoteErrorStatus = "Note can't be empty";
    //                         } else {
    //                           addNoteErrorStatus = '';
    //                           BlocProvider.of<CustomerBloc>(context).add(
    //                               CreateCustomerNoteEvent(
    //                                   customerId:
    //                                       customerData!.id.toString(),
    //                                   notes: addNoteController.text.trim()));
    //                         }
    //                         setDialog(() {});
    //                       },
    //                       child: Container(
    //                         width: MediaQuery.of(context).size.width,
    //                         height: 56,
    //                         alignment: Alignment.center,
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(12),
    //                             color: AppColors.primaryColors),
    //                         child: const Text(
    //                           "Confirm",
    //                           style: TextStyle(
    //                               fontSize: 14,
    //                               fontWeight: FontWeight.w500,
    //                               color: Colors.white),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       );
    //     });
    //   },
    // );
  }

  Padding errorWidget(String errorString) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Visibility(
          visible: errorString.isNotEmpty,
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

  notesTextBox(
      TextEditingController addNoteController, String addNoteErrorStatus) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - kToolbarHeight - 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: TextField(
          controller: addNoteController,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            hintText: "Enter Notes",
            hintStyle: const TextStyle(fontSize: 16),
            counterText: "",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: addNoteErrorStatus.isNotEmpty
                    ? const Color(0xffD80027)
                    : const Color(0xffC1C4CD),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: addNoteErrorStatus.isNotEmpty
                    ? const Color(0xffD80027)
                    : const Color(0xffC1C4CD),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: addNoteErrorStatus.isNotEmpty
                    ? const Color(0xffD80027)
                    : const Color(0xffC1C4CD),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
