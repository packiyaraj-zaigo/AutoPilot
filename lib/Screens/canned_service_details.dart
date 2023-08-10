import 'package:auto_pilot/Models/canned_service_create_model.dart';
import 'package:auto_pilot/Models/canned_service_model.dart';
import 'package:auto_pilot/Screens/add_service_screen.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/Screens/services_list_screen.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/bloc/service_bloc/service_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CannedServiceDetailsPage extends StatefulWidget {
  const CannedServiceDetailsPage({super.key, required this.service});
  final Datum service;
  @override
  State<CannedServiceDetailsPage> createState() =>
      _CannedServiceDetailsPageState();
}

class _CannedServiceDetailsPageState extends State<CannedServiceDetailsPage> {
  int selectedIndex = 0;
  List<CannedServiceAddModel> material = [];
  List<CannedServiceAddModel> part = [];
  List<CannedServiceAddModel> labor = [];
  List<CannedServiceAddModel> subContract = [];
  List<CannedServiceAddModel> fee = [];

  @override
  void initState() {
    super.initState();
    if (widget.service.cannedServiceItems != null &&
        widget.service.cannedServiceItems!.isNotEmpty) {
      for (var element in widget.service.cannedServiceItems!) {
        final item = CannedServiceAddModel(
          id: element.id.toString(),
          cannedServiceId: element.cannedServiceId,
          discount: element.discount,
          itemName: element.itemName,
          unitPrice: element.unitPrice,
          part: element.partName ?? '',
          subTotal: element.subTotal,
          discountType: 'Percentage',
          itemType: element.itemType,
          position: element.position,
          quanityHours: element.quanityHours,
          note: '',
        );
        if (element.itemType == 'Material') {
          material.add(item);
        } else if (element.itemType == 'Part') {
          part.add(item);
        } else if (element.itemType == 'Labor') {
          labor.add(item);
        } else if (element.itemType == 'Fee') {
          fee.add(item);
        } else {
          subContract.add(item);
        }
      }
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAFAFA),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryColors,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          elevation: 0,
          title: const Text(
            'Service Information',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return moreOptionsSheet();
                  },
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12.0)),
                  ),
                );
              },
              child: const Icon(
                Icons.more_horiz,
                color: AppColors.primaryColors,
              ),
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: BlocListener<ServiceBloc, ServiceState>(
          listener: (context, state) {
            if (state is DeleteCannedServiceSuccessState) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ServicesListScreen(),
              ));

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Service Deleted Successfully"),
                  backgroundColor: Colors.green));
            }
            if (state is DeleteCannedServiceErrorState) {
              Navigator.of(context).pop(true);
              CommonWidgets().showDialog(context, '${state.message}');
            }
            if (state is DeleteCannedServiceLoadingState) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => const CupertinoActivityIndicator());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  widget.service.serviceName,
                  style: const TextStyle(
                      color: Color(0xFF061237),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: CupertinoSlidingSegmentedControl(
                    onValueChanged: (value) {
                      setState(() {
                        selectedIndex = value ?? 0;
                      });
                    },
                    groupValue: selectedIndex,
                    children: {
                      0: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          'assets/images/employee_info_icon.svg',
                          color: selectedIndex == 0
                              ? AppColors.primaryColors
                              : null,
                        ),
                      ),
                      1: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: SvgPicture.asset(
                          'assets/images/dollar.svg',
                          color: selectedIndex == 1
                              ? AppColors.primaryColors
                              : null,
                        ),
                      ),
                    },
                  ),
                ),
                const SizedBox(height: 24),
                selectedIndex == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Labor Rate',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${widget.service.servicePrice} \$',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(
                            thickness: 1.5,
                            color: Color(0xFFE8EAED),
                          ),
                          const SizedBox(height: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Discount',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${widget.service.discount} \$',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(
                            thickness: 1.5,
                            color: Color(0xFFE8EAED),
                          ),
                          // const SizedBox(height: 14),
                          // const Text(
                          //   'Address',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 15,
                          //   ),
                          // ),
                          // const SizedBox(height: 5),
                          // const Text(
                          //   '123 Street Name City, State Zip',
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          const Text(
                            'Tax',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${widget.service.tax}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Divider(
                            thickness: 1.5,
                            color: Color(0xFFE8EAED),
                          ),
                          // const SizedBox(height: 14),
                          // const Text(
                          //   'Sub Total',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 14,
                          //   ),
                          // ),
                          // const SizedBox(height: 5),
                          // Text(
                          //   '${widget.service.subTotal}',
                          //   style: const TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                          const SizedBox(height: 14),
                          const Divider(
                            thickness: 1.5,
                            color: Color(0xFFE8EAED),
                          ),
                        ],
                      )
                    : material.isEmpty &&
                            part.isEmpty &&
                            labor.isEmpty &&
                            subContract.isEmpty &&
                            fee.isEmpty
                        ? const Center(
                            child: Text(
                            'No Items Found',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyText),
                          ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              material.isEmpty
                                  ? const SizedBox()
                                  : itemTile(material, 'Material'),
                              part.isEmpty
                                  ? const SizedBox()
                                  : itemTile(part, 'Part'),
                              labor.isEmpty
                                  ? const SizedBox()
                                  : itemTile(labor, 'Labor'),
                              subContract.isEmpty
                                  ? const SizedBox()
                                  : itemTile(subContract, 'Sub Contract'),
                              fee.isEmpty
                                  ? const SizedBox()
                                  : itemTile(fee, 'Fee'),
                            ],
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column itemTile(List<CannedServiceAddModel> cannedServiceItem, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cannedServiceItem.length,
              itemBuilder: (context, index) {
                final item = cannedServiceItem[index];
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(item.itemName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        const Expanded(child: SizedBox()),
                        Text('\$${item.subTotal} ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(
          thickness: 1.5,
          color: Color(0xFFE8EAED),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget moreOptionsSheet() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              bottomSheetTile(
                'Edit',
                Icons.edit,
                AddServiceScreen(
                  fee: fee,
                  labor: labor,
                  material: material,
                  part: part,
                  service: widget.service,
                  subContract: subContract,
                ),
                context,
              ),
              bottomSheetTile(
                'Delete',
                Icons.delete,
                null,
                context,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 56,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColors),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetTile(
      String title, IconData icon, constructor, BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () async {
          if (title == 'Delete') {
            Navigator.of(context).pop(true);
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Delete service?"),
                content:
                    const Text('Do you really want to delete this service?'),
                actions: [
                  CupertinoButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      BlocProvider.of<ServiceBloc>(scaffoldKey.currentContext!)
                          .add(
                        DeleteCannedServiceEvent(
                          id: widget.service.id.toString(),
                        ),
                      );
                    },
                  ),
                  CupertinoButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              ),
            );
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => constructor,
              ),
            );
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: const Color(0xffF6F6F6),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: title == 'Delete'
                    ? CupertinoColors.destructiveRed
                    : AppColors.primaryColors,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: title == 'Delete'
                        ? CupertinoColors.destructiveRed
                        : AppColors.primaryColors,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
