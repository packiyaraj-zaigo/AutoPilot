import 'dart:developer';

import 'package:auto_pilot/Screens/create_employee_screen.dart';
import 'package:auto_pilot/Screens/employee_details_screen.dart';
import 'package:auto_pilot/Screens/scanner_screen.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/models/employee_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late final EmployeeBloc bloc;
  final ScrollController controller = ScrollController();
  final List<Employee> employeeList = [];

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EmployeeBloc>(context);
    bloc.currentPage = 1;
    bloc.add(GetAllEmployees());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            // scaffoldKey.currentState!.openDrawer();
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
                builder: (context) => const CreateEmployeeScreen(),
              ));
            },
            child: const Icon(
              Icons.add,
              color: Colors.black87,
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
          padding: const EdgeInsets.only(left: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Employees',
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
                        placeholder: 'Search Employee...',
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
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocListener<EmployeeBloc, EmployeeState>(
                  listener: (context, state) {
                    if (state is EmployeeDetailsSuccessState) {
                      employeeList.addAll(state.employees.employeeList ?? []);
                    }
                  },
                  child: BlocBuilder<EmployeeBloc, EmployeeState>(
                    builder: (context, state) {
                      if (state is EmployeeDetailsLoadingState &&
                          !bloc.isEmployeesLoading) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      } else if (state is EmployeeDetailsSuccessState) {
                        log('here');
                        return customScrollView(employeeList);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
              BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  if (bloc.isEmployeesLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ScrollConfiguration customScrollView(List<Employee> employeeList) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: StickyAzList(
        controller: controller
          ..addListener(() {
            if (controller.offset == controller.position.maxScrollExtent &&
                !bloc.isEmployeesLoading &&
                bloc.currentPage <= bloc.totalPages) {
              bloc.add(GetAllEmployees());
            }
          }),
        options: const StickyAzOptions(
          scrollBarOptions: ScrollBarOptions(scrollable: true),
          listOptions: ListOptions(
            showSectionHeader: false,
          ),
        ),
        items: employeeList,
        builder: (context, index, item) => Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EmployeeDetailsScreen(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.firstName ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF061237),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        item.roles?[0].name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF6A7187),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
