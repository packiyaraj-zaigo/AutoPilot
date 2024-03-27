import 'package:auto_pilot/Models/customer_summary_report_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomerSummaryReportScreen extends StatefulWidget {
  const CustomerSummaryReportScreen({super.key});

  @override
  State<CustomerSummaryReportScreen> createState() =>
      _CustomerSummaryReportScreen();
}

class _CustomerSummaryReportScreen extends State<CustomerSummaryReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataRow> rows = [];
  Map<String, String> dropdownValuesMap = {
    'Today': 'today',
    'Yesterday': 'yesterday',
    'This week': 'week',
    'This month': 'month',
    'This year': 'year',
  };
  CustomerSummaryReportModel? customerSummaryReportModel;
  List<Datum> reportList = [];
  String sortBy = "desc";
  String? fieldName;
  String? table;

  // final List<ChartData> chartData = [
  //   ChartData("Mark", 35),
  //   ChartData("Kevin", 23),
  //   ChartData("san", 38),
  //   ChartData("san2", 30),
  //   ChartData("san3", 33),
  //   ChartData("san4", 36),
  //   ChartData("san5", 32),
  //   ChartData("san6", 35),
  //   ChartData("san7", 30),
  //   ChartData("san8", 33),
  //   ChartData("san9", 31),
  //   ChartData("san10", 32),
  // ];

  final List<ChartData> chartData = [];

  String? currentType;
  @override
  Widget build(BuildContext) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add(GetCustomerSummaryReportEvent(
                createFilter: "", page: "", exportType: ""));
          } else if (state is GetCustomerSummaryReportState) {
            reportList.clear();
            rows.clear();
            chartData.clear();
            customerSummaryReportModel = state.customerSummaryReportModel;
            reportList
                .addAll(state.customerSummaryReportModel.data.paginator.data);

            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.firstName)),
                DataCell(Text(element.lastName)),
                DataCell(Text(element.totalPayments)),
                DataCell(Text(element.profitablity)),
              ]));
            });

            customerSummaryReportModel?.graphArr.forEach((element) {
              chartData.add(ChartData(
                  element.firstName, double.parse(element.totalPayments)));
            });
          } else if (state is GetExportLinkState) {
            context.read<ReportBloc>().add(ExportReportEvent(
                downloadPath: "",
                downloadUrl: state.link,
                fileName: "",
                context: context));
          }
          // TODO: implement listener
        },
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              drawer: showDrawer(context),
              bottomNavigationBar: state is ReportLoadingState
                  ? const SizedBox()
                  : reportList.isEmpty
                      ? const SizedBox()
                      : exportButtonWidget(context),
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
              body: state is ReportLoadingState
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ],
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
                                "Summary By Customer",
                                style: TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              creationDropDown("Creation", context),
                              const SizedBox(
                                height: 24,
                              ),
                              reportList.isEmpty
                                  ? const SizedBox()
                                  : customerPaymentGraphWidget(),
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

  //Function to render customer payment graph widget.
  Widget customerPaymentGraphWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: 225,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 4))
              ]),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Payments",
                  style: TextStyle(
                      color: AppColors.primaryTitleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 180,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                            visibleMaximum: 3,
                            maximumLabelWidth: 30,
                            maximumLabels: 20,
                            autoScrollingMode: AutoScrollingMode.start),
                        zoomPanBehavior: ZoomPanBehavior(
                          enablePanning: true,
                        ),

                        // Palette colors
                        palette: const <Color>[
                          AppColors.primaryColors,
                        ],
                        series: <CartesianSeries>[
                          ColumnSeries<ChartData, String>(
                              width: 0.3,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                              //spacing: 0.2,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y),
                        ]),
                  ),
                )
              ],
            ),
          )),
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
                            ..add(GetCustomerSummaryReportEvent(
                                createFilter: "", page: "", exportType: ""));
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
                    ..add(GetCustomerSummaryReportEvent(
                        createFilter: dropdownValuesMap[currentType] ?? "",
                        page: "",
                        exportType: ""));
                },
                items: dropdownValuesMap.keys.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
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
                                  label: Row(
                                    children: [
                                      Text('First Name'),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            table = "customer";
                                            fieldName = "first_name";
                                          });

                                          sortTable(ctx);
                                        },
                                        child: Icon(sortBy == "asc"
                                            ? Icons.arrow_upward_rounded
                                            : Icons.arrow_downward_rounded),
                                      )
                                    ],
                                  ),
                                ),
                                DataColumn(
                                    label: Row(
                                  children: [
                                    Text('Last Name'),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          table = "customer";
                                          fieldName = "last_name";
                                        });

                                        sortTable(ctx);
                                      },
                                      child: Icon(sortBy == "asc"
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded),
                                    )
                                  ],
                                )),
                                DataColumn(label: Text('Total Payments')),
                                DataColumn(label: Text('Profitability')),
                              ],
                              rows: rows,
                              columnSpacing: 120,
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
                            "${customerSummaryReportModel?.data.range.from} - ${customerSummaryReportModel?.data.range.to} to ${customerSummaryReportModel?.data.range.total}")
                      ],
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (customerSummaryReportModel
                                        ?.data.paginator.prevPageUrl !=
                                    null) {
                                  ctx.read<ReportBloc>().add(
                                      GetCustomerSummaryReportEvent(
                                          createFilter:
                                              dropdownValuesMap[currentType] ??
                                                  "",
                                          page: "prev",
                                          exportType: ""));
                                }
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: customerSummaryReportModel
                                            ?.data.paginator.prevPageUrl !=
                                        null
                                    ? Colors.black
                                    : Colors.grey.shade300,
                              )),
                          IconButton(
                              onPressed: () {
                                if (customerSummaryReportModel
                                        ?.data.paginator.nextPageUrl !=
                                    null) {
                                  ctx.read<ReportBloc>().add(
                                      GetCustomerSummaryReportEvent(
                                          createFilter:
                                              dropdownValuesMap[currentType] ??
                                                  "",
                                          page: "next",
                                          exportType: ""));
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: customerSummaryReportModel
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

  Widget exportButtonWidget(BuildContext ctx) {
    String downloadPath = "";
    return BlocProvider.value(
      value: BlocProvider.of<ReportBloc>(ctx),
      child: Padding(
          padding: const EdgeInsets.only(right: 21.0, bottom: 12, left: 21),
          child: ElevatedButton(
              onPressed: () async {
                ctx.read<ReportBloc>().add(GetCustomerSummaryReportEvent(
                    createFilter: dropdownValuesMap[currentType] ?? "",
                    page: "",
                    fieldName: fieldName,
                    sortBy: sortBy,
                    table: table,
                    exportType: "excel"));
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0.6,
                  alignment: Alignment.center,
                  minimumSize: Size(MediaQuery.of(ctx).size.width, 56),
                  maximumSize: Size(MediaQuery.of(ctx).size.width, 56),
                  backgroundColor: Color(0xffF6F6F6),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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

  void toggleSortOrder() {
    setState(() {
      sortBy = sortBy == "asc" ? "desc" : "asc";
    });
    print("Sort order toggled to: $sortBy");
  }

  void sortTable(BuildContext ctx) {
    toggleSortOrder();
    ctx.read<ReportBloc>().add(GetCustomerSummaryReportEvent(
        createFilter: dropdownValuesMap[currentType] ?? "",
        page: "",
        exportType: "",
        fieldName: fieldName,
        sortBy: sortBy,
        table: table));
  }
}
