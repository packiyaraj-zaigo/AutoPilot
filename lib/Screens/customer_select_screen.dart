import 'dart:async';

import 'package:auto_pilot/Screens/estimate_details_screen.dart';
import 'package:auto_pilot/Screens/estimate_partial_screen.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/estimate_bloc/estimate_bloc.dart' as eb;
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_strings.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/customer_model.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import 'app_drawer.dart';
import 'customer_information_screen.dart';
import 'new_customer_screen.dart';

class SelectCustomerScreen extends StatefulWidget {
  const SelectCustomerScreen(
      {super.key, required this.navigation, this.orderId, this.subNavigation});
  final String navigation;
  final String? orderId;
  final String? subNavigation;

  @override
  State<SelectCustomerScreen> createState() => _SelectCustomerScreenState();
}

class _SelectCustomerScreenState extends State<SelectCustomerScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final CustomerBloc bloc;
  final ScrollController controller = ScrollController();
  final List<Datum> customerList = [];
  final _debouncer = Debouncer();
  final customerSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CustomerBloc>(context);
    bloc.currentPage = 1;
    bloc.add(customerDetails(query: ''));
  }

  Future<bool> networkCheck() async {
    final value = await AppUtils.getConnectivity().then((value) {
      return value;
    });
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        foregroundColor: AppColors.primaryColors,
        backgroundColor: Colors.transparent,
        title: Text(
          'Autopilot',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: AppStrings.fontSize18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       networkCheck().then((value) {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => NewCustomerScreen(),
        //           ),
        //         );
        //       });
        //     },
        //     icon: Icon(
        //       Icons.add,
        //       size: AppStrings.fontSize20,
        //       color: AppColors.primaryColors,
        //     ),
        //   ),
        //   const SizedBox(width: 10)
        // ],

        // backgroundColor: Colors.transparent,
        elevation: 0,
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
                    'Customers',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
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
                      controller: customerSearchController,
                      suffix: GestureDetector(
                        onTap: () {
                          customerSearchController.clear();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.close,
                            color: AppColors.primaryColors,
                            size: 18,
                          ),
                        ),
                      ),
                      padding:
                          const EdgeInsets.only(top: 14, bottom: 14, left: 16),
                      onChanged: (value) {
                        _debouncer.run(() {
                          customerList.clear();
                          bloc.currentPage = 1;
                          bloc.add(customerDetails(query: value));
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
                      placeholder: 'Search Customer',
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
                child: BlocListener<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is CustomerReady) {
                      customerList.addAll(state.customer.data ?? []);
                    }
                  },
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomerLoading &&
                          !bloc.isPaginationLoading) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else {
                        return customerList.isEmpty
                            ? const Center(
                                child: Text(
                                'No Customer Found',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryTextColors),
                              ))
                            : ScrollConfiguration(
                                behavior: const ScrollBehavior(),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    controller: controller
                                      ..addListener(() {
                                        if (controller.offset ==
                                                controller
                                                    .position.maxScrollExtent &&
                                            !bloc.isPaginationLoading &&
                                            bloc.currentPage <=
                                                bloc.totalPages) {
                                          _debouncer.run(() {
                                            bloc.isPaginationLoading = true;
                                            bloc.add(
                                                customerDetails(query: ''));
                                          });
                                        }
                                      }),
                                    itemBuilder: (context, index) {
                                      final item = customerList[index];
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: Offset(0,
                                                      7), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                if (widget.navigation ==
                                                        "appointment" ||
                                                    widget.navigation ==
                                                        'create_vehicle') {
                                                  Navigator.of(context)
                                                      .pop(item);
                                                } else {
                                                  //open dialog
                                                  showDialog(context, "", item);
                                                }
                                              },
                                              child: ListTile(
                                                title: Text(
                                                    "${item.firstName} ${item.lastName}"),
                                                subtitle: Text(
                                                    '${item.companyName ?? ''}'),
                                                trailing: const Icon(Icons.add,
                                                    color: AppColors
                                                        .primaryColors),
                                              ),
                                            ),
                                          ),
                                          bloc.currentPage <= bloc.totalPages &&
                                                  index ==
                                                      customerList.length - 1
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
                                          index == customerList.length - 1
                                              ? const SizedBox(height: 24)
                                              : const SizedBox(),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 24),
                                    itemCount: customerList.length),
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
    );
  }

  Future showDialog(BuildContext context, message, Datum item) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => BlocProvider(
        create: (context) => eb.EstimateBloc(apiRepository: ApiRepository()),
        child: BlocListener<eb.EstimateBloc, eb.EstimateState>(
          listener: (context, state) {
            if (state is eb.CreateEstimateState) {
              // Navigator.pop(context);
              // Navigator.pushReplacement(context, MaterialPageRoute(
              //   builder: (context) {
              //     return EstimatePartialScreen(
              //       estimateDetails: state.createEstimateModel,
              //       navigation: widget.subNavigation,
              //     );
              //   },
              // ));

              context.read<eb.EstimateBloc>().add(eb.GetSingleEstimateEvent(
                  orderId: state.createEstimateModel.data.id.toString()));
            } else if (state is eb.EditEstimateState) {
              // Navigator.pushReplacement(context, MaterialPageRoute(
              //   builder: (context) {
              //     return EstimatePartialScreen(
              //       estimateDetails: state.createEstimateModel,
              //       navigation: widget.subNavigation,
              //     );
              //   },
              // ));

              context.read<eb.EstimateBloc>().add(eb.GetSingleEstimateEvent(
                  orderId: state.createEstimateModel.data.id.toString()));
            } else if (state is eb.GetSingleEstimateState) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return EstimatePartialScreen(
                    estimateDetails: state.createEstimateModel,
                    navigation: widget.subNavigation,
                  );
                },
              ));
            }
            // TODO: implement listener
          },
          child: BlocBuilder<eb.EstimateBloc, eb.EstimateState>(
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: widget.navigation == "new"
                    ? const Text("Create Estimate?")
                    : const Text("Update Estimate?"),
                content: widget.navigation == "new"
                    ? const Text(
                        "Do you want to create an estimate with this customer?")
                    : const Text(
                        "Do you want to add this customer to estimate?"),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: const Text("Yes"),
                      onPressed: () {
                        networkCheck().then((value) {
                          if (widget.navigation == "new") {
                            context.read<eb.EstimateBloc>().add(
                                eb.CreateEstimateEvent(
                                    id: item.id.toString(), which: "customer"));
                          } else {
                            context.read<eb.EstimateBloc>().add(
                                eb.EditEstimateEvent(
                                    id: item.id.toString(),
                                    orderId: widget.orderId ?? "",
                                    which: "customer",
                                    customerId: item.id.toString()));
                          }
                        });
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
