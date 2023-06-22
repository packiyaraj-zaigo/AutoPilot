import 'package:auto_pilot/Screens/app_drawer.dart';
import 'package:auto_pilot/utils/app_colors.dart';
import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boardview/boardview.dart';

class WorkFlowScreen extends StatefulWidget {
  const WorkFlowScreen({super.key});

  @override
  State<WorkFlowScreen> createState() => _WorkFlowScreenState();
}

class _WorkFlowScreenState extends State<WorkFlowScreen>
    with SingleTickerProviderStateMixin {
  BoardViewController boardViewController = BoardViewController();
  late final controller = TabController(length: 2, vsync: this);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<BoardList> lists = [];

  final list3 = BoardList(
    backgroundColor: Colors.transparent,
    header: const [
      SizedBox(
        height: 35,
        width: 200,
        // width: double.infinity,
        // color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estimate',
              style: TextStyle(
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
        10,
        (index) => BoardItem(
              item: Column(
                children: [
                  Container(
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
                          offset:
                              const Offset(7, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            '3/7/23 9:00 AM - 3/10/23 12:00 PM',
                            style: TextStyle(
                              color: Color(0xFF9A9A9A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Estimate #1847 - Satin Black Wrap',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColors,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$index',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            '2022 Tesla Model Y',
                            style: TextStyle(
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
                              padding: EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5),
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
                            child: const Center(
                              child: Text(
                                'In Progress',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColors),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            )),
  );
  final list = BoardList(
    backgroundColor: Colors.transparent,
    header: const [
      SizedBox(
        height: 35,
        width: 200,
        // width: double.infinity,
        // color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Inquiry',
              style: TextStyle(
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
        10,
        (index) => BoardItem(
              item: Column(
                children: [
                  Container(
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
                          offset:
                              const Offset(7, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            '3/7/23 9:00 AM - 3/10/23 12:00 PM',
                            style: TextStyle(
                              color: Color(0xFF9A9A9A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Estimate #1847 - Satin Black Wrap',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColors,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$index',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            '2022 Tesla Model Y',
                            style: TextStyle(
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
                              padding: EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5),
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
                            child: const Center(
                              child: Text(
                                'In Progress',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColors),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            )),
  );
  final list2 = BoardList(
    backgroundColor: Colors.transparent,
    header: const [
      SizedBox(
        height: 35,
        width: 200,
        // width: double.infinity,
        // color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estimate',
              style: TextStyle(
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
        10,
        (index) => BoardItem(
              item: Column(
                children: [
                  Container(
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
                          offset:
                              const Offset(7, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            '3/7/23 9:00 AM - 3/10/23 12:00 PM',
                            style: TextStyle(
                              color: Color(0xFF9A9A9A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Estimate #1847 - Satin Black Wrap',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColors,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$index',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF333333),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            '2022 Tesla Model Y',
                            style: TextStyle(
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
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 14.0, right: 14, top: 5),
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
                            child: const Center(
                              child: Text(
                                'In Progress',
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryColors),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            )),
  );

  @override
  void initState() {
    super.initState();
    lists = [list];
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Autopilot',
          style: TextStyle(color: Colors.black87),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: AppColors.primaryColors,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: const Text(
                  'Workflow',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
              ),
              PreferredSize(
                preferredSize: const Size(double.infinity, 60),
                child: TabBar(
                  controller: controller,
                  enableFeedback: false,
                  indicatorColor: AppColors.primaryColors,
                  unselectedLabelColor: const Color(0xFF9A9A9A),
                  labelColor: AppColors.primaryColors,
                  tabs: const [
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Orders',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Vehicle',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        // child: Column(
        //   children: [Text("Workflow screen")],
        // ),
        // child: Kanban,

        child: ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: TabBarView(
            controller: controller,
            children: [
              BoardView(
                width: 240,
                lists: [list, list3],
                boardViewController: boardViewController,
              ),
              BoardView(
                width: 240,
                lists: [list2],
                boardViewController: boardViewController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
