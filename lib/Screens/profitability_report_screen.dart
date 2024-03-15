import 'package:auto_pilot/Screens/app_drawer.dart';

import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ProfitabilityReportScreen extends StatefulWidget {
  const ProfitabilityReportScreen({super.key});

  @override
  State<ProfitabilityReportScreen> createState() =>
      _ProfitabilityReportScreen();
}

class _ProfitabilityReportScreen extends State<ProfitabilityReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataRow> rows = [];
  List<String> typeList = ["Today", "Yesterday", "This Month", "This Year"];

  List<DateTime?> dateRangeList = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
  ];

  String startDateStr = "";
  String endDateStr = "";
  String startDateToServer = "";
  String endDateToServer = "";

  String? currentType;
  @override
  Widget build(BuildContext) {
    return BlocProvider(
      create: (context) => ReportBloc(),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              drawer: showDrawer(context),
              bottomNavigationBar: exportButtonWidget(context),
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
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/images/message.svg",
                          color: AppColors.primaryColors,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          "assets/images/notification.svg",
                          color: AppColors.primaryColors,
                        ))
                  ]),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profitability",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    dateSelectionWidget(context),
                    serviceWriterDropdown("Service Writers", context),
                    const SizedBox(
                      height: 24,
                    ),
                    tableWidget(context, state)
                  ],
                ),
              )),
            );
          },
        ),
      ),
    );
  }

  //Function to render date selection widget
  Widget dateSelectionWidget(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Invoiced",
            style: TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(ctx).size.width,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: Color(0xff919EAB33).withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.07),
                              spreadRadius: 0,
                              offset: Offset(0, 4),
                              blurRadius: 10)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startDateStr != "" && endDateStr != ""
                                ? "${startDateStr}- ${endDateStr}"
                                : "Select Date Range",
                            style: TextStyle(fontSize: 16),
                          ),
                          startDateStr != "" && endDateStr != ""
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      startDateStr = "";
                                      endDateStr = "";
                                      startDateToServer = "";
                                      endDateToServer = "";
                                    });
                                    ctx.read<ReportBloc>()
                                      ..currentPage = 1
                                      ..add(GetSalesTaxReportEvent(
                                          startDate: startDateToServer,
                                          endDate: endDateToServer,
                                          currentPage: 1,
                                          exportType: ""));
                                  },
                                  icon: Icon(Icons.close))
                              : const SizedBox()
                        ],
                      ),
                    )),
              ),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      List<DateTime?> tempDateList = dateRangeList;
                      return BlocProvider.value(
                        value: BlocProvider.of<ReportBloc>(ctx),
                        child: AlertDialog(
                          insetPadding: EdgeInsets.zero,
                          content: Container(
                            height: 400,
                            width: 300,
                            child: Column(
                              children: [
                                CalendarDatePicker2(
                                    config: CalendarDatePicker2Config(
                                      calendarType:
                                          CalendarDatePicker2Type.range,
                                    ),
                                    value: dateRangeList,
                                    onValueChanged: (dates) {
                                      tempDateList = dates;
                                      print(tempDateList);
                                    }),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            DateFormat outputFormat =
                                                DateFormat('MMM d, yyyy');
                                            DateFormat serverFormat =
                                                DateFormat('yyyy-MM-dd');

                                            // dateRangeList[0] = DateTime.parse(
                                            //     outputFormat
                                            //         .format(tempDateList[0]!));

                                            // dateRangeList[1] = DateTime.parse(
                                            //     outputFormat
                                            //         .format(tempDateList[1]!));

                                            dateRangeList = tempDateList;

                                            startDateStr = outputFormat
                                                .format(dateRangeList[0]!);
                                            endDateStr = outputFormat
                                                .format(dateRangeList[1]!);

                                            startDateToServer = serverFormat
                                                .format(dateRangeList[0]!);
                                            endDateToServer = serverFormat
                                                .format(dateRangeList[1]!);
                                          });

                                          // ctx.read<ReportBloc>()
                                          //   ..currentPage = 1
                                          //   ..add(GetSalesTaxReportEvent(
                                          //       startDate: startDateToServer,
                                          //       endDate: endDateToServer,
                                          //       currentPage: 1,
                                          //       exportType: ""));

                                          Navigator.pop(context);
                                        },
                                        child: Text("Ok")),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                            "assets/images/report_calander_icon.svg")),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  //Function to render creation dropdown

  serviceWriterDropdown(String label, BuildContext ctx) {
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
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
              child: DropdownButton<String>(
                icon: currentType != null && currentType != ""
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            currentType = null;
                          });
                          ctx.read<ReportBloc>()
                            ..currentPage = 1
                            ..add(GetPaymentTypeReportEvent(
                                typeFilter: "",
                                searchQuery: "",
                                currentPage: 1,
                                exportType: ""));
                        },
                        child: Icon(Icons.close))
                    : const SizedBox(),
                hint: Text("Select Type"),
                value: currentType,
                onChanged: (String? selectedType) {
                  // Handle selected month
                  print('Selected Month: $selectedType');

                  setState(() {
                    currentType = selectedType;
                  });

                  ctx.read<ReportBloc>()
                    ..currentPage = 1
                    ..add(GetPaymentTypeReportEvent(
                        typeFilter: currentType?.toLowerCase() ?? "",
                        searchQuery: "",
                        currentPage: 1,
                        exportType: ""));
                },
                items: typeList
                    .map((String type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                isExpanded: true,
                underline: const SizedBox(),
                padding: EdgeInsets.only(left: 12, right: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to render table

  Widget tableWidget(BuildContext ctx, state) {
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child:
          //  reportList.isEmpty
          //     ? Container(
          //         width: MediaQuery.of(context).size.width,
          //         height: 300,
          //         child: Center(
          //           child: Text("No Report Found"),
          //         ),
          //       )
          //     :
          Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state is TableLoadingState
              ? Column(
                  children: [
                    Center(
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  ],
                )
              : SingleChildScrollView(
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
                          DataColumn(
                            label: Text('Order'),
                          ),
                          DataColumn(label: Text('First Name')),
                          DataColumn(label: Text('Parts Retail')),
                          DataColumn(label: Text('Parts Cost')),
                          DataColumn(label: Text('Labor Retail')),
                          DataColumn(label: Text('Labor Cost')),
                          DataColumn(label: Text('Subcontract Retail')),
                          DataColumn(label: Text('Subcontract Cost')),
                          DataColumn(label: Text('Fees')),
                          DataColumn(label: Text('Part Profit')),
                          DataColumn(label: Text('Labor Profit')),
                          DataColumn(label: Text('Subcontract Profit')),
                          DataColumn(label: Text('Discount')),
                          DataColumn(label: Text('Total Profit')),
                          DataColumn(label: Text('Total Profit %')),
                        ],
                        rows: rows,
                        columnSpacing: 120,
                        headingRowColor:
                            MaterialStateProperty.all(const Color(0xffCEDEFF)),
                        headingRowHeight: 50,
                      ),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Rows per page: 10'),
                  const SizedBox(
                    width: 16,
                  ),
                  // Text(
                  //     "${timeLogReportModel?.data.range.from} - ${timeLogReportModel?.data.range.to} to ${timeLogReportModel?.data.range.total}")
                ],
              ),
              Transform.scale(
                scale: 0.7,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          // if (timeLogReportModel
                          //         ?.data.paginator.prevPageUrl !=
                          //     null) {
                          //   ctx.read<ReportBloc>().add(
                          //       GetTimeLogReportEvent(
                          //           monthFilter: "",
                          //           techFilter: technicianId,
                          //           searchQuery: "",
                          //           currentPage: 1,
                          //           exportType: ""));
                          // }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          // color: timeLogReportModel
                          //             ?.data.paginator.prevPageUrl !=
                          //         null
                          //     ? Colors.black
                          //     : Colors.grey.shade300,
                        )),
                    IconButton(
                        onPressed: () {
                          // if (timeLogReportModel
                          //         ?.data.paginator.nextPageUrl !=
                          //     null) {
                          //   ctx.read<ReportBloc>().add(
                          //       GetTimeLogReportEvent(
                          //           monthFilter: "",
                          //           techFilter: technicianId,
                          //           searchQuery: "",
                          //           currentPage: 1,
                          //           exportType: ""));
                          // }
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          // color: timeLogReportModel
                          //             ?.data.paginator.nextPageUrl !=
                          //         null
                          //     ? Colors.black
                          //     : Colors.grey.shade300,
                        ))
                  ],
                ),
              )
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0),
          //   child: Row(
          //     children: [
          //       Text('Rows per page: 10'),
          //       // DropdownButton<int>(
          //       //   value: _rowsPerPage,
          //       //   underline: const SizedBox(),
          //       //   onChanged: (newValue) {
          //       //     setState(() {
          //       //       _rowsPerPage = newValue!;
          //       //     });
          //       //   },
          //       //   items: [5, 10, 20, 50]
          //       //       .map((value) => DropdownMenuItem<int>(
          //       //             value: value,
          //       //             child: Text(value.toString()),
          //       //           ))
          //       //       .toList(),
          //       // ),

          //       const SizedBox(
          //         width: 16,
          //       ),

          //       Text(
          //           "${timeLogReportModel?.data.range.from} - ${timeLogReportModel?.data.range.to} to ${timeLogReportModel?.data.range.total}")
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Transform.scale(
          //           scale: 0.7,
          //           child: CupertinoSwitch(
          //               value: false, onChanged: (vlaue) {})),
          //       Text(
          //         "Dense",
          //         style: TextStyle(fontSize: 16),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Widget exportButtonWidget(BuildContext ctx) {
    String downloadPath = "";
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: Padding(
          padding: const EdgeInsets.only(right: 21.0, bottom: 12, left: 21),
          child: ElevatedButton(
              onPressed: () async {
                // ctx.read<ReportBloc>().add(GetTimeLogReportEvent(
                //     monthFilter: currentTimeIn == "Last Week"
                //         ? "last_week"
                //         : currentTimeIn == "Last Month"
                //             ? "last_month"
                //             : currentTimeIn == "Last Year"
                //                 ? "last_year"
                //                 : currentTimeIn?.toLowerCase() ?? "",
                //     techFilter: technicianId,
                //     searchQuery: "",
                //     currentPage: 1,
                //     exportType: "excel"));
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0.6,
                  alignment: Alignment.center,
                  minimumSize: Size(MediaQuery.of(ctx).size.width, 56),
                  maximumSize: Size(MediaQuery.of(ctx).size.width, 56),
                  backgroundColor: Color(0xffF6F6F6),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: AppColors.primaryColors,
                  ),
                  Text(
                    " Export",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColors),
                  )
                ],
              ))),
    );
  }
}
