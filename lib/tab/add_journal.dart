import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/controller/journal_list_controller.dart';
import 'package:life_track/repo/add_journal_repository.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../components/login_tf.dart';

class AddJournal extends StatefulWidget {
  const AddJournal({Key? key}) : super(key: key);

  @override
  _AddJournalState createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
//to refresh journal_list screen
  final JournalListController journalListController = Get.put(JournalListController());


  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  final TextEditingController _date = TextEditingController();

 _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(

        context: context,
        initialDate:  DateTime.now(),
        // firstDate: DateTime(1901, 1),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        String convertedDate = new DateFormat("yyyy-MM-dd").format(selectedDate);
        // for testing
        print("kfjkdf"+ convertedDate.toString());
        _date.value = TextEditingValue(text: convertedDate.toString());
      });
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
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.PRIMARY_COLOR_LIGHT,
        title: const Text(
          'Add Journal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontFamily: fontFamilyName,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: BackgroundGradientContainer(
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 0),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  LoginTF(
                    hintText: 'Journal Title',
                    icon: null,
                    controller: titleController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: '* Required'),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                        maxLines: 8,
                        controller: descController,
                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required'),
                        ]),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: const TextStyle(color: Colors.white, fontSize: 8),
                          hintText: 'Journal Description',
                          floatingLabelAlignment: FloatingLabelAlignment.start,
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _date,
                      validator: MultiValidator([
                        RequiredValidator(errorText: '* Required'),
                      ]),//editing controller of this TextField
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.black,
                        ),
                        hintText: 'Select Date',
                        errorStyle: const TextStyle(color: Colors.white, fontSize: 8),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        _selectDate(context);
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.10,),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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

                          print("Journal title "+titleController.toString());
                          print("Journal Desc "+descController.toString());
                          print("Selected date "+_date.toString());

                          if(formkey.currentState!.validate()){
                            addJournal(
                                '',
                                titleController.text.toString(),
                                descController.text.toString(),
                                _date.text.toString()).then((value) {

                              if(value.status==true){
                                Fluttertoast.showToast(
                                    msg: value.message,

                                    backgroundColor: AppColors.PRIMARY_COLOR);
                                titleController.clear();
                                descController.clear();
                                _date.clear();
                                //to refresh journal_list screen
                                journalListController.getdata();
                                Navigator.pop(context);
                                  }

                              return null;
                            });
                          }

                          // add a api for add journal
                          // _moveToCreateProfileScreen(context);
                        },
                        child: const Text(
                          'Add Journal',
                          style: TextStyle(
                            fontFamily: fontFamilyName,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
