import 'package:auto_pilot/Models/line_item_detail_report_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/dashboard_screen.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LineItemDetailReportScreen extends StatefulWidget {
  const LineItemDetailReportScreen({super.key});

  @override
  State<LineItemDetailReportScreen> createState() =>
      _LineItemDetailReportScreen();
}

class _LineItemDetailReportScreen extends State<LineItemDetailReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<DataRow> rows = [];
  Map<String, String> dropdownValuesMap = {
    'Today': 'today',
    'Yesterday': 'yesterday',
    'This week': 'week',
    'This month': 'month',
    'This year': 'year',
  };
  LineItemDetailReportModel? lineItemDetailReportModel;
  List<Datum> reportList = [];
  String sortBy = "desc";
  String? fieldName;
  String? table;

  String? currentType;
  @override
  Widget build(BuildContext) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          // TODO: implement listener

          if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add(GetLineItemDetailReportEvent(
                createFilter: "", exportType: "", page: ""));
          } else if (state is GetLineItemDetailReportState) {
            reportList.clear();
            rows.clear();
            lineItemDetailReportModel = state.lineItemDetailReportModel;
            reportList
                .addAll(state.lineItemDetailReportModel.data.paginator.data);

            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.orderNumber.toString())),
                DataCell(Text(element.invoicedDate)),
                DataCell(Text(element.vehicle)),
                DataCell(Text(element.type)),
                DataCell(Text(element.itemDescription)),
                DataCell(Text(element.technician)),
                DataCell(Text(element.vendor)),
                DataCell(Text(element.cost)),
                DataCell(Text(element.price)),
                DataCell(Text(element.quantity)),
              ]));
            });
          } else if (state is GetExportLinkState) {
            context.read<ReportBloc>().add(ExportReportEvent(
                downloadPath: "",
                downloadUrl: state.link,
                fileName: "",
                context: context));
          }
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
                                "Line Item Detail",
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
                            ..add(GetLineItemDetailReportEvent(
                                createFilter: "", exportType: "", page: ""));
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
                    ..add(GetLineItemDetailReportEvent(
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
                            label: Row(
                              children: [
                                Text('Order'),
                              ],
                            ),
                          ),
                          DataColumn(label: Text('Invoiced Date')),
                          DataColumn(label: Text('Vehicle')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Type Description')),
                          DataColumn(label: Text('Technician')),
                          DataColumn(label: Text('Vendor')),
                          DataColumn(label: Text('Cost')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Quantity')),
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
                  Text(
                      "${lineItemDetailReportModel?.data.range.from} - ${lineItemDetailReportModel?.data.range.to} to ${lineItemDetailReportModel?.data.range.total}")
                ],
              ),
              Transform.scale(
                scale: 0.7,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (lineItemDetailReportModel
                                  ?.data.paginator.prevPageUrl !=
                              null) {
                            ctx.read<ReportBloc>().add(
                                GetLineItemDetailReportEvent(
                                    createFilter:
                                        dropdownValuesMap[currentType] ?? "",
                                    exportType: "",
                                    page: "prev"));
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: lineItemDetailReportModel
                                      ?.data.paginator.prevPageUrl !=
                                  null
                              ? Colors.black
                              : Colors.grey.shade300,
                        )),
                    IconButton(
                        onPressed: () {
                          if (lineItemDetailReportModel
                                  ?.data.paginator.nextPageUrl !=
                              null) {
                            ctx.read<ReportBloc>().add(
                                GetLineItemDetailReportEvent(
                                    createFilter:
                                        dropdownValuesMap[currentType] ?? "",
                                    exportType: "",
                                    page: "next"));
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: lineItemDetailReportModel
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
                ctx.read<ReportBloc>().add(GetLineItemDetailReportEvent(
                    createFilter: "", exportType: "excel", page: ""));
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

  void toggleSortOrder() {
    setState(() {
      sortBy = sortBy == "asc" ? "desc" : "asc";
    });
    print("Sort order toggled to: $sortBy");
  }

  void sortTable(BuildContext ctx) {
    toggleSortOrder();
    ctx.read<ReportBloc>().add(GetLineItemDetailReportEvent(
        createFilter: dropdownValuesMap[currentType] ?? "",
        exportType: "",
        page: "",
        sortBy: sortBy,
        fieldName: fieldName,
        table: table));
  }
}
