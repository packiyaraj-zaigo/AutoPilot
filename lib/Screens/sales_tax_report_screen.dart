import 'package:auto_pilot/Screens/all_invoice_report_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SalesTaxReportScreen extends StatefulWidget {
  const SalesTaxReportScreen({super.key});

  @override
  State<SalesTaxReportScreen> createState() => _SalesTaxReportScreenState();
}

class _SalesTaxReportScreenState extends State<SalesTaxReportScreen> {
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              dateSelectionWidget(),
              const SizedBox(
                height: 6,
              ),
              taxTileWidget("Taxes collected", "48000"),
              taxTileWidget("Taxe owed", "68000"),
              tableWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget dateSelectionWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, right: 24, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date",
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
                        "Aug 1 ,2023- Aug 10 , 2023",
                        style: TextStyle(fontSize: 16),
                      ),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                          "assets/images/report_calander_icon.svg")),
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
