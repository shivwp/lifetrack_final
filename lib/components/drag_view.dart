import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:life_track/Utils.dart';
import 'package:life_track/extension/date_time.dart';
import 'package:life_track/repo/updateTagStatus.dart';
import 'package:popover/popover.dart';
import 'package:time_range/time_range.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../models/get_added_tags.dart';

enum ListingFor {
  budget,
  actual,
}

class ResizingItemModel {
  double top = 0;
  double heightOfItem = 50;
  double heightOfContainer = 50;
  Color? bgColor;
  String tagTitle = "";
  DateTime startDateTime;
  DateTime endDateTime;
  AddedActivityModel? tagModel;
  bool isCompleted = false;
  ResizingItemModel(
      {required this.heightOfItem,
      required this.heightOfContainer,
      required this.startDateTime,
      required this.endDateTime,
      this.bgColor,
      required this.tagTitle});
}

class DraggableView extends StatefulWidget {
  List<ResizingItemModel> lst;
  ListingFor listingFor;
  String type;
  Function(
      {required DateTime start,
      required DateTime end,
      required List<ResizingItemModel> lst,
      required int index,
      required ListingFor listingFor}) callback;
  Function(
      {required AddedActivityModel tagDropped,
      required ListingFor listingFor,
      required int index}) callbackTagDropped;
  Function(
      {required AddedActivityModel tagDeleted,
      required ListingFor listingFor,
      required int index}) callbackTagDeleted;
  DraggableView(
      {required this.lst,
      required this.callback,
      required this.listingFor,
      required this.callbackTagDropped,
      required this.callbackTagDeleted,
      required this.type});
  @override
  _DraggableViewState createState() => _DraggableViewState();
}

class _DraggableViewState extends State<DraggableView> {
  @override
  Widget build(BuildContext context) {
    double widthBox = 100;
    double draggableHeight = 20;
    return Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.lst.length,
        itemBuilder: (context, index) {
          return SizedBox(
            height: widget.lst[index].heightOfItem + widget.lst[index].top <
                    widget.lst[index].heightOfContainer
                ? widget.lst[index].heightOfContainer
                : widget.lst[index].heightOfItem,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: widget.lst[index].top,
                  height: widget.lst[index].heightOfItem,
                  width: widthBox,
                  child: DragTarget<AddedActivityModel>(
                    builder: (BuildContext context, List<dynamic> accepted,
                        List<dynamic> rejected) {
                      return GestureDetector(
                        onLongPress: () {
                          //showPopOver(index: index);

                          if (widget.type == 'Budget') {
                            _showPopOver1(context: context, index: index);
                          } else {
                            // _showPopOver(context: context, index: index, tagId: widget.lst[index].tagModel!.id??0, color: widget.lst[index].bgColor);

                            showPopover(
                              context: context,
                              transitionDuration:
                                  const Duration(milliseconds: 150),
                              bodyBuilder: (context) {
                                return Column(
                                  children: [
                                    IconButton(
                                      color: Colors.black,
                                      icon: const Icon(Icons.delete_forever),
                                      onPressed: () {
                                        if (widget.lst[index].tagModel !=
                                            null) {
                                          widget.callbackTagDeleted(
                                              index: index,
                                              listingFor: widget.listingFor,
                                              tagDeleted:
                                                  widget.lst[index].tagModel!);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    IconButton(
                                      color: Colors.black,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        await _showTimeFrameDialog(
                                            index: index);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    IconButton(
                                      color: Colors.black,
                                      icon: const Icon(
                                          Icons.check_circle_outline),
                                      onPressed: () {
                                        EasyLoading.show();
                                        updateTagStatus(widget
                                                    .lst[index].tagModel?.id ??
                                                0)
                                            .then((value) {
                                          showToast(value.message);
                                          EasyLoading.dismiss();
                                          if (value.status) {
                                            setState(() {
                                              widget.lst[index].isCompleted =
                                                  true;
                                            });
                                          }
                                          Navigator.of(context).pop();
                                          return null;
                                        });
                                      },
                                    )
                                  ],
                                );
                              },
                              onPop: () => print('Popover was popped!'),
                              direction: PopoverDirection.left,
                              width: 50,
                              height: 145,
                              //arrowHeight: 15,
                              //arrowWidth: 30,
                            );
                          }
                        },
                        onTapDown: (TapDownDetails details) {
                          //_showPopOver(context: context, index: index);
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            color: widget.lst[index].tagModel == null
                                ? Colors.green.withOpacity(0.2)
                                : widget.lst[index].tagModel?.getColor(),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.white,
                              width: 0.5,
                            ),
                          ),
                          duration: const Duration(milliseconds: 500),
                          child: Stack(
                            children: [
                              widget.lst[index].isCompleted
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: Icon(
                                        Icons.check_circle_outline_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ))
                                  : SizedBox.shrink(),
                              Padding(
                                padding: EdgeInsets.all(
                                    widget.lst[index].tagModel == null
                                        ? 0.0
                                        : 2.0),
                                child: Center(
                                  child: Text(
                                    widget.lst[index].tagModel == null
                                        ? //widget.lst[index].tagTitle.capitalizeFirst!+
                                        'Not\nAssigned'
                                        : (widget.lst[index].tagModel?.activity!
                                                .capitalizeFirst! ??
                                            ''),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: fontFamilyName,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onAccept: (data) {
                      _showMyDialog(index: index);
                      setState(() {
                        widget.lst[index].tagModel = data;
                      });
                    },
                    onWillAccept: (data) {
                      return true;
                    },
                  ),
                ),
                /*
                //Top middle
                Positioned(
                  top: widget.lst[index].top - (draggableHeight / 5),
                  child: ManipulatingDrag(
                    width: widthBox,
                    height: draggableHeight,
                    onDrag: (dx, dy) {
                      print('dx= $dx dy= $dy');
                      var newHeight = widget.lst[index].heightOfItem - dy;
                      setState(() {
                        widget.lst[index].heightOfItem =
                            newHeight > 0 ? newHeight : 0;
                        print('New height= ${widget.lst[index].heightOfItem}');
                        widget.lst[index].top = widget.lst[index].top + dy;
                      });
                    },
                  ),
                ),
                //Bottom middle
                Positioned(
                  top: widget.lst[index].top +
                      widget.lst[index].heightOfItem -
                      draggableHeight,
                  child: ManipulatingDrag(
                    width: widthBox,
                    height: draggableHeight,
                    onDrag: (dx, dy) {
                      var newHeight = widget.lst[index].heightOfItem + dy;
                      setState(() {
                        widget.lst[index].heightOfItem =
                            newHeight > 0 ? newHeight : 0;
                        print('New height= ${widget.lst[index].heightOfItem}');
                      });
                    },
                  ),
                ),
                */
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showMyDialog({required int index}) async {
    Dialog dialog = Dialog(
      backgroundColor: AppColors.PRIMARY_COLOR,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              'Are you sure you want to set the given timeframe?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppColors.SUBMIT_BUTTON_BACKGROUND),
                          minimumSize: MaterialStateProperty.resolveWith(
                            (states) => const Size.fromHeight(50),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (widget.lst[index].tagModel != null) {
                            widget.callbackTagDropped(
                                index: index,
                                listingFor: widget.listingFor,
                                tagDropped: widget.lst[index].tagModel!);
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontFamily: fontFamilyName,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppColors.SUBMIT_BUTTON_BACKGROUND),
                          minimumSize: MaterialStateProperty.resolveWith(
                            (states) => const Size.fromHeight(50),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.lst[index].tagModel = null;
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: fontFamilyName,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return await showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  Future<void> _showTimeFrameDialog({required int index}) async {
    const black = Color(0xFF000000);
    const dark = Color(0xFFFFFFFF);
    const double leftPadding = 8;
    TimeRangeResult? _timeRange = TimeRangeResult(
        TimeOfDay(
            hour: widget.lst[index].startDateTime.hour,
            minute: widget.lst[index].startDateTime.minute),
        TimeOfDay(
            hour: widget.lst[index].endDateTime.hour,
            minute: widget.lst[index].endDateTime.minute));
    Dialog dialog = Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: AppColors.PRIMARY_COLOR,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 50),
          child: Column(
            children: [
              TimeRange(
                fromTitle: const Text(
                  'FROM',
                  style: TextStyle(
                    fontSize: 14,
                    color: dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                toTitle: const Text(
                  'TO',
                  style: TextStyle(
                    fontSize: 14,
                    color: dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                titlePadding: leftPadding,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: dark,
                ),
                activeTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
                borderColor: dark,
                activeBorderColor: dark,
                backgroundColor: Colors.transparent,
                activeBackgroundColor: dark,
                firstTime: TimeOfDay(
                    hour: widget.lst[index].startDateTime.hour, minute: 00),
                lastTime: const TimeOfDay(hour: 24, minute: 00),
                initialRange: _timeRange,
                timeStep: 15,
                timeBlock: 15,
                onRangeCompleted: (range) => setState(() => _timeRange = range),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: 150,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.SUBMIT_BUTTON_BACKGROUND),
                      minimumSize: MaterialStateProperty.resolveWith(
                        (states) => const Size.fromHeight(50),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _calculateHeightBasedOnTimeSelection(
                          index: index, selectedTimeRange: _timeRange);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontFamily: fontFamilyName,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return await showDialog(
        context: context, builder: (BuildContext context) => dialog);
  }

  _calculateHeightBasedOnTimeSelection(
      {required int index, required TimeRangeResult? selectedTimeRange}) {
    DateTime start =
        DateTime.now().applied(selectedTimeRange?.start ?? TimeOfDay.now());
    DateTime end =
        DateTime.now().applied(selectedTimeRange?.end ?? TimeOfDay.now());
    widget.callback(
        index: index,
        lst: widget.lst,
        start: start,
        end: end,
        listingFor: widget.listingFor);
  }

  _showPopOver(
      {required BuildContext context,
      required int index,
      tagId,
      Color? color}) {
    showPopover(
      context: context,
      transitionDuration: const Duration(milliseconds: 150),
      bodyBuilder: (context) {
        return Column(
          children: [
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                if (widget.lst[index].tagModel != null) {
                  widget.callbackTagDeleted(
                      index: index,
                      listingFor: widget.listingFor,
                      tagDeleted: widget.lst[index].tagModel!);
                }
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await _showTimeFrameDialog(index: index);
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.check_circle_outline),
              onPressed: () {
                updateTagStatus(tagId).then((value) {
                  showToast(value.message);
                  EasyLoading.dismiss();
                  if (value.status) {
                    color!.green;
                  }
                  Navigator.of(context).pop();
                  return null;
                });
              },
            )
          ],
        );
      },
      onPop: () => print('Popover was popped!'),
      direction: PopoverDirection.left,
      width: 50,
      height: 145,
      //arrowHeight: 15,
      //arrowWidth: 30,
    );
  }

  _showPopOver1({required BuildContext context, required int index}) {
    showPopover(
      context: context,
      transitionDuration: const Duration(milliseconds: 150),
      bodyBuilder: (context) {
        return Column(
          children: [
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                if (widget.lst[index].tagModel != null) {
                  widget.callbackTagDeleted(
                      index: index,
                      listingFor: widget.listingFor,
                      tagDeleted: widget.lst[index].tagModel!);
                }
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await _showTimeFrameDialog(index: index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      onPop: () => print('Popover was popped!'),
      direction: PopoverDirection.left,
      width: 50,
      height: 90,
      //arrowHeight: 15,
      //arrowWidth: 30,
    );
  }
/*
  _showPopUpMenu({required int index, required Offset offset}) async {
    double left = offset.dx;
    double top = offset.dy;
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          offset & const Size(40, 40), // smaller rect, the touch area
          Offset.zero &
              (overlay?.semanticBounds.size ??
                  Size.zero) // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem(
          child: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.delete_forever),
            onPressed: () {},
          ),
        ),
        PopupMenuItem(
          child: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
        ),
        PopupMenuItem(
          child: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {},
          ),
        ),
      ],
      elevation: 8.0,
    );
  }
  */
}

class ManipulatingDrag extends StatefulWidget {
  final Function onDrag;
  double width;
  double height;
  ManipulatingDrag(
      {required this.width, required this.height, required this.onDrag});

  @override
  _ManipulatingDragState createState() => _ManipulatingDragState();
}

class _ManipulatingDragState extends State<ManipulatingDrag> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _handleDrag,
      onVerticalDragUpdate: _handleUpdate,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: const BoxDecoration(
            color: Colors.transparent //Colors.blue.withOpacity(0.5),
            ),
      ),
    );
  }
}
