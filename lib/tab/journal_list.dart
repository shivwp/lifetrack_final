import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/controller/journal_list_controller.dart';
import 'package:life_track/models/get_journal_response.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import 'add_journal.dart';
import 'journal_calendar.dart';
import 'journal_detail.dart';

class JournalList extends StatefulWidget {
  const JournalList({Key? key}) : super(key: key);

  @override
  _JournalListState createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {

  final JournalListController journalListController = Get.put(JournalListController());

  void _moveToDetail(context, Data data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetail(data),
      ),
    );
  }

  void _moveToAddJournal(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddJournal(),
      ),
    );
  }

  void _moveToCalendar(context, String dateSelected) {

    Get.to(JournalCalendar(),arguments: [dateSelected]);

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => JournalCalendar(dateSelected),
    //   ),
    // );
  }

  Future<void> _showDateTimePicker()async
  {
    final DateTime? datePicked=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2015, 8), lastDate: DateTime(2101));

    if(datePicked!=null)
    {
      var selectDate = DateFormat("yyyy-MM-dd").format(datePicked);

      // print("datePicked"+"${ DateFormat("yyyy-MM-dd").format(datePicked)}");
      print("datePicked"+selectDate.toString());
      Get.to(JournalCalendar(),arguments: [selectDate]);
      // final TimeOfDay? timePicked=await showTimePicker(context: context,initialTime: TimeOfDay(hour: TimeOfDay.now().hour,minute: TimeOfDay.now().minute));
      // if(timePicked !=null)
      // {
      //
      // }
    }

  }

  @override
  void initState() {
    super.initState();
    journalListController.getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.calendar_today_rounded),
                onPressed: () {
                  _showDateTimePicker();
                   // print("msbnfndbg"+_selectDate.toString());

                  // _moveToCalendar(context);
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
                  _moveToAddJournal(context);
                },
              ),
            ],
          ),
        ),
        body: BackgroundGradientContainer(
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 0),
            child: Obx(() {
              return journalListController.isDataLoading.value
                  ? journalListController.model.value.data!.isEmpty
                  ? Center(child: Text('No Journal List found'))
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
        ));
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.description,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              data.date.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
