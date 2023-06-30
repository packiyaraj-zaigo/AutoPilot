import 'package:auto_pilot/Screens/add_company_details.dart';
import 'package:auto_pilot/api_provider/api_repository.dart';
import 'package:auto_pilot/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCompanyReviewScreen extends StatefulWidget {
  const AddCompanyReviewScreen(
      {super.key,
      required this.basicDetailsMap,
      required this.operationDetailsMap});
  final Map<String, dynamic> basicDetailsMap;
  final Map<String, dynamic> operationDetailsMap;

  @override
  State<AddCompanyReviewScreen> createState() => _AddCompanyReviewScreenState();
}

class _AddCompanyReviewScreenState extends State<AddCompanyReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(apiRepository: ApiRepository()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: AppColors.primaryColors,
              ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
                child: GestureDetector(
                  onTap: () {
                    Map<String, dynamic> finalDataMap = {}
                      ..addAll(widget.basicDetailsMap)
                      ..addAll(widget.operationDetailsMap);
                    context
                        .read<DashboardBloc>()
                        .add(AddCompanyEvent(dataMap: finalDataMap,context: context));
                  },
                  child: Container(
                    height: 56,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primaryColors,
                    ),
                    child:state is AddCompanyLoadingState?const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    ): const Text(
                      "Confirm",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Review Details",
                      style: TextStyle(
                          color: AppColors.primaryTitleColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Something wrong? Tap on the row to edit it.\nOtherwise tap confirm and continue.",
                        style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: detailsWidget("Name",
                          widget.basicDetailsMap['company_name'], "basic"),
                    ),
                    dividerLine(),
                    detailsWidget("Address",
                        widget.basicDetailsMap['address_1'], "basic"),
                    dividerLine(),
                    detailsWidget(
                        "Phone", widget.basicDetailsMap['phone'], "basic"),
                    dividerLine(),
                    detailsWidget("Website", "", "basic"),
                    dividerLine(),
                    detailsWidget("Timezone",
                        widget.operationDetailsMap['time_zone'], "operation"),
                    dividerLine(),
                    detailsWidget(
                        "Tax Rate",
                        widget.operationDetailsMap['sales_tax_rate'],
                        "operation"),
                    dividerLine(),
                    detailsWidget(
                        "Base Labor Cost",
                        widget.operationDetailsMap['base_labor_cost'],
                        "operation"),
                    dividerLine(),
                    detailsWidget("Employees", "", "employee"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dividerLine() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 0.5,
        color: const Color(0xff6A7187),
      ),
    );
  }

  Widget detailsWidget(String label, String value, String navigation) {
    return GestureDetector(
      onTap: () {
        if (navigation == "basic") {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return AddCompanyDetailsScreen(
                widgetIndex: 0,
                basicDetailsMap: widget.basicDetailsMap,
              );
            },
          ));
        } else if (navigation == "operation") {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return AddCompanyDetailsScreen(
                widgetIndex: 1,
                operationDetailsMap: widget.operationDetailsMap,
              );
            },
          ));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return AddCompanyDetailsScreen(widgetIndex: 2);
            },
          ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                  color: Color(
                    0xff6A7187,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              value,
              style: const TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}
