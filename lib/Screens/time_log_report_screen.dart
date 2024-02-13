import 'package:auto_pilot/Models/time_log_report_model.dart';
import 'package:auto_pilot/Screens/all_invoice_report_screen.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeLogReportScreen extends StatefulWidget {
  TimeLogReportScreen({super.key});

  @override
  State<TimeLogReportScreen> createState() => _TimeLogReportScreen();
}

class _TimeLogReportScreen extends State<TimeLogReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> monthOptions = ["This Month", "Last Month"];
  int _rowsPerPage = 5;
  final List<TimeLogReportModel> timeLogReportList = [];
  // final List<DataRow> rows = List.generate(
  //   10, // Replace with your actual data
  //   (index) => DataRow(
  //     cells: [
  //       DataCell(Text('Item $index')),
  //       DataCell(Text('Description $index')),
  //       DataCell(Text('Test $index')),
  //       DataCell(Text('Test 2 $index')),

  //       // Add more DataCells as needed
  //     ],
  //   ),
  // );

  List<DataRow> rows = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc()
        ..add(GetTimeLogReportEvent(
            monthFilter: "", techFilter: "", searchQuery: "", currentPage: 1)),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state is GetTimeLogReportSuccessState) {
            timeLogReportList.addAll(state.timeLogReportModel);

            timeLogReportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.entry.toString())),
                DataCell(Text(element.type)),
                DataCell(Text(element.technician)),
                DataCell(Text(element.firstName)),
                DataCell(Text(element.lastName)),
                DataCell(Text(element.vehicle)),
                DataCell(Text(element.fndDatetime.toString())),
                DataCell(Text(element.activityType)),
                DataCell(Text(element.activityName)),
                DataCell(Text(element.note)),
                DataCell(Text(element.techRate.toString())),
                DataCell(Text(element.duration.toString())),
                DataCell(Text(element.total.toString())),
              ]));
            });
          }
        },
        child: BlocBuilder<ReportBloc, ReportState>(
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
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: const Text(
                    'Autopilot',
                    style: TextStyle(color: Colors.black87),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) {
                          //     return AppointmentDetailsScreen();
                          //   },
                          // ));
                          // CommonWidgets().showSuccessDialog(
                          //     context, "Successfully created data");
                        },
                        icon: SvgPicture.asset(
                          "assets/images/message.svg",
                          color: AppColors.primaryColors,
                        )),
                    IconButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //       builder: (context) => AddCompanyScreen()),
                          // );
                        },
                        icon: SvgPicture.asset(
                          "assets/images/notification.svg",
                          color: AppColors.primaryColors,
                        ))
                  ]),
              body: state is ReportLoadingState
                  ? Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 15.0,
                          left: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Time Log",
                              style: TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 21,
                            ),
                            timeLogTile(
                                "Hours tracked", "0", Color(0xff5976F6)),
                            timeLogTile("Average hours per service", "0",
                                Color(0xff12A58C)),
                            const SizedBox(
                              height: 35,
                            ),
                            monthDropdown("Time in"),
                            monthDropdown("Technicians"),
                            searchBar(),
                            tableWidget()
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

  monthDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xff919EAB33).withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                      blurRadius: 10)
                ]),
            child: DropdownButton<String>(
              value: monthOptions.isNotEmpty ? monthOptions[0] : null,
              onChanged: (String? selectedMonth) {
                // Handle selected month
                print('Selected Month: $selectedMonth');
              },
              items: monthOptions
                  .map((String month) => DropdownMenuItem<String>(
                        value: month,
                        child: Text(month),
                      ))
                  .toList(),
              isExpanded: true,
              underline: const SizedBox(),
              padding: EdgeInsets.only(left: 12, right: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeLogTile(String label, String value, Color tileColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, right: 24),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xff919EAB33).withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    spreadRadius: 0,
                    offset: Offset(0, 4),
                    blurRadius: 10)
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: tileColor,
                      radius: 11,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      label,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 24, bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: Color(0xff919EAB33).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          spreadRadius: 0,
                          offset: Offset(0, 4),
                          blurRadius: 10)
                    ]),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search",
                      contentPadding: EdgeInsets.only(
                          left: 12, right: 12, top: 15, bottom: 0),
                      prefixIcon: Icon(Icons.search)),
                )),
          ),
          const SizedBox(
            width: 16,
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                      blurRadius: 10)
                ]),
            child: Icon(
              Icons.add,
              color: AppColors.primaryColors,
            ),
          )
        ],
      ),
    );
  }

  Widget tableWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // BoxShadow(color: Color(0xff919EAB), blurRadius: 2),
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 6,
                      offset: Offset(10, 16)),
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DataTable(
                columns: [
                  // DataColumn(label: Text('Item')),
                  // DataColumn(label: Text('Description')),
                  // DataColumn(label: Text('Test')),
                  // DataColumn(label: Text('Test 2')),

                  DataColumn(label: Text('Entry')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Technician')),
                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Vehicle')),
                  DataColumn(label: Text('Fnd Date Time')),
                  DataColumn(label: Text('Activity Type')),
                  DataColumn(label: Text('Activity Name')),
                  DataColumn(label: Text('Note')),
                  DataColumn(label: Text('Tech Rate')),
                  DataColumn(label: Text('Duration')),
                  DataColumn(label: Text('Total')),
                ],
                rows: rows,
                columnSpacing: 80,
                headingRowColor:
                    MaterialStateProperty.all(const Color(0xffCEDEFF)),
                headingRowHeight: 50,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text('Rows per page: '),
              DropdownButton<int>(
                value: _rowsPerPage,
                underline: const SizedBox(),
                onChanged: (newValue) {
                  setState(() {
                    _rowsPerPage = newValue!;
                  });
                },
                items: [5, 10, 20, 50]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(value: false, onChanged: (vlaue) {})),
              Text(
                "Dense",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )
      ],
    );
  }
}
