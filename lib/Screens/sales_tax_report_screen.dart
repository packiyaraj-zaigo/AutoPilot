import 'package:auto_pilot/Models/sales_tax_report_model.dart';
import 'package:auto_pilot/Screens/all_invoice_report_screen.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class SalesTaxReportScreen extends StatefulWidget {
  const SalesTaxReportScreen({super.key});

  @override
  State<SalesTaxReportScreen> createState() => _SalesTaxReportScreenState();
}

class _SalesTaxReportScreenState extends State<SalesTaxReportScreen> {
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _rowsPerPage = 5;
  List<DataRow> rows = [];
  List<DateTime?> dateRangeList = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
  ];

  String startDateStr = "";
  String endDateStr = "";
  String startDateToServer = "";
  String endDateToServer = "";
  SalesTaxReportModel? salesTaxReportModel;
  List<Datum> reportList = [];

  @override
  void initState() {
    // DateFormat outputFormat = DateFormat('MMM d, yyyy');
    // startDateStr = outputFormat.format(dateRangeList[0]!);
    // endDateStr = outputFormat.format(dateRangeList[1]!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is GetSalesTaxReportSuccessState) {
            salesTaxReportModel = state.salesTaxReportModel;
            reportList.clear();
            rows.clear();
            reportList.addAll(state.salesTaxReportModel.data);

            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.type)),
                DataCell(Text(element.taxable.toString())),
                DataCell(Text(element.nonTaxable.toString())),
                DataCell(Text(element.nonTaxable.toString())),
                DataCell(Text(element.discount.toString())),
                DataCell(Text(element.total.toString())),
              ]));
            });
          } else if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add(
                  GetSalesTaxReportEvent(
                      startDate: "",
                      endDate: "",
                      currentPage: 1,
                      exportType: ""),
                );
          } else if (state is GetExportLinkState) {
            context.read<ReportBloc>().add(ExportReportEvent(
                downloadPath: "SalesTaxReport",
                downloadUrl: state.link,
                fileName: "SalesTaxReport",
                context: context));
          }
        },
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: exportButtonWidget(context),
              ),
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
                  : state is InternerConnectionErrorState
                      ? Column(
                          children: [
                            Center(
                              child:
                                  Text("Please check your internet connection"),
                            ),
                            IconButton(
                                onPressed: () {
                                  context
                                      .read<ReportBloc>()
                                      .add(InternetConnectionEvent());
                                },
                                icon: Icon(Icons.replay_outlined))
                          ],
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sales Tax",
                                  style: TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                dateSelectionWidget(context),
                                const SizedBox(
                                  height: 6,
                                ),
                                taxTileWidget(
                                    "Taxes collected",
                                    salesTaxReportModel?.taxCollected
                                            .toString() ??
                                        ""),
                                taxTileWidget(
                                    "Taxe owed",
                                    salesTaxReportModel?.nonTaxableTotal
                                            .toString() ??
                                        ""),
                                state is GetSalesTaxReportErrorState
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 300,
                                            child: Center(
                                              child: Text(state.errorMessage),
                                            ),
                                          ),
                                        ],
                                      )
                                    : tableWidget(),
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

  Widget exportButtonWidget(BuildContext ctx) {
    String downloadPath = "";
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: Padding(
          padding: const EdgeInsets.only(right: 21.0, bottom: 12),
          child: ElevatedButton(
              onPressed: () async {
                // context.read<ReportBloc>().add(ExportReportEvent(
                //     downloadPath: downloadPath,
                //     downloadUrl: downloadUrl,
                //     fileName: fileName));

                // PermissionStatus status = await Permission.storage.request();
                // print(status.toString() + "sttaus");
                // if (status.isGranted) {
                //   var dir =
                //       await DownloadsPath.downloadsDirectory().then((value) {
                //     downloadPath = value?.path ?? "";
                //     print(downloadPath + "pathhhh");
                //     context.read<ReportBloc>().add(ExportReportEvent(
                //         downloadPath: downloadPath,
                //         downloadUrl: "https://pdfobject.com/pdf/sample.pdf",
                //         fileName: "test"));
                //   });
                // } else if (status.isDenied) {
                //   await Permission.storage.request();
                // }

                // ctx.read<ReportBloc>().add(ExportReportEvent(
                //     downloadPath: downloadPath,
                //     downloadUrl: "https://pdfobject.com/pdf/sample.pdf",
                //     fileName: "test",
                //     context: ctx));

                ctx.read<ReportBloc>().add(GetSalesTaxReportEvent(
                    startDate: startDateToServer,
                    endDate: endDateToServer,
                    currentPage: 1,
                    exportType: "excel"));
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

                                          ctx.read<ReportBloc>()
                                            ..currentPage = 1
                                            ..add(GetSalesTaxReportEvent(
                                                startDate: startDateToServer,
                                                endDate: endDateToServer,
                                                currentPage: 1,
                                                exportType: ""));

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

  Widget taxTileWidget(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, right: 24),
      child: Container(
          alignment: Alignment.centerLeft,
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
            padding: const EdgeInsets.only(left: 12.0, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "\$ " + value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          )),
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

                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Taxable')),
                  DataColumn(label: Text('Non-Taxable')),
                  DataColumn(label: Text('Tax Exempt')),
                  DataColumn(label: Text('Discounts')),
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
        // Padding(
        //   padding: const EdgeInsets.only(top: 8.0),
        //   child: Row(
        //     children: [
        //       Text('Rows per page: '),
        //       DropdownButton<int>(
        //         value: _rowsPerPage,
        //         underline: const SizedBox(),
        //         onChanged: (newValue) {
        //           setState(() {
        //             _rowsPerPage = newValue!;
        //           });
        //         },
        //         items: [5, 10, 20, 50]
        //             .map((value) => DropdownMenuItem<int>(
        //                   value: value,
        //                   child: Text(value.toString()),
        //                 ))
        //             .toList(),
        //       ),
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
        //           child: CupertinoSwitch(value: false, onChanged: (vlaue) {})),
        //       Text(
        //         "Dense",
        //         style: TextStyle(fontSize: 16),
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }
}
