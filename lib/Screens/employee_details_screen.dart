import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key, required this.employee});
  final Employee employee;

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final tabBarItems = [
    SvgPicture.asset('assets/images/employee_info_icon.svg'),
    SvgPicture.asset('assets/images/employee_message_icon.svg'),
    SvgPicture.asset('assets/images/employee_payment_icon.svg'),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final date =
        AppUtils.getDateFormatted(widget.employee.createdAt.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColors,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        title: const Text(
          'Employee Information',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              // Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              '${widget.employee.firstName ?? ''} ${widget.employee.lastName ?? ''}',
              style: TextStyle(
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
                  for (int i = 0; i < tabBarItems.length; i++)
                    i: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: tabBarItems[i],
                    )
                },
              ),
            ),
            const SizedBox(height: 24),
            selectedIndex == 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '(${widget.employee.phone!.substring(0, 3)})    ${widget.employee.phone!.substring(3, 6)} - ${widget.employee.phone!.substring(6)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (widget.employee.phone != null) {
                                    final Uri smsLaunchUri = Uri(
                                      scheme: 'sms',
                                      path: widget.employee.phone!,
                                      queryParameters: <String, String>{
                                        'body': Uri.encodeComponent(' '),
                                      },
                                    );
                                    launchUrl(smsLaunchUri);
                                  }
                                },
                                icon: SvgPicture.asset(
                                  'assets/images/sms_icons.svg',
                                   color: AppColors.primaryColors,
                                  height: 27,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                onPressed: () {
                                  final Uri emailLaunchUri = Uri(
                                    scheme: 'tel',
                                    path: widget.employee.phone ?? '',
                                  );

                                  launchUrl(emailLaunchUri);
                                },
                                icon: SvgPicture.asset(
                                  'assets/images/phone_icon.svg',
                                   color: AppColors.primaryColors,
                                  height: 27,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(
                        thickness: 1.5,
                        color: Color(0xFFE8EAED),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '${widget.employee.email}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              if (widget.employee.email != null) {
                                String? encodeQueryParameters(
                                    Map<String, String> params) {
                                  return params.entries
                                      .map((MapEntry<String, String> e) =>
                                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                      .join('&');
                                }

                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: widget.employee.email ?? '',
                                  query: encodeQueryParameters(<String, String>{
                                    'subject': ' ',
                                  }),
                                );

                                launchUrl(emailLaunchUri);
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/images/mail_icons.svg',
                               color: AppColors.primaryColors,
                              height: 23,
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
                        'Position',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${widget.employee.roles?[0].name ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(
                        thickness: 1.5,
                        color: Color(0xFFE8EAED),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Created Date',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '$date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(
                        thickness: 1.5,
                        color: Color(0xFFE8EAED),
                      ),
                    ],
                  )
                : selectedIndex == 1
                    ? const Text('message')
                    : const Text('payment')
          ],
        ),
      ),
    );
  }
}
