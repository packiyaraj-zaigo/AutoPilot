import 'dart:async';

import 'package:auto_pilot/Models/service_model.dart';
import 'package:auto_pilot/Screens/add_service_screen.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/service_info_screen.dart';

import 'package:auto_pilot/bloc/service_bloc/service_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ScrollController controller = ScrollController();
  // final List<Employee> servicesList = [];
  final List<Datum> servicesList = [];
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc()..add(GetAllServicess(query: "")),
      child: BlocListener<ServiceBloc, ServiceState>(
        listener: (context, state) {
          if (state is GetServiceSucessState) {
            servicesList.addAll(state.serviceModel.data.data);
          }
          // TODO: implement listener
        },
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              drawer: showDrawer(context),
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.primaryColors,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                ),
                backgroundColor: const Color(0xFFFAFAFA),
                elevation: 0,
                title: const Text(
                  'Autopilot',
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                ),
                centerTitle: true,
                actions: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddServiceScreen()));
                    },
                    child: const Icon(
                      Icons.add,
                      color: AppColors.primaryColors,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              body: SafeArea(
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
                              padding: const EdgeInsets.only(
                                  top: 14, bottom: 14, left: 16),
                              onChanged: (value) {
                                _debouncer.run(() {
                                  servicesList.clear();
                                  context
                                      .read<ServiceBloc>()
                                      .add(GetAllServicess(query: value));

                                  //  bloc.currentPage = 1;
                                  // bloc.add(GetAllEmployees(query: value));
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
                              placeholder: 'Search Services...',
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
                      const SizedBox(height: 14),
                      Expanded(
                          child: ScrollConfiguration(
                        behavior: const ScrollBehavior(),
                        child: state is GetServiceLoadingState
                            ? const Center(
                                child: CupertinoActivityIndicator(),
                              )
                            : servicesList.isEmpty
                                ? const Center(
                                    child: Text("No Service Found!"),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    controller: controller
                                      ..addListener(() {
                                        if ((BlocProvider.of<ServiceBloc>(
                                                        context)
                                                    .currentPage <=
                                                BlocProvider.of<ServiceBloc>(
                                                        context)
                                                    .totalPages) &&
                                            controller
                                                    .offset ==
                                                controller
                                                    .position.maxScrollExtent &&
                                            BlocProvider.of<ServiceBloc>(
                                                        context)
                                                    .currentPage !=
                                                0 &&
                                            !BlocProvider.of<ServiceBloc>(
                                                    context)
                                                .isFetching) {
                                          context.read<ServiceBloc>()
                                            ..isFetching = true
                                            ..add(GetAllServicess(query: ""));
                                        }
                                      }),
                                    itemBuilder: (context, index) {
                                      //   final item = servicesList[index];

                                      if (index == servicesList.length) {
                                        return BlocProvider.of<ServiceBloc>(
                                                            context)
                                                        .currentPage <=
                                                    BlocProvider.of<
                                                                ServiceBloc>(
                                                            context)
                                                        .totalPages &&
                                                BlocProvider.of<ServiceBloc>(
                                                            context)
                                                        .currentPage !=
                                                    0
                                            ? const SizedBox(
                                                height: 40,
                                                child:
                                                    CupertinoActivityIndicator(
                                                  color:
                                                      AppColors.primaryColors,
                                                ))
                                            : Container();
                                      }
                                      return Column(
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ServiceInfoScreen(
                                                    serviceData:
                                                        servicesList[index],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 12.0),
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
                                                        servicesList[index]
                                                            .serviceName,
                                                        // 'Basic Vinyl Wrap',
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
                                                      const SizedBox(height: 3),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'ID: ${servicesList[index].id}',
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
                                                          const Text(
                                                            'QTY:',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF6A7187),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            'MSRP: \$${servicesList[index].subTotal}',
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
                                          ),
                                          // bloc.currentPage <= bloc.totalPages &&
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
                                        ],
                                      );
                                    },
                                    itemCount: servicesList.length + 1),
                      )),
                    ],
                  ),
                ),
              ),
            );
          },
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
  //                 !bloc.isPagenationLoading &&
  //                 bloc.currentPage <= bloc.totalPages) {
  //               _debouncer.run(() {
  //                 bloc.isPagenationLoading = true;
  //                 bloc.add(GetAllEmployees());
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
