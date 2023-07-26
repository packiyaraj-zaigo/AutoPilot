import 'package:auto_pilot/Models/estimate_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class EstimateScreen extends StatefulWidget {
  const EstimateScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen>
    with TickerProviderStateMixin {
  EstimateModel? estimateModel;

  List<Datum> estimateData = [];
  List<Datum> ordersData = [];
  List<Datum> invoiceData = [];
  List<Datum> recentData = [];
  @override
  void initState() {
    //     TabController tabController = TabController(length: 4, vsync: this);
    // AppUtils().estimateTabController=tabController;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository()),
      child: Scaffold(
          // appBar: AppBar(
          //   leading: GestureDetector(
          //     child: Icon(Icons.menu)),
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          //   foregroundColor:AppColors.primaryColors ,
          //   title: const Text("AutoPilot",
          //   style: TextStyle(
          //     color: Color(0xff061237),
          //     fontSize: 16,
          //     fontWeight: FontWeight.w600
          //   ),),
          //   centerTitle: true,
          //   actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: AppColors.primaryColors,))],
          //   bottom:PreferredSize(
          //     preferredSize: const Size(double.infinity, 80),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //          const Padding(
          //            padding:  EdgeInsets.symmetric(horizontal:16.0),
          //            child: Text("Estimates",style: TextStyle(
          //                 color: AppColors.primaryTitleColor,
          //                 fontSize: 28,
          //                 fontWeight: FontWeight.w500
          //               ),),
          //          ),
          //         TabBar(
          //           controller: tabController,
          //           enableFeedback: false,
          //           indicatorColor: AppColors.primaryColors,

          //           unselectedLabelColor: const Color(0xFF9A9A9A),
          //           labelColor: AppColors.primaryColors,
          //           tabs: const [
          //             SizedBox(
          //               height: 50,
          //               child: Center(
          //               child: Text(
          //                 'Recent',
          //                 style: TextStyle(fontWeight: FontWeight.w500),
          //               ),
          //               ),
          //             ),
          //             SizedBox(
          //               height: 50,
          //               child: Center(
          //               child: Text(
          //                 'Estimates',
          //                 style: TextStyle(fontWeight: FontWeight.w500),
          //               ),
          //               ),
          //             ),
          //             SizedBox(
          //               height: 50,
          //               child: Center(
          //               child: Text(
          //                 'Orders',
          //                 style: TextStyle(fontWeight: FontWeight.w500),
          //               ),
          //               ),
          //             ),

          //                SizedBox(
          //               height: 50,
          //               child: Center(
          //               child: Text(
          //                 'Invoices',
          //                 style: TextStyle(fontWeight: FontWeight.w500),
          //               ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ) ,
          // ),
          //  drawer: showDrawer(context),
          body: TabBarView(controller: widget.tabController, children: [
        recentTabWidget(context),
        estimateTabWidget(context),
        ordersTabWidget(context),
        invoiceTabWidget(context)
      ])),
    );
  }

  Widget recentTabWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => EstimateBloc(apiRepository: ApiRepository())
        ..add(GetEstimateEvent(orderStatus: "")),
      child: BlocListener<EstimateBloc, EstimateState>(
        listener: (context, state) async {
          if (state is GetEstimateState) {
            recentData.addAll(state.estimateData.data.data);
          } else if (state is GetEstimateLoadingState) {
            recentData.clear();
          } else if (state is GetSingleEstimateState) {
            await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return EstimatePartialScreen(
                  estimateDetails: state.createEstimateModel,
                  navigation: "bottom_nav",
                );
              },
            )).then((value) {
              context.read<EstimateBloc>()
                ..add(GetEstimateEvent(orderStatus: ""));
            });
          }

          // TODO: implement listener
        },
        child: BlocBuilder<EstimateBloc, EstimateState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: state is GetEstimateState
                  ? recentData.isEmpty
                      ? const Center(
                          child: Text(
                            "No Data Found!",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                context.read<EstimateBloc>().add(
                                    GetSingleEstimateEvent(
                                        orderId:
                                            recentData[index].id.toString()));
                              },
                              child: tileWidget(
                                  recentData[index].orderStatus,
                                  recentData[index].orderNumber ?? "",
                                  recentData[index].customer?.firstName ?? "",
                                  "${recentData[index].vehicle?.vehicleYear} ${recentData[index].vehicle?.vehicleMake} ${recentData[index].vehicle?.vehicleModel}",
                                  recentData[index].estimationName ?? ""),
                            );
                          },
                          itemCount: recentData.length,
                        )
                  : const Center(
                      child: CupertinoActivityIndicator(),
                    ),
            );
          },
        ),
      ),
    );
  }

  //Estimate tab widget

  Widget estimateTabWidget(BuildContext context) {
    return Builder(builder: (context) {
      final estimateScrollController = ScrollController();

      print("hheyyy");
      return BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository())
          ..add(const GetEstimateEvent(orderStatus: "Estimate")),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) async {
            if (state is GetEstimateState) {
              estimateData.addAll(state.estimateData.data.data);
              print("estimate added");
            } else if (state is GetEstimateLoadingState) {
              estimateData.clear();
            } else if (state is GetSingleEstimateState) {
              await Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: "bottom_nav",
                  );
                },
              )).then((value) {
                context.read<EstimateBloc>()
                  ..add(GetEstimateEvent(orderStatus: ""));
              });
            }

            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: state is GetEstimateState
                    ? estimateData.isEmpty
                        ? const Center(
                            child: Text(
                              "No Estimate Found!",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              if (index == estimateData.length) {
                                return BlocProvider.of<EstimateBloc>(context)
                                                .currentPage <=
                                            BlocProvider.of<EstimateBloc>(
                                                    context)
                                                .totalPages &&
                                        BlocProvider.of<EstimateBloc>(context)
                                                .currentPage !=
                                            0
                                    ? const SizedBox(
                                        height: 40,
                                        child: CupertinoActivityIndicator(
                                          color: AppColors.primaryColors,
                                        ))
                                    : Container();
                              }

                              return GestureDetector(
                                onTap: () {
                                  context.read<EstimateBloc>().add(
                                      GetSingleEstimateEvent(
                                          orderId:
                                              recentData[index].id.toString()));
                                },
                                child: tileWidget(
                                    estimateData[index].orderStatus,
                                    estimateData[index].orderNumber ?? "",
                                    estimateData[index].customer?.firstName ??
                                        "",
                                    "${estimateData[index].vehicle?.vehicleYear} ${estimateData[index].vehicle?.vehicleMake} ${estimateData[index].vehicle?.vehicleModel}",
                                    estimateData[index].estimationName ?? ""),
                              );
                            },
                            controller: estimateScrollController
                              ..addListener(() {
                                if ((BlocProvider.of<EstimateBloc>(context)
                                            .currentPage <=
                                        BlocProvider.of<EstimateBloc>(context)
                                            .totalPages) &&
                                    estimateScrollController.offset ==
                                        estimateScrollController
                                            .position.maxScrollExtent &&
                                    BlocProvider.of<EstimateBloc>(context)
                                            .currentPage !=
                                        0 &&
                                    !BlocProvider.of<EstimateBloc>(context)
                                        .isFetching) {
                                  context.read<EstimateBloc>()
                                    ..isFetching = true
                                    ..add(GetEstimateEvent(
                                        orderStatus: "Estimate"));
                                }
                              }),
                            itemCount: estimateData.length + 1,
                          )
                    : const Center(
                        child: CupertinoActivityIndicator(),
                      ),
              );
            },
          ),
        ),
      );
    });
  }

  //Orders tab widget

  Widget ordersTabWidget(BuildContext context) {
    return Builder(builder: (context) {
      final orderScrollController = ScrollController();
      return BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository())
          ..add(GetEstimateEvent(orderStatus: "Orders")),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) async {
            if (state is GetEstimateState) {
              ordersData.addAll(state.estimateData.data.data);
              print("order added");
            } else if (state is GetEstimateLoadingState) {
              ordersData.clear();
            } else if (state is GetSingleEstimateState) {
              await Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: "bottom_nav",
                  );
                },
              )).then((value) {
                context.read<EstimateBloc>()
                  ..add(GetEstimateEvent(orderStatus: ""));
              });
            }

            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              print(ordersData);

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: state is GetEstimateState
                    ? ordersData.isEmpty
                        ? const Center(
                            child: Text(
                              "No Orders Found!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              if (index == ordersData.length) {
                                return BlocProvider.of<EstimateBloc>(context)
                                                .currentPage <=
                                            BlocProvider.of<EstimateBloc>(
                                                    context)
                                                .totalPages &&
                                        BlocProvider.of<EstimateBloc>(context)
                                                .currentPage !=
                                            0
                                    ? const SizedBox(
                                        height: 40,
                                        child: CupertinoActivityIndicator(
                                          color: AppColors.primaryColors,
                                        ))
                                    : Container();
                              }
                              return GestureDetector(
                                onTap: () {
                                  context.read<EstimateBloc>().add(
                                      GetSingleEstimateEvent(
                                          orderId: recentData[index % 15]
                                              .id
                                              .toString()));
                                },
                                child: tileWidget(
                                    ordersData[index].orderStatus,
                                    ordersData[index].orderNumber ?? "",
                                    ordersData[index].customer?.firstName ?? "",
                                    "${ordersData[index].vehicle?.vehicleYear} ${ordersData[index].vehicle?.vehicleMake} ${ordersData[index].vehicle?.vehicleModel}",
                                    ordersData[index].estimationName ?? ""),
                              );
                            },
                            controller: orderScrollController
                              ..addListener(() {
                                if ((BlocProvider.of<EstimateBloc>(context)
                                            .currentPage <=
                                        BlocProvider.of<EstimateBloc>(context)
                                            .totalPages) &&
                                    orderScrollController.offset ==
                                        orderScrollController
                                            .position.maxScrollExtent &&
                                    BlocProvider.of<EstimateBloc>(context)
                                            .currentPage !=
                                        0 &&
                                    !BlocProvider.of<EstimateBloc>(context)
                                        .isFetching) {
                                  context.read<EstimateBloc>()
                                    ..isFetching = true
                                    ..add(GetEstimateEvent(
                                        orderStatus: "Orders"));
                                }
                              }),
                            itemCount: ordersData.length + 1,
                          )
                    : const Center(
                        child: CupertinoActivityIndicator(),
                      ),
              );
            },
          ),
        ),
      );
    });
  }

  //Invoice tab widget

  Widget invoiceTabWidget(BuildContext context) {
    return Builder(builder: (context) {
      final invoiceScrollController = ScrollController();
      return BlocProvider(
        create: (context) => EstimateBloc(apiRepository: ApiRepository())
          ..add(GetEstimateEvent(orderStatus: "Invoice")),
        child: BlocListener<EstimateBloc, EstimateState>(
          listener: (context, state) async {
            if (state is GetEstimateState) {
              print("invoicec added");
              invoiceData.addAll(state.estimateData.data.data);
            } else if (state is GetEstimateLoadingState) {
              invoiceData.clear();
            } else if (state is GetSingleEstimateState) {
              await Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: "bottom_nav",
                  );
                },
              )).then((value) {
                context.read<EstimateBloc>()
                  ..add(GetEstimateEvent(orderStatus: ""));
              });
            }

            // TODO: implement listener
          },
          child: BlocBuilder<EstimateBloc, EstimateState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: state is GetEstimateLoadingState
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          if (index == invoiceData.length) {
                            return BlocProvider.of<EstimateBloc>(context)
                                            .currentPage <=
                                        BlocProvider.of<EstimateBloc>(context)
                                            .totalPages &&
                                    BlocProvider.of<EstimateBloc>(context)
                                            .currentPage !=
                                        0
                                ? const SizedBox(
                                    height: 40,
                                    child: CupertinoActivityIndicator(
                                      color: AppColors.primaryColors,
                                    ))
                                : Container();
                          }
                          return GestureDetector(
                            onTap: () {
                              context.read<EstimateBloc>().add(
                                  GetSingleEstimateEvent(
                                      orderId:
                                          recentData[index].id.toString()));
                            },
                            child: tileWidget(
                                invoiceData[index].orderStatus,
                                invoiceData[index].orderNumber ?? "",
                                invoiceData[index].customer?.firstName ?? "",
                                "${invoiceData[index].vehicle?.vehicleYear} ${invoiceData[index].vehicle?.vehicleMake} ${invoiceData[index].vehicle?.vehicleModel}",
                                invoiceData[index].estimationName ?? ""),
                          );
                        },
                        controller: invoiceScrollController
                          ..addListener(() {
                            if ((BlocProvider.of<EstimateBloc>(context)
                                        .currentPage <=
                                    BlocProvider.of<EstimateBloc>(context)
                                        .totalPages) &&
                                invoiceScrollController.offset ==
                                    invoiceScrollController
                                        .position.maxScrollExtent &&
                                BlocProvider.of<EstimateBloc>(context)
                                        .currentPage !=
                                    0 &&
                                !BlocProvider.of<EstimateBloc>(context)
                                    .isFetching) {
                              context.read<EstimateBloc>()
                                ..isFetching = true
                                ..add(GetEstimateEvent(orderStatus: "Invoice"));
                            }
                          }),
                        itemCount: invoiceData.length + 1,
                      ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget tileWidget(String estimateName, estimateId, String customerName,
      String carModel, String serviceName) {
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
              Row(
                children: [
                  SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                  const Text(
                    " 3/7/23 9:00 Am - ",
                    style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                  SvgPicture.asset("assets/images/calendar_estimate_icon.svg"),
                  const Text(
                    " 3/7/23 9:00 Am",
                    style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
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
}
