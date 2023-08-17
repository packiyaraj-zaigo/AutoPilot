import 'dart:convert';
import 'dart:developer';

import 'package:auto_pilot/Models/workflow_model.dart';
import 'package:auto_pilot/Models/workflow_status_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/Screens/bottom_bar.dart';
import 'package:auto_pilot/Screens/create_workflow.dart';
import 'package:auto_pilot/bloc/workflow/workflow_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WorkFlowScreen extends StatefulWidget {
  const WorkFlowScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<WorkFlowScreen> createState() => _WorkFlowScreenState();
}

class _WorkFlowScreenState extends State<WorkFlowScreen>
    with SingleTickerProviderStateMixin {
  BoardViewController boardViewController = BoardViewController();
  // late final controller = TabController(length: 2, vsync: this);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<BoardList> workflowOrderList = [];
  List<WorkflowStatusModel> statuses = [];
  List<String> workflowOrderHeadings = [];
  List<BoardList> lists = [];

  @override
  void initState() {
    super.initState();
  }

  filterColumns(List<WorkflowModel> workflows) {
    for (var status in statuses) {
      final filteredList = workflows
          .where((element) => element.bucketName?.parentId == status.id)
          .toList();
      workflowOrderList.add(boardWidget(filteredList, status));
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (boardViewController.state.mounted) {
      boardViewController.state.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return WorkflowBloc()..add(GetAllWorkflows());
      },
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: BlocListener<WorkflowBloc, WorkflowState>(
              listener: (context, state) {
                if (state is GetAllWorkflowSuccessState) {
                  statuses.addAll(state.statuses);
                  filterColumns(state.workflows);
                }
                if (state is EditWorkflowSuccessState ||
                    state is EditWorkflowErrorState) {
                  Navigator.of(scaffoldKey.currentContext!).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => BottomBarScreen(
                                currentIndex: 1,
                              )),
                      (route) => false);
                }
              },
              child: BlocBuilder<WorkflowBloc, WorkflowState>(
                builder: (context, state) {
                  if (state is GetAllWorkflowLoadingState) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (state is GetAllWorkflowErrorState) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: AppColors.greyText)),
                    );
                  }
                  return TabBarView(
                    controller: widget.tabController
                      ..addListener(() {
                        Navigator.of(scaffoldKey.currentContext!)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => BottomBarScreen(
                                          currentIndex: 1,
                                          tabControllerIndex:
                                              widget.tabController.index,
                                        )),
                                (route) => false);
                      }),
                    children: [
                      BoardView(
                        width: 240,
                        lists: workflowOrderList,
                      ),
                      BoardView(
                        width: 240,
                        lists: lists,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoardList boardWidget(
      List<WorkflowModel> workflows, WorkflowStatusModel status) {
    return BoardList(
      backgroundColor: Colors.transparent,
      header: [
        SizedBox(
          height: 35,
          width: 200,
          // width: double.infinity,
          // color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status.title,
                style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateWorkflowScreen(id: status.id.toString()),
                    ),
                  );
                },
                child: const Icon(
                  Icons.more_horiz,
                  color: AppColors.primaryColors,
                ),
              ),
            ],
          ),
        )
      ],
      items: List.generate(
        workflows.length,
        (index) => BoardItem(
          onDropItem:
              (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
            log(statuses[listIndex ?? 0].title);
            if (listIndex != null &&
                oldListIndex != null &&
                listIndex != oldListIndex) {
              scaffoldKey.currentContext!.read<WorkflowBloc>().add(
                    EditWorkflow(
                      workflowId: workflows[index].id.toString(),
                      clientBucketId:
                          statuses[listIndex].childBuckets.first.id.toString(),
                      orderId: workflows[index].orderId.toString(),
                      oldBucketId: status.id.toString(),
                    ),
                  );
            }
          },
          item: Column(
            children: [
              workflowCard(workflows[index]),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Container workflowCard(WorkflowModel workflow) {
    String str = workflow.bucketName!.color ?? '';
    str = str.replaceAll('#', '0xFF');

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(7, 7), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '${AppUtils.getTimeFormatted(workflow.orders?.shopStart ?? DateTime.now())} - ${AppUtils.getTimeFormatted(workflow.orders?.shopFinish ?? DateTime.now())}',
              style: const TextStyle(
                color: Color(0xFF9A9A9A),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${workflow.orders?.orderStatus ?? ''} #${workflow.orders?.orderNumber ?? ''} - ${workflow.orders?.estimationName ?? ''}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(int.tryParse(str) ?? 0xFF1355FF),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${workflow.orders?.customer?.firstName} ${workflow.orders?.customer?.lastName}',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${workflow.orders?.vehicle?.vehicleYear ?? ''} ${workflow.orders?.vehicle?.vehicleModel}',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            // Container(
            //   height: 24,
            //   decoration: BoxDecoration(
            //       color: Color(0xFFF5F5F5),
            //       borderRadius: BorderRadius.circular(12)),
            //   child: const Padding(
            //     padding: EdgeInsets.only(left: 14.0, right: 14, top: 5),
            //     child: Text(
            //       'Tag',
            //       maxLines: 1,
            //       textAlign: TextAlign.center,
            //       style: TextStyle(fontWeight: FontWeight.w500),
            //     ),
            //   ),
            // ),
            Container(
                height: 24,
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    workflow.bucketName?.title ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color:
                            // str == '' ?
                            AppColors.primaryColors
                        // : Color(color),
                        ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
