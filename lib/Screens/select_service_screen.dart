import 'dart:async';

import 'package:auto_pilot/Bloc/service_Bloc/service_bloc.dart';
import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/canned_service_model.dart';
import 'package:auto_pilot/Screens/add_service_screen.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/create_employee_screen.dart';
import 'package:auto_pilot/Screens/employee_details_screen.dart';

import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';

import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SelectServiceScreen extends StatefulWidget {
  const SelectServiceScreen(
      {super.key, required this.orderId, this.navigation});
  final String orderId;
  final String? navigation;

  @override
  State<SelectServiceScreen> createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController controller = ScrollController();
  // final List<Employee> servicesList = [];
  List<Datum> serviceList = [];
  String materialTax = "0";
  String partTax = "0";
  String laborTax = "0";

  final _debouncer = Debouncer();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc()
        ..add(GetAllServicess())
        ..add(GetClientByIdEvent()),
      child: Scaffold(
        key: scaffoldKey,
        drawer: showDrawer(context),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryColors,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xFFFAFAFA),
          elevation: 0,
          title: const Text(
            'Autopilot',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          centerTitle: true,
          // actions: [
          //   // GestureDetector(
          //   //   onTap: () {
          //   //     Navigator.of(context).push(MaterialPageRoute(
          //   //         builder: (context) => const AddServiceScreen()));
          //   //   },
          //   //   child: const Icon(
          //   //     Icons.add,
          //   //     color: AppColors.primaryColors,
          //   //     size: 30,
          //   //   ),
          //   // ),
          //   const SizedBox(
          //     width: 20,
          //   ),
          // ],
        ),
        body: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state) {
            if (state is GetClientSuccessState) {
              if (state.client.taxOnMaterial == "Y") {
                materialTax = state.client.materialTaxRate.toString();
              }
              if (state.client.taxOnLabors == "Y") {
                laborTax = state.client.laborTaxRate.toString();
              }
              if (state.client.taxOnParts == "Y") {
                partTax = state.client.salesTaxRate.toString();
              }
            }
            // TODO: implement listener
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        'Services',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        height: 50,
                        child: CupertinoTextField(
                          textAlignVertical: TextAlignVertical.bottom,
                          controller: searchController,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                if (searchController.text.isNotEmpty) {
                                  searchController.clear();
                                  BlocProvider.of<ServiceBloc>(
                                          scaffoldKey.currentContext!)
                                      .add(GetAllServicess(query: ""));
                                }
                              },
                              child: Icon(
                                Icons.close,
                                color: AppColors.primaryColors,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 14, bottom: 14, left: 16),
                          onChanged: (value) {
                            _debouncer.run(() {
                              serviceList.clear();
                              BlocProvider.of<ServiceBloc>(
                                      scaffoldKey.currentContext!)
                                  .currentPage = 1;
                              BlocProvider.of<ServiceBloc>(
                                      scaffoldKey.currentContext!)
                                  .add(GetAllServicess(query: value));
                            });
                          },
                          prefix: const Row(
                            children: [
                              SizedBox(width: 24),
                              Icon(
                                CupertinoIcons.search,
                                color: Color(0xFF7F808C),
                                size: 20,
                              ),
                            ],
                          ),
                          placeholder: 'Search Services',
                          maxLines: 1,
                          placeholderStyle: const TextStyle(
                            color: Color(0xFF7F808C),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: BlocListener<ServiceBloc, ServiceState>(
                      listener: (context, state) {
                        if (state is GetAllCannedServiceState) {
                          serviceList
                              .addAll(state.cannedServiceModel.data.data);
                        }
                      },
                      child: BlocBuilder<ServiceBloc, ServiceState>(
                        builder: (context, state) {
                          if (state is ServiceDetailsLoadingState &&
                              !BlocProvider.of<ServiceBloc>(context)
                                  .isPagenationLoading) {
                            return const Center(
                                child: CupertinoActivityIndicator());
                          } else {
                            return ScrollConfiguration(
                              behavior: const ScrollBehavior(),
                              child: serviceList.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      controller: controller
                                        ..addListener(() {
                                          if (controller.offset ==
                                                  controller.position
                                                      .maxScrollExtent &&
                                              !BlocProvider.of<ServiceBloc>(
                                                      context)
                                                  .isPagenationLoading &&
                                              BlocProvider.of<ServiceBloc>(
                                                          context)
                                                      .currentPage <=
                                                  BlocProvider.of<ServiceBloc>(
                                                          context)
                                                      .totalPages) {
                                            _debouncer.run(() {
                                              BlocProvider.of<ServiceBloc>(
                                                      context)
                                                  .isPagenationLoading = true;
                                              BlocProvider.of<ServiceBloc>(
                                                      context)
                                                  .add(GetAllServicess());
                                            });
                                          }
                                        }),
                                      itemBuilder: (context, index) {
                                        // final item = servicesList[index];
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         EmployeeDetailsScreen(
                                                //       employee: item,
                                                //     ),
                                                //   ),
                                                // );
                                                showPopup(context, "",
                                                    serviceList[index]);
                                              },
                                              child: Container(
                                                height: 77,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.07),
                                                      offset:
                                                          const Offset(0, 4),
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        // item.firstName ?? "",
                                                        serviceList[index]
                                                            .serviceName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF061237),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'ID: ${serviceList[index].id}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF6A7187),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          // const Text(
                                                          //   'QTY: 0',
                                                          //   overflow:
                                                          //       TextOverflow
                                                          //           .ellipsis,
                                                          //   style: TextStyle(
                                                          //     color: Color(
                                                          //         0xFF6A7187),
                                                          //     fontWeight:
                                                          //         FontWeight
                                                          //             .w400,
                                                          //   ),
                                                          // ),
                                                          Text(
                                                            'MSRP: \$ ${serviceList[index].subTotal}',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF6A7187),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // BlocProvider.of<ServiceBloc>(context).currentPage <= BlocProvider.of<ServiceBloc>(context).totalPages &&
                                            //         index == servicesList.length - 1
                                            //     ? const Column(
                                            //         children: [
                                            //           SizedBox(height: 24),
                                            //           Center(
                                            //             child:
                                            //                 CupertinoActivityIndicator(),
                                            //           ),
                                            //           SizedBox(height: 24),
                                            //         ],
                                            //       )
                                            //     : const SizedBox(),
                                            context
                                                            .read<ServiceBloc>()
                                                            .currentPage <=
                                                        context
                                                            .read<ServiceBloc>()
                                                            .totalPages &&
                                                    index ==
                                                        serviceList.length - 1
                                                ? Column(
                                                    children: [
                                                      SizedBox(height: 16),
                                                      Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                                      SizedBox(height: 16),
                                                    ],
                                                  )
                                                : SizedBox(height: 24)
                                          ],
                                        );
                                      },
                                      itemCount: serviceList.length)
                                  : const Center(
                                      child: Text(
                                        "No Service Found",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.greyText,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ScrollConfiguration customScrollView(BuildContext context) {
  //   print('here');
  //   return ScrollConfiguration(
  //     behavior: const ScrollBehavior(),
  //     child: StickyAzList(
  //         controller: controller
  //           ..addListener(() {
  //             if (controller.offset == controller.position.maxScrollExtent &&
  //                 !BlocProvider.of<ServiceBloc>(context).isPagenationLoading &&
  //                 BlocProvider.of<ServiceBloc>(context).currentPage <= BlocProvider.of<ServiceBloc>(context).totalPages) {
  //               _debouncer.run(() {
  //                 BlocProvider.of<ServiceBloc>(context).isPagenationLoading = true;
  //                 BlocProvider.of<ServiceBloc>(context).add(GetAllEmployees());
  //               });
  //             }
  //           }),
  //         options: const StickyAzOptions(
  //           scrollBarOptions: ScrollBarOptions(scrollable: true),
  //           listOptions: ListOptions(
  //             showSectionHeader: false,
  //           ),
  //         ),
  //         items: servicesList,
  //         builder: (context, index, item) {
  //           return Column(
  //             children: [
  //               GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: () {
  //                   Navigator.of(context).push(
  //                     MaterialPageRoute(
  //                       builder: (context) => const EmployeeDetailsScreen(),
  //                     ),
  //                   );
  //                 },
  //                 child: Container(
  //                   height: 77,
  //                   width: double.infinity,
  //                   decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: Colors.black.withOpacity(0.07),
  //                         offset: const Offset(0, 4),
  //                         blurRadius: 10,
  //                       ),
  //                     ],
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           item.firstName ?? "",
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                             color: Color(0xFF061237),
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 3),
  //                         Text(
  //                           item.roles?[0].name ?? '',
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                             color: Color(0xFF6A7187),
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //             ],
  //           );
  //         }),
  //   );
  // }

  Future showPopup(BuildContext ctx, message, Datum item) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) {
            if (state is CreateOrderServiceState) {
              //push to partial estiimate screen.
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              //   return EstimatePartialScreen(estimateDetails: estimateDetails)
              // },))
              if (item.cannedServiceItems != null &&
                  item.cannedServiceItems!.isNotEmpty) {
                for (int i = 0; i < item.cannedServiceItems!.length; i++) {
                  context.read<EstimateBloc>().add(
                        CreateOrderServiceItemEvent(
                          cannedServiceId: state.orderServiceId,
                          item: CannedServiceAddModel(
                            cannedServiceId: 0,
                            itemName: item.cannedServiceItems![i].itemName,
                            itemType: item.cannedServiceItems![i].itemType,
                            discount: item.cannedServiceItems![i].discount,
                            discountType:
                                item.cannedServiceItems![i].discountType,
                            quanityHours:
                                item.cannedServiceItems![i].quanityHours,
                            subTotal: item.cannedServiceItems![i].subTotal,
                            unitPrice: item.cannedServiceItems![i].unitPrice,
                            tax: item.cannedServiceItems![i].itemType ==
                                    "Material"
                                ? materialTax
                                : item.cannedServiceItems![i].itemType == "Part"
                                    ? partTax
                                    : laborTax,
                            cost: item.cannedServiceItems![i].markup,
                            note: item.cannedServiceItems![i].itemServiceNote ??
                                '',
                            part: item.cannedServiceItems![i].partName ?? '',
                            vendorId: item.cannedServiceItems![i].vendorId,
                          ),
                        ),
                      );
                }
              } else {
                context
                    .read<EstimateBloc>()
                    .add(GetSingleEstimateEvent(orderId: widget.orderId));
              }
            }

            if (state is GetSingleEstimateState) {
              int count = 3;
              // Navigator.pushReplacement(context, MaterialPageRoute(
              //   builder: (context) {
              //     return EstimatePartialScreen(
              //         estimateDetails: state.createEstimateModel);
              //   },
              // ));

              Navigator.pushAndRemoveUntil(ctx, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: widget.navigation,
                  );
                },
              ), (route) => count-- == 0);
            }
            if (state is CreateOrderServiceItemState) {
              context
                  .read<EstimateBloc>()
                  .add(GetSingleEstimateEvent(orderId: widget.orderId));
            }
            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text("Update Estimate?"),
                content:
                    const Text("Do you want to Add this Service to Estimate?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        // _debouncer.run(() {
                        if (state is! CreateOrderServiceLoadingState &&
                            state is! GetSingleEstimateLoadingState &&
                            state is! CreateOrderServiceItemLoadingState) {
                          context.read<EstimateBloc>().add(
                              CreateOrderServiceEvent(
                                  orderId: widget.orderId,
                                  serviceName: item.serviceName,
                                  serviceNotes: item.serviceNote.toString(),
                                  laborRate: item.serviceEpa,
                                  tax: item.tax,
                                  servicePrice: item.servicePrice,
                                  technicianId: "0"));
                        }
                        //  });

                        // Navigator.pop(context);
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

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
