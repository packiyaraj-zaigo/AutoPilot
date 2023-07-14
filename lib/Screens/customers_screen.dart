import 'dart:async';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Models/customer_model.dart';
import '../api_provider/api_repository.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../utils/app_utils.dart';
import 'app_drawer.dart';
import 'customer_information_screen.dart';
import 'new_customer_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final CustomerBloc bloc;
  final ScrollController controller = ScrollController();
  final List<Datum> customerList = [];
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CustomerBloc>(context);
    bloc.currentPage = 1;
    bloc.add(customerDetails(query: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Autopilot',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: AppStrings.fontSize18,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewCustomerScreen()));
              },
              icon: Icon(
                Icons.add,
                size: AppStrings.fontSize20,
                color: AppColors.primaryBlackColors,
              )),
          SizedBox(
            width: 20,
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: showDrawer(context),
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
                                'No user found',
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
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CustomerInformationScreen(
                                                                customerData:
                                                                    item)));
                                              },
                                              child: ListTile(
                                                title: Text(
                                                    '${item.firstName ?? ''}'),
                                                subtitle: Text(
                                                    '${item.companyName ?? ''}'),
                                                // trailing: Icon(Icons.add),
                                                trailing: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/images/sms.svg",
                                                      color: AppColors
                                                          .primaryColors,
                                                    ),
                                                    SizedBox(
                                                      width: 28,
                                                    ),
                                                    Icon(
                                                      CupertinoIcons.phone,
                                                      color: AppColors
                                                          .primaryColors,
                                                    )
                                                  ],
                                                ),
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
