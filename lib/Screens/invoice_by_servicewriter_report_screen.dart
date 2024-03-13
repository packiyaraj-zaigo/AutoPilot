import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InvoiceByServiceWriterReportScreen extends StatefulWidget {
  const InvoiceByServiceWriterReportScreen({super.key});

  @override
  State<InvoiceByServiceWriterReportScreen> createState() =>
      _InvoiceByServiceWriterReportScreen();
}

class _InvoiceByServiceWriterReportScreen
    extends State<InvoiceByServiceWriterReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataRow> rows = [];
  List<String> typeList = ["Today", "Yesterday", "This Month", "This Year"];

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
                      "Invoice By Service Writer",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    creationDropDown("Creation", context),
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

  Widget summaryTile(String label, String value) {
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
                Text(
                  label,
                  style: TextStyle(fontSize: 16),
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

  //Widget to render creation dropdown

  creationDropDown(String label, BuildContext ctx) {
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
                            label: Text('Service Writer'),
                          ),
                          DataColumn(label: Text('# of Estimates')),
                          DataColumn(label: Text('# of Invoice')),
                          DataColumn(label: Text('Paid Invoice Total')),
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
