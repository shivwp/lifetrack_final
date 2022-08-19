import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:life_track/Contants/constant.dart';
import 'package:life_track/controller/journal_list_controller.dart';
import 'package:life_track/repo/get_journal_repository.dart';
import 'package:life_track/tab/journal_detail.dart';

import '../Contants/appcolors.dart';
import '../components/background_gradient_container.dart';
import 'package:life_track/models/get_journal_response.dart';

class JournalCalendar extends StatefulWidget {
  JournalCalendar( {Key? key}) : super(key: key);

  @override
  _JournalCalendarState createState() => _JournalCalendarState();
}

class _JournalCalendarState extends State<JournalCalendar> {
  final JournalListController journalListController = Get.put(JournalListController());

  // DateTime _currentDate = DateTime(2022, 3, 25);
  final EventList<Event> _markedDateMap = EventList<Event>(
    events: {
      DateTime(2022, 3, 10): [
        Event(
          date: DateTime(2022, 3, 10),
          title: 'Event 1',
          icon: _eventIcon,
          dot: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            color: Colors.green,
            height: 5.0,
            width: 5.0,
          ),
        ),
        Event(
          date: DateTime(2022, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        Event(
          date: DateTime(2022, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
      ],
    },
  );


  @override
  void initState() {
    super.initState();
    journalListController.selectD();
    journalListController.getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        leading: BackButton(
          onPressed: (){

            getJournalData('').then((value) {
              journalListController.isDataLoading.value = true;
              return journalListController.model.value = value;
            });
            Get.back();
          },
        ),
        title: Image.asset(
          'assets/images/splash_logo.png',
          width: 159,
          height: 50,
        ),
      ),

      body: WillPopScope(
        onWillPop: () async {
          getJournalData('').then((value) {
            journalListController.isDataLoading.value = true;
            return journalListController.model.value = value;
          });
          return false;
        },
        child: BackgroundGradientContainer(
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 0),
            child: Obx(() {
              return journalListController.isDataLoading.value
                  ? journalListController.model.value.data!.length==0
                  ? Center(child: Text(" No data found",style: TextStyle(color: Colors.white),))
                  : ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount: journalListController.model.value.data!.length,
                itemBuilder: (context, index) {
                  // return Text(journalListController.model.value.data![5].name.toString());
                  return journalList(journalListController.model.value.data![index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 2,
                    thickness: 0,
                    color: AppColors.PRIMARY_COLOR,
                  );
                },
              )
                  : Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),

      // body: BackgroundGradientContainer(
      //   child: SafeArea(
      //     minimum: const EdgeInsets.only(top: 0),
      //     child: calendar(),
      //   ),
      // ),
    );
  }
  void _moveToDetail(context, Data data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetail(data),
      ),
    );
  }
  Widget journalList(Data data) {
    return Container(
      color: AppColors.PRIMARY_COLOR,
      child: ListTile(
        onTap: () {
          _moveToDetail(context, data);
        },
        minVerticalPadding: 16,
        title: Text(
          data.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontFamily: fontFamilyName,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          data.description,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: fontFamilyName,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

 /* Widget calendar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 350,
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          setState(() => _currentDate = date);
        },
        headerTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.white),
        daysTextStyle: const TextStyle(color: Colors.white),
        weekdayTextStyle: const TextStyle(color: Colors.white),
        iconColor: Colors.white,
        //thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
        customDayBuilder: (
          /// you can provide your own build function to make custom day containers
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
          /// This way you can build custom containers for specific days only, leaving rest as default.

          // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
          *//*if (day.day == 15) {
            return const Center(
              child: Icon(Icons.note_outlined),
            );
          } else {
            return null;
          }*//*
        },
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        //height: 420.0,
        selectedDateTime: _currentDate,
        daysHaveCircularBorder: false,

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }*/

  static final Widget _eventIcon = Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: const Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );
}
