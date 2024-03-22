import 'package:auto_pilot/Models/service_technician_report_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:auto_pilot/Models/report_technician_list_model.dart'
    as techModel;

class ServicesByTechnicianReportScreen extends StatefulWidget {
  ServicesByTechnicianReportScreen({super.key});

  @override
  State<ServicesByTechnicianReportScreen> createState() =>
      _ServicesByTechnicianReportScreen();
}

class _ServicesByTechnicianReportScreen
    extends State<ServicesByTechnicianReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ServiceByTechReportModel? serviceByTechReporModel;
  List<String> monthOptions = ["This Month", "Last Month"];
  int _rowsPerPage = 5;
  techModel.Datum? currentTechnician;

  List<techModel.Datum> technicianData = [];
  String technicianId = '';
  final TextEditingController technicianController = TextEditingController();
  String sortBy = "asc";
  String? tableName;
  String? fieldName;
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
  List<DateTime?> dateRangeList = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
  ];

  String startDateStr = "";
  String endDateStr = "";
  String startDateToServer = "";
  String endDateToServer = '';
  List<Datum> reportList = [];

  @override
  void initState() {
    // DateFormat outputFormat = DateFormat('MMM d, yyyy');
    // startDateStr = outputFormat.format(dateRangeList[0]!);
    // endDateStr = outputFormat.format(dateRangeList[1]!);
    // TODO: implement initState
    super.initState();
  }

  void toggleSortOrder() {
    setState(() {
      sortBy = sortBy == "asc" ? "desc" : "asc";
    });
    print("Sort order toggled to: $sortBy");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is GetServiceByTechnicianReportSuccessState) {
            serviceByTechReporModel = state.serviceByTechReportModel;
            reportList.clear();
            rows.clear();
            reportList
                .addAll(state.serviceByTechReportModel.data.paginator.data);

            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.techicianName)),
                DataCell(Text(element.date.toString())),
                DataCell(Text(element.order.toString())),
                DataCell(Text(element.serviceName)),
                // DataCell(Text(element.invoicedHours.toString())),
              ]));
            });
          } else if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add(GetServiceByTechnicianReportEvent(
                startDate: "",
                page: "",
                endDate: "",
                searchQuery: "",
                techFilter: "",
                currentPage: 1,
                pagination: "",
                exportType: ""));

            context.read<ReportBloc>().add(GetAllTechnicianEvent());
          } else if (state is GetAllTechnicianState) {
            technicianData.clear();
            technicianData.addAll(state.technicianModel.data);

            print(technicianData);
          } else if (state is GetExportLinkState) {
            context.read<ReportBloc>().add(ExportReportEvent(
                downloadPath: "",
                downloadUrl: state.link,
                fileName: "ServiceByTechnicianReport",
                context: context));
          }
        },
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              bottomNavigationBar: exportButtonWidget(context),
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
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                icon: Icon(Icons.replay))
                          ],
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
                                  "Services By Technician",
                                  style: TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                dateSelectionWidget(context),
                                technicianDropdown(
                                    "Technician", state, context),
                                //  searchBar(),
                                const SizedBox(
                                  height: 32,
                                ),
                                state is GetServiceByTechnicianReportErrorState
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
                                    : tableWidget(context, state)
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
          padding:
              const EdgeInsets.only(right: 21.0, bottom: 12, left: 21, top: 12),
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

                ctx.read<ReportBloc>().add(GetServiceByTechnicianReportEvent(
                    startDate: startDateToServer,
                    endDate: endDateToServer,
                    searchQuery: "",
                    techFilter: technicianId,
                    page: "",
                    currentPage: 1,
                    pagination: "",
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

  monthDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 24),
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

  Widget tableWidget(BuildContext ctx, state) {
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: reportList.isEmpty
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Center(
                child: Text("No Report Found"),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: state is TableLoadingState
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        )
                      : Container(
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
                              decoration: BoxDecoration(),
                              horizontalMargin: 12,
                              columns: [
                                // DataColumn(label: Text('Item')),
                                // DataColumn(label: Text('Description')),
                                // DataColumn(label: Text('Test')),
                                // DataColumn(label: Text('Test 2')),

                                DataColumn(
                                    label: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                fieldName = "first_name";
                                                tableName = "technician";
                                              });
                                              toggleSortOrder();
                                              ctx.read<ReportBloc>()
                                                ..currentPage = 1
                                                ..add(
                                                    GetServiceByTechnicianReportEvent(
                                                        startDate:
                                                            startDateToServer,
                                                        endDate:
                                                            endDateToServer,
                                                        searchQuery: "",
                                                        page: "",
                                                        techFilter:
                                                            technicianId,
                                                        currentPage: 1,
                                                        pagination: "",
                                                        exportType: "",
                                                        sort: sortBy,
                                                        fieldName: fieldName,
                                                        tableName: tableName));
                                            },
                                            child: Icon(sortBy == "asc"
                                                ? Icons.arrow_upward_rounded
                                                : Icons
                                                    .arrow_downward_rounded)),
                                        Text(
                                          'Tech',
                                          textAlign: TextAlign.center,
                                        )
                                      ]),
                                )),
                                DataColumn(label: Text('Date')),
                                DataColumn(
                                    label: Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tableName = "order_service";
                                        fieldName = "service_name";
                                      });
                                      toggleSortOrder();
                                      ctx.read<ReportBloc>()
                                        ..currentPage = 1
                                        ..add(GetServiceByTechnicianReportEvent(
                                            startDate: startDateToServer,
                                            endDate: endDateToServer,
                                            searchQuery: "",
                                            techFilter: technicianId,
                                            currentPage: 1,
                                            pagination: "",
                                            page: "",
                                            exportType: "",
                                            sort: sortBy,
                                            fieldName: "order_number",
                                            tableName: "order"));
                                    },
                                    child: Icon(sortBy == "asc"
                                        ? Icons.arrow_upward_rounded
                                        : Icons.arrow_downward_rounded),
                                  ),
                                  Text('Order')
                                ])),
                                DataColumn(
                                    label: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          fieldName = "service_name";
                                          tableName = "order_service";
                                        });
                                        toggleSortOrder();
                                        ctx.read<ReportBloc>()
                                          ..currentPage = 1
                                          ..add(
                                              GetServiceByTechnicianReportEvent(
                                                  startDate: startDateToServer,
                                                  endDate: endDateToServer,
                                                  searchQuery: "",
                                                  techFilter: technicianId,
                                                  currentPage: 1,
                                                  page: "",
                                                  pagination: "",
                                                  exportType: "",
                                                  sort: sortBy,
                                                  fieldName: fieldName,
                                                  tableName: tableName));
                                      },
                                      child: Icon(sortBy == "asc"
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded),
                                    ),
                                    Text('Service'),
                                  ],
                                )),
                                //  DataColumn(label: Text('Invoiced Hours')),
                              ],
                              rows: rows,
                              columnSpacing: 80,
                              headingRowColor: MaterialStateProperty.all(
                                  const Color(0xffCEDEFF)),
                              headingRowHeight: 50,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Rows per page:10 '),
                          // DropdownButton<int>(
                          //   value: _rowsPerPage,
                          //   underline: const SizedBox(),
                          //   onChanged: (newValue) {
                          //     setState(() {
                          //       _rowsPerPage = newValue!;
                          //     });
                          //   },
                          //   items: [5, 10, 20, 50]
                          //       .map((value) => DropdownMenuItem<int>(
                          //             value: value,
                          //             child: Text(value.toString()),
                          //           ))
                          //       .toList(),
                          // ),
                          const SizedBox(
                            width: 16,
                          ),

                          Text(
                              "${serviceByTechReporModel?.data.range.from} - ${serviceByTechReporModel?.data.range.to} to ${serviceByTechReporModel?.data.range.total}")
                        ],
                      ),
                      Transform.scale(
                        scale: 0.7,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (serviceByTechReporModel
                                          ?.data.paginator.prevPageUrl !=
                                      null) {
                                    ctx.read<ReportBloc>().add(
                                        GetServiceByTechnicianReportEvent(
                                            startDate: startDateToServer,
                                            endDate: endDateToServer,
                                            searchQuery: "",
                                            page: "prev",
                                            techFilter: technicianId,
                                            currentPage: 1,
                                            pagination: "prev",
                                            exportType: "",
                                            fieldName: fieldName,
                                            tableName: tableName,
                                            sort: sortBy));
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: serviceByTechReporModel
                                              ?.data.paginator.prevPageUrl !=
                                          null
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                )),
                            IconButton(
                                onPressed: () {
                                  if (serviceByTechReporModel
                                          ?.data.paginator.nextPageUrl !=
                                      null) {
                                    ctx.read<ReportBloc>().add(
                                        GetServiceByTechnicianReportEvent(
                                            startDate: startDateToServer,
                                            endDate: endDateToServer,
                                            searchQuery: "",
                                            page: "next",
                                            techFilter: technicianId,
                                            currentPage: 1,
                                            pagination: "next",
                                            exportType: "",
                                            fieldName: fieldName,
                                            sort: sortBy,
                                            tableName: tableName));
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: serviceByTechReporModel
                                              ?.data.paginator.nextPageUrl !=
                                          null
                                      ? Colors.black
                                      : Colors.grey.shade300,
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
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
            ),
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
                                      sortBy = "asc";
                                    });
                                    ctx.read<ReportBloc>()
                                      ..currentPage = 1
                                      ..add(GetServiceByTechnicianReportEvent(
                                        startDate: "",
                                        endDate: "",
                                        searchQuery: "",
                                        page: "",
                                        techFilter: technicianId,
                                        currentPage: 1,
                                        pagination: "",
                                        exportType: "",
                                      ));
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
                                            ..add(
                                                GetServiceByTechnicianReportEvent(
                                                    startDate:
                                                        startDateToServer,
                                                    endDate: endDateToServer,
                                                    searchQuery: "",
                                                    techFilter: "",
                                                    page: "",
                                                    currentPage: 1,
                                                    pagination: "",
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

  technicianDropdown(String label, state, BuildContext ctx) {
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
              width: MediaQuery.of(ctx).size.width,
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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return technicianBottomSheet(state, ctx);
                    },
                  );
                },
                readOnly: true,
                controller: technicianController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 2),
                    hintText: "Technician",
                    suffix: technicianId != "" &&
                            technicianController.text != ""
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                technicianController.text = "";
                                technicianId = "";
                              });
                              ctx.read<ReportBloc>()
                                ..currentPage = 1
                                ..add(GetServiceByTechnicianReportEvent(
                                    startDate: startDateToServer,
                                    endDate: endDateToServer,
                                    searchQuery: "",
                                    techFilter: "",
                                    page: "",
                                    currentPage: 1,
                                    pagination: "",
                                    exportType: ""));
                            },
                            child: SizedBox(
                                height: 56,
                                width: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.close),
                                  ],
                                )),
                          )
                        : const SizedBox()),
              )),
        ],
      ),
    );
  }

  Widget technicianBottomSheet(state, ctx) {
    // return BlocProvider(
    //   create: (context) => ReportBloc()..add(GetAllTechnicianEvent()),
    //   child: BlocListener<ReportBloc, ReportState>(
    //     listener: (context, state) {
    //       if (state is GetAllTechnicianState) {
    //         technicianData.clear();
    //         technicianData.addAll(state.technicianModel.data);

    //         print(technicianData);
    //       }
    //       // TODO: implement listener
    //     },
    //     child: BlocBuilder<ReportBloc, ReportState>(
    //       builder: (context, state) {
    //         return
    //       },
    //     ),
    //   ),
    // );

    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: Container(
        height: MediaQuery.of(ctx).size.height / 2,
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: state is ReportLoadingState
              ? const Center(
                  child: CupertinoActivityIndicator(),
                )
              : technicianData.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Technician",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryTitleColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: LimitedBox(
                            maxHeight:
                                MediaQuery.of(context).size.height / 2 - 90,
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print("heyy");

                                      technicianController.text =
                                          technicianData[index].firstName +
                                              " " +
                                              technicianData[index].lastName;
                                      technicianId =
                                          technicianData[index].id.toString();

                                      print(technicianId + "techhh iddd");

                                      context.read<ReportBloc>()
                                        ..currentPage = 1
                                        ..add(GetServiceByTechnicianReportEvent(
                                            searchQuery: "",
                                            startDate: "",
                                            endDate: "",
                                            page: "",
                                            techFilter: technicianId,
                                            currentPage: 1,
                                            pagination: "",
                                            exportType: ""));

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          "${technicianData[index].firstName} ${technicianData[index].lastName}",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: technicianData.length,
                            ),
                          ),
                        )
                      ],
                    )
                  : const Center(
                      child: Text("No Technician Found!"),
                    ),
        ),
      ),
    );
  }
}

class MyDataTableSource extends DataTableSource {
  final List<DataRow> _rows;

  MyDataTableSource(this._rows);

  @override
  DataRow? getRow(int index) {
    if (index >= _rows.length) {
      return null;
    }
    return _rows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}
