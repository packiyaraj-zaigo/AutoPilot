import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../api_provider/api_repository.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import 'app_drawer.dart';
import 'customer_information_screen.dart';
import 'new_customer_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({Key? key}) : super(key: key);

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  int selectedIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
                        builder: (context) => const NewCustomerScreen()));
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
      body: BlocProvider(
        create: (context) => CustomerBloc(apiRepository: ApiRepository())
          ..add(customerDetails()),
        child: BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerError) {
            } else if (state is CustomerLoading) {}
          },
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return Center(child: CupertinoActivityIndicator());
              } else if (state is CustomerReady) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 34, top: 24, bottom: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customers',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlackColors),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 50,
                            child: CupertinoSearchTextField(
                              backgroundColor: Colors.white,
                              placeholder: 'Search Customers...',
                              prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 16),
                                child: Icon(
                                  CupertinoIcons.search,
                                  color: AppColors.primaryTextFieldColors,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AlphabetScrollView(
                        list: state.data.data.data
                            .map((e) => AlphaModel(e.firstName))
                            .toList(),
                        isAlphabetsFiltered: true,
                        alignment: LetterAlignment.right,
                        itemExtent: 200,
                        unselectedTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                        selectedTextStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        itemBuilder: (_, k, id) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 34, left: 24),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 7), // changes position of shadow
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
                                                  customerData: state
                                                      .data.data.data[k])));
                                },
                                child: ListTile(
                                  title: Text('${id ?? ''}'),
                                  subtitle: Text(
                                      '${state.data.data.data[k].companyName ?? ''}'),
                                  // trailing: Icon(Icons.add),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset("assets/images/sms.svg"),
                                      SizedBox(
                                        width: 28,
                                      ),
                                      Icon(
                                        CupertinoIcons.phone,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
