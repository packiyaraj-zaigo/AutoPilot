import 'package:auto_pilot/Models/payment_type_report_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentTypeReportScreen extends StatefulWidget {
  PaymentTypeReportScreen({super.key});

  @override
  State<PaymentTypeReportScreen> createState() => _PaymentTypeReportScreen();
}

class _PaymentTypeReportScreen extends State<PaymentTypeReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PaymentTypeReportModel? paymentTypeReportModel;
  List<String> typeList = ["Cash", "Card", "Check", "Others"];
  int _rowsPerPage = 5;
  String? currentType;
  List<Total> reportList = [];
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
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is GetPaymentTypeReportSuccessState) {
            paymentTypeReportModel = state.paymentReportModel;
            reportList.clear();
            rows.clear();
            reportList.addAll(state.paymentReportModel.data.totals);

            reportList.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.type)),
                DataCell(Text(element.percentage.toString())),
                DataCell(Text(element.total.toString())),
              ]));
            });
          } else if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add(GetPaymentTypeReportEvent(
                typeFilter: "",
                searchQuery: "",
                currentPage: 1,
                exportType: ""));
          } else if (state is GetExportLinkState) {
            context.read<ReportBloc>().add(ExportReportEvent(
                downloadPath: "",
                downloadUrl: state.link,
                fileName: "PaymentTypeReport",
                context: context));
          }
          // TODO: implement listener
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
                                  "Payment Types",
                                  style: TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                typeDropDown("Type", context),
                                // searchBar(),
                                const SizedBox(
                                  height: 36,
                                ),
                                state is GetPaymentTypeReportErrorState
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
                                    : tableWidget()
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

  typeDropDown(String label, BuildContext ctx) {
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

                ctx.read<ReportBloc>().add(GetPaymentTypeReportEvent(
                    typeFilter: currentType?.toLowerCase() ?? "",
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
    return reportList.isEmpty
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

                        DataColumn(label: Text('Payment Type')),
                        DataColumn(label: Text('% of Total')),
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
