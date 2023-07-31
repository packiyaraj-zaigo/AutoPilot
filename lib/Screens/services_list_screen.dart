import 'dart:async';
import 'dart:developer';

import 'package:auto_pilot/Bloc/service_Bloc/service_bloc.dart';
import 'package:auto_pilot/Models/canned_service_model.dart';
import 'package:auto_pilot/Screens/add_service_screen.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/canned_service_details.dart';

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
  List<Datum> serviceList = [];
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc()..add(GetAllServicess()),
      child: Scaffold(
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
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
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
                        serviceList.addAll(state.cannedServiceModel.data.data);
                      } else if (state is ServiceDetailsErrorState) {
                        log(state.message);
                      }
                    },
                    child: BlocBuilder<ServiceBloc, ServiceState>(
                      builder: (context, state) {
                        print(state);
                        print(serviceList);
                        if (state is ServiceDetailsLoadingState &&
                            !BlocProvider.of<ServiceBloc>(context)
                                .isPagenationLoading) {
                          return const Center(
                              child: CupertinoActivityIndicator());
                        } else {
                          if (serviceList.isEmpty) {
                            return const Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No Services Found',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.greyText,
                                        fontWeight: FontWeight.w600))
                              ],
                            ));
                          }
                          return ScrollConfiguration(
                            behavior: const ScrollBehavior(),
                            child: ListView.builder(
                                shrinkWrap: true,
                                controller: controller
                                  ..addListener(() {
                                    if (controller.offset ==
                                            controller
                                                .position.maxScrollExtent &&
                                        !BlocProvider.of<ServiceBloc>(context)
                                            .isPagenationLoading &&
                                        BlocProvider.of<ServiceBloc>(context)
                                                .currentPage <=
                                            BlocProvider.of<ServiceBloc>(
                                                    context)
                                                .totalPages) {
                                      _debouncer.run(() {
                                        BlocProvider.of<ServiceBloc>(context)
                                            .isPagenationLoading = true;
                                        BlocProvider.of<ServiceBloc>(context)
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
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CannedServiceDetailsPage(
                                                service: serviceList[index],
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
                                                color: Colors.black
                                                    .withOpacity(0.07),
                                                offset: const Offset(0, 4),
                                                blurRadius: 10,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  // item.firstName ?? "",
                                                  serviceList[index]
                                                      .serviceName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color(0xFF061237),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
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
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF6A7187),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'QTY: 0',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF6A7187),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    Text(
                                                      'MSRP: \$ ${serviceList[index].subTotal}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF6A7187),
                                                        fontWeight:
                                                            FontWeight.w400,
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

                                      context.read<ServiceBloc>().currentPage <=
                                                  context
                                                      .read<ServiceBloc>()
                                                      .totalPages &&
                                              index == serviceList.length - 1
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
                                itemCount: serviceList.length),
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
