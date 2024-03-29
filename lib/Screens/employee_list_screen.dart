import 'dart:async';
import 'dart:developer';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/create_employee_screen.dart';
import 'package:auto_pilot/Screens/employee_details_screen.dart';
import 'package:auto_pilot/Screens/no_internet_screen.dart';
import 'package:auto_pilot/Screens/scanner_screen.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final EmployeeBloc bloc;
  final ScrollController controller = ScrollController();
  final List<Employee> employeeList = [];
  final _debouncer = Debouncer();

  bool network = true;

  Future<bool> networkCheck() async {
    final value = await AppUtils.getConnectivity().then((value) {
      return value;
    });
    return value;
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EmployeeBloc>(context);
    bloc.currentPage = 1;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await networkCheck().then((value) {
        if (value != network) {
          setState(() {
            network = value;
          });
        } else if (network) {
          bloc.add(GetAllEmployees());
        }
      });
    });
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => BottomBarScreen(),
            ),
            (route) => false);
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: !network ? Colors.white : null,
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Autopilot',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: !network
                  ? () {
                      CommonWidgets().showDialog(context,
                          'Please check your internet connection and try again');
                    }
                  : () async {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const CreateEmployeeScreen(
                            navigation: "add_employee"),
                      ));
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
        body: !network
            ? NoInternetScreen(state: setState)
            : SafeArea(
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
                            'Employees',
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
                                  employeeList.clear();
                                  bloc.currentPage = 1;
                                  bloc.add(GetAllEmployees(query: value));
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
                              placeholder: 'Type First Name To Search',
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
                        child: BlocListener<EmployeeBloc, EmployeeState>(
                          listener: (context, state) {
                            if (state is EmployeeDetailsSuccessState) {
                              employeeList
                                  .addAll(state.employees.employeeList ?? []);

                              print(state.employees.employeeList!.length);
                            }
                          },
                          child: BlocBuilder<EmployeeBloc, EmployeeState>(
                            builder: (context, state) {
                              if (state is EmployeeDetailsLoadingState &&
                                  !bloc.isPagenationLoading) {
                                return const Center(
                                    child: CupertinoActivityIndicator());
                              } else {
                                return employeeList.isEmpty
                                    ? const Center(
                                        child: Text(
                                        'No User Found',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryTextColors),
                                      ))
                                    : ScrollConfiguration(
                                        behavior: const ScrollBehavior()
                                            .copyWith(overscroll: false),
                                        child: ListView.separated(
                                            shrinkWrap: true,
                                            controller: controller
                                              ..addListener(() {
                                                if (controller.offset ==
                                                        controller.position
                                                            .maxScrollExtent &&
                                                    !bloc.isPagenationLoading &&
                                                    bloc.currentPage <=
                                                        bloc.totalPages) {
                                                  _debouncer.run(() {
                                                    bloc.isPagenationLoading =
                                                        true;
                                                    bloc.add(GetAllEmployees());
                                                  });
                                                }
                                              }),
                                            itemBuilder: (context, index) {
                                              final item = employeeList[index];
                                              return Column(
                                                children: [
                                                  CommonWidgets()
                                                      .employeeCard(item: item),
                                                  bloc.currentPage <=
                                                              bloc.totalPages &&
                                                          index ==
                                                              employeeList
                                                                      .length -
                                                                  1
                                                      ? const Column(
                                                          children: [
                                                            SizedBox(
                                                                height: 24),
                                                            Center(
                                                              child:
                                                                  CupertinoActivityIndicator(),
                                                            ),
                                                            SizedBox(
                                                                height: 24),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                  index ==
                                                          employeeList.length -
                                                              1
                                                      ? const SizedBox(
                                                          height: 24)
                                                      : const SizedBox(),
                                                ],
                                              );
                                            },
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 24),
                                            itemCount: employeeList.length),
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
  //         items: employeeList,
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
