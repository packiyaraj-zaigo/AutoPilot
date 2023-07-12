import 'dart:developer';

import 'package:auto_pilot/Models/workflow_model.dart';
import 'package:auto_pilot/Screens/app_drawer.dart';
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
  List<String> workflowOrderHeadings = [];
  List<List<WorkflowModel>> workflowOrderModelsList = [];
  List<BoardList> lists = [];

  late final WorkflowBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<WorkflowBloc>(context);
    bloc.add(GetAllWorkflows());
  }

  filterWorkflowOrders(String title, List<WorkflowModel> workflows) {
    if (!workflowOrderHeadings.contains(title)) {
      workflowOrderHeadings.add(title);
      final tasks = workflows
          .where((element) => element.bucketName?.title == title)
          .toList();
      tasks.sort(
        (a, b) {
          final aPos = a.bucketName?.position;
          final bPos = b.bucketName?.position;
          return bPos!.compareTo(aPos!);
        },
      );
      workflowOrderList.add(boardWidget(tasks));
      workflowOrderModelsList.add(tasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: BlocListener<WorkflowBloc, WorkflowState>(
            listener: (context, state) {
              if (state is GetAllWorkflowSuccessState) {
                for (int i = 0; i < state.workflows.length; i++) {
                  filterWorkflowOrders(
                      state.workflows[i].bucketName?.title ?? '',
                      state.workflows);
                }
              }
            },
            child: BlocBuilder<WorkflowBloc, WorkflowState>(
              builder: (context, state) {
                if (state is GetAllWorkflowLoadingState && !bloc.isLoading) {
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
                  controller: widget.tabController,
                  children: [
                    BoardView(
                      width: 240,
                      lists: workflowOrderList,
                      boardViewController: boardViewController,
                    ),
                    BoardView(
                      width: 240,
                      lists: lists,
                      boardViewController: boardViewController,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  BoardList boardWidget(List<WorkflowModel> workflows) {
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
                workflows[0].bucketName?.title ?? '',
                style: const TextStyle(
                  color: AppColors.primaryColors,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: AppColors.primaryColors,
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
            //if (listIndex != oldListIndex && itemIndex != oldItemIndex) {
            final workflow =
                workflowOrderModelsList[oldListIndex!][oldItemIndex!];
            workflowOrderModelsList[listIndex!].insert(itemIndex!, workflow);
            workflowOrderModelsList[oldListIndex].removeAt(oldItemIndex);
            workflow.bucketName!.position = itemIndex + 1;
            workflow.bucketName!.title = workflowOrderHeadings[listIndex];

            log(workflow.toJson().toString());
            bloc.add(EditWorkflowPosition(workflow: workflow));
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
    final color = int.parse(str);

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
              '${AppUtils.getTimeFormatted(workflow.createdAt ?? DateTime.now())} - ${AppUtils.getTimeFormatted(workflow.orders?.promiseDate ?? DateTime.now())}',
              style: const TextStyle(
                color: Color(0xFF9A9A9A),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${workflow.orders?.orderStatus ?? ''} #${workflow.orderId} - ${workflow.orders?.estimationName}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColors,
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
            Container(
              height: 24,
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.only(left: 14.0, right: 14, top: 5),
                child: Text(
                  'Tag',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(
                height: 24,
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    workflow.bucketName?.color ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: str == '' ? AppColors.primaryColors : Color(color),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
