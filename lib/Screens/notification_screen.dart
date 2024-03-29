import 'package:auto_pilot/Models/notification_response_model.dart';
import 'package:auto_pilot/Screens/no_internet_screen.dart';
import 'package:auto_pilot/bloc/notification/notification_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final NotificationBloc bloc;
  final List<Notifications> notifications = [];

  bool network = false;

  Future<bool> networkCheck() async {
    final value = await AppUtils.getConnectivity().then((value) {
      return value;
    });
    return value;
  }

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<NotificationBloc>(context);
    bloc.currentPage = 1;
    bloc.add(GetAllNotification());
    networkCheck().then((value) {
      // if (!network) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await networkCheck().then((value) {
        if (value != network) {
          setState(() {
            network = value;
          });
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
        backgroundColor: Colors.transparent,
        title: const Text(
          'Notifications',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTitleColor),
        ),
      ),
      body: !network
          ? NoInternetScreen(state: setState)
          : BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
                if (state is AllNotificationSucessState) {
                  notifications.addAll(state.notification.notification!);
                  notifications.sort((a, b) {
                    var adate = a.createdAt
                        .toString(); //before -> var adate = a.expiry;
                    var bdate = b.createdAt
                        .toString(); //before -> var bdate = b.expiry;
                    return bdate.compareTo(
                        adate); //to get the order other way just switch `adate & bdate`
                  });
                }
              },
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is AllNotificationLoadingState) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (state is AllNotificationsErorState) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (notifications.isEmpty) {
                    return const Center(
                      child: Text('No Notifications found'),
                    );
                  }
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final yesterday =
                          DateTime.now().subtract(const Duration(days: 1));
                      bool isYesterday = false;
                      bool today = false;
                      if (notification.createdAt?.day == yesterday.day &&
                          notification.createdAt?.month == yesterday.month &&
                          notification.createdAt?.year == yesterday.year) {
                        isYesterday = true;
                      }
                      if (notification.createdAt?.day == DateTime.now().day &&
                          notification.createdAt?.month ==
                              DateTime.now().month &&
                          notification.createdAt?.year == DateTime.now().year) {
                        today = true;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            index == 0
                                ? notification.createdAt == null
                                    ? const SizedBox()
                                    : isYesterday
                                        ? const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16.0),
                                            child: Text(
                                              'Yesterday',
                                              style: TextStyle(
                                                  color: Color(0xFF9A9A9A),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : today
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  "Today",
                                                  style: TextStyle(
                                                      color: Color(0xFF9A9A9A),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Text(
                                                  AppUtils.getDateFormatted(
                                                      notification.createdAt
                                                          .toString()),
                                                  style: const TextStyle(
                                                      color: Color(0xFF9A9A9A),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                : notification.createdAt
                                            .toString()
                                            .substring(0, 10) !=
                                        notifications[index - 1]
                                            .createdAt
                                            .toString()
                                            .substring(0, 10)
                                    ? notification.createdAt == null
                                        ? const SizedBox()
                                        : isYesterday
                                            ? const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  'Yesterday',
                                                  style: TextStyle(
                                                      color: Color(0xFF9A9A9A),
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )
                                            : today
                                                ? const Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 16.0),
                                                    child: Text(
                                                      "Today",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF9A9A9A),
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 16.0),
                                                    child: Text(
                                                      AppUtils.getDateFormatted(
                                                          notification.createdAt
                                                              .toString()),
                                                      style: const TextStyle(
                                                          color:
                                                              Color(0xFF9A9A9A),
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                    : const SizedBox(),
                            Container(
                              height: 77,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.07),
                                    offset: const Offset(0, 7),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.07),
                                            offset: const Offset(0, 7),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification.title ?? '',
                                              style: const TextStyle(
                                                height: 1.5,
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              notification.message ?? '',
                                              style: const TextStyle(
                                                height: 1.7,
                                                color: AppColors.greyText,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: notification.isRead == 1
                                          ? Colors.white
                                          : Color(0xFFFF5C5C),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: notifications.length,
                  );
                },
              ),
            ),
    );
  }
}
