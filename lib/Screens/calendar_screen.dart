import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../api_provider/api_repository.dart';
import '../bloc/calendar_bloc/calendar_bloc.dart';
import '../bloc/calendar_bloc/calendar_event.dart';
import '../bloc/calendar_bloc/calendar_state.dart';
import '../utils/app_colors.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<DateTime> selectedDates = [];
  var inputFormat = DateFormat('EE, MM/dd/yyyy');
  var _selectedDate = DateTime.now();
  final List<List<String>> items = [
    ['Item 1', 'Item 2'],
    ['Item 4', 'Item 5', 'Item 6'],
    ['Item 7', 'Item 8', 'Item 9'],
    ['Item 10', 'Item 11', 'Item 12'],
    ['Item 13', 'Item 14', 'Item 15'],
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: BlocProvider(
          create: (context) => CalendarBloc(apiRepository: ApiRepository())
            ..add(CalendarDetails(selectedDate: DateTime.now())),
          child: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 24, right: 24, bottom: 10),
                    child: Text(
                      "Calendar",
                      style: AppUtils.calendarStyle(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _selectedDate = DateTime(_selectedDate.year,
                              _selectedDate.month, _selectedDate.day - 1);
                          setState(() {});
                          print('kkkkk${_selectedDate}');
                          context.read<CalendarBloc>().add(CalendarDetails(
                                selectedDate: _selectedDate,
                              ));
                        },
                        child: const Icon(
                          Icons.chevron_left,
                          color: AppColors.primaryColors,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        inputFormat.format(_selectedDate),
                        style: AppUtils.boldStyle(),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      InkWell(
                          onTap: () {
                            _selectedDate = DateTime(_selectedDate.year,
                                _selectedDate.month, _selectedDate.day + 1);
                            print(inputFormat.format(_selectedDate));
                            print('kkkkk${_selectedDate}');
                            setState(() {});
                            context.read<CalendarBloc>().add(CalendarDetails(
                                  selectedDate: _selectedDate,
                                ));
                          },
                          child: const Icon(
                            Icons.chevron_right,
                            color: AppColors.primaryColors,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(
                                    7, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: IconButton(
                              onPressed: () async {
                                // BlocProvider.of<CalendarBloc>(context)
                                //     .add(CalendarButtonUpdate(
                                //   calendarDate:
                                //       BlocProvider.of<CalendarBloc>(context)
                                //           .selectedDate,
                                // ));
                                _selectedDate = (await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate,
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100))) ??
                                    _selectedDate;
                                setState(() {});
                                context
                                    .read<CalendarBloc>()
                                    .add(CalendarDetails(
                                      selectedDate: _selectedDate,
                                    ));
                                print(
                                    'kkkllkl${DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day + 1)}');
                              },
                              icon: const Icon(
                                Icons.calendar_month_sharp,
                                color: AppColors.primaryColors,
                              )),
                        ),
                      )
                    ],
                  ),
                  const TabBar(
                    labelColor: AppColors.primaryColors,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        text: 'Day',
                      ),
                      Tab(text: 'Week'),
                    ],
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TabBarView(
                            children: [
                              BlocBuilder<CalendarBloc, CalendarState>(
                                  builder: (context, state) {
                                if (state is CalendarLoading) {
                                  return Center(
                                      child: CupertinoActivityIndicator());
                                } else if (state is CalendarReady) {
                                  return state.calendarModel.data.isNotEmpty
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                state.calendarModel.data.length,
                                                (rowIndex) {
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: List.generate(
                                                      state
                                                          .calendarModel
                                                          .data[rowIndex]
                                                          .data
                                                          .length,
                                                      (colIndex) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10,
                                                                  left: 24,
                                                                  bottom: 10),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  '${state.calendarModel.data[rowIndex].title}'),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: 230,
                                                                height: 200,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.1),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          10,
                                                                      offset: const Offset(
                                                                          7,
                                                                          7), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Text(
                                                                        '${state.calendarModel.data[rowIndex].data[colIndex].text}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF9A9A9A),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      Text(
                                                                        '${state.calendarModel.data[rowIndex].data[colIndex].text2}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              AppColors.primaryColors,
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      Text(
                                                                        state.calendarModel.data[rowIndex].data[colIndex].text3 ==
                                                                                null
                                                                            ? 'no data'
                                                                            : '${state.calendarModel.data[rowIndex].data[colIndex].text3}' ??
                                                                                '',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Color(0xFF333333),
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      Text(
                                                                        state.calendarModel.data[rowIndex].data[colIndex].text3 ==
                                                                                null
                                                                            ? 'no data'
                                                                            : '${state.calendarModel.data[rowIndex].data[colIndex].text4}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          color:
                                                                              Color(0xFF333333),
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            24,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFF5F5F5),
                                                                            borderRadius: BorderRadius.circular(12)),
                                                                        child:
                                                                            const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 14.0,
                                                                              right: 14,
                                                                              top: 5),
                                                                          child:
                                                                              Text(
                                                                            'Tag',
                                                                            maxLines:
                                                                                1,
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(child: Text('No Events Found'));
                                } else {
                                  return Container();
                                }
                              }),
                              BlocBuilder<CalendarBloc, CalendarState>(
                                  builder: (context, state) {
                                if (state is CalendarLoading) {
                                  return Center(
                                      child: CupertinoActivityIndicator());
                                } else if (state is CalendarReady) {
                                  return state.calendarModel.data.isNotEmpty
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20,
                                              left: 24,
                                              right: 24,
                                              bottom: 20),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                state.calendarModel.data.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${state.calendarModel.data[index].title}',
                                                    style: TextStyle(
                                                      color: Color(0xFF9A9A9A),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 10,
                                                            offset: const Offset(
                                                                7,
                                                                7), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  width: 70,
                                                                  child:
                                                                      const Text(
                                                                    '3',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Color(
                                                                          0xFF333333),
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 70,
                                                                  child:
                                                                      const Text(
                                                                    '3',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Color(
                                                                          0xFF333333),
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                Container()
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                SizedBox(
                                                                  width: 93,
                                                                  child:
                                                                      const Text(
                                                                    'Appointment',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Color(
                                                                          0xFF333333),
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                SizedBox(
                                                                  width: 93,
                                                                  child:
                                                                      const Text(
                                                                    'staff',
                                                                    style:
                                                                        TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      color: Color(
                                                                          0xFF333333),
                                                                    ),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                Container(),
                                                                Container()
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  height: 24,
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(
                                                                          0xFFF5F5F5),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12)),
                                                                  child:
                                                                      const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            14.0,
                                                                        right:
                                                                            14,
                                                                        top: 5),
                                                                    child: Text(
                                                                      'Tag',
                                                                      maxLines:
                                                                          1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 24,
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(
                                                                          0xFFF5F5F5),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12)),
                                                                  child:
                                                                      const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            14.0,
                                                                        right:
                                                                            14,
                                                                        top: 5),
                                                                    child: Text(
                                                                      'Tag',
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 24,
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(
                                                                          0xFFF5F5F5),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              12)),
                                                                  child:
                                                                      const Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            14.0,
                                                                        right:
                                                                            14,
                                                                        top: 5),
                                                                    child: Text(
                                                                      'Tag',
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(),
                                                                Container()
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : Center(child: Text('No Events Found'));
                                } else {
                                  return Container();
                                }
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                  //
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
