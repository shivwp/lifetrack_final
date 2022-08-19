import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:life_track/loginsignup/login.dart';
import 'package:life_track/tab/tab.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import '../models/add_activity_response.dart';
import '../models/categorylist_response.dart';
import '../models/subcategorylist_response.dart';
import '../network/api_base_helper.dart';
import '../network/api_response.dart';

class AddActivity extends StatefulWidget {
  const AddActivity({Key? key}) : super(key: key);

  @override
  _AddActivityState createState() => _AddActivityState();
}

enum TagPrivacyScope { private, public }

class _AddActivityState extends State<AddActivity> {
  final _formKey = GlobalKey<FormState>();
  final colorWidthHeigh = 55.0;
  TagPrivacyScope? _tagscope = TagPrivacyScope.private;
  TextEditingController activityNameController = TextEditingController();
  TextEditingController fromTimeController = TextEditingController();
  TextEditingController toTimeController = TextEditingController();
  CategoryListModel? _categoryChoose;
  List<CategoryListModel> categoryDataList = [];
  SubcategoryListModel? _subcategoryChoose;
  List<SubcategoryListModel> totalSubCategoryDataList = [];
  List<SubcategoryListModel> subcategoryDataList = [];
  int selectedColorIndex = 0;
  final List<int> _colorList = [
    0xFFF44336,
    0xFF2196F3,
    0xFF4CAF50,
    0xFFFFEB3B,
    0xFFFF9800,
    0xFF448AFF,
    0xFF607D8B,
    0xFFE91E63
  ];
  var inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      10.0,
    ),
    borderSide: const BorderSide(
      width: 1,
      color: AppColors.DROP_DOWN_BG,
    ),
  );
  @override
  void initState() {
    _getCategoryList();
    _getSubCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 16),
            child: Stack(
              children: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  width: deviceWidth,
                  margin: const EdgeInsets.only(top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        'Setup Activity Tags',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: fontFamilyName,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 10, 20, 20),
                                          /*errorText: '',
                                          errorStyle: const TextStyle(
                                            color: AppColors.DROP_DOWN_BG,
                                            fontSize: 16.0,
                                          ),*/
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          fillColor: AppColors.DROP_DOWN_BG,
                                          filled: true),
                                      child: DropdownButtonHideUnderline(
                                        child:
                                            DropdownButton<CategoryListModel>(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: fontFamilyName,
                                          ),
                                          hint: const Text(
                                            "Category",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: fontFamilyName,
                                            ),
                                          ),
                                          items: categoryDataList.map<
                                                  DropdownMenuItem<
                                                      CategoryListModel>>(
                                              (CategoryListModel value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  /*CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(value.bank_logo),
                                                  ),
                                                  // Icon(valueItem.bank_logo),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),*/
                                                  Text(value.title),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          isExpanded: true,
                                          isDense: true,
                                          onChanged: (newSelected) {
                                            _onDropDownItemSelected(
                                                newSelected);
                                          },
                                          value: _categoryChoose,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                child: FormField<String>(
                                  builder: (FormFieldState<String> state) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 10, 20, 20),
                                          /*errorText: '',
                                          errorStyle: const TextStyle(
                                            color: AppColors.DROP_DOWN_BG,
                                            fontSize: 16.0,
                                          ),*/
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10.0,
                                            ),
                                          ),
                                          fillColor: AppColors.DROP_DOWN_BG,
                                          filled: true),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<
                                            SubcategoryListModel>(
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontFamily: fontFamilyName,
                                          ),
                                          hint: const Text(
                                            "Sub Category",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                              fontFamily: fontFamilyName,
                                            ),
                                          ),
                                          items: subcategoryDataList.map<
                                                  DropdownMenuItem<
                                                      SubcategoryListModel>>(
                                              (SubcategoryListModel value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Row(
                                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  /*CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(value.bank_logo),
                                                  ),
                                                  // Icon(valueItem.bank_logo),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),*/
                                                  Text(value.title),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          isExpanded: true,
                                          isDense: true,
                                          onChanged: (newSelected) {
                                            _onDropDownSubCategorySelected(
                                                newSelected);
                                          },
                                          value: _subcategoryChoose,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        12, 10, 20, 20),
                                    /*errorText: '',*/
                                    errorStyle: const TextStyle(
                                      color: AppColors.DROP_DOWN_BG,
                                      fontSize: 12.0,
                                    ),
                                    border: inputBorder,
                                    errorBorder: inputBorder,
                                    focusedBorder: inputBorder,
                                    hintText: 'Activity Name',
                                    fillColor: AppColors.DROP_DOWN_BG,
                                    filled: true),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '* Required';
                                  }
                                  return null;
                                },
                                controller: activityNameController,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 16),
                        child: Text(
                          'Select Color',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        height: colorWidthHeigh,
                        margin: const EdgeInsets.only(left: 16, top: 24),
                        child: ListView.builder(
                          itemCount: _colorList.length,
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Container(
                                width: colorWidthHeigh,
                                color: Color(_colorList[index]),
                                child: index == selectedColorIndex
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20, left: 16),
                        child: Text(
                          'Tag Privacy',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Align(
                          child: Text(
                            'Private',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          alignment: Alignment(-1.2, 0),
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                        leading: Radio<TagPrivacyScope>(
                          value: TagPrivacyScope.private,
                          groupValue: _tagscope,
                          onChanged: (TagPrivacyScope? value) {
                            setState(() {
                              _tagscope = value;
                            });
                          },
                          activeColor: Colors.blueAccent,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                      ),
                      ListTile(
                        title: const Align(
                          child: Text(
                            'Public',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          alignment: Alignment(-1.2, 0),
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0),
                        leading: Radio<TagPrivacyScope>(
                          value: TagPrivacyScope.public,
                          groupValue: _tagscope,
                          onChanged: (TagPrivacyScope? value) {
                            setState(() {
                              _tagscope = value;
                            });
                          },
                          activeColor: Colors.blueAccent,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Colors.white),
                        ),
                      ),
                      /*const Padding(
                        padding: EdgeInsets.only(top: 20, left: 16),
                        child: Text(
                          'Time Frame',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: deviceWidth / 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 10, 20, 20),
                                  *//*errorText: '',
                                              errorStyle: const TextStyle(
                                                color: AppColors.DROP_DOWN_BG,
                                                fontSize: 16.0,
                                              ),*//*
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
                                  ),
                                  hintText: 'From Time',
                                  fillColor: AppColors.DROP_DOWN_BG,
                                  filled: true,
                                ),
                                controller: fromTimeController,
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child ?? Container(),
                                      );
                                    },
                                    context: context,
                                  );

                                  if (pickedTime != null) {
                                    print(pickedTime
                                        .format(context)); //output 10:51 PM
                                    DateTime parsedTime = DateFormat('HH:mm').parse(
                                        pickedTime.format(context).toString());
                                    // converting to DateTime so that we can further format on different pattern.
                                    // print(
                                    //     parsedTime); //output 1970-01-01 22:53:00.000
                                    String formattedTime =
                                        DateFormat('HH:mm').format(parsedTime);
                                    // print(formattedTime); //output 14:59:00
                                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                                    setState(() {
                                      fromTimeController.text =
                                          formattedTime; //set the value of text field.
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: 'Time is not selected', backgroundColor: AppColors.PRIMARY_COLOR);
                                    print("Time is not selected");
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: deviceWidth / 2,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 16),
                              child: TextField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(12, 10, 20, 20),
                                  *//*errorText: '',
                                              errorStyle: const TextStyle(
                                                color: AppColors.DROP_DOWN_BG,
                                                fontSize: 16.0,
                                              ),*//*
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
                                  ),
                                  hintText: 'To Time',
                                  fillColor: AppColors.DROP_DOWN_BG,
                                  filled: true,
                                ),
                                controller: toTimeController,
                                readOnly: true,
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child ?? Container(),
                                      );
                                    },
                                    context: context,
                                  );

                                  if (pickedTime != null) {
                                    // print(pickedTime
                                    //     .format(context)); //output 10:51 PM
                                    DateTime parsedTime = DateFormat('HH:mm').parse(
                                        pickedTime.format(context).toString());
                                    //converting to DateTime so that we can further format on different pattern.
                                    // print(
                                    //     parsedTime); //output 1970-01-01 22:53:00.000
                                    // String formattedTime =
                                    //     DateFormat('HH:mm').format(parsedTime);
                                    // print(formattedTime); //output 14:59:00
                                    //DateFormat() is from intl package, you can format the time on any pattern you need.
                                    String formattedTime =
                                    DateFormat('HH:mm').format(parsedTime);
                                    setState(() {
                                      toTimeController.text =
                                          formattedTime; //set the value of text field.
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Time is not selected', backgroundColor: AppColors.PRIMARY_COLOR);
                                    print("Time is not selected");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 32, bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            _callAddActivityApi(true);
                          },
                          child: const Text(
                            '+ Add another activity tag',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => AppColors.SUBMIT_BUTTON_BACKGROUND),
                            minimumSize: MaterialStateProperty.resolveWith(
                              (states) => const Size.fromHeight(50),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            _callAddActivityApi(false);
                          },
                          child: const Text(
                            'Confirm & Continue',
                            style: TextStyle(
                              fontFamily: fontFamilyName,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
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
      ),
    );
  }

  Future<void> _getCategoryList() async {
    EasyLoading.show();
    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().get('get_category');
    try {
      final model = CategoryListResponseModel.fromJson(response?.data);
      EasyLoading.dismiss();
      if (model.status) {
        setState(() {
          categoryDataList = model.categories;
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

  Future<void> _getSubCategoryList() async {
    EasyLoading.show();
    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().get('get_subcategory');
    try {
      final model = SubCategoryListResponseModel.fromJson(response?.data);
      EasyLoading.dismiss();
      if (model.status) {
        setState(() {
          totalSubCategoryDataList = model.subcategories;
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

  void _onDropDownItemSelected(CategoryListModel? newSelectedCategory) {
    setState(() {
      _categoryChoose = newSelectedCategory;
      subcategoryDataList = totalSubCategoryDataList.where((model) {
        return model.parentId == _categoryChoose?.id;
      }).toList();
    });
  }

  void _onDropDownSubCategorySelected(
      SubcategoryListModel? subcategoryListModel) {
    setState(() {
      _subcategoryChoose = subcategoryListModel;
    });
  }

  bool validate() {
    if (_categoryChoose == null) {
      Fluttertoast.showToast(
          msg: 'Select category!', backgroundColor: AppColors.PRIMARY_COLOR);
      return false;
    }
    if (_subcategoryChoose == null) {
      Fluttertoast.showToast(
          msg: 'Select subcategory!', backgroundColor: AppColors.PRIMARY_COLOR);
      return false;
    }
    if (activityNameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Enter activity name!',
          backgroundColor: AppColors.PRIMARY_COLOR);
      return false;
    }
    // if (fromTimeController.text.isEmpty) {
    //   Fluttertoast.showToast(
    //       msg: 'Select from time frame!',
    //       backgroundColor: AppColors.PRIMARY_COLOR);
    //   return false;
    // }
    // if (toTimeController.text.isEmpty) {
    //   Fluttertoast.showToast(
    //       msg: 'Select to time frame!',
    //       backgroundColor: AppColors.PRIMARY_COLOR);
    //   return false;
    // }
    print(_formKey.currentState?.validate() ?? false);
    return true; //_formKey.currentState?.validate() ?? false;
  }

  void _callAddActivityApi(bool isAddAnother) async {
    if (!validate()) {
      return;
    }

    EasyLoading.show();
    Map<String, dynamic> param = {
      "activity": activityNameController.text.trim(),
      // "starttime": fromTimeController.text,
      // "endtime": toTimeController.text,
      "selectprivacy": _tagscope == TagPrivacyScope.private ? '0' : '1',
      "selectcolor": _colorList[selectedColorIndex],
      "parent_catgory": _categoryChoose?.id,
      "sub_category": _subcategoryChoose?.id,
    };
    ApiResponse<dynamic>? response =
        await ApiBaseHelper.getInstance().post('add_activity_tag', param);
    try {
      final model = AddActivityResponseModel.fromJson(response?.data);
      EasyLoading.dismiss();
      if (model.status) {
        Fluttertoast.showToast(
            msg: model.message ?? 'Something went wrong!',
            backgroundColor: AppColors.PRIMARY_COLOR);
        if (isAddAnother) {
          _prepareAddAnotherTag();
        } else {
           _moveToBackScreen(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const Login()),
          // );

        }
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

  void _prepareAddAnotherTag() {
    setState(() {
      _categoryChoose = null;
      _subcategoryChoose = null;
      activityNameController.text = '';
      selectedColorIndex = 0;
      fromTimeController.text = '';
      _tagscope = TagPrivacyScope.private;
      toTimeController.text = '';
    });
  }

  void _moveToBackScreen(context) {
    Navigator.pop(context);
  }
}
