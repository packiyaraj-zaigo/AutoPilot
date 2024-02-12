import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllInvoiceReportScreen extends StatefulWidget {
  AllInvoiceReportScreen({super.key});

  @override
  State<AllInvoiceReportScreen> createState() => _AllInvoiceReportScreen();
}

class _AllInvoiceReportScreen extends State<AllInvoiceReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> monthOptions = ["This Month", "Last Month"];
  final List<DataRow> rows = List.generate(
    10, // Replace with your actual data
    (index) => DataRow(
      cells: [
        DataCell(Text('Item $index')),
        DataCell(Text('Description $index')),
        DataCell(Text('Test $index')),
        DataCell(Text('Test 2 $index')),

        // Add more DataCells as needed
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
              monthDropdown("Invoiced"),
              monthDropdown("Fully Paid"),
              searchBar(),
              tableWidget()
            ],
          ),
        ),
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
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: PaginatedDataTable(columns: [
                    DataColumn(label: Text('Item')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Test')),
                    DataColumn(label: Text('Test 2')),
                  ], headingRowHeight: 50, source: MyDataTableSource(rows)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(19, 168, 208, 248),
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(value: false, onChanged: (vlaue) {})),
              Text(
                "Dense",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )
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
