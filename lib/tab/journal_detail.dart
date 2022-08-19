import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/models/get_journal_response.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import 'journal_calendar.dart';

class JournalDetail extends StatefulWidget {
  Data data;
  JournalDetail(this.data, {Key? key}) : super(key: key);



  @override
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetail> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        leading: InkWell(
        onTap: (){
          Get.back();
        }
        ,child: Icon(Icons.arrow_back)),
        title: Text(widget.data.name.toString()),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.calendar_today_rounded),
            onPressed: () {
              _showDateTimePicker();
              // print("msbnfndbg"+_selectDate.toString());

              // _moveToCalendar(context);
            },
          )
        ],
        centerTitle: true,
      ),
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: EdgeInsets.only(top: 0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(widget.data.description.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: fontFamilyName,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
