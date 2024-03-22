import 'package:auto_pilot/Models/shop_performance_report_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShopPerformanceSummaryScreen extends StatefulWidget {
  const ShopPerformanceSummaryScreen({super.key});

  @override
  State<ShopPerformanceSummaryScreen> createState() =>
      _ShopPerformanceSummaryScreen();
}

class _ShopPerformanceSummaryScreen
    extends State<ShopPerformanceSummaryScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ShopPerformanceReportModel? shopPerformanceReportModel;
  List<DataRow> rows = [];
  List<Service> reportList = [];
  @override
  Widget build(BuildContext) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is InternetConnectionSuccessState) {
            context
                .read<ReportBloc>()
                .add(GetShopPerformanceReportEvent(exportType: ""));
          } else if (state is GetShopPerformanceReportState) {
            shopPerformanceReportModel = state.shopPerformanceReportModel;
            reportList.addAll(state.shopPerformanceReportModel.data.service);
            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.type)),
                DataCell(Text(element.percentage)),
                DataCell(Text(element.service)),
              ]));
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
                                "Sales Summary",
                                style: TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              summaryTile(
                                  "Invoiced",
                                  shopPerformanceReportModel?.invoiced
                                          .toString() ??
                                      "0"),
                              summaryTile(
                                  "Payments Collected",
                                  shopPerformanceReportModel?.paymentCollected
                                          .toString() ??
                                      "0"),
                              summaryTile(
                                  "Profit",
                                  shopPerformanceReportModel?.profit
                                          .toString() ??
                                      "0"),
                              summaryTile(
                                  "Profit Percentage",
                                  shopPerformanceReportModel?.profitPercentage
                                          .toString() ??
                                      "0"),
                              const SizedBox(
                                height: 32,
                              ),
                              Text(
                                "Revenue Breakdown",
                                style: TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 12,
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
                            label: Text('Type'),
                          ),
                          DataColumn(label: Text('%')),
                          DataColumn(label: Text('Revenue')),
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
          const SizedBox(
            height: 24,
          )

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
                ctx
                    .read<ReportBloc>()
                    .add(GetShopPerformanceReportEvent(exportType: "excel"));
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
