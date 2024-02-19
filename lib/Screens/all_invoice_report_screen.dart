import 'package:auto_pilot/Models/all_invoice_report_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/bloc/report_bloc/report_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AllInvoiceReportScreen extends StatefulWidget {
  AllInvoiceReportScreen({super.key});

  @override
  State<AllInvoiceReportScreen> createState() => _AllInvoiceReportScreen();
}

class _AllInvoiceReportScreen extends State<AllInvoiceReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> monthOptions = ["This Month", "Last Month"];
  AllInvoiceReportModel? allInvoiceReportModel;
  int _rowsPerPage = 5;

  // final List<DataRow> rows = List.generate(
  //   18, // Replace with your actual data
  //   (index) => DataRow(
  //     cells: [
  //       DataCell(Text('First Name $index')),
  //       DataCell(Text('Last Name $index')),
  //       DataCell(Text('Vehicle $index')),
  //       DataCell(Text('Order $index')),
  //       DataCell(Text('Order Name $index')),
  //       DataCell(Text('Payment Date $index')),
  //       DataCell(Text('Note $index')),
  //       DataCell(Text('Payment Type $index')),
  //       DataCell(Text('Card Type $index')),
  //       DataCell(Text('Total Order Amount $index')),
  //       DataCell(Text('Remaining Amount $index')),
  //       DataCell(Text('Payment Amount $index')),

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

  @override
  void initState() {
    DateFormat outputFormat = DateFormat('MMM d, yyyy');
    startDateStr = outputFormat.format(dateRangeList[0]!);
    endDateStr = outputFormat.format(dateRangeList[1]!);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportBloc()..add(InternetConnectionEvent()),
      child: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is InternetConnectionSuccessState) {
            context.read<ReportBloc>().add((GetAllInvoiceReportEvent(
                monthFilter: "",
                paidFilter: "",
                searchQuery: "",
                currentPage: 1)));
          }
          // TODO: implement listener

          if (state is GetAllInvoiceReportSuccessState) {
            allInvoiceReportModel = state.allInvoiceReportModel;

            allInvoiceReportModel?.data.data.forEach((element) {
              rows.add(DataRow(cells: [
                DataCell(Text(element.customerFirstName)),
                DataCell(Text(element.vehicleName)),
                DataCell(Text(element.customerLastName)),
                DataCell(Text(element.orderNumber.toString())),
                DataCell(Text(element.orderName ?? "")),
                DataCell(Text(element.paymentDate.toString())),
                DataCell(Text(element.note)),
                DataCell(Text(element.paymentType)),
                DataCell(Text(element.cardType)),
                DataCell(Text(element.totalOrderAmount.toString())),
                DataCell(Text(element.remainingAmount.toString())),
                DataCell(Text(element.paymentAmount.toString())),
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
                            padding: const EdgeInsets.only(
                              top: 15.0,
                              left: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "All Invoices",
                                  style: TextStyle(
                                      color: AppColors.primaryTitleColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                dateSelectionWidget(),
                                monthDropdown("Fully Paid"),
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

  Widget dateSelectionWidget() {
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
                    width: MediaQuery.of(context).size.width,
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
                      child: Text(
                        "${startDateStr}- ${endDateStr}",
                        style: TextStyle(fontSize: 16),
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
                      return AlertDialog(
                        insetPadding: EdgeInsets.zero,
                        content: Container(
                          height: 400,
                          width: 300,
                          child: Column(
                            children: [
                              CalendarDatePicker2(
                                  config: CalendarDatePicker2Config(
                                    calendarType: CalendarDatePicker2Type.range,
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
                                        });

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

  monthDropdown(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, right: 24),
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

                  DataColumn(label: Text('First Name')),
                  DataColumn(label: Text('Vehicle')),
                  DataColumn(label: Text('Last Name')),
                  DataColumn(label: Text('Order')),
                  DataColumn(label: Text('Order Name')),
                  DataColumn(label: Text('Payment Date')),
                  DataColumn(label: Text('Note')),
                  DataColumn(label: Text('Payment Type')),
                  DataColumn(label: Text('Card Type')),
                  DataColumn(label: Text('Total Order Amount')),
                  DataColumn(label: Text('Remaining Amount')),
                  DataColumn(label: Text('Payment Amount')),
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
