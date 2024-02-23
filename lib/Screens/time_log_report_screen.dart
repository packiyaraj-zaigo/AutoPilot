import 'package:auto_pilot/Models/report_technician_list_model.dart'
    as technicianModel;
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
  List<String> monthOptions = [
    "Today",
    "Yesterday",
    "Last Week",
    "Last Month",
    "Last Year"
  ];
  String? currentTimeIn;
  int _rowsPerPage = 5;
  TimeLogReportModel? timeLogReportModel;

  List<technicianModel.Datum> technicianData = [];
  final TextEditingController technicianController = TextEditingController();
  String technicianId = '';
  String startDateToServer = "";
  String endDateToServer = "";
  List<Datum> reportList = [];
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
  //TechnicianOnlyModel? technicianModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state is GetTimeLogReportSuccessState) {
            reportList.clear();
            rows.clear();
            timeLogReportModel = state.timeLogReportModel;
            reportList.addAll(state.timeLogReportModel.data.paginator.data);

            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                //  DataCell(Text(element.entry.toString())),
                // DataCell(Text(element.type)),
                DataCell(Text(element.techician)),
                DataCell(Text(element.firstName)),
                DataCell(Text(element.lastName)),
                DataCell(Text(element.vehicleName)),
                //  DataCell(Text(element.fndEndDate.toString())),
                DataCell(Text(element.activityType)),
                DataCell(Text(element.activityName)),
                DataCell(Text(element.note)),
                DataCell(Text(element.techRate.toString())),
                DataCell(Text(element.duration.toString())),
                DataCell(Text(element.total.toString())),
              ]));
            });
          } else if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add(GetTimeLogReportEvent(
                monthFilter: "",
                techFilter: "",
                searchQuery: "",
                currentPage: 1,
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
                fileName: "TimeLogReport",
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
                                    "Hours tracked",
                                    timeLogReportModel?.hoursTracked ?? "",
                                    Color(0xff5976F6)),
                                // timeLogTile(
                                //     "Average hours per service",
                                //     timeLogReportModel?.  ?? "",
                                //     Color(0xff12A58C)),
                                const SizedBox(
                                  height: 35,
                                ),
                                monthDropdown("Time in", context),
                                technicianDropdown(
                                    "Technicians", context, state),
                                //  searchBar(),
                                const SizedBox(
                                  height: 36,
                                ),
                                state is GetTimeLogReportErrorState
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
          padding: const EdgeInsets.only(right: 21.0, bottom: 12, left: 21),
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

                ctx.read<ReportBloc>().add(GetTimeLogReportEvent(
                    monthFilter: currentTimeIn == "Last Week"
                        ? "last_week"
                        : currentTimeIn == "Last Month"
                            ? "last_month"
                            : currentTimeIn == "Last Year"
                                ? "last_year"
                                : currentTimeIn?.toLowerCase() ?? "",
                    techFilter: technicianId,
                    searchQuery: "",
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

  monthDropdown(String label, BuildContext ctx) {
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 24),
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
                value: currentTimeIn,
                icon: currentTimeIn != null && currentTimeIn != ""
                    ? GestureDetector(
                        onTap: () {
                          ctx.read<ReportBloc>()
                            ..currentPage = 1
                            ..add(GetTimeLogReportEvent(
                                monthFilter: "",
                                techFilter: technicianId,
                                searchQuery: "",
                                currentPage: 1,
                                exportType: ""));

                          setState(() {
                            currentTimeIn = null;
                          });
                        },
                        child: Icon(Icons.close))
                    : const SizedBox(),
                hint: Text("Select Time in"),
                onChanged: (String? selectedMonth) {
                  // Handle selected month
                  print('Selected Month: $selectedMonth');
                  setState(() {
                    currentTimeIn = selectedMonth;
                  });

                  ctx.read<ReportBloc>()
                    ..currentPage = 1
                    ..add(GetTimeLogReportEvent(
                        monthFilter: currentTimeIn == "Last Week"
                            ? "last_week"
                            : currentTimeIn == "Last Month"
                                ? "last_month"
                                : currentTimeIn == "Last Year"
                                    ? "last_year"
                                    : currentTimeIn?.toLowerCase() ?? "",
                        techFilter: technicianId,
                        searchQuery: "",
                        currentPage: 1,
                        exportType: ""));
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
      ),
    );
  }

  technicianDropdown(String label, BuildContext ctx, state) {
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
                                ..add(GetTimeLogReportEvent(
                                    monthFilter: currentTimeIn == "Last Week"
                                        ? "last_week"
                                        : currentTimeIn == "Last Month"
                                            ? "last_month"
                                            : currentTimeIn == "Last Year"
                                                ? "last_year"
                                                : currentTimeIn
                                                        ?.toLowerCase() ??
                                                    "",
                                    techFilter: "",
                                    searchQuery: "",
                                    currentPage: 1,
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
                                // DataColumn(label: Text('Item')),
                                // DataColumn(label: Text('Description')),
                                // DataColumn(label: Text('Test')),
                                // DataColumn(label: Text('Test 2')),

                                // DataColumn(label: Text('Entry')),
                                // DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Technician')),
                                DataColumn(label: Text('First Name')),
                                DataColumn(label: Text('Last Name')),
                                DataColumn(label: Text('Vehicle')),
                                // DataColumn(label: Text('Fnd Date Time')),
                                DataColumn(label: Text('Activity Type')),
                                DataColumn(label: Text('Activity Name')),
                                DataColumn(label: Text('Note')),
                                DataColumn(label: Text('Tech Rate')),
                                DataColumn(label: Text('Duration')),
                                DataColumn(label: Text('Total')),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Rows per page: 10'),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                            "${timeLogReportModel?.data.range.from} - ${timeLogReportModel?.data.range.to} to ${timeLogReportModel?.data.range.total}")
                      ],
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (timeLogReportModel
                                        ?.data.paginator.prevPageUrl !=
                                    null) {
                                  ctx.read<ReportBloc>().add(
                                      GetTimeLogReportEvent(
                                          monthFilter: "",
                                          techFilter: technicianId,
                                          searchQuery: "",
                                          currentPage: 1,
                                          exportType: ""));
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: timeLogReportModel
                                            ?.data.paginator.prevPageUrl !=
                                        null
                                    ? Colors.black
                                    : Colors.grey.shade300,
                              )),
                          IconButton(
                              onPressed: () {
                                if (timeLogReportModel
                                        ?.data.paginator.nextPageUrl !=
                                    null) {
                                  ctx.read<ReportBloc>().add(
                                      GetTimeLogReportEvent(
                                          monthFilter: "",
                                          techFilter: technicianId,
                                          searchQuery: "",
                                          currentPage: 1,
                                          exportType: ""));
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: timeLogReportModel
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
                                        ..add(GetTimeLogReportEvent(
                                            monthFilter: "",
                                            techFilter: technicianId,
                                            searchQuery: "",
                                            currentPage: 1,
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
