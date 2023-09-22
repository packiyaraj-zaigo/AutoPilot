import 'dart:developer';

import 'package:auto_pilot/Models/workflow_model.dart';
import 'package:auto_pilot/Models/workflow_status_model.dart';
import 'package:auto_pilot/Screens/kanban_board.dart';
import 'package:auto_pilot/Screens/create_workflow.dart';
import 'package:auto_pilot/bloc/workflow/workflow_bloc.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:auto_pilot/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:boardview/boardview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkFlowScreen extends StatefulWidget {
  const WorkFlowScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<WorkFlowScreen> createState() => _WorkFlowScreenState();
}

class _WorkFlowScreenState extends State<WorkFlowScreen>
    with SingleTickerProviderStateMixin {
  // BoardViewController boardViewController = BoardViewController();
  // late final controller = TabController(length: 2, vsync: this);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<BoardList> workflowOrderList = [];
  List<BoardList> workflowVehicleList = [];
  List<WorkflowStatusModel> statuses = [];
  bool alreadyLoaded = false;
  bool apiCall = false;

  @override
  void initState() {
    super.initState();
  }

  filterColumns(List<WorkflowModel> workflows) {
    alreadyLoaded = true;
    apiCall = false;
    workflowOrderList.clear();
    workflowVehicleList.clear();
    for (var status in statuses) {
      final filteredList = workflows
          .where((element) =>
              element.bucketName?.parentId == status.id &&
              element.orders != null)
          .toList()
          .reversed
          .toList();
      final vehicleList = workflows
          .where((element) =>
              element.bucketName?.parentId == status.id &&
              element.orders?.vehicle != null)
          .toList()
          .reversed
          .toList();

      workflowOrderList.add(boardWidget(filteredList, status, false));
      workflowVehicleList.add(boardWidget(vehicleList, status, true));
    }
  }

  @override
  void dispose() {
    super.dispose();
    // if (boardViewController.state.mounted) {
    //   boardViewController.state.dispose();
    // }
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
                  statuses.clear();
                  statuses.addAll(state.statuses);
                  filterColumns(state.workflows);
                }
                if (state is EditWorkflowSuccessState ||
                    state is EditWorkflowErrorState) {
                  // Navigator.of(scaffoldKey.currentContext!).pushAndRemoveUntil(
                  //     MaterialPageRoute(
                  //         builder: (context) => BottomBarScreen(
                  //               currentIndex: 1,
                  //             )),
                  //     (route) => false);

                  context.read<WorkflowBloc>().add(GetAllWorkflows());
                }
              },
              child: BlocBuilder<WorkflowBloc, WorkflowState>(
                builder: (context, state) {
                  if (state is GetAllWorkflowLoadingState && !alreadyLoaded) {
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
                        if (widget.tabController.indexIsChanging) {
                          alreadyLoaded = false;
                          if (!apiCall) {
                            apiCall = true;
                            scaffoldKey.currentContext!
                                .read<WorkflowBloc>()
                                .add(GetAllWorkflows());
                          }
                        }
                      }),
                    children: [
                      BoardView(
                        width: 240,
                        lists: workflowOrderList,
                        // boardViewController: boardViewController,
                        length: statuses.length,
                      ),
                      BoardView(
                        width: 240,
                        lists: workflowVehicleList,
                        // boardViewController: boardViewController,
                        length: statuses.length,
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

  BoardList boardWidget(List<WorkflowModel> workflows,
      WorkflowStatusModel status, bool isVehicle) {
    return BoardList(
      // boardView: boardViewController.state,
      length: statuses.length,
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
          // boardList: BoardListState(),
          onDropItem:
              (listIndex, itemIndex, oldListIndex, oldItemIndex, state) {
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
              workflowCard(workflows[index], isVehicle, status),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Container workflowCard(
      WorkflowModel workflow, bool isVehicle, WorkflowStatusModel status) {
    String str = workflow.bucketName!.color ?? '';
    str = str.replaceAll('#', '0xFF');
    String mainTitle = "";
    String secondaryTitle = "";
    if (isVehicle) {
      mainTitle =
          '${workflow.orders?.vehicle?.vehicleYear ?? ''} ${workflow.orders?.vehicle?.vehicleModel ?? ''}';
      secondaryTitle =
          '${workflow.orders?.orderStatus ?? ''} #${workflow.orders?.orderNumber ?? ''} - ${workflow.orders?.estimationName ?? ''}';
    } else {
      mainTitle =
          '${workflow.orders?.orderStatus ?? ''} #${workflow.orders?.orderNumber ?? ''} - ${workflow.orders?.estimationName ?? ''}';
      secondaryTitle =
          '${workflow.orders?.vehicle?.vehicleYear ?? ''} ${workflow.orders?.vehicle?.vehicleModel ?? ''}';
    }

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
              mainTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(int.tryParse(str) ?? 0xFF1355FF),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              workflow.orders?.customer?.firstName != null
                  ? '${workflow.orders?.customer?.firstName} ${workflow.orders?.customer?.lastName}'
                  : "NA",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Color(0xFF333333),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              secondaryTitle,
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
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => dropDown(status, workflow),
                );
              },
              child: Container(
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
                  )),
            )
          ],
        ),
      ),
    );
  }

  AlertDialog dropDown(WorkflowStatusModel status, WorkflowModel workflow) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      scrollable: true,
      title: const Text(
        'Select Status',
        style: TextStyle(
          color: AppColors.primaryTitleColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Builder(builder: (context) {
        return Column(
          children: List.generate(
            status.childBuckets.length,
            (index) => Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: GestureDetector(
                onTap: () {
                  scaffoldKey.currentContext!.read<WorkflowBloc>().add(
                        EditWorkflow(
                          workflowId: workflow.id.toString(),
                          clientBucketId:
                              status.childBuckets[index].id.toString(),
                          orderId: workflow.orderId.toString(),
                          oldBucketId: status.id.toString(),
                        ),
                      );
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 75,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          status.childBuckets[index].title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CreateWorkflowScreen(
                                  id: status.childBuckets[index].parentId
                                      .toString(),
                                  status: status.childBuckets[index]),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryColors,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
