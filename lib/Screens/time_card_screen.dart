import 'dart:async';

import 'package:auto_pilot/Models/time_card_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/create_time_card.dart';
import 'package:auto_pilot/bloc/time_card/time_card_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeCardsScreen extends StatefulWidget {
  const TimeCardsScreen({super.key});

  @override
  State<TimeCardsScreen> createState() => _TimeCardsScreenState();
}

class _TimeCardsScreenState extends State<TimeCardsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<TimeCardModel> timeCards = [];
  late final TimeCardBloc bloc;
  final _debouncer = Debouncer();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<TimeCardBloc>(context);
    bloc.add(GetAllTimeCardsEvent());
  }

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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TimeCardCreate(),
              ));
            },
            child: const Icon(
              Icons.add,
              color: AppColors.primaryColors,
              size: 30,
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
            topWidget(),
            const SizedBox(height: 16),
            BlocListener<TimeCardBloc, TimeCardState>(
              listener: (context, state) {
                if (state is GetAllTimeCardsSucessState) {
                  timeCards.addAll(state.timeCards);
                } else if (state is GetAllTimeCardsErrorState) {
                  CommonWidgets().showDialog(context, state.message);
                }
              },
              child: BlocBuilder<TimeCardBloc, TimeCardState>(
                builder: (context, state) {
                  if (state is GetAllTimeCardsLoadingState && !bloc.isLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    return timeCards.isEmpty
                        ? Center(
                            child: Text(
                              'No time cards found',
                              style: TextStyle(
                                  color: AppColors.greyText, fontSize: 18),
                            ),
                          )
                        : Expanded(
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior(),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final timeCard = timeCards[index];
                                  return Column(
                                    children: [
                                      Container(
                                        height: 213,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.07),
                                              offset: const Offset(0, 7),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 16,
                                            bottom: 20,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    timeCard.employeeName ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: AppColors
                                                          .primaryTitleColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    timeCard.position ?? '',
                                                    style: const TextStyle(
                                                      color: AppColors.greyText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                    width: 70,
                                                    child: Text('Today'),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            250,
                                                    color:
                                                        AppColors.dividerColors,
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: Text(
                                                        '${timeCard.dayTotal?.substring(0, 5) ?? ''} ${timeCard.dayTotal?.substring(0, 5) == null ? '' : ' hrs'}'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                      width: 70,
                                                      child:
                                                          Text('This Week ')),
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            250,
                                                    color:
                                                        AppColors.dividerColors,
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: Text(
                                                        '${timeCard.weekTotal?.substring(0, 5) ?? ''} ${timeCard.weekTotal?.substring(0, 5) == null ? '' : ' hrs'}'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const SizedBox(
                                                    width: 70,
                                                    child: Text('This Month'),
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            250,
                                                    color:
                                                        AppColors.dividerColors,
                                                  ),
                                                  SizedBox(
                                                    width: 70,
                                                    child: Text(
                                                        '${timeCard.monthTatal?.substring(0, 5) ?? ''} ${timeCard.monthTatal?.substring(0, 5) == null ? '' : ' hrs'}'),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                96) /
                                                            2,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      color: const Color(
                                                          0xFFF5F5F5),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .primaryColors,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TimeCardCreate(
                                                            id: timeCard
                                                                .employeeId,
                                                            employee: timeCard
                                                                .employeeName,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              96) /
                                                          2,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        color: const Color(
                                                            0xFFF5F5F5),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Add',
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .primaryColors,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      bloc.currentPage < bloc.totalPages &&
                                              index == timeCards.length - 1
                                          ? const Column(
                                              children: [
                                                SizedBox(height: 16),
                                                Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                                SizedBox(height: 16),
                                              ],
                                            )
                                          : const SizedBox(
                                              height: 16,
                                            )
                                    ],
                                  );
                                },
                                itemCount: timeCards.length,
                              ),
                            ),
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column topWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Time Cards',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryTitleColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                offset: const Offset(0, 4),
                blurRadius: 10,
              )
            ],
          ),
          height: 50,
          child: CupertinoTextField(
            textAlignVertical: TextAlignVertical.bottom,
            padding: const EdgeInsets.only(top: 14, bottom: 14, left: 16),
            onChanged: (value) {
              _debouncer.run(() {});
            },
            prefix: const Row(
              children: [
                SizedBox(width: 24),
                Icon(
                  CupertinoIcons.search,
                  color: Color(0xFF7F808C),
                  size: 20,
                ),
              ],
            ),
            placeholder: 'Search User',
            maxLines: 1,
            placeholderStyle: const TextStyle(
              color: Color(0xFF7F808C),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      const Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}
