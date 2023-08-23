// ignore_for_file: prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'package:boardview/boardview_controller.dart';
import 'package:boardview/vs_scrollbar.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class BoardView extends StatefulWidget {
  List<BoardList>? lists;
  final double width;
  Widget? middleWidget;
  double? bottomPadding;
  bool isSelecting;
  bool? scrollbar;
  ScrollbarStyle? scrollbarStyle;
  BoardViewController? boardViewController;
  int dragDelay;
  int length;

  Function(bool)? itemInMiddleWidget;
  OnDropBottomWidget? onDropItemInMiddleWidget;
  BoardView(
      {Key? key,
      this.itemInMiddleWidget,
      this.scrollbar,
      this.scrollbarStyle,
      this.boardViewController,
      this.dragDelay = 300,
      this.onDropItemInMiddleWidget,
      this.isSelecting = false,
      this.lists,
      this.width = 280,
      this.middleWidget,
      this.bottomPadding,
      required this.length})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardViewState();
  }
}

typedef OnDropBottomWidget = void Function(
    int? listIndex, int? itemIndex, double percentX);
typedef OnDropItem = void Function(int? listIndex, int? itemIndex);
typedef OnDropList = void Function(int? listIndex);

class BoardViewState extends State<BoardView> {
  Widget? draggedItem;
  int? draggedItemIndex;
  int? draggedListIndex;
  double? dx;
  double? dxInit;
  double? dyInit;
  double? dy;
  double? offsetX;
  double? offsetY;
  double? initialX = 0;
  double? initialY = 0;
  double? rightListX;
  double? leftListX;
  double? topListY;
  double? bottomListY;
  double? topItemY;
  double? bottomItemY;
  double? height;
  int? startListIndex;
  int? startItemIndex;

  bool canDrag = true;

  ScrollController boardViewController = ScrollController();

  List<BoardListState> listStates = [];

  OnDropItem? onDropItem;
  OnDropList? onDropList;

  bool isScrolling = false;

  bool _isInWidget = false;

  final GlobalKey _middleWidgetKey = GlobalKey();

  var pointer;

  void moveDown() {
    if (topItemY != null) {
      topItemY = topItemY! +
          listStates[draggedListIndex!]
              .itemStates[draggedItemIndex! + 1]
              .height;
    }
    if (bottomItemY != null) {
      bottomItemY = bottomItemY! +
          listStates[draggedListIndex!]
              .itemStates[draggedItemIndex! + 1]
              .height;
    }
    var item = widget.lists![draggedListIndex!].items![draggedItemIndex!];
    widget.lists![draggedListIndex!].items!.removeAt(draggedItemIndex!);
    var itemState = listStates[draggedListIndex!].itemStates[draggedItemIndex!];
    listStates[draggedListIndex!].itemStates.removeAt(draggedItemIndex!);
    if (draggedItemIndex != null) {
      draggedItemIndex = draggedItemIndex! + 1;
    }
    widget.lists![draggedListIndex!].items!.insert(draggedItemIndex!, item);
    listStates[draggedListIndex!]
        .itemStates
        .insert(draggedItemIndex!, itemState);
    if (listStates[draggedListIndex!].mounted) {
      listStates[draggedListIndex!].setState(() {});
    }
  }

  void moveUp() {
    if (topItemY != null) {
      topItemY = topItemY! -
          listStates[draggedListIndex!]
              .itemStates[draggedItemIndex! - 1]
              .height;
    }
    if (bottomItemY != null) {
      bottomItemY = bottomItemY! -
          listStates[draggedListIndex!]
              .itemStates[draggedItemIndex! - 1]
              .height;
    }
    var item = widget.lists![draggedListIndex!].items![draggedItemIndex!];
    widget.lists![draggedListIndex!].items!.removeAt(draggedItemIndex!);
    var itemState = listStates[draggedListIndex!].itemStates[draggedItemIndex!];
    listStates[draggedListIndex!].itemStates.removeAt(draggedItemIndex!);
    if (draggedItemIndex != null) {
      draggedItemIndex = draggedItemIndex! - 1;
    }
    widget.lists![draggedListIndex!].items!.insert(draggedItemIndex!, item);
    listStates[draggedListIndex!]
        .itemStates
        .insert(draggedItemIndex!, itemState);
    if (listStates[draggedListIndex!].mounted) {
      listStates[draggedListIndex!].setState(() {});
    }
  }

  void moveListRight() {
    var list = widget.lists![draggedListIndex!];
    var listState = listStates[draggedListIndex!];
    widget.lists!.removeAt(draggedListIndex!);
    listStates.removeAt(draggedListIndex!);
    if (draggedListIndex != null) {
      draggedListIndex = draggedListIndex! + 1;
    }
    widget.lists!.insert(draggedListIndex!, list);
    listStates.insert(draggedListIndex!, listState);
    canDrag = false;
    if (boardViewController.hasClients) {
      int? tempListIndex = draggedListIndex;
      boardViewController
          .animateTo(draggedListIndex! * widget.width,
              duration: const Duration(milliseconds: 400), curve: Curves.ease)
          .whenComplete(() {
        RenderBox object =
            listStates[tempListIndex!].context.findRenderObject() as RenderBox;
        Offset pos = object.localToGlobal(Offset.zero);
        leftListX = pos.dx;
        rightListX = pos.dx + object.size.width;
        Future.delayed(Duration(milliseconds: widget.dragDelay), () {
          canDrag = true;
        });
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  void moveRight() {
    var item = widget.lists![draggedListIndex!].items![draggedItemIndex!];
    var itemState = listStates[draggedListIndex!].itemStates[draggedItemIndex!];
    widget.lists![draggedListIndex!].items!.removeAt(draggedItemIndex!);
    listStates[draggedListIndex!].itemStates.removeAt(draggedItemIndex!);
    if (listStates[draggedListIndex!].mounted) {
      listStates[draggedListIndex!].setState(() {});
    }
    if (draggedListIndex != null) {
      draggedListIndex = draggedListIndex! + 1;
    }
    double closestValue = 10000;
    draggedItemIndex = 0;
    for (int i = 0; i < listStates[draggedListIndex!].itemStates.length; i++) {
      if (listStates[draggedListIndex!].itemStates[i].mounted) {
        RenderBox box = listStates[draggedListIndex!]
            .itemStates[i]
            .context
            .findRenderObject() as RenderBox;
        Offset pos = box.localToGlobal(Offset.zero);
        var temp = (pos.dy - dy! + (box.size.height / 2)).abs();
        if (temp < closestValue) {
          closestValue = temp;
          draggedItemIndex = i;
          dyInit = dy;
        }
      }
    }
    widget.lists![draggedListIndex!].items!.insert(draggedItemIndex!, item);
    listStates[draggedListIndex!]
        .itemStates
        .insert(draggedItemIndex!, itemState);
    canDrag = false;
    if (listStates[draggedListIndex!].mounted) {
      listStates[draggedListIndex!].setState(() {});
    }
    if (boardViewController.hasClients) {
      int? tempListIndex = draggedListIndex;
      int? tempItemIndex = draggedItemIndex;
      boardViewController
          .animateTo(draggedListIndex! * widget.width,
              duration: const Duration(milliseconds: 400), curve: Curves.ease)
          .whenComplete(() {
        RenderBox object =
            listStates[tempListIndex!].context.findRenderObject() as RenderBox;
        Offset pos = object.localToGlobal(Offset.zero);
        leftListX = pos.dx;
        rightListX = pos.dx + object.size.width;
        RenderBox box = listStates[tempListIndex]
            .itemStates[tempItemIndex!]
            .context
            .findRenderObject() as RenderBox;
        Offset itemPos = box.localToGlobal(Offset.zero);
        topItemY = itemPos.dy;
        bottomItemY = itemPos.dy + box.size.height;
        Future.delayed(Duration(milliseconds: widget.dragDelay), () {
          canDrag = true;
        });
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  void moveListLeft() {
    var list = widget.lists![draggedListIndex!];
    var listState = listStates[draggedListIndex!];
    widget.lists!.removeAt(draggedListIndex!);
    listStates.removeAt(draggedListIndex!);
    if (draggedListIndex != null) {
      draggedListIndex = draggedListIndex! - 1;
    }
    widget.lists!.insert(draggedListIndex!, list);
    listStates.insert(draggedListIndex!, listState);
    canDrag = false;
    if (boardViewController.hasClients) {
      int? tempListIndex = draggedListIndex;
      boardViewController
          .animateTo(draggedListIndex! * widget.width,
              duration: Duration(milliseconds: widget.dragDelay),
              curve: Curves.ease)
          .whenComplete(() {
        RenderBox object =
            listStates[tempListIndex!].context.findRenderObject() as RenderBox;
        Offset pos = object.localToGlobal(Offset.zero);
        leftListX = pos.dx;
        rightListX = pos.dx + object.size.width;
        Future.delayed(Duration(milliseconds: widget.dragDelay), () {
          canDrag = true;
        });
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  void moveLeft() {
    var item = widget.lists![draggedListIndex!].items![draggedItemIndex!];
    var itemState = listStates[draggedListIndex!].itemStates[draggedItemIndex!];
    widget.lists![draggedListIndex!].items!.removeAt(draggedItemIndex!);
    listStates[draggedListIndex!].itemStates.removeAt(draggedItemIndex!);
    if (listStates[draggedListIndex!].mounted) {
      listStates[draggedListIndex!].setState(() {});
    }
    if (draggedListIndex != null) {
      draggedListIndex = draggedListIndex! - 1;
    }
    double closestValue = 10000;
    draggedItemIndex = 0;
    for (int i = 0; i < listStates[draggedListIndex!].itemStates.length; i++) {
      if (listStates[draggedListIndex!].itemStates[i].mounted) {
        RenderBox box = listStates[draggedListIndex!]
            .itemStates[i]
            .context
            .findRenderObject() as RenderBox;
        Offset pos = box.localToGlobal(Offset.zero);
        var temp = (pos.dy - dy! + (box.size.height / 2)).abs();
        if (temp < closestValue) {
          closestValue = temp;
          draggedItemIndex = i;
          dyInit = dy;
        }
      }
    }
    widget.lists![draggedListIndex!].items!.insert(draggedItemIndex!, item);
    listStates[draggedListIndex!]
        .itemStates
        .insert(draggedItemIndex!, itemState);
    canDrag = false;
    if (listStates[draggedListIndex!].mounted) {
      listStates[draggedListIndex!].setState(() {});
    }
    if (boardViewController.hasClients) {
      int? tempListIndex = draggedListIndex;
      int? tempItemIndex = draggedItemIndex;
      boardViewController
          .animateTo(draggedListIndex! * widget.width,
              duration: const Duration(milliseconds: 400), curve: Curves.ease)
          .whenComplete(() {
        RenderBox object =
            listStates[tempListIndex!].context.findRenderObject() as RenderBox;
        Offset pos = object.localToGlobal(Offset.zero);
        leftListX = pos.dx;
        rightListX = pos.dx + object.size.width;
        RenderBox box = listStates[tempListIndex]
            .itemStates[tempItemIndex!]
            .context
            .findRenderObject() as RenderBox;
        Offset itemPos = box.localToGlobal(Offset.zero);
        topItemY = itemPos.dy;
        bottomItemY = itemPos.dy + box.size.height;
        Future.delayed(Duration(milliseconds: widget.dragDelay), () {
          canDrag = true;
        });
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  bool shown = true;

  @override
  Widget build(BuildContext context) {
    if (boardViewController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
        try {
          boardViewController.position.didUpdateScrollPositionBy(0);
        } catch (_) {}
        bool _shown = boardViewController.position.maxScrollExtent != 0;
        if (_shown != shown) {
          setState(() {
            shown = _shown;
          });
        }
      });
    }
    Widget listWidget = ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: widget.length,
      scrollDirection: Axis.horizontal,
      controller: boardViewController,
      itemBuilder: (BuildContext context, int index) {
        if (widget.lists![index].boardView == null) {
          widget.lists![index] = BoardList(
            items: widget.lists![index].items,
            headerBackgroundColor: widget.lists![index].headerBackgroundColor,
            backgroundColor: widget.lists![index].backgroundColor,
            footer: widget.lists![index].footer,
            header: widget.lists![index].header,
            draggable: widget.lists![index].draggable,
            onDropList: widget.lists![index].onDropList,
            onTapList: widget.lists![index].onTapList,
            onStartDragList: widget.lists![index].onStartDragList,
            length: widget.length,
          );
        }
        if (widget.lists![index].index != index) {
          widget.lists![index] = BoardList(
            items: widget.lists![index].items,
            length: widget.length,
            headerBackgroundColor: widget.lists![index].headerBackgroundColor,
            backgroundColor: widget.lists![index].backgroundColor,
            footer: widget.lists![index].footer,
            header: widget.lists![index].header,
            draggable: widget.lists![index].draggable,
            boardView: this,
            index: index,
            onDropList: widget.lists![index].onDropList,
            onTapList: widget.lists![index].onTapList,
            onStartDragList: widget.lists![index].onStartDragList,
          );
        }

        var temp = Container(
            width: widget.width,
            padding: EdgeInsets.fromLTRB(0, 0, 0, widget.bottomPadding ?? 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Expanded(child: widget.lists![index])],
            ));
        if (draggedListIndex == index && draggedItemIndex == null) {
          return Opacity(
            opacity: 0.0,
            child: temp,
          );
        } else {
          return temp;
        }
      },
    );
    if (widget.scrollbar == true) {
      listWidget = VsScrollbar(
          controller: boardViewController,
          showTrackOnHover: true, // default false
          isAlwaysShown: shown && widget.lists!.length > 1, // default false
          scrollbarFadeDuration: const Duration(
              milliseconds: 500), // default : Duration(milliseconds: 300)
          scrollbarTimeToFade: const Duration(
              milliseconds: 800), // default : Duration(milliseconds: 600)
          style: widget.scrollbarStyle != null
              ? VsScrollbarStyle(
                  hoverThickness: widget.scrollbarStyle!.hoverThickness,
                  radius: widget.scrollbarStyle!.radius,
                  thickness: widget.scrollbarStyle!.thickness,
                  color: widget.scrollbarStyle!.color)
              : const VsScrollbarStyle(),
          child: listWidget);
    }
    List<Widget> stackWidgets = <Widget>[listWidget];
    bool isInBottomWidget = false;
    if (dy != null) {
      if (MediaQuery.of(context).size.height - dy! < 80) {
        isInBottomWidget = true;
      }
    }
    if (widget.itemInMiddleWidget != null && _isInWidget != isInBottomWidget) {
      widget.itemInMiddleWidget!(isInBottomWidget);
      _isInWidget = isInBottomWidget;
    }
    if (initialX != null &&
        initialY != null &&
        offsetX != null &&
        offsetY != null &&
        dx != null &&
        dy != null &&
        height != null) {
      if (canDrag && dxInit != null && dyInit != null && !isInBottomWidget) {
        if (draggedItemIndex != null &&
            draggedItem != null &&
            topItemY != null &&
            bottomItemY != null) {
          //dragging item
          if (0 <= draggedListIndex! - 1 && dx! < leftListX! + 45) {
            //scroll left
            if (boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels - 5,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease);
              if (listStates[draggedListIndex!].mounted) {
                RenderBox object = listStates[draggedListIndex!]
                    .context
                    .findRenderObject() as RenderBox;
                Offset pos = object.localToGlobal(Offset.zero);
                leftListX = pos.dx;
                rightListX = pos.dx + object.size.width;
              }
            }
          }
          if (widget.lists!.length > draggedListIndex! + 1 &&
              dx! > rightListX! - 45) {
            //scroll right
            if (boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels + 5,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease);
              if (listStates[draggedListIndex!].mounted) {
                RenderBox object = listStates[draggedListIndex!]
                    .context
                    .findRenderObject() as RenderBox;
                Offset pos = object.localToGlobal(Offset.zero);
                leftListX = pos.dx;
                rightListX = pos.dx + object.size.width;
              }
            }
          }
          if (0 <= draggedListIndex! - 1 && dx! < leftListX!) {
            //move left
            moveLeft();
          }
          if (widget.lists!.length > draggedListIndex! + 1 &&
              dx! > rightListX!) {
            //move right
            moveRight();
          }
          if (dy! < topListY! + 70) {
            //scroll up
            if (listStates[draggedListIndex!].boardListController.hasClients &&
                !isScrolling) {
              isScrolling = true;
              double pos = listStates[draggedListIndex!]
                  .boardListController
                  .position
                  .pixels;
              listStates[draggedListIndex!]
                  .boardListController
                  .animateTo(
                      listStates[draggedListIndex!]
                              .boardListController
                              .position
                              .pixels -
                          5,
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.ease)
                  .whenComplete(() {
                pos -= listStates[draggedListIndex!]
                    .boardListController
                    .position
                    .pixels;
                initialY ??= 0;
//                if(widget.boardViewController != null) {
//                  initialY -= pos;
//                }
                isScrolling = false;
                if (topItemY != null) {
                  topItemY = topItemY! + pos;
                }
                if (bottomItemY != null) {
                  bottomItemY = bottomItemY! + pos;
                }
                if (mounted) {
                  setState(() {});
                }
              });
            }
          }
          if (0 <= draggedItemIndex! - 1 &&
              dy! <
                  topItemY! -
                      listStates[draggedListIndex!]
                              .itemStates[draggedItemIndex! - 1]
                              .height /
                          2) {
            //move up
            moveUp();
          }
          double? tempBottom = bottomListY;
          if (widget.middleWidget != null) {
            if (_middleWidgetKey.currentContext != null) {
              RenderBox _box = _middleWidgetKey.currentContext!
                  .findRenderObject() as RenderBox;
              tempBottom = _box.size.height;
            }
          }
          if (dy! > tempBottom! - 70) {
            //scroll down

            if (listStates[draggedListIndex!].boardListController.hasClients) {
              isScrolling = true;
              double pos = listStates[draggedListIndex!]
                  .boardListController
                  .position
                  .pixels;
              listStates[draggedListIndex!]
                  .boardListController
                  .animateTo(
                      listStates[draggedListIndex!]
                              .boardListController
                              .position
                              .pixels +
                          5,
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.ease)
                  .whenComplete(() {
                pos -= listStates[draggedListIndex!]
                    .boardListController
                    .position
                    .pixels;
                initialY ??= 0;
//                if(widget.boardViewController != null) {
//                  initialY -= pos;
//                }
                isScrolling = false;
                if (topItemY != null) {
                  topItemY = topItemY! + pos;
                }
                if (bottomItemY != null) {
                  bottomItemY = bottomItemY! + pos;
                }
                if (mounted) {
                  setState(() {});
                }
              });
            }
          }
          if (widget.lists![draggedListIndex!].items!.length >
                  draggedItemIndex! + 1 &&
              dy! >
                  bottomItemY! +
                      listStates[draggedListIndex!]
                              .itemStates[draggedItemIndex! + 1]
                              .height /
                          2) {
            //move down
            moveDown();
          }
        } else {
          //dragging list
          if (0 <= draggedListIndex! - 1 && dx! < leftListX! + 45) {
            //scroll left
            if (boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels - 5,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease);
              if (leftListX != null) {
                leftListX = leftListX! + 5;
              }
              if (rightListX != null) {
                rightListX = rightListX! + 5;
              }
            }
          }

          if (widget.lists!.length > draggedListIndex! + 1 &&
              dx! > rightListX! - 45) {
            //scroll right
            if (boardViewController.hasClients) {
              boardViewController.animateTo(
                  boardViewController.position.pixels + 5,
                  duration: const Duration(milliseconds: 10),
                  curve: Curves.ease);
              if (leftListX != null) {
                leftListX = leftListX! - 5;
              }
              if (rightListX != null) {
                rightListX = rightListX! - 5;
              }
            }
          }
          if (widget.lists!.length > draggedListIndex! + 1 &&
              dx! > rightListX!) {
            //move right
            moveListRight();
          }
          if (0 <= draggedListIndex! - 1 && dx! < leftListX!) {
            //move left
            moveListLeft();
          }
        }
      }
      if (widget.middleWidget != null) {
        stackWidgets
            .add(Container(key: _middleWidgetKey, child: widget.middleWidget));
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          setState(() {});
        }
      });
      stackWidgets.add(Positioned(
        width: widget.width,
        height: height,
        left: (dx! - offsetX!) + initialX!,
        top: (dy! - offsetY!) + initialY!,
        child: Opacity(opacity: .7, child: draggedItem),
      ));
    }

    return Listener(
        onPointerMove: (opm) {
          if (draggedItem != null) {
            dxInit ??= opm.position.dx;
            dyInit ??= opm.position.dy;
            dx = opm.position.dx;
            dy = opm.position.dy;
            if (mounted) {
              setState(() {});
            }
          }
        },
        onPointerDown: (opd) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset pos = box.localToGlobal(opd.position);
          offsetX = pos.dx;
          offsetY = pos.dy;
          pointer = opd;
          if (mounted) {
            setState(() {});
          }
        },
        onPointerUp: (opu) {
          if (onDropItem != null) {
            int? tempDraggedItemIndex = draggedItemIndex;
            int? tempDraggedListIndex = draggedListIndex;
            int? startDraggedItemIndex = startItemIndex;
            int? startDraggedListIndex = startListIndex;

            if (_isInWidget && widget.onDropItemInMiddleWidget != null) {
              onDropItem!(startDraggedListIndex, startDraggedItemIndex);
              widget.onDropItemInMiddleWidget!(
                  startDraggedListIndex,
                  startDraggedItemIndex,
                  opu.position.dx / MediaQuery.of(context).size.width);
            } else {
              onDropItem!(tempDraggedListIndex, tempDraggedItemIndex);
            }
          }
          if (onDropList != null) {
            int? tempDraggedListIndex = draggedListIndex;
            if (_isInWidget && widget.onDropItemInMiddleWidget != null) {
              onDropList!(tempDraggedListIndex);
              widget.onDropItemInMiddleWidget!(tempDraggedListIndex, null,
                  opu.position.dx / MediaQuery.of(context).size.width);
            } else {
              onDropList!(tempDraggedListIndex);
            }
          }
          draggedItem = null;
          offsetX = null;
          offsetY = null;
          initialX = null;
          initialY = null;
          dx = null;
          dy = null;
          draggedItemIndex = null;
          draggedListIndex = null;
          onDropItem = null;
          onDropList = null;
          dxInit = null;
          dyInit = null;
          leftListX = null;
          rightListX = null;
          topListY = null;
          bottomListY = null;
          topItemY = null;
          bottomItemY = null;
          startListIndex = null;
          startItemIndex = null;
          if (mounted) {
            setState(() {});
          }
        },
        child: Stack(
          children: stackWidgets,
        ));
  }

  void run() {
    if (pointer != null) {
      dx = pointer.position.dx;
      dy = pointer.position.dy;
      if (mounted) {
        setState(() {});
      }
    }
  }
}

class ScrollbarStyle {
  double hoverThickness;
  double thickness;
  Radius radius;
  Color color;
  ScrollbarStyle(
      {this.radius = const Radius.circular(10),
      this.hoverThickness = 10,
      this.thickness = 10,
      this.color = Colors.black});
}

typedef OnDropList2 = void Function(int? listIndex, int? oldListIndex);
typedef OnTapList = void Function(int? listIndex);
typedef OnStartDragList = void Function(int? listIndex);

class BoardList extends StatefulWidget {
  final List<Widget>? header;
  final Widget? footer;
  final List<BoardItem>? items;
  final Color? backgroundColor;
  final Color? headerBackgroundColor;
  final BoardViewState? boardView;
  final OnDropList2? onDropList;
  final OnTapList? onTapList;
  final OnStartDragList? onStartDragList;
  final bool draggable;
  final int length;

  const BoardList({
    Key? key,
    this.header,
    this.items,
    this.footer,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.boardView,
    this.draggable = true,
    this.index,
    this.onDropList,
    this.onTapList,
    this.onStartDragList,
    required this.length,
  }) : super(key: key);

  final int? index;

  @override
  State<StatefulWidget> createState() {
    return BoardListState();
  }
}

class BoardListState extends State<BoardList> {
  List<BoardItemState> itemStates = [];
  ScrollController boardListController = ScrollController();

  void onDropList(int? listIndex) {
    if (widget.onDropList != null) {
      widget.onDropList!(listIndex, widget.boardView!.startListIndex);
    }
    widget.boardView!.draggedListIndex = null;
    if (widget.boardView!.mounted) {
      widget.boardView!.setState(() {});
    }
  }

  void _startDrag(Widget item, BuildContext context) {
    if (widget.boardView != null && widget.draggable) {
      if (widget.onStartDragList != null) {
        widget.onStartDragList!(widget.index);
      }
      widget.boardView!.startListIndex = widget.index;
      widget.boardView!.height = context.size!.height;
      widget.boardView!.draggedListIndex = widget.index!;
      widget.boardView!.draggedItemIndex = null;
      widget.boardView!.draggedItem = item;
      widget.boardView!.onDropList = onDropList;
      widget.boardView!.run();
      if (widget.boardView!.mounted) {
        widget.boardView!.setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listWidgets = [];
    if (widget.header != null && listWidgets.length <= widget.length) {
      // Color? headerBackgroundColor = const Color.fromARGB(255, 255, 255, 255);
      if (widget.headerBackgroundColor != null) {
        // headerBackgroundColor = widget.headerBackgroundColor;
      }
      listWidgets.add(GestureDetector(
          onTap: () {
            if (widget.onTapList != null) {
              widget.onTapList!(widget.index);
            }
          },
          onTapDown: (otd) {
            if (widget.draggable) {
              RenderBox object = context.findRenderObject() as RenderBox;
              Offset pos = object.localToGlobal(Offset.zero);
              widget.boardView!.initialX = pos.dx;
              widget.boardView!.initialY = pos.dy;

              widget.boardView!.rightListX = pos.dx + object.size.width;
              widget.boardView!.leftListX = pos.dx;
            }
          },
          onTapCancel: () {},
          onLongPress: () {
            if (!widget.boardView!.widget.isSelecting && widget.draggable) {
              _startDrag(widget, context);
            }
          },
          child: Container(
            color: widget.headerBackgroundColor,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.header!),
          )));
    }
    if (widget.items != null) {
      listWidgets.add(Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            controller: boardListController,
            itemCount: widget.items!.length,
            itemBuilder: (ctx, index) {
              if (widget.items![index].boardList == null ||
                  widget.items![index].index != index ||
                  widget.items![index].boardList!.widget.index !=
                      widget.index ||
                  widget.items![index].boardList != this) {
                widget.items![index] = BoardItem(
                  boardList: this,
                  item: widget.items![index].item,
                  draggable: widget.items![index].draggable,
                  index: index,
                  onDropItem: widget.items![index].onDropItem,
                  onTapItem: widget.items![index].onTapItem,
                  onDragItem: widget.items![index].onDragItem,
                  onStartDragItem: widget.items![index].onStartDragItem,
                );
              }
              if (widget.boardView!.draggedItemIndex == index &&
                  widget.boardView!.draggedListIndex == widget.index) {
                return Opacity(
                  opacity: 0.0,
                  child: widget.items![index],
                );
              } else {
                return widget.items![index];
              }
            },
          )));
    }

    if (widget.footer != null) {
      listWidgets.add(widget.footer!);
    }

    Color? backgroundColor = const Color.fromARGB(255, 255, 255, 255);

    if (widget.backgroundColor != null) {
      backgroundColor = widget.backgroundColor;
    }
    if (widget.boardView!.listStates.length > widget.index!) {
      widget.boardView!.listStates.removeAt(widget.index!);
    }
    widget.boardView!.listStates.insert(widget.index!, this);

    return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: listWidgets.length > widget.length
              ? listWidgets.sublist(0, widget.length)
              : listWidgets,
        ));
  }
}

typedef OnDropItem3 = void Function(int? listIndex, int? itemIndex,
    int? oldListIndex, int? oldItemIndex, BoardItemState state);
typedef OnTapItem = void Function(
    int? listIndex, int? itemIndex, BoardItemState state);
typedef OnStartDragItem = void Function(
    int? listIndex, int? itemIndex, BoardItemState state);
typedef OnDragItem = void Function(int oldListIndex, int oldItemIndex,
    int newListIndex, int newItemIndex, BoardItemState state);

class BoardItem extends StatefulWidget {
  final BoardListState? boardList;
  final Widget? item;
  final int? index;
  final OnDropItem3? onDropItem;
  final OnTapItem? onTapItem;
  final OnStartDragItem? onStartDragItem;
  final OnDragItem? onDragItem;
  final bool draggable;

  const BoardItem(
      {Key? key,
      this.boardList,
      this.item,
      this.index,
      this.onDropItem,
      this.onTapItem,
      this.onStartDragItem,
      this.draggable = true,
      this.onDragItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BoardItemState();
  }
}

class BoardItemState extends State<BoardItem> {
  late double height;
  double? width;

  void onDropItem(int? listIndex, int? itemIndex) {
    if (widget.onDropItem != null) {
      widget.onDropItem!(
          listIndex,
          itemIndex,
          widget.boardList!.widget.boardView!.startListIndex,
          widget.boardList!.widget.boardView!.startItemIndex,
          this);
    }
    widget.boardList!.widget.boardView!.draggedItemIndex = null;
    widget.boardList!.widget.boardView!.draggedListIndex = null;
    if (widget.boardList!.widget.boardView!.listStates[listIndex!].mounted) {
      widget.boardList!.widget.boardView!.listStates[listIndex].setState(() {});
    }
  }

  void _startDrag(Widget item, BuildContext context) {
    if (widget.boardList!.widget.boardView != null) {
      widget.boardList!.widget.boardView!.onDropItem = onDropItem;
      if (widget.boardList!.mounted) {
        widget.boardList!.setState(() {});
      }
      widget.boardList!.widget.boardView!.draggedItemIndex = widget.index;
      widget.boardList!.widget.boardView!.height = context.size!.height;
      widget.boardList!.widget.boardView!.draggedListIndex =
          widget.boardList!.widget.index;
      widget.boardList!.widget.boardView!.startListIndex =
          widget.boardList!.widget.index;
      widget.boardList!.widget.boardView!.startItemIndex = widget.index;
      widget.boardList!.widget.boardView!.draggedItem = item;
      if (widget.onStartDragItem != null) {
        widget.onStartDragItem!(
            widget.boardList!.widget.index, widget.index, this);
      }
      widget.boardList!.widget.boardView!.run();
      if (widget.boardList!.widget.boardView!.mounted) {
        widget.boardList!.widget.boardView!.setState(() {});
      }
    }
  }

  void afterFirstLayout(BuildContext context) {
    try {
      height = context.size!.height;
      width = context.size!.width;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => afterFirstLayout(context));
    if (widget.boardList!.itemStates.length > widget.index!) {
      widget.boardList!.itemStates.removeAt(widget.index!);
    }
    widget.boardList!.itemStates.insert(widget.index!, this);
    return GestureDetector(
      onTapDown: (otd) {
        if (widget.draggable) {
          RenderBox object = context.findRenderObject() as RenderBox;
          Offset pos = object.localToGlobal(Offset.zero);
          RenderBox box =
              widget.boardList!.context.findRenderObject() as RenderBox;
          Offset listPos = box.localToGlobal(Offset.zero);
          widget.boardList!.widget.boardView!.leftListX = listPos.dx;
          widget.boardList!.widget.boardView!.topListY = listPos.dy;
          widget.boardList!.widget.boardView!.topItemY = pos.dy;
          widget.boardList!.widget.boardView!.bottomItemY =
              pos.dy + object.size.height;
          widget.boardList!.widget.boardView!.bottomListY =
              listPos.dy + box.size.height;
          widget.boardList!.widget.boardView!.rightListX =
              listPos.dx + box.size.width;

          widget.boardList!.widget.boardView!.initialX = pos.dx;
          widget.boardList!.widget.boardView!.initialY = pos.dy;
        }
      },
      onTapCancel: () {},
      onTap: () {
        if (widget.onTapItem != null) {
          widget.onTapItem!(widget.boardList!.widget.index, widget.index, this);
        }
      },
      onLongPress: () {
        if (!widget.boardList!.widget.boardView!.widget.isSelecting &&
            widget.draggable) {
          _startDrag(widget, context);
        }
      },
      child: widget.item,
    );
  }
}
