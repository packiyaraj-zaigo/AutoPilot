import 'package:auto_pilot/Screens/all_invoice_report_screen.dart';
import 'package:auto_pilot/Screens/all_orders_report.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/canned_service_report_screen.dart';
import 'package:auto_pilot/Screens/customer_summary_report_screen.dart';
import 'package:auto_pilot/Screens/end_of_day_report_screen.dart';
import 'package:auto_pilot/Screens/invoice_by_servicewriter_report_screen.dart';
import 'package:auto_pilot/Screens/line_item_detail_report_screen.dart';
import 'package:auto_pilot/Screens/payment_type_report_screen.dart';
import 'package:auto_pilot/Screens/profitability_report_screen.dart';
import 'package:auto_pilot/Screens/sales_tax_report_screen.dart';
import 'package:auto_pilot/Screens/service_by_technician_report_screen.dart';
import 'package:auto_pilot/Screens/shop_performance_summary_report_screen.dart';
import 'package:auto_pilot/Screens/time_log_report_screen.dart';
import 'package:auto_pilot/Screens/transaction_report_screen.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ReportListScreen extends StatefulWidget {
  ReportListScreen({super.key});
  @override
  State<ReportListScreen> createState() => _ReportListScreen();
}

class _ReportListScreen extends State<ReportListScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: showDrawer(context),
      key: scaffoldKey,
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
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        title: const Text(
          'Autopilot',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Reports',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryTitleColor,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              reportTileWidget("All Invoice", AllInvoiceReportScreen()),
              reportTileWidget("Sales Tax", SalesTaxReportScreen()),
              reportTileWidget("Time Log", TimeLogReportScreen()),
              reportTileWidget("Payment Types", PaymentTypeReportScreen()),
              reportTileWidget(
                  "Services By Technician", ServicesByTechnicianReportScreen()),
              reportTileWidget(
                  "Shop Performance Summary", ShopPerformanceSummaryScreen()),
              reportTileWidget(
                  "Summary By Customer", CustomerSummaryReportScreen()),
              reportTileWidget("Transactions", TransactionReportScreen()),
              reportTileWidget("All Orders", AllOrdersReportScreen()),
              reportTileWidget("Invoice By Service Writer",
                  InvoiceByServiceWriterReportScreen()),
              reportTileWidget(
                  "Line Item Detail", LineItemDetailReportScreen()),
              reportTileWidget("End of Day", EndOfDayReportScreen()),
              reportTileWidget("Profitability", ProfitabilityReportScreen()),
              reportTileWidget(
                  "Canned Service Summary", CannedServiceReportScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget reportTileWidget(String title, Widget screen) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return screen;
          },
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 13.0, bottom: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
