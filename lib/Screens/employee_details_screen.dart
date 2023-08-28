import 'dart:developer';

import 'package:auto_pilot/Models/employee_response_model.dart';
import 'package:auto_pilot/Screens/create_employee_screen.dart';
import 'package:auto_pilot/Screens/employee_list_screen.dart';
import 'package:auto_pilot/bloc/employee/employee_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  const EmployeeDetailsScreen({super.key, required this.employee});
  final Employee employee;

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  int selectedIndex = 0;
  List<Widget> messageChatWidgetList = [];
  final messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
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
            Navigator.of(context).pop(true);
          },
        ),
        elevation: 0,
        title: const Text(
          'Employee Information',
          style: TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
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
      body: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is DeleteEmployeeSuccessState) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const EmployeeListScreen(),
            ));
            CommonWidgets()
                .showSuccessDialog(context, "Employee Deleted Successfully");
          } else if (state is DeleteEmployeeErrorState) {
            Navigator.of(context).pop(true);
            CommonWidgets().showDialog(
                context, 'Something went wrong please try again later');
          } else if (state is DeleteEmployeeLoadingState) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const CupertinoActivityIndicator());
          } else if (state is GetEmployeeMessageState) {
            for (var message in state.messages) {
              messageChatWidgetList.add(chatBubleWidget(
                  message.message,
                  AppUtils.getTimeFormattedForMessage(
                      message.createdAt.toLocal().toString()),
                  widget.employee.id == message.senderUserId));
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                '${widget.employee.firstName ?? ''} ${widget.employee.lastName ?? ''}',
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

                    if (selectedIndex == 1) {
                      messageChatWidgetList.clear();
                      context.read<EmployeeBloc>().messageCurrentPage = 1;
                      context.read<EmployeeBloc>().messageTotalPage = 1;
                      context.read<EmployeeBloc>().messageIsFetching = true;
                      context.read<EmployeeBloc>().add(
                            GetEmployeeMessageEvent(
                              receiverUserId: widget.employee.id.toString(),
                            ),
                          );
                    }
                  },
                  groupValue: selectedIndex,
                  children: {
                    0: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SvgPicture.asset(
                        'assets/images/employee_info_icon.svg',
                        color:
                            selectedIndex == 0 ? AppColors.primaryColors : null,
                      ),
                    ),
                    1: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: SvgPicture.asset(
                        'assets/images/employee_message_icon.svg',
                        color:
                            selectedIndex == 1 ? AppColors.primaryColors : null,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                widget.employee.phone!.length > 6
                                    ? Text(
                                        '(${widget.employee.phone!.substring(0, 3)}) ${widget.employee.phone!.substring(3, 6)} - ${widget.employee.phone!.substring(6)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )
                                    : Text(
                                        '(${widget.employee.phone!.substring(0, 3)}) ${widget.employee.phone!.substring(3, 6)}}',
                                        style: const TextStyle(
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
                                  icon: SizedBox(
                                    height: 27,
                                    width: 18,
                                    child: SvgPicture.asset(
                                      'assets/images/sms_icons.svg',
                                      height: 27,
                                      color: AppColors.primaryColors,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                IconButton(
                                  onPressed: () {
                                    final Uri emailLaunchUri = Uri(
                                      scheme: 'tel',
                                      path: widget.employee.phone ?? '',
                                    );

                                    launchUrl(emailLaunchUri);
                                  },
                                  icon: SizedBox(
                                    height: 27,
                                    width: 18,
                                    child: SvgPicture.asset(
                                      'assets/images/phone_icon.svg',
                                      height: 27,
                                      color: AppColors.primaryColors,
                                    ),
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
                                    fontSize: 14,
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
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject': ' ',
                                    }),
                                  );

                                  launchUrl(emailLaunchUri);
                                }
                              },
                              icon: SizedBox(
                                height: 27,
                                width: 18,
                                child: SvgPicture.asset(
                                  'assets/images/mail_icons.svg',
                                  height: 23,
                                  color: AppColors.primaryColors,
                                ),
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
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${widget.employee.roles?[0].name?.toUpperCase() ?? ''}',
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
                        const SizedBox(height: 14),
                        const Text(
                          'Created Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
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
                  : chatWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget chatWidget() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return state is GetEmployeeMessageLoadingState &&
                !BlocProvider.of<EmployeeBloc>(context).messageIsFetching
            ? const Expanded(child: CupertinoActivityIndicator())
            : Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    chatBoxWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              messageChipWidget("Ready for pickup"),
                              messageChipWidget("Working on.."),
                              messageChipWidget("We are delayed")
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 0.7,
                                  spreadRadius: 1.2,
                                  offset: Offset(3, 2))
                            ]),

                        // child: Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal:22.0),
                        //   child: Row(
                        //     children: [
                        //       SvgPicture.asset("assets/images/attachment_icon.svg"),

                        //       TextField(
                        //         decoration: InputDecoration(
                        //           hintText: "Enter your message..",
                        //           contentPadding: EdgeInsets.all(0)
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),

                        child: TextField(
                          controller: messageController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 18),
                              hintText: "Enter your messsage..",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                        "assets/images/attachment_icon.svg")),
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (messageController.text
                                        .trim()
                                        .isNotEmpty) {
                                      setState(() {
                                        messageChatWidgetList.add(
                                            chatBubleWidget(
                                                messageController.text,
                                                AppUtils
                                                    .getTimeFormattedForMessage(
                                                        DateTime.now()
                                                            .toString()),
                                                false));
                                        BlocProvider.of<EmployeeBloc>(context)
                                            .add(SendEmployeeMessageEvent(
                                                receiverUserId: widget
                                                    .employee.id
                                                    .toString(),
                                                message: messageController.text
                                                    .trim()));
                                        messageController.clear();
                                      });
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.primaryColors,
                                    child: SvgPicture.asset(
                                        "assets/images/send_icon.svg"),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    )
                  ],
                ),
              );
      },
    );
  }

  Widget messageChipWidget(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 9.0),
      child: GestureDetector(
        onTap: () {
          messageController.text = text;
        },
        child: Container(
          // height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryColors)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 13),
            child: Text(
              text,
              style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  Widget chatBoxWidget() {
    return Expanded(
      child: ListView.builder(
        controller: scrollController
          ..addListener(() {
            if (scrollController.offset ==
                    scrollController.position.maxScrollExtent &&
                !BlocProvider.of<EmployeeBloc>(context).messageIsFetching &&
                BlocProvider.of<EmployeeBloc>(context).messageCurrentPage <=
                    BlocProvider.of<EmployeeBloc>(context).messageTotalPage) {
              BlocProvider.of<EmployeeBloc>(context).messageIsFetching = true;

              BlocProvider.of<EmployeeBloc>(context).add(
                  GetEmployeeMessageEvent(
                      receiverUserId: widget.employee.id.toString()));
            }
          }),
        reverse: true,
        itemBuilder: (context, index) {
          final messages = messageChatWidgetList.reversed.toList();
          return messages[index];
        },
        itemCount: messageChatWidgetList.length,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
      ),
    );
  }

  Widget chatBubleWidget(String message, String time, bool isReceived) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment:
            isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: isReceived ? Colors.white : AppColors.primaryColors,
                boxShadow: isReceived
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset:
                              const Offset(0, 7), // changes position of shadow
                        ),
                      ]
                    : [],
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Column(
                crossAxisAlignment: isReceived
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.7,
                        minWidth: 80),
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: isReceived
                            ? AppColors.primaryTitleColor
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: isReceived
                                ? AppColors.primaryTitleColor
                                : Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        //  Expanded(child: SizedBox()),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 6.0),
                        //   child: SvgPicture.asset(
                        //       "assets/images/Double_tick_icon.svg"),
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //   ),
          //  ),
        ],
      ),
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
                CreateEmployeeScreen(
                  navigation: 'edit_employee',
                  employee: widget.employee,
                ),
              ),
              bottomSheetTile(
                'Delete',
                Icons.delete,
                null,
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

  Widget bottomSheetTile(String title, IconData icon, constructor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () async {
          if (title == 'Delete') {
            Navigator.of(context).pop(true);
            showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text("Delete employee?"),
                content:
                    const Text('Do you really want to delete this employee?'),
                actions: [
                  CupertinoButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      BlocProvider.of<EmployeeBloc>(context).add(
                        DeleteEmployee(
                          id: widget.employee.id!,
                          context: context,
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
