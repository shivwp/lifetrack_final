import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/get_feeling_controller.dart';
import 'package:life_track/repo/add_filling_reposotory.dart';
import 'package:life_track/repo/updateActivity.dart';

import '../Contants/constant.dart';
import '../Utils.dart';
import '../activitytags/add_activity_tag.dart';
import '../components/background_gradient_container.dart';
import '../components/drag_view.dart';
import '../models/get_added_tags.dart';
import '../models/get_daily_activity.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  final GetFillingController getFillingController =
      Get.put(GetFillingController());

  List<ResizingItemModel> lstBudget = [];
  List<ResizingItemModel> lstActual = [];
  List<AddedActivityModel> lstActivity = [];
  DailyActivityDataModel? _dailyActivityDataModel;
  List<DateTime> lstDateTime = [];
  int interval = 60;
  final double intervalHeight = 60;
  late double totalIntervalHeight = 0;
  final ScrollController _intervalScrollController = ScrollController();

  @override
  void initState() {
    if (kDebugMode) {
      log('*************** initState called ***************');
    }
    totalIntervalHeight = intervalHeight + 20;
    _getAddedTags();
    _getAddedDailyActivities();
    buildIntervalList();
    super.initState();
    getFillingController.getData();
  }

  @override
  bool get wantKeepAlive => true;

  /**
   * This method is used to build array of models which is used in vertical budget list design.
   *
   */
  buildBudgetAndActualList() {
    setState(() {
      lstBudget = List.generate(lstDateTime.length, (index) {
        ResizingItemModel model = ResizingItemModel(
            heightOfItem: totalIntervalHeight,
            heightOfContainer: totalIntervalHeight,
            startDateTime: lstDateTime[index],
            endDateTime: lstDateTime[index].add(Duration(
                minutes: index == 0
                    ? interval - 1
                    : interval)), //First index should start time 00:01 and end time 01:00
            bgColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0),
            tagTitle: 'Activity');
        return model;
      });
      _filterFromBudgetedAddedActivities();
      lstActual = List.generate(
          lstDateTime.length,
          (index) => ResizingItemModel(
              heightOfItem: totalIntervalHeight,
              heightOfContainer: totalIntervalHeight,
              startDateTime: lstDateTime[index],
              endDateTime: lstDateTime[index].add(Duration(minutes: interval)),
              bgColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(1.0),
              tagTitle: 'Activity'));
      _filterFromActualAddedActivities();
    });
  }

  _filterFromBudgetedAddedActivities() {
    lstBudget.asMap().forEach((index, model) {
      if (_dailyActivityDataModel?.bugeted != null) {
        List<Bugeted> lstFiltered =
            _dailyActivityDataModel!.bugeted!.where((budgeted) {
          if (model.startDateTime
              .isAtSameMomentAs(budgeted.startDateTime ?? DateTime.now())) {
            return true;
          }
          bool isStartingBetween = (budgeted.startDateTime ?? DateTime.now())
                  .isAfter(model.startDateTime) &&
              (budgeted.startDateTime ?? DateTime.now())
                  .isBefore(model.endDateTime);
          bool isEndingBetween = (budgeted.endDateTime ?? DateTime.now())
                  .isAfter(model.startDateTime) &&
              (budgeted.endDateTime ?? DateTime.now())
                  .isBefore(model.endDateTime);
          if (isStartingBetween || isEndingBetween) {
            return true;
          }
          return false;
        }).toList();
        if (lstFiltered.isNotEmpty) {
          log('Budgeted start= ${lstFiltered[0].startDateTime!.hour}:${lstFiltered[0].startDateTime!.minute} Budgeted end= ${lstFiltered[0].endDateTime!.hour}:${lstFiltered[0].endDateTime!.minute} same or after ${model.startDateTime.hour}:${model.startDateTime.minute}');
          DateTime start = lstFiltered[0].startDateTime ?? DateTime.now();
          DateTime end = lstFiltered[0].endDateTime ?? DateTime.now();
          if (start.isBefore(model.startDateTime)) {
            //Budgeted is started in previous slot
            if (end.isBefore(model.endDateTime)) {
              //Budgeted started in previous slot and end is in this slot so we have to start this slot when previous slot closes.
              start = end;
              end = model.endDateTime;
            }
          }
          double height = _getCalculatedHeight(start, end);
          setState(() {
            model.startDateTime = start;
            model.endDateTime = end;
            //model.heightOfContainer = height;
            model.heightOfItem = height;
            model.tagModel = AddedActivityModel.fromTag(
                lstFiltered[0].tag, lstFiltered[0].tagId, lstFiltered[0].id);
          });
        }
      }
    });
  }

  _filterFromActualAddedActivities() {
    lstActual.asMap().forEach((index, model) {
      if (_dailyActivityDataModel?.actual != null) {
        List<Actual> lstFiltered =
            _dailyActivityDataModel!.actual!.where((actual) {
          if (model.startDateTime
              .isAtSameMomentAs(actual.startDateTime ?? DateTime.now())) {
            return true;
          }
          bool isStartingBetween = (actual.startDateTime ?? DateTime.now())
                  .isAfter(model.startDateTime) &&
              (actual.startDateTime ?? DateTime.now())
                  .isBefore(model.endDateTime);
          bool isEndingBetween = (actual.endDateTime ?? DateTime.now())
                  .isAfter(model.startDateTime) &&
              (actual.endDateTime ?? DateTime.now())
                  .isBefore(model.endDateTime);
          if (isStartingBetween || isEndingBetween) {
            return true;
          }
          return false;
        }).toList();
        if (lstFiltered.isNotEmpty) {
          log('Actual start= ${lstFiltered[0].startDateTime!.hour}:${lstFiltered[0].startDateTime!.minute} Actual end= ${lstFiltered[0].endDateTime!.hour}:${lstFiltered[0].endDateTime!.minute} same or after ${model.startDateTime.hour}:${model.startDateTime.minute}');
          DateTime start = lstFiltered[0].startDateTime ?? DateTime.now();
          DateTime end = lstFiltered[0].endDateTime ?? DateTime.now();
          if (start.isBefore(model.startDateTime)) {
            //Budgeted is started in previous slot
            if (end.isBefore(model.endDateTime)) {
              //Budgeted started in previous slot and end is in this slot so we have to start this slot when previous slot closes.
              start = end;
              end = model.endDateTime;
            }
          }
          double height = _getCalculatedHeight(start, end);
          setState(() {
            model.startDateTime = start;
            model.endDateTime = end;
            //model.heightOfContainer = height;
            model.heightOfItem = height;
            model.tagModel = AddedActivityModel.fromTag(
                lstFiltered[0].tag, lstFiltered[0].tagId, lstFiltered[0].id);
          });
        }
      }
    });
  }

  double _getCalculatedHeight(DateTime start, DateTime end) {
    int diff = end.difference(start).inMinutes;
    if (diff < 0) {
      //diff negative when start night 23:00:00 and end 00:00:00
      diff = 60;
    }
    double ratio = totalIntervalHeight / interval;
    double calculatedHeight = diff * ratio;
    return calculatedHeight;
  }

  _callbackTagDropped(
      {required AddedActivityModel tagDropped,
      required ListingFor listingFor,
      required int index}) {
    if (listingFor == ListingFor.budget) {
      //Replace tagged start/end time with proposed block start/end time
      tagDropped.starttime = hrMinDF.format(lstBudget[index].startDateTime);
      tagDropped.endtime = hrMinDF.format(lstBudget[index].endDateTime);
      if (_dailyActivityDataModel == null) {
        _dailyActivityDataModel = DailyActivityDataModel.fromTag(tagDropped);
      } else {
        List<Bugeted> lstFiltered =
            _dailyActivityDataModel!.bugeted!.where((model) {
          return ((model.tagId == tagDropped.id) &&
                  (model.id == tagDropped.activityId)) ==
              true;
        }).toList();
        List<Actual> lstFilteredActual =
            _dailyActivityDataModel!.actual!.where((model) {
          return ((model.tagId == tagDropped.id) &&
                  (model.id == tagDropped.activityId)) ==
              true;
        }).toList();
        if (lstFiltered.length > 0) {
          lstFiltered[0].budgetedStartTime = tagDropped.starttime;
          lstFiltered[0].budgetEndTime = tagDropped.endtime;
        } else {
          _dailyActivityDataModel!.bugeted?.add(Bugeted.fromTag(tagDropped));
        }
        if (lstFilteredActual.length > 0) {
        } else {
          _dailyActivityDataModel!.actual?.add(Actual.fromTag(tagDropped));
        }
      }
    }
    //save to server
    _callAddDailyActivityApi(false);
  }

  _callbackTagDeleted(
      {required AddedActivityModel tagDeleted,
      required ListingFor listingFor,
      required int index}) {
    if (listingFor == ListingFor.budget) {
      if (_dailyActivityDataModel != null) {
        List<Bugeted> lstFiltered =
            _dailyActivityDataModel!.bugeted!.where((model) {
          return ((model.tagId == tagDeleted.id) &&
                  (model.id == tagDeleted.activityId)) ==
              false;
        }).toList();
        List<Actual> lstFilteredActual =
            _dailyActivityDataModel!.actual!.where((model) {
          return ((model.tagId == tagDeleted.id) &&
                  (model.id == tagDeleted.activityId)) ==
              false;
        }).toList();
        setState(() {
          _dailyActivityDataModel!.bugeted = lstFiltered;
          _dailyActivityDataModel!.actual = lstFilteredActual;
        });
      }
    }
    if (listingFor == ListingFor.actual) {
      if (_dailyActivityDataModel != null) {
        List<Actual> lstFiltered =
            _dailyActivityDataModel!.actual!.where((model) {
          return ((model.tagId == tagDeleted.id) &&
                  (model.id == tagDeleted.activityId)) ==
              false;
        }).toList();
        setState(() {
          _dailyActivityDataModel!.actual = lstFiltered;
        });
      }
    }

    //save to server
    _callAddDailyActivityApi(true);
  }

  _timeIntervalSelected(
      {required DateTime start,
      required DateTime end,
      required List<ResizingItemModel> lst,
      required int index,
      required ListingFor listingFor}) {
    log('Model Start= ${lst[index].startDateTime.hour}:${lst[index].startDateTime.minute}, End= ${lst[index].endDateTime.hour}:${lst[index].endDateTime.minute}');
    log('Selected= ${start.hour}:${start.minute}, Selected End= ${end.hour}:${end.minute}');
    log('Interval is $interval and totalHeight is $totalIntervalHeight');
    int selectedStartMin = start.hour * 60 + start.minute;
    int selectedEndMin = end.hour * 60 + end.minute;
    int diff = selectedEndMin - selectedStartMin;
    double ratio = totalIntervalHeight / interval;
    double calculatedHeight = diff * ratio;
    log('Selected minute difference ${diff}');
    log('Height/Interval = $ratio');
    log('Calculated height= $calculatedHeight');
    if (diff > interval) {
      //User selects more time than box time frame
      int diffExceded = diff - interval;
      double heightExceded = diffExceded * ratio;
      log('Height exceded $heightExceded');
      if (lst.length > index + 1) {
        double newItemHeight = lst[index + 1].heightOfItem - heightExceded;
        double newContainerHeight =
            lst[index + 1].heightOfContainer - heightExceded;
        log('Next widget height must be $newItemHeight');
        log('Next widget container must be $newContainerHeight');
        if (newItemHeight > 0 && newContainerHeight > 0) {
          lst[index + 1].heightOfItem = newItemHeight;
          lst[index + 1].heightOfContainer = newContainerHeight;
        }
        print('Next widget start time ${end.hour}:${end.minute}');
        lst[index + 1].startDateTime = end;
      }
    }
    setState(() {
      lst[index].startDateTime = start;
      lst[index].endDateTime = end;
      lst[index].heightOfItem = diff * ratio;
    });
    _callbackTagDropped(
        tagDropped: lst[index].tagModel!, listingFor: listingFor, index: index);
  }

  /**
   * This method is used to build vertical time interval between budget and actual list.
   * Time interval like 23:00 - 00:00
   */
  buildIntervalList() async {
    //print('interval is $interval');
    await Future.value(const Duration(seconds: 1));
    lstDateTime = [];
    TimeOfDay currentTime = const TimeOfDay(hour: 00, minute: 01);
    DateFormat dateFormat = DateFormat('hh:mm');
    DateTime parsedTime =
        dateFormat.parse(currentTime.format(context).toString());
    String yourDate = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString() +
        '- 00:00:00.000';
    DateTime roundedTime = roundWithin30Minutes(parsedTime);
    int indexToScroll = 0;
    lstDateTime.add(roundedTime);
    int totalElement = 24 ~/ (interval / 60);
    for (var i = 1; i < totalElement; i++) {
      DateTime nextRoundedTime =
          lstDateTime[i - 1].add(Duration(minutes: interval));
      if (lstDateTime[i - 1].hour == TimeOfDay.now().hour) {
        indexToScroll = i - 1;
      }
      lstDateTime.add(nextRoundedTime);
    }
    lstDateTime[0] = parsedTime; //Set starting time to 00:01 AM
    buildBudgetAndActualList();
    setState(() {
      Timer(const Duration(milliseconds: 50), () {
        _intervalScrollController.animateTo(indexToScroll * totalIntervalHeight,
            duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
      });
    });
  }

  void zoomIn() {
    if (interval < 120) {
      interval = interval * 2;
      buildIntervalList();
    }
  }

  void zoomOut() {
    if (interval > 15) {
      interval = interval ~/ 2;
      buildIntervalList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.white,
              icon: Obx(() {
                return getFillingController.isDataloading.value
                    ? getFillingController.model.value.data!.reviewMassge ==
                            'Very Sad'
                        ? FaIcon(FontAwesomeIcons.faceFrown)
                        : getFillingController.model.value.data!.reviewMassge ==
                                'Sad'
                            ? FaIcon(FontAwesomeIcons.faceFrownOpen)
                            : getFillingController
                                        .model.value.data!.reviewMassge ==
                                    'Ok'
                                ? Icon(Icons.add_reaction_outlined)
                                : getFillingController
                                            .model.value.data!.reviewMassge ==
                                        'Happy'
                                    ? FaIcon(FontAwesomeIcons.faceSmile)
                                    : getFillingController.model.value.data!
                                                .reviewMassge ==
                                            'Very Happy'
                                        ? FaIcon(FontAwesomeIcons.faceSmileBeam)
                                        : Icon(Icons.add_reaction_outlined)
                    : Icon(Icons.add_reaction_outlined);
              }),
              onPressed: () {
                showEmojiAlert();
              },
            ),
            Image.asset(
              'assets/images/splash_logo.png',
              width: 159,
              height: 50,
            ),
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.add_outlined),
              onPressed: () {
                _moveToAddActivityScreen(context);
              },
            ),
          ],
        ),
      ),
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 0),
          child: Container(
            width: deviceWidth,
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 35,
                  width: deviceWidth,
                  child: ListView.builder(
                    // shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: lstActivity.length,
                    itemBuilder: (context, index) {
                      return LongPressDraggable<AddedActivityModel>(
                        data: lstActivity[index],
                        dragAnchorStrategy: pointerDragAnchorStrategy,
                        child: InkWell(
                          onTap: () {
                            final tagController = TextEditingController();
                            GlobalKey<FormState> _formKey =
                                GlobalKey<FormState>();
                            tagController.text =
                                lstActivity[index].activity ?? '';
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: Stack(
                                      children: <Widget>[
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                height: 60,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3)))),
                                                child: Center(
                                                    child: Text("Enter Tag",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 20,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontFamily:
                                                                "Helvetica"))),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2))),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          flex: 4,
                                                          child: TextFormField(
                                                            controller:
                                                                tagController,
                                                            decoration: InputDecoration(
                                                                hintText:
                                                                    "Enter Tag",
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            20),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                                errorBorder:
                                                                    InputBorder
                                                                        .none,
                                                                hintStyle: TextStyle(
                                                                    color: Colors
                                                                        .black26,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      EasyLoading.show();
                                                      updateActivity(
                                                              lstActivity[index]
                                                                  .id
                                                                  .toString(),
                                                              tagController
                                                                  .text)
                                                          .then((value) {
                                                        showToast(
                                                            value.message);
                                                        EasyLoading.dismiss();
                                                        if (value.status) {
                                                          setState(() {
                                                            lstActivity[index]
                                                                    .activity =
                                                                tagController
                                                                    .text;
                                                          });
                                                        }
                                                        return null;
                                                      });
                                                      Get.back();
                                                    }
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                        color: AppColors
                                                            .PRIMARY_COLOR,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(25.0),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 4,
                                                            blurRadius: 10,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          )
                                                        ]),
                                                    child: Center(
                                                        child: Text(
                                                      "Submit",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            //width: 100,
                            padding: const EdgeInsets.only(
                                left: 16, right: 4, top: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: lstActivity[index].getColor(),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    lstActivity[index]
                                            .activity!
                                            .capitalizeFirst! ??
                                        '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: fontFamilyName,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        feedback: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: lstActivity[index].getColor(),
                          ),
                          height: 50.0,
                          width: 100.0,
                          child: Center(
                            child: Text(
                              lstActivity[index].activity ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                /*
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Draggable<HorizontalTagNames>(
                        data: lstHorizontalTags[index],
                        child: Container(
                          width: 100,
                          padding:
                              const EdgeInsets.only(left: 16, right: 4, top: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: lstHorizontalTags[index].bgColor,
                            ),
                            child: Center(
                              child: Text(
                                lstHorizontalTags[index].tagTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: fontFamilyName,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        feedback: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: lstHorizontalTags[index].bgColor,
                          ),
                          height: 50.0,
                          width: 100.0,
                          child: Center(
                            child: Text(
                              lstHorizontalTags[index].tagTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Draggable<HorizontalTagNames>(
                        data: lstHorizontalTags[index],
                        child: Container(
                          width: 100,
                          padding:
                              const EdgeInsets.only(left: 16, right: 4, top: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: lstHorizontalTags[index].bgColor,
                            ),
                            child: Center(
                              child: Text(
                                lstHorizontalTags[index].tagTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: fontFamilyName,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                        feedback: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: lstHorizontalTags[index].bgColor,
                          ),
                          height: 50.0,
                          width: 100.0,
                          child: Center(
                            child: Text(
                              lstHorizontalTags[index].tagTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                */
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'BUDGET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: zoomOut,
                            child: Container(
                              width: 30,
                              height: 40,
                              child: IconButton(
                                padding: EdgeInsets.only(bottom: 30, top: 0),
                                onPressed: null,
                                icon: const Icon(
                                  Icons.minimize,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              interval = 60;
                              buildIntervalList();
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.zoom_in,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: zoomIn,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'ACTUAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _intervalScrollController,
                    child: getBottomWidget(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getBottomWidget() {
    if (lstDateTime.isEmpty) {
      return Container(
        color: Colors.red,
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: lstDateTime.isNotEmpty
            ? (lstDateTime.length * totalIntervalHeight) + 50
            : 10,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DraggableView(
                type: 'Budget',
                lst: lstBudget,
                callback: _timeIntervalSelected,
                callbackTagDropped: _callbackTagDropped,
                listingFor: ListingFor.budget,
                callbackTagDeleted: _callbackTagDeleted,
              ),
              SizedBox(
                width: 50,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: lstDateTime.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: (index != lstDateTime.length - 1)
                          ? totalIntervalHeight
                          : totalIntervalHeight + 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            hrMinDF.format(lstDateTime[index]),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Image.asset(
                            'assets/images/interval_time.png',
                            width: 14,
                            height: intervalHeight,
                          ),
                          if (index == lstDateTime.length - 1)
                            Text(
                              hrMinDF.format(lstDateTime[0].add(Duration(
                                  minutes:
                                      -1))), //At last show 23:00 to 00:00 not 00:01
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              DraggableView(
                type: 'Actual',
                lst: lstActual,
                callback: _timeIntervalSelected,
                callbackTagDropped: _callbackTagDropped,
                listingFor: ListingFor.actual,
                callbackTagDeleted: _callbackTagDeleted,
              ),
            ],
          ),
        ),
      );
    }
  }

  DateTime roundWithin30Minutes(DateTime d) {
    final int deltaMinute;
    if (d.minute < 15) {
      deltaMinute = -d.minute; // go back to zero
    } else if (d.minute < 45) {
      deltaMinute = 30 - d.minute; // go to 30 minutes
    } else {
      deltaMinute = 60 - d.minute;
    }
    return d.add(Duration(
        milliseconds: -d.millisecond,
        // reset milliseconds to zero
        microseconds: -d.microsecond,
        // reset microseconds to zero,
        seconds: -d.second,
        // reset seconds to zero
        minutes: deltaMinute));
  }

  void showEmojiAlert() {
    Dialog errorDialog = Dialog(
      backgroundColor: AppColors.PRIMARY_COLOR,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SizedBox(
        height: 160.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: fontFamilyName,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: FaIcon(FontAwesomeIcons.faceFrown),
                      onPressed: () {
                        EasyLoading.show();
                        addFilling('Very Sad').then((value) {
                          if (value.status == true) {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            getFillingController.getData();
                            Navigator.of(context).pop();
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            Navigator.of(context).pop();
                          }
                          return null;
                        });
                      },
                    ),
                    const Text(
                      'Very Sad',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: fontFamilyName,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const FaIcon(FontAwesomeIcons.faceFrownOpen),
                      onPressed: () {
                        EasyLoading.show();
                        addFilling('Sad').then((value) {
                          if (value.status == true) {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            getFillingController.getData();
                            Navigator.of(context).pop();
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            Navigator.of(context).pop();
                          }
                          return null;
                        });
                      },
                    ),
                    const Text(
                      'Sad',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: fontFamilyName,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.add_reaction_outlined),
                      onPressed: () {
                        EasyLoading.show();
                        addFilling('Ok').then((value) {
                          if (value.status == true) {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            getFillingController.getData();
                            Navigator.of(context).pop();
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            Navigator.of(context).pop();
                          }
                          return null;
                        });
                      },
                    ),
                    const Text(
                      'Ok',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: fontFamilyName,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const FaIcon(FontAwesomeIcons.faceSmile),
                      onPressed: () {
                        EasyLoading.show();
                        addFilling('Happy').then((value) {
                          if (value.status == true) {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            getFillingController.getData();
                            Navigator.of(context).pop();
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            Navigator.of(context).pop();
                          }
                          return null;
                        });
                      },
                    ),
                    const Text(
                      'Happy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: fontFamilyName,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const FaIcon(FontAwesomeIcons.faceSmileBeam),
                      onPressed: () {
                        EasyLoading.show();
                        addFilling('Very Happy').then((value) {
                          if (value.status == true) {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            getFillingController.getData();
                            Navigator.of(context).pop();
                          } else {
                            EasyLoading.dismiss();
                            Fluttertoast.showToast(
                                msg: value.message,
                                backgroundColor: AppColors.PRIMARY_COLOR);
                            Navigator.of(context).pop();
                          }
                          return null;
                        });
                      },
                    ),
                    const Text(
                      'Very Happy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: fontFamilyName,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  void _moveToAddActivityScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddActivity(),
      ),
    ).then((value) => _getAddedTags());
  }

  Future<void> _getAddedTags() async {
    EasyLoading.show();
    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().get('get_activity_tag');
    try {
      final model = GetAddedTagsResponseModel.fromJson(response?.data);
      EasyLoading.dismiss();
      if (model.status) {
        setState(() {
          lstActivity = model.activity ?? [];
        });
      } else {
        Fluttertoast.showToast(
            msg: model.message ?? 'Something went wrong!',
            backgroundColor: AppColors.PRIMARY_COLOR);
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Decoding failed! $e', backgroundColor: AppColors.PRIMARY_COLOR);
    }
  }

  Future<void> _getAddedDailyActivities() async {
    EasyLoading.show();
    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().get('get_activity');
    try {
      final model = GetDailyActivityModel.fromJson(response?.data);
      print('::::::::get_activity::::::::::===>' + jsonEncode(model));
      EasyLoading.dismiss();
      if (model.status ?? false) {
        setState(() {
          _dailyActivityDataModel = model.data;
          _filterFromBudgetedAddedActivities();
          _filterFromActualAddedActivities();
        });
      } else {
        Fluttertoast.showToast(
            msg: model.message ?? 'Something went wrong!',
            backgroundColor: AppColors.PRIMARY_COLOR);
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Decoding failed! $e', backgroundColor: AppColors.PRIMARY_COLOR);
    }
  }

  void _callAddDailyActivityApi(bool isDeleted) async {
    EasyLoading.show();
    Map<String, dynamic> param = {
      "activitys": _dailyActivityDataModel?.toJson(),
    };

    print("lokesh check ==> " + param.toString());

    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().post('add-activities', param);
    try {
      final model = GetDailyActivityModel.fromJson(response?.data);
      print('::::::::add-activities::::::::::===>' + jsonEncode(model));
      if (isDeleted) {
        buildIntervalList();
      }
      setState(() {
        _dailyActivityDataModel = model.data;
        _filterFromBudgetedAddedActivities();
        _filterFromActualAddedActivities();
      });
      EasyLoading.dismiss();
      if (model.status ?? false) {
        Fluttertoast.showToast(
            msg: model.message ?? 'Something went wrong!',
            backgroundColor: AppColors.PRIMARY_COLOR);
      } else {
        Fluttertoast.showToast(
            msg: model.message ?? 'Something went wrong!',
            backgroundColor: AppColors.PRIMARY_COLOR);
      }
    } on Exception catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(
          msg: 'Decoding failed! $e', backgroundColor: AppColors.PRIMARY_COLOR);
    }
  }
}
