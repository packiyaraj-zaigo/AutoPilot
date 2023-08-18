import 'dart:developer';

import 'package:auto_pilot/Models/time_card_user_model.dart';
import 'package:auto_pilot/Screens/create_time_card.dart';
import 'package:auto_pilot/bloc/time_card/time_card_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTimeCardsScreen extends StatefulWidget {
  const UserTimeCardsScreen({super.key, required this.id});
  final String id;

  @override
  State<UserTimeCardsScreen> createState() => _UserTimeCardsScreenState();
}

class _UserTimeCardsScreenState extends State<UserTimeCardsScreen> {
  final _debouncer = Debouncer();
  final ScrollController controller = ScrollController();
  final List<TimeCardUserModel> timeCards = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimeCardBloc()
        ..add(
          GetUserTimeCardsEvent(id: widget.id),
        ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          foregroundColor: AppColors.primaryColors,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Autopilot',
            style: TextStyle(color: Colors.black87, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: BlocListener<TimeCardBloc, TimeCardState>(
          listener: (context, state) {
            if (state is GetUserTimeCardsSuccessState) {
              timeCards.addAll(state.timeCards);
            }
          },
          child: BlocBuilder<TimeCardBloc, TimeCardState>(
            builder: (context, state) {
              if (state is GetUserTimeCardsLoadingState &&
                  context.read<TimeCardBloc>().isCurrentUserTimeCardLoading) {
                return const Center(child: CupertinoActivityIndicator());
              } else {
                return timeCards.isEmpty
                    ? const Center(
                        child: Text(
                        'No User Found',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTextColors),
                      ))
                    : ScrollConfiguration(
                        behavior: const ScrollBehavior(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ListView.separated(
                              shrinkWrap: true,
                              controller: controller
                                ..addListener(() {
                                  if (controller.offset ==
                                          controller.position.maxScrollExtent &&
                                      !BlocProvider.of<TimeCardBloc>(context)
                                          .isCurrentUserTimeCardLoading &&
                                      BlocProvider.of<TimeCardBloc>(context)
                                              .currentUserTimeCardIndex <=
                                          BlocProvider.of<TimeCardBloc>(context)
                                              .totalUserTimeCardIndex) {
                                    _debouncer.run(() {
                                      BlocProvider.of<TimeCardBloc>(context)
                                          .isCurrentUserTimeCardLoading = true;
                                      BlocProvider.of<TimeCardBloc>(context)
                                          .add(GetUserTimeCardsEvent(
                                              id: widget.id));
                                    });
                                  }
                                }),
                              itemBuilder: (context, index) {
                                final item = timeCards[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          TimeCardCreate(timeCard: item),
                                    ));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: item.notes.isEmpty ? 130 : 180,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.07),
                                              offset: const Offset(0, 4),
                                              blurRadius: 10,
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                item.activityType,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors
                                                      .primaryTitleColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Clock In:       ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .primaryTitleColor,
                                                  ),
                                                ),
                                                Text(
                                                  AppUtils
                                                      .getFormattedForNotesScreen(
                                                          item.clockInTime
                                                              .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryTitleColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Clock Out:   ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .primaryTitleColor,
                                                  ),
                                                ),
                                                Text(
                                                  AppUtils
                                                      .getFormattedForNotesScreen(
                                                          item.clockOutTime
                                                              .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryTitleColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Total:              ",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors
                                                        .primaryTitleColor,
                                                  ),
                                                ),
                                                Text(
                                                  "${item.totalTime}  hrs",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .primaryTitleColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            item.notes.isNotEmpty
                                                ? AppUtils.verticalDivider()
                                                : const SizedBox(),
                                            item.notes.isNotEmpty
                                                ? Flexible(
                                                    child: Text(
                                                      item.notes,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .primaryTitleColor,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ),
                                      BlocProvider.of<TimeCardBloc>(context)
                                                      .currentUserTimeCardIndex <=
                                                  BlocProvider.of<TimeCardBloc>(
                                                          context)
                                                      .totalUserTimeCardIndex &&
                                              index == timeCards.length - 1
                                          ? const Column(
                                              children: [
                                                SizedBox(height: 24),
                                                Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                                SizedBox(height: 24),
                                              ],
                                            )
                                          : const SizedBox(),
                                      index == timeCards.length - 1
                                          ? const SizedBox(height: 24)
                                          : const SizedBox(),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 24),
                              itemCount: timeCards.length),
                        ),
                      );
              }
            },
          ),
        ),
      ),
    );
  }
}
