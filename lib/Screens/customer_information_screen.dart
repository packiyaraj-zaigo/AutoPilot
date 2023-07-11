import 'dart:developer';

import 'package:auto_pilot/Models/customer_model.dart';
import 'package:auto_pilot/Models/cutomer_message_model.dart' as cm;
import 'package:auto_pilot/Screens/customers_screen.dart' as cs;
import 'package:auto_pilot/Screens/new_customer_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/customer_bloc/customer_bloc.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/app_utils.dart';

class CustomerInformationScreen extends StatefulWidget {
  const CustomerInformationScreen({
    Key? key,
    required this.customerData,
  }) : super(key: key);
  final Datum customerData;

  @override
  State<CustomerInformationScreen> createState() =>
      _CustomerInformationScreenState();
}

class _CustomerInformationScreenState extends State<CustomerInformationScreen> {
  final List _segmentTitles = [
    SvgPicture.asset(
      "assets/images/info.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/note.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/chat_icon.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/car_icon.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
    SvgPicture.asset(
      "assets/images/dollar.svg",
      color: AppColors.greyText,
      height: 20,
      width: 20,
    ),
  ];
  int? selectedIndex = 0;
  List<Widget> messageChatWidgetList = [];
  List<cm.Datum> customerMessageList = [];
  final messageController = TextEditingController();
  final chatScrollController = ScrollController();
  int newIndex = 0;
  final _debouncer = Debouncer();
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<CustomerBloc>(context).add(customerDetails(query: ''));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryBlackColors,
            size: AppStrings.fontSize16,
          ),
        ),
        title: Text(
          'Customer Information',
          style: TextStyle(
              color: AppColors.primaryBlackColors,
              fontSize: AppStrings.fontSize16,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                showBottomSheet();
              },
              icon: Icon(
                Icons.more_horiz,
                size: AppStrings.fontSize20,
                color: AppColors.primaryBlackColors,
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: BlocListener<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerError) {
          } else if (state is CustomerLoading) {}
        },
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mike Stevenson',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryTitleColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoSlidingSegmentedControl(
                      onValueChanged: (value) {
                        setState(() {
                          selectedIndex = value ?? 0;
                          customerMessageList.clear();
                        });
                        if (value == 2) {
                          BlocProvider.of<CustomerBloc>(context)
                              .add(GetCustomerMessageEvent());
                        }
                      },
                      groupValue: selectedIndex,
                      children: {
                        for (int i = 0; i < _segmentTitles.length; i++)
                          i: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 25),
                            child: _segmentTitles[i],
                          )
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    selectedIndex == 0
                        ? Expanded(
                            child: Container(
                                height: MediaQuery.of(context).size.height,
                                color: const Color(0xffF9F9F9),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Phone",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                widget.customerData.phone
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  final Uri smsLaunchUri = Uri(
                                                    scheme: 'sms',
                                                    path: widget
                                                        .customerData.phone,
                                                    queryParameters: <String,
                                                        String>{
                                                      'body':
                                                          Uri.encodeComponent(
                                                              ' '),
                                                    },
                                                  );
                                                  launchUrl(smsLaunchUri);
                                                },
                                                icon: SizedBox(
                                                  height: 27,
                                                  width: 18,
                                                  child: SvgPicture.asset(
                                                    'assets/images/sms_icons.svg',
                                                    height: 27,
                                                    color:
                                                        AppColors.primaryColors,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              IconButton(
                                                onPressed: () {
                                                  final Uri emailLaunchUri =
                                                      Uri(
                                                    scheme: 'tel',
                                                    path: widget.customerData
                                                            .phone ??
                                                        '',
                                                  );

                                                  launchUrl(emailLaunchUri);
                                                },
                                                icon: SizedBox(
                                                  height: 27,
                                                  width: 18,
                                                  child: SvgPicture.asset(
                                                    'assets/images/phone_icon.svg',
                                                    height: 27,
                                                    color:
                                                        AppColors.primaryColors,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      AppUtils.verticalDivider(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Email",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryGrayColors),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "${widget.customerData.email.toString()}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .primaryTitleColor),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              String? encodeQueryParameters(
                                                  Map<String, String> params) {
                                                return params.entries
                                                    .map((MapEntry<String,
                                                                String>
                                                            e) =>
                                                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                    .join('&');
                                              }

                                              final Uri emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path:
                                                    widget.customerData.email ??
                                                        '',
                                                query:
                                                    encodeQueryParameters(<String,
                                                        String>{
                                                  'subject': ' ',
                                                }),
                                              );

                                              launchUrl(emailLaunchUri);
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
                                      AppUtils.verticalDivider(),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      const Text(
                                        "Address",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryGrayColors),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.customerData.addressLine1.toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryTitleColor),
                                      ),
                                      AppUtils.verticalDivider(),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      const Text(
                                        "License Number",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryGrayColors),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text(
                                        "Need to change",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryTitleColor),
                                      ),
                                      AppUtils.verticalDivider(),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      const Text(
                                        "Customer Created",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryGrayColors),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.customerData.createdAt.toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryTitleColor),
                                      ),
                                      AppUtils.verticalDivider(),
                                      const SizedBox(
                                        height: 14,
                                      ),
                                      const Text(
                                        "Address",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primaryGrayColors),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${widget.customerData.addressLine1.toString()}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primaryTitleColor),
                                      ),
                                      AppUtils.verticalDivider(),
                                    ],
                                  ),
                                )),
                          )
                        : Container(),
                    selectedIndex == 1
                        ? Column(
                            children: [
                              SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: AppColors.buttonColors),
                                  onPressed: () {},
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: AppColors.primaryColors,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Add New Note',
                                        style: AppUtils.cardStyle(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // ListView.builder(
                              //   shrinkWrap: true,
                              //   itemCount: widget.customerData.clientId
                              //       .toString()
                              //       .length,
                              //   itemBuilder:
                              //       (BuildContext context, int index) {
                              //     return
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                width: double.infinity,
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18,
                                      top: 2,
                                      bottom: 10,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.customerData.createdAt}',
                                          style: AppUtils.requiredStyle(),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${widget.customerData.notes}',
                                          style: AppUtils.summaryStyle(),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //   );
                                // },
                              )
                            ],
                          )
                        : Container(),
                    selectedIndex == 2 ? chatWidget(context) : Container(),
                    selectedIndex == 3
                        ? Container(
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            width: double.infinity,
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 18,
                                  top: 2,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.customerData.createdAt}',
                                      style: AppUtils.requiredStyle(),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${widget.customerData.notes}',
                                      style: AppUtils.summaryStyle(),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //   );
                            // },
                          )
                        : Container(),
                    selectedIndex == 4
                        ? const Center(
                            child: Text('Coming Soon'),
                          )
                        : Container()
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Center(
                  child: Container(
                    height: 6,
                    width: 40,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: AppColors.buttonColors,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text(
                    "Select an option",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTitleColor),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                AppUtils.verticalDivider(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.buttonColors,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primaryColors,
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'New Estimate',
                                style: TextStyle(
                                    color: AppColors.primaryColors,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: '.SF Pro Text',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.buttonColors,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primaryColors,
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Add Customer',
                                style: TextStyle(
                                    color: AppColors.primaryColors,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: '.SF Pro Text',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.buttonColors,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: AppColors.primaryColors,
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Edit Customer',
                                style: TextStyle(
                                    color: AppColors.primaryColors,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: '.SF Pro Text',
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewCustomerScreen(
                                        customerEdit: widget.customerData)));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 57,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: AppColors.buttonColors,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                color: AppColors.primaryColors,
                                size: 16,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Delete Customer',
                                style: TextStyle(
                                    color: AppColors.primaryColors,
                                    fontFamily: '.SF Pro Text',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          onPressed: () {
                            BlocProvider.of<CustomerBloc>(context).add(
                                DeleteCustomerEvent(
                                    customerId:
                                        widget.customerData.id.toString()));
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) {
                                return const cs.CustomersScreen();
                              },
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: AppColors.primaryColors,
                            fontWeight: FontWeight.w500,
                            fontFamily: '.SF Pro Text',
                            fontSize: 16),
                      )),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget chatWidget(BuildContext context) {
    log("re build");
    return BlocListener<CustomerBloc, CustomerState>(
      listener: (context, state) async {
        if (state is GetCustomerMessageState) {
          customerMessageList.addAll(state.messageModel.data.data);
          Future.delayed(Duration(milliseconds: 300)).then((value) {
            chatScrollController.animateTo(
                chatScrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.linear);
          });
        } else if (state is SendCustomerMessageState) {
        } else if (state is GetCustomerMessagePaginationState) {
          customerMessageList.insertAll(0, state.messageModel.data.data);

          print("pagniation state emited");
          print(customerMessageList.length);
        }
        // TODO: implement listener
      },
      child: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          log(BlocProvider.of<CustomerBloc>(context)
                  .messageCurrentPage
                  .toString() +
              "in char widget");
          return Expanded(
            // width: MediaQuery.of(context).size.width,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                chatBoxWidget(customerMessageList),
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
                              onTap: () async {
                                // setState(() {
                                //   messageChatWidgetList.add(chatBubleWidget(
                                //       messageController.text,""));

                                //   messageController.clear();
                                // });

                                if (messageController.text.isNotEmpty) {
                                  context.read<CustomerBloc>().add(
                                      SendCustomerMessageEvent(
                                          customerId:
                                              widget.customerData.id.toString(),
                                          messageBody: messageController.text));

                                  cm.Datum localMessage = cm.Datum(
                                      clientId: widget.customerData.clientId,
                                      createdAt: DateTime.now(),
                                      id: widget.customerData.id,
                                      messageBody: messageController.text,
                                      messageType: "SMS",
                                      receiverCustomerId: null,
                                      status: "Open",
                                      updatedAt: DateTime.now(),
                                      sendCustomer: "",
                                      senderUserId: null);
                                  customerMessageList.add(localMessage);
                                  messageController.clear();
                                  await Future.delayed(
                                          Duration(milliseconds: 500))
                                      .then((_) {
                                    chatScrollController.animateTo(
                                        chatScrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.linear);
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
      ),
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

  Widget chatBoxWidget(List<cm.Datum> messsageModelList) {
    log("re build");
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        log(messsageModelList.length.toString());
        return Expanded(
          child: ListView.builder(
              itemBuilder: (context2, index) {
                newIndex = index;

                return chatBubleWidget(
                    messsageModelList[index].messageBody,
                    messsageModelList[index]
                        .createdAt
                        .toString()
                        .substring(11, 16));
              },
              itemCount: messsageModelList.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              controller: chatScrollController
                ..addListener(() {
                  if (chatScrollController.position.pixels == 0 &&
                      BlocProvider.of<CustomerBloc>(context)
                              .messageCurrentPage !=
                          0) {
                    print("pagination called");
                    _debouncer.run(() {
                      log(BlocProvider.of<CustomerBloc>(context)
                          .messageCurrentPage
                          .toString());
                      BlocProvider.of<CustomerBloc>(context)
                          .add(GetCustomerMessagePaginationEvent());
                    });
                  }
                })),
        );
      },
    );
  }

  Widget chatBubleWidget(String message, String time) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppColors.primaryColors,
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.7,
                        minWidth: 80),
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        //  Expanded(child: SizedBox()),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: SvgPicture.asset(
                              "assets/images/Double_tick_icon.svg"),
                        )
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
}
