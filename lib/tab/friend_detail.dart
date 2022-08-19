import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/activity_controller.dart';
import 'package:life_track/controller/custom-activity-report_controller.dart';
import 'package:life_track/controller/get_activity_tag_controller.dart';
import 'package:life_track/controller/single_friend_detail_controller.dart';
import 'package:life_track/controller/single_user_activity_controller.dart';
import 'package:life_track/models/categorylist_response.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/subcategorylist_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';
import 'package:life_track/tab/chart.dart';
import 'package:life_track/tab/chart_helper/outside_label.dart';
import 'package:life_track/tab/chart_helper/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';

enum ChartDisplayType { daily, weekly, monthly, all }

class FriendsDetail extends StatefulWidget {
  const FriendsDetail({Key? key}) : super(key: key);

  @override
  _FriendsDetailState createState() => _FriendsDetailState();
}

enum TagPrivacyScope { private, public }

class _FriendsDetailState extends State<FriendsDetail> {
  final SingleFriendDetailController controllerFirend = Get.put(
      SingleFriendDetailController());
  final ActivityController activityController = Get.put(ActivityController());
  final SingleUserActivityController singleUserActivity = Get.put(
      SingleUserActivityController());

  // final ActivityController01 activityController =
  // Get.put(ActivityController01());
  final CustomActivityController customActivityController = Get.put(
      CustomActivityController());
  final GetActivityTagsController getActivityTagsController = Get.put(
      GetActivityTagsController());

  ChartDisplayType chartDisplayType = ChartDisplayType.daily;

  CategoryListModel? _categoryChoose;
  List<CategoryListModel> categoryDataList = [];

  StackedBarChart? _barChart; // = StackedBarChart.withRandomData();
  PieOutsideLabelChart? _pieChart; // = PieOutsideLabelChart.withRandomData();
  // ChartDisplayType chartDisplayType = ChartDisplayType.daily;

  // final PieOutsideLabelChart _pieChart = PieOutsideLabelChart.withRandomData();
  // final StackedBarChart _barChart = StackedBarChart.withRandomData();
  String? dropDownValue;
  Activity? dropDownActualProgression;
  Activity? dropDownVarianceProgression;
  String? _startDateVPG, _endDateVPG;
  String? _startDateAPG, _endDateAPG;

  var varianceSelectedActivity;

  SubcategoryListModel? _subcategoryChoose;
  List<SubcategoryListModel> totalSubCategoryDataList = [];

  // final List<String> _selectedItems = [];
  List<Activity>? items;

  var catId;
  var subCatId;

  var userChecked = RxList<String>.empty(growable: true).obs;

  List<SubcategoryListModel> subcategoryDataList = [];


  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior1;
  late TooltipBehavior _tooltipBehavior2;
  late TooltipBehavior _tooltipBehavior3;
  late TooltipBehavior _tooltipBehavior4;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _tooltipBehavior1 = TooltipBehavior(enable: true);
    _tooltipBehavior2 = TooltipBehavior(enable: true);
    _tooltipBehavior3 = TooltipBehavior(enable: true);
    _tooltipBehavior4 = TooltipBehavior(enable: true);

    _getCategoryList();
    _getSubCategoryList();


    activityController.getDayWiseData(Get.arguments[0], null, null, null);
    activityController.getCategoryDayWiseData(Get.arguments[0], 'daily');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;

    List<BarCharModel> dataEntriesBarChart = [];
    List<PieChartModel> dataEntries = [];
    List<PieChartModel> dataEntries01 = [];

    List<SalesData> dataEntriesBarlineActual = [];
    List<SalesData> dataEntriesBarlineVariance = [];

    List<ChartData> chartDataActual = [];
    List<ChartData> chartDataBudget = [];

    final ActivityController controller = Get.put(ActivityController());
    SubcategoryListModel? _subcategoryChoose;
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.only(top: 16),
            child: Obx(() {
              if (activityController.isDataLoading.value) {
                // items = activityController.model.value.data as List<Activity>;
                if (chartDataActual.isEmpty &&
                    activityController.model.value.data != null) {
                  for (var i = 0;
                  i <
                      activityController
                          .model.value.data!.actualData.length;
                  i++) {
                    chartDataActual.add(ChartData(
                        activityController.model.value.data!.actualData[i].time,
                        double.parse(activityController
                            .model.value.data!.actualData[i].time)
                            .toInt(),
                        activityController.model.value.data!.actualData[i]
                            .getColor()));
                  }
                }
                if (chartDataBudget.isEmpty &&
                    activityController.model.value.data != null) {
                  for (var i = 0;
                  i <
                      activityController
                          .model.value.data!.budgetedData.length;
                  i++) {
                    chartDataBudget.add(ChartData(
                        activityController
                            .model.value.data!.budgetedData[i].time,
                        double.parse(activityController
                            .model.value.data!.budgetedData[i].time)
                            .toInt(),
                        activityController.model.value.data!.budgetedData[i]
                            .getColor()));
                  }
                }
                if (dataEntriesBarChart.isEmpty &&
                    activityController.model.value.data != null) {
                  for (var k = 0;
                  k < activityController.model.value.data!.barChat.length;
                  k++) {
                    /*print("xsdc02" + controller.model.value.data!.barChat[k].budgetedTime.toString() + " " + "xsdc02" + controller.model.value.data!.barChat[k].actualTime
                        .toString());*/
                    dataEntriesBarChart.add(BarCharModel(
                        xAxisUnits: activityController
                            .model.value.data!.barChat[k].title
                            .toString(),
                        yAxisUnits: double.parse(activityController
                            .model.value.data!.barChat[k].budgetedTime
                            .toString())
                            .toInt()));
                  }
                }
              }

              if (customActivityController.isDataLoading.value) {
                if (dataEntriesBarlineActual.isEmpty &&
                    customActivityController.model.value.data != null) {
                  for (var l = 0; l <
                      customActivityController.model.value.data!.barChat
                          .length; l++) {
                    dataEntriesBarlineActual.add(SalesData(
                      l,
                      customActivityController.model.value.data!.barChat[l]
                          .title
                          .toString(),
                      double.parse(customActivityController.model.value.data!
                          .barChat[l].budgetedTime.toString()).toInt(),
                      customActivityController.model.value.data!.barChat[l]
                          .getColor(),
                    ));
                  }
                }
              }

              return controller.isDataLoading.value
                  && controller.isDataLoading.value
                  && controllerFirend.model.value.data != null

                  ? Stack(
                children: [
                  Container(
                    width: deviceWidth * 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),

                        Image.asset(
                          'assets/images/splash_logo.png',
                          width: 159,
                          height: 50,
                        ),
                        SizedBox(width: 50,)
                      ],
                    ),
                  ),
                  Container(
                    width: deviceWidth,
                    margin: const EdgeInsets.only(top: 60),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              //backgroundImage: AssetImage('assets/images/defaultuser.png'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  controllerFirend.model.value.data!.image
                                      .toString(),
                                  fit: BoxFit.cover,
                                  // height: 55,
                                  // width: 55,
                                ),
                              ),
                              radius: 30.0,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controllerFirend.model.value.data!.firstName
                                      .toString() +
                                      " " +
                                      controllerFirend
                                          .model.value.data!.lastName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  controllerFirend.model.value.data!.achievement
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),

                        controllerFirend.model.value.data!.privacySetting[2]
                            .status == false
                            ? Center(child: Text('Private Access',
                          style: TextStyle(fontSize: 12, color: Colors.white),))
                            :
                        Charts(deviceHeight, deviceWidth, context)
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     SizedBox(
                        //       height: deviceHeight * 0.07,
                        //       child: Container(
                        //         alignment: Alignment.centerLeft,
                        //         padding: EdgeInsets.only(left: 16.0),
                        //         child: DropdownButtonHideUnderline(
                        //           child: DropdownButton<String>(
                        //             hint: dropDownValue == null
                        //                 ? Text('Select to show',style: TextStyle(color: Colors.white),)
                        //                 : Text(dropDownValue!, style: TextStyle(color: Colors.white),
                        //             ),
                        //             items: <String>['Activity', 'Category', 'Sub-category'].map((String value) {
                        //               return DropdownMenuItem<String>(
                        //                 value: value,
                        //                 child: Text(value),
                        //               );
                        //             }).toList(),
                        //             onChanged: (value) {
                        //               setState(
                        //                     () {
                        //                   dropDownValue = value;
                        //                 },
                        //               );
                        //             },
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //
                        //     dropDownValue=='Sub-category'
                        //         ? Column(
                        //       children: [
                        //         Center(
                        //           child: Container(
                        //             margin: const EdgeInsets.only(
                        //                 left: 15, top: 10, right: 15),
                        //             child: FormField<String>(
                        //               builder: (FormFieldState<String> state) {
                        //                 return InputDecorator(
                        //                   decoration: InputDecoration(
                        //                       contentPadding:
                        //                       const EdgeInsets.fromLTRB(
                        //                           12, 10, 20, 20),
                        //                       /*errorText: '',
                        //               errorStyle: const TextStyle(
                        //                 color: AppColors.DROP_DOWN_BG,
                        //                 fontSize: 16.0,
                        //               ),*/
                        //                       border: OutlineInputBorder(
                        //                         borderRadius: BorderRadius.circular(
                        //                           10.0,
                        //                         ),
                        //                       ),
                        //                       fillColor: AppColors.DROP_DOWN_BG,
                        //                       filled: true),
                        //                   child: DropdownButtonHideUnderline(
                        //                     child:
                        //                     DropdownButton<CategoryListModel>(
                        //                       style: const TextStyle(
                        //                         fontSize: 16,
                        //                         color: Colors.grey,
                        //                         fontFamily: fontFamilyName,
                        //                       ),
                        //                       hint: const Text(
                        //                         "Category",
                        //                         style: TextStyle(
                        //                           color: Colors.grey,
                        //                           fontSize: 16,
                        //                           fontFamily: fontFamilyName,
                        //                         ),
                        //                       ),
                        //                       items: categoryDataList.map<
                        //                           DropdownMenuItem<
                        //                               CategoryListModel>>(
                        //                               (CategoryListModel value) {
                        //                             catId = value.id;
                        //                             return DropdownMenuItem(
                        //                               value: value,
                        //                               child: Row(
                        //                                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                 children: [
                        //                                   /*CircleAvatar(
                        //                         backgroundImage:
                        //                             NetworkImage(value.bank_logo),
                        //                       ),
                        //                       // Icon(valueItem.bank_logo),
                        //                       const SizedBox(
                        //                         width: 15,
                        //                       ),*/
                        //                                   Text(value.title),
                        //                                 ],
                        //                               ),
                        //                             );
                        //                           }).toList(),
                        //                       isExpanded: true,
                        //                       isDense: true,
                        //                       onChanged: (newSelected) {
                        //                         _onDropDownItemSelected(
                        //                             newSelected);
                        //                       },
                        //                       value: _categoryChoose,
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //         Center(
                        //           child: Container(
                        //             margin: const EdgeInsets.only(
                        //                 left: 15, top: 10, right: 15),
                        //             child: FormField<String>(
                        //               builder: (FormFieldState<String> state) {
                        //                 return InputDecorator(
                        //                   decoration: InputDecoration(
                        //                       contentPadding:
                        //                       const EdgeInsets.fromLTRB(
                        //                           12, 10, 20, 20),
                        //                       /*errorText: '',
                        //               errorStyle: const TextStyle(
                        //                 color: AppColors.DROP_DOWN_BG,
                        //                 fontSize: 16.0,
                        //               ),*/
                        //                       border: OutlineInputBorder(
                        //                         borderRadius: BorderRadius.circular(
                        //                           10.0,
                        //                         ),
                        //                       ),
                        //                       fillColor: AppColors.DROP_DOWN_BG,
                        //                       filled: true),
                        //                   child: DropdownButtonHideUnderline(
                        //                     child: DropdownButton<
                        //                         SubcategoryListModel>(
                        //                       style: const TextStyle(
                        //                         fontSize: 16,
                        //                         color: Colors.grey,
                        //                         fontFamily: fontFamilyName,
                        //                       ),
                        //                       hint: const Text(
                        //                         "Sub Category",
                        //                         style: TextStyle(
                        //                           color: Colors.grey,
                        //                           fontSize: 16,
                        //                           fontFamily: fontFamilyName,
                        //                         ),
                        //                       ),
                        //                       items: subcategoryDataList.map<
                        //                           DropdownMenuItem<
                        //                               SubcategoryListModel>>(
                        //                               (SubcategoryListModel value) {
                        //                             subCatId = value.id;
                        //                             return DropdownMenuItem(
                        //                               value: value,
                        //                               child: Row(
                        //                                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                 children: [
                        //                                   /*CircleAvatar(
                        //                         backgroundImage:
                        //                             NetworkImage(value.bank_logo),
                        //                       ),
                        //                       // Icon(valueItem.bank_logo),
                        //                       const SizedBox(
                        //                         width: 15,
                        //                       ),*/
                        //                                   Text(value.title),
                        //                                 ],
                        //                               ),
                        //                             );
                        //                           }).toList(),
                        //                       isExpanded: true,
                        //                       isDense: true,
                        //                       onChanged: (newSelected) {
                        //                         _onDropDownSubCategorySelected(
                        //                             newSelected);
                        //                       },
                        //                       value: _subcategoryChoose,
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             ),
                        //           ),
                        //         ),
                        //         SizedBox(height: 16,),
                        //       ],
                        //     )
                        //         : SizedBox.shrink(),
                        //     dropDownValue==null
                        //         ? SizedBox(
                        //         height: deviceHeight*0.7,
                        //         child: Center(child: Text('select above options to see charts',style: TextStyle(fontSize: 20,color: Colors.white),)))
                        //         : SizedBox(
                        //       height: deviceHeight,
                        //       child: SingleChildScrollView(
                        //         child:Column(
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 GestureDetector(
                        //                   onTap: () {
                        //                     setState(() {
                        //                       if(dropDownValue=='Activity'){
                        //                         controller.getDayWiseData(Get.arguments[0].toString(),'', '', '');
                        //                       }else if(dropDownValue=='Category'){
                        //                         controller.getDayWiseData(Get.arguments[0].toString(),'', '', '');
                        //                       }else if(dropDownValue=='Sub-category'){
                        //                         controller.getDayWiseData(Get.arguments[0].toString(),'', catId, subCatId);
                        //                         print('work=> '+catId.toString()+"ljkfkdjf=>"+subCatId.toString());
                        //                       }
                        //                       chartDisplayType = ChartDisplayType.daily;
                        //
                        //                     });
                        //                   },
                        //                   child: Container(
                        //                     margin: const EdgeInsets.only(left: 16),
                        //                     padding: const EdgeInsets.only(
                        //                         left: 16, top: 8, right: 16, bottom: 8),
                        //                     decoration: BoxDecoration(
                        //                       color: chartDisplayType == ChartDisplayType.daily
                        //                           ? Colors.white
                        //                           : Colors.transparent,
                        //                       borderRadius: const BorderRadius.all(
                        //                         Radius.circular(16),
                        //                       ),
                        //                       border: Border.all(
                        //                         color: Colors.white,
                        //                         width: chartDisplayType == ChartDisplayType.daily
                        //                             ? 0
                        //                             : 1,
                        //                       ),
                        //                     ),
                        //                     child: Text(
                        //                       'Daily',
                        //                       style: TextStyle(
                        //                         color: chartDisplayType == ChartDisplayType.daily
                        //                             ? Colors.black
                        //                             : Colors.white,
                        //                         fontSize: 13,
                        //                         fontFamily: fontFamilyName,
                        //                         fontWeight: FontWeight.w700,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 GestureDetector(
                        //                   onTap: () {
                        //                     setState(() {
                        //                       if(dropDownValue=='Activity'){
                        //                         controller.getWeeklyWiseData(Get.arguments[0].toString(), '','');
                        //                       }else if(dropDownValue=='Category'){
                        //                         controller.getWeeklyWiseData(Get.arguments[0].toString(), '', '');
                        //                       }else if(dropDownValue=='Sub-category'){
                        //                         controller.getWeeklyWiseData(Get.arguments[0].toString(), catId, subCatId);
                        //                         print('work=> '+Get.arguments[0].toString()+"catid==>"+catId.toString()+"ljkfkdjf=>"+subCatId.toString());
                        //                       }
                        //
                        //                       chartDisplayType = ChartDisplayType.weekly;
                        //
                        //                     });
                        //                   },
                        //                   child: Container(
                        //                     margin: const EdgeInsets.only(left: 16),
                        //                     padding: const EdgeInsets.only(
                        //                         left: 16, top: 8, right: 16, bottom: 8),
                        //                     decoration: BoxDecoration(
                        //                         color: chartDisplayType == ChartDisplayType.weekly
                        //                             ? Colors.white
                        //                             : Colors.transparent,
                        //                         border: Border.all(
                        //                           color: Colors.white,
                        //                           width: chartDisplayType == ChartDisplayType.weekly
                        //                               ? 0
                        //                               : 1,
                        //                         ),
                        //                         borderRadius:
                        //                         const BorderRadius.all(Radius.circular(16))),
                        //                     child: Text(
                        //                       'Weekly',
                        //                       style: TextStyle(
                        //                         color: chartDisplayType == ChartDisplayType.weekly
                        //                             ? Colors.black
                        //                             : Colors.white,
                        //                         fontSize: 13,
                        //                         fontFamily: fontFamilyName,
                        //                         fontWeight: FontWeight.w700,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 GestureDetector(
                        //                   onTap: () {
                        //                     setState(() {
                        //
                        //                       if(dropDownValue=='Activity'){
                        //                         controller.getMonthlyWiseData(Get.arguments[0].toString(), '','');
                        //                       }else if(dropDownValue=='Category'){
                        //                         controller.getMonthlyWiseData(Get.arguments[0].toString(),'','');
                        //                       }else if(dropDownValue=='Sub-category'){
                        //                         controller.getMonthlyWiseData(Get.arguments[0].toString(), catId, subCatId);
                        //                         print('work=> '+Get.arguments[0].toString()+"catid===>"+catId.toString()+"ljkfkdjf=>"+subCatId.toString());
                        //                       }
                        //                       chartDisplayType = ChartDisplayType.monthly;
                        //
                        //                     });
                        //                   },
                        //                   child: Container(
                        //                     margin: const EdgeInsets.only(left: 16),
                        //                     padding: const EdgeInsets.only(
                        //                         left: 16, top: 8, right: 16, bottom: 8),
                        //                     decoration: BoxDecoration(
                        //                         color: chartDisplayType == ChartDisplayType.monthly
                        //                             ? Colors.white
                        //                             : Colors.transparent,
                        //                         border: Border.all(
                        //                           color: Colors.white,
                        //                           width: chartDisplayType ==
                        //                               ChartDisplayType.monthly
                        //                               ? 0
                        //                               : 1,
                        //                         ),
                        //                         borderRadius:
                        //                         const BorderRadius.all(Radius.circular(16))),
                        //                     child: Text(
                        //                       'Monthly',
                        //                       style: TextStyle(
                        //                         color: chartDisplayType == ChartDisplayType.monthly
                        //                             ? Colors.black
                        //                             : Colors.white,
                        //                         fontSize: 13,
                        //                         fontFamily: fontFamilyName,
                        //                         fontWeight: FontWeight.w700,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //             Obx(() {
                        //               return controller.model.value.data==null? Center(child: Text('no data found')): Column(
                        //                 children: [
                        //                   Container(
                        //                     margin: const EdgeInsets.only(
                        //                         top: 8, left: 16, right: 16),
                        //                     padding: const EdgeInsets.only(top: 8, bottom: 16),
                        //                     decoration: BoxDecoration(
                        //                         border: Border.all(color: Colors.white,),
                        //                         borderRadius: const BorderRadius.all(
                        //                             Radius.circular(8))),
                        //                     // height: 400,
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                       children: [
                        //
                        //                         Text('Budgeted data (in %)',
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 20,
                        //                             fontFamily: fontFamilyName,
                        //                             fontWeight: FontWeight.w700,
                        //                           ),
                        //                         ),
                        //                         // _pieChart = PieOutsideLabelChart.withRandomData(dataEntries),
                        //                         SfCircularChart(
                        //                             palette: <Color>[
                        //                               Colors.amber,
                        //                               Colors.brown,
                        //                               Colors.green,
                        //                               Colors.redAccent,
                        //                               Colors.blueAccent,
                        //                               Colors.teal
                        //                             ],
                        //                             series: <CircularSeries<ChartData, String>>[
                        //                               // Render pie chart
                        //                               PieSeries<ChartData, String>(
                        //                                 dataSource: chartDataBudget,
                        //                                 pointColorMapper: (ChartData data,
                        //                                     _) => data.color,
                        //                                 xValueMapper: (ChartData data, _) =>
                        //                                 data.label,
                        //                                 yValueMapper: (ChartData data, _) =>
                        //                                 data.sales,
                        //                                 dataLabelSettings: DataLabelSettings(
                        //                                     isVisible: true),
                        //                                 emptyPointSettings:
                        //                                 EmptyPointSettings(
                        //                                     mode: EmptyPointMode.average),
                        //                                 dataLabelMapper: (ChartData data,
                        //                                     _) => data.label,
                        //                               )
                        //                             ]
                        //                         ),
                        //                         Container(
                        //                           width: deviceWidth*0.6,
                        //                           child: GridView.builder(
                        //                             physics: NeverScrollableScrollPhysics(),
                        //                             shrinkWrap: true,
                        //                             itemCount: controller.model.value.data!
                        //                                 .budgetedData.length,
                        //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //                               crossAxisCount: 4,
                        //                               childAspectRatio: deviceWidth /
                        //                                   (MediaQuery.of(context).size.height / 4),
                        //                             ),
                        //
                        //                             itemBuilder: (BuildContext context, int index) {
                        //                               return Card(
                        //                                 color: controller.model.value
                        //                                     .data!.budgetedData[index]
                        //                                     .getColor(),
                        //                                 child: Row(
                        //                                   mainAxisAlignment: MainAxisAlignment
                        //                                       .center,
                        //                                   children: [
                        //                                     Expanded(
                        //                                       child: Text(controller.model.value.data!
                        //                                           .budgetedData[index].title
                        //                                           .toString(), overflow: TextOverflow.ellipsis,style: TextStyle(
                        //                                           color: Colors.white,fontSize: 10),),
                        //                                     ),
                        //
                        //
                        //                                   ],
                        //                                 ),
                        //                               );
                        //                             },
                        //                           ),
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     margin: const EdgeInsets.only(
                        //                         top: 8, left: 16, right: 16),
                        //                     padding: const EdgeInsets.only(top: 8, bottom: 16),
                        //                     decoration: BoxDecoration(
                        //                         border: Border.all(color: Colors.white,),
                        //                         borderRadius: const BorderRadius.all(
                        //                             Radius.circular(8))),
                        //                     // height: 400,
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                       children: [
                        //
                        //                         Text('Actual data (in %)',
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 20,
                        //                             fontFamily: fontFamilyName,
                        //                             fontWeight: FontWeight.w700,
                        //                           ),
                        //                         ),
                        //                         SfCircularChart(
                        //                             palette: <Color>[
                        //                               Colors.amber,
                        //                               Colors.brown,
                        //                               Colors.green,
                        //                               Colors.redAccent,
                        //                               Colors.blueAccent,
                        //                               Colors.teal
                        //                             ],
                        //                             series: <CircularSeries<ChartData, String>>[
                        //                               // Render pie chart
                        //                               PieSeries<ChartData, String>(
                        //                                 dataSource: chartDataActual,
                        //                                 pointColorMapper: (ChartData data, _) => data.color,
                        //                                 xValueMapper: (ChartData data, _) => data.label,
                        //                                 yValueMapper: (ChartData data, _) => data.sales,
                        //                                 dataLabelSettings: DataLabelSettings(isVisible: true),
                        //                                 emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average),
                        //                                 dataLabelMapper: (ChartData data, _) => data.label,
                        //                               )
                        //                             ]
                        //                         ),
                        //                         Container(
                        //                           width: deviceWidth*0.6,
                        //                           child: GridView.builder(
                        //                             physics: NeverScrollableScrollPhysics(),
                        //                             shrinkWrap: true,
                        //                             itemCount: controller.model.value.data!.actualData.length,
                        //                             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //                               crossAxisCount: 4,
                        //                               childAspectRatio: deviceWidth /
                        //                                   (MediaQuery.of(context).size.height / 4),
                        //                             ),
                        //
                        //                             itemBuilder: (BuildContext context, int index) {
                        //                               return Card(
                        //                                 color: controller.model.value
                        //                                     .data!.actualData[index]
                        //                                     .getColor(),
                        //                                 child: Row(
                        //                                   mainAxisAlignment: MainAxisAlignment
                        //                                       .center,
                        //                                   children: [
                        //                                     Expanded(
                        //                                       child: Text(controller.model.value.data!
                        //                                           .actualData[index].title
                        //                                           .toString(), overflow: TextOverflow.ellipsis,style: TextStyle(
                        //                                           color: Colors.white,fontSize: 10),),
                        //                                     ),
                        //
                        //
                        //                                   ],
                        //                                 ),
                        //                               );
                        //                             },
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   Container(
                        //                     margin: const EdgeInsets.only(
                        //                         top: 8, left: 16, right: 16, bottom: 16),
                        //                     padding: const EdgeInsets.only(top: 8, bottom: 16),
                        //                     decoration: BoxDecoration(
                        //                         border: Border.all(
                        //                           color: Colors.white,
                        //                         ),
                        //                         borderRadius: const BorderRadius.all(
                        //                             Radius.circular(8))),
                        //                     //height: 450,
                        //                     //width: 300,
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //                       children: [
                        //                         const Text(
                        //                           'Variance Chart (in %)',
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 20,
                        //                             fontFamily: fontFamilyName,
                        //                             fontWeight: FontWeight.w700,
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           child: _barChart = StackedBarChart.withRandomData(dataEntriesBarChart),
                        //                           height: 300,
                        //                         ),
                        //                         const SizedBox(
                        //                           height: 16,
                        //                         ),
                        //                         Row(
                        //                           mainAxisAlignment: MainAxisAlignment.center,
                        //                           children: [
                        //                             Row(
                        //                               children: [
                        //                                 Container(
                        //                                   height: 21,
                        //                                   width: 21,
                        //                                   decoration: const BoxDecoration(
                        //                                     borderRadius:
                        //                                     BorderRadius.all(Radius.circular(4)),
                        //                                     color: Color(0xff26a3c1),
                        //                                   ),
                        //                                 ),
                        //                                 const SizedBox(
                        //                                   width: 4,
                        //                                 ),
                        //                                 const Text(
                        //                                   'Title Name',
                        //                                   style: TextStyle(
                        //                                     color: Colors.white,
                        //                                     fontSize: 13,
                        //                                     fontFamily: fontFamilyName,
                        //                                     fontWeight: FontWeight.normal,
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             const SizedBox(
                        //                               width: 16,
                        //                             ),
                        //                             Row(
                        //                               children: [
                        //                                 Container(
                        //                                   height: 21,
                        //                                   width: 21,
                        //                                   decoration: const BoxDecoration(
                        //                                     borderRadius:
                        //                                     BorderRadius.all(Radius.circular(4)),
                        //                                     color: Color(0xff568dd8),
                        //                                   ),
                        //                                 ),
                        //                                 const SizedBox(
                        //                                   width: 4,
                        //                                 ),
                        //                                 const Text(
                        //                                   'Title Name',
                        //                                   style: TextStyle(
                        //                                     color: Colors.white,
                        //                                     fontSize: 13,
                        //                                     fontFamily: fontFamilyName,
                        //                                     fontWeight: FontWeight.normal,
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ],
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ),
                        //                   // varience charts
                        //                   dropDownValue == 'Activity' ? Container(
                        //                     margin: const EdgeInsets.only(
                        //                         top: 8, left: 16, right: 16),
                        //                     padding: const EdgeInsets.only(
                        //                         top: 8, bottom: 16),
                        //                     decoration: BoxDecoration(
                        //                         border: Border.all(color: Colors.white,),
                        //                         borderRadius: const BorderRadius.all(
                        //                             Radius.circular(8))),
                        //                     height: 410,
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                       children: [
                        //                         // line graph where the user can select a single activity, and a date range to show the spread between their budget and actual time spent over time
                        //                         Text('Variance  Progression Graph (in %)',
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 20,
                        //                             fontFamily: fontFamilyName,
                        //                             fontWeight: FontWeight.w700,
                        //                           ),
                        //                         ),
                        //
                        //                         SizedBox(height: 8.0,),
                        //                         SizedBox(
                        //                           height: deviceHeight * 0.05,
                        //                           child: Row(
                        //                             children: [
                        //                               Expanded(
                        //                                 child: Container(
                        //                                   alignment: Alignment.centerLeft,
                        //                                   margin: EdgeInsets.only(left: 16.0),
                        //                                   padding: EdgeInsets.all(8),
                        //                                   decoration: BoxDecoration(
                        //                                       color: Colors.white,
                        //                                       borderRadius: BorderRadius
                        //                                           .circular(4)
                        //                                   ),
                        //                                   child: DropdownButtonHideUnderline(
                        //
                        //                                     child: DropdownButton<Activity>(
                        //                                       hint: dropDownVarianceProgression ==
                        //                                           null
                        //                                           ? Text('Select an Activity',
                        //                                         style: TextStyle(
                        //                                             color: Colors.black,
                        //                                             fontSize: 14),)
                        //                                           : Text(
                        //                                         dropDownVarianceProgression!
                        //                                             .activity,
                        //                                         style: TextStyle(
                        //                                             color: Colors.black,
                        //                                             fontSize: 14),
                        //                                       ),
                        //                                       items: getActivityTagsController
                        //                                           .model.value.activity!.map((
                        //                                           Activity value) {
                        //                                         return DropdownMenuItem<
                        //                                             Activity>(
                        //                                           value: value,
                        //                                           child: Text(value.activity
                        //                                               .toString()),
                        //                                         );
                        //                                       }).toList(),
                        //                                       onChanged: (Activity? value) {
                        //                                         setState(
                        //                                               () {
                        //                                             print("loikkfrnfjfghgh :: " + value!.id.toString());
                        //                                             varianceSelectedActivity = value.id.toString();
                        //
                        //                                             dropDownVarianceProgression =
                        //                                                 value;
                        //                                           },
                        //                                         );
                        //                                       },
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                               Expanded(
                        //                                 child: InkWell(
                        //                                   onTap: /*_show*/() {
                        //                                     Get.defaultDialog(
                        //                                         title: 'DateRange',
                        //                                         content: Container(
                        //                                           width: deviceWidth,
                        //                                           height: deviceHeight*0.5,
                        //                                           child: Column(
                        //                                             children: [
                        //                                               SfDateRangePicker(
                        //                                                 showActionButtons: true,
                        //                                                 onSubmit: (
                        //                                                     Object? value) {
                        //                                                   Navigator.pop(
                        //                                                       context);
                        //                                                   customActivityController
                        //                                                       .getCustomActivityReport(
                        //                                                       Get.arguments[0].toString(),
                        //                                                       varianceSelectedActivity,
                        //                                                       '${_startDate}',
                        //                                                       '${_endDate}');
                        //                                                 },
                        //                                                 onCancel: () {
                        //                                                   Navigator.pop(
                        //                                                       context);
                        //                                                 },
                        //                                                 selectionMode: DateRangePickerSelectionMode
                        //                                                     .range,
                        //                                                 onSelectionChanged: selectionChanged,
                        //                                               )
                        //                                             ],),
                        //                                         )
                        //                                     );
                        //                                   },
                        //                                   child: Container(
                        //                                     alignment: Alignment.centerLeft,
                        //                                     margin: EdgeInsets.only(
                        //                                         left: 16.0, right: 16.0),
                        //                                     padding: EdgeInsets.all(8),
                        //                                     decoration: BoxDecoration(
                        //                                         color: Colors.white,
                        //                                         borderRadius: BorderRadius
                        //                                             .circular(4)
                        //                                     ),
                        //                                     child: Row(
                        //                                       mainAxisAlignment: MainAxisAlignment
                        //                                           .spaceBetween,
                        //                                       children: [
                        //                                         Text(
                        //                                           "Start date: ${_startDate}"
                        //                                               "" +
                        //                                               "\n""End date: ${_endDate}",
                        //                                           style: TextStyle(
                        //                                               fontSize: 8),),
                        //                                         Icon(Icons
                        //                                             .calendar_today_outlined)
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             ],
                        //                           ),
                        //                         ),
                        //                         SfCartesianChart(
                        //                             primaryXAxis: NumericAxis(
                        //                                 edgeLabelPlacement: EdgeLabelPlacement
                        //                                     .shift),
                        //                             series: <ChartSeries>[
                        //                               // Renders line chart
                        //                               LineSeries<SalesData, int>(
                        //                                 dataSource: dataEntriesBarlineActual,
                        //                                 pointColorMapper: (SalesData sales,
                        //                                     _) => sales.color,
                        //                                 xValueMapper: (SalesData sales,
                        //                                     _) => sales.label,
                        //                                 yValueMapper: (SalesData sales,
                        //                                     _) => sales.sales,
                        //                                 dataLabelSettings: DataLabelSettings(
                        //                                     isVisible: true),
                        //                                 emptyPointSettings: EmptyPointSettings(
                        //                                     mode: EmptyPointMode.average),
                        //                                 dataLabelMapper: (SalesData sales,
                        //                                     _) => sales.title.toString(),
                        //                               )
                        //                             ]
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ) : SizedBox.shrink(),
                        //                   dropDownValue=='Activity' ?Container(
                        //                     margin: const EdgeInsets.only(
                        //                         top: 8, left: 16, right: 16),
                        //                     padding: const EdgeInsets.only(top: 8, bottom: 16),
                        //                     decoration: BoxDecoration(
                        //                         border: Border.all(color: Colors.white,),
                        //                         borderRadius: const BorderRadius.all(
                        //                             Radius.circular(8))),
                        //                     height: 410,
                        //                     child: Column(
                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                       children: [
                        //                         // line graph where the user can select a single activity, and a date range to show the spread between their budget and actual time spent over time
                        //                         Text('Variance Progression Graph (in %)',
                        //                           style: TextStyle(
                        //                             color: Colors.white,
                        //                             fontSize: 20,
                        //                             fontFamily: fontFamilyName,
                        //                             fontWeight: FontWeight.w700,
                        //                           ),
                        //                         ),
                        //                         SizedBox(height: 8.0,),
                        //                         SizedBox(
                        //                           height: deviceHeight * 0.05,
                        //                           child: Row(
                        //                             children: [
                        //                               Expanded(
                        //                                 child: InkWell(
                        //                                   onTap: (){
                        //                                     showDialog(
                        //                                         barrierDismissible: false,
                        //                                         context: context,
                        //                                         builder: (BuildContext context) {
                        //                                           return ListSelection(getActivityTagsController.model.value.activity!);
                        //                                         });
                        //                                   },
                        //                                   child: Container(
                        //                                     alignment: Alignment.centerLeft,
                        //                                     margin: EdgeInsets.only(left: 16.0),
                        //                                     padding: EdgeInsets.all(8),
                        //                                     decoration: BoxDecoration(
                        //                                         color: Colors.white,
                        //                                         borderRadius: BorderRadius.circular(4)
                        //                                     ),
                        //                                     child: Text('Select Activity'),
                        //                                   ),
                        //                                 ),
                        //                               ),
                        //                               Expanded(
                        //                                 child: InkWell(
                        //                                   onTap: /*_show*/(){
                        //
                        //                                     Get.defaultDialog(
                        //                                         title: 'DateRange',
                        //                                         content: Container(
                        //                                           width: deviceWidth,
                        //                                           height: deviceHeight*0.5,
                        //                                           child: Column(
                        //                                             children: [
                        //                                               SfDateRangePicker(
                        //                                                 showActionButtons: true,
                        //                                                 onSubmit: (Object? value) {
                        //                                                   Navigator.pop(context);
                        //                                                   customActivityController.getCustomActivityReport(
                        //                                                       Get.arguments[0].toString(),
                        //                                                       customActivityController.ids.value,
                        //                                                       '${_startDate}', '${_endDate}');
                        //                                                   print('Ids :: '+customActivityController.ids.value);
                        //                                                 },
                        //                                                 onCancel: () {
                        //                                                   Navigator.pop(context);
                        //                                                 },
                        //                                                 selectionMode: DateRangePickerSelectionMode.range,
                        //                                                 onSelectionChanged: selectionChanged,
                        //                                               )
                        //                                             ],),
                        //                                         )
                        //                                     );
                        //                                   },
                        //                                   child: Container(
                        //                                     alignment: Alignment.centerLeft,
                        //                                     margin: EdgeInsets.only(left: 16.0,right: 16.0),
                        //                                     padding: EdgeInsets.all(8),
                        //                                     decoration: BoxDecoration(
                        //                                         color: Colors.white,
                        //                                         borderRadius: BorderRadius.circular(4)
                        //                                     ),
                        //                                     child: Row(
                        //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                       children: [
                        //                                         Text("Start date: ${_startDate}"
                        //                                             ""+"\n""End date: ${_endDate}",style: TextStyle(fontSize: 8),),
                        //                                         Icon(Icons.calendar_today_outlined)
                        //                                       ],
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             ],
                        //                           ),
                        //                         ),
                        //
                        //                         SfCartesianChart(
                        //                             primaryXAxis: NumericAxis(edgeLabelPlacement: EdgeLabelPlacement.shift),
                        //                             series: <ChartSeries>[
                        //                               // Renders line chart
                        //                               LineSeries<SalesData, int>(
                        //                                 dataSource: dataEntriesBarlineVariance,
                        //                                 pointColorMapper: (SalesData sales, _) => sales.color,
                        //                                 xValueMapper: (SalesData sales, _) => sales.label,
                        //                                 yValueMapper: (SalesData sales, _) => sales.sales,
                        //                                 dataLabelSettings: DataLabelSettings(isVisible: true),
                        //                                 emptyPointSettings: EmptyPointSettings(mode: EmptyPointMode.average),
                        //                                 dataLabelMapper: (SalesData sales, _) => sales.title.toString(),
                        //                               )
                        //                             ]
                        //                         )
                        //                       ],
                        //                     ),
                        //                   ) : SizedBox.shrink(),
                        //                   // varience charts end
                        //                   SizedBox(height: 500,)
                        //                 ],
                        //               );
                        //             })
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )

                        /* SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chartDisplayType =
                                        ChartDisplayType.daily;
                                    activityController.getDayWiseData();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 8,
                                      right: 16,
                                      bottom: 8),
                                  decoration: BoxDecoration(
                                    color: chartDisplayType ==
                                        ChartDisplayType.daily
                                        ? Colors.white
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: chartDisplayType ==
                                          ChartDisplayType.daily
                                          ? 0
                                          : 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Daily',
                                    style: TextStyle(
                                      color: chartDisplayType ==
                                          ChartDisplayType.daily
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 13,
                                      fontFamily: fontFamilyName,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chartDisplayType =
                                        ChartDisplayType.weekly;
                                    activityController
                                        .getWeeklyWiseData();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 8,
                                      right: 16,
                                      bottom: 8),
                                  decoration: BoxDecoration(
                                      color: chartDisplayType ==
                                          ChartDisplayType.weekly
                                          ? Colors.white
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: chartDisplayType ==
                                            ChartDisplayType.weekly
                                            ? 0
                                            : 1,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Text(
                                    'Weekly',
                                    style: TextStyle(
                                      color: chartDisplayType ==
                                          ChartDisplayType.weekly
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 13,
                                      fontFamily: fontFamilyName,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    chartDisplayType =
                                        ChartDisplayType.monthly;
                                    activityController
                                        .getMonthlyWiseData();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 8,
                                      right: 16,
                                      bottom: 8),
                                  decoration: BoxDecoration(
                                      color: chartDisplayType ==
                                          ChartDisplayType.monthly
                                          ? Colors.white
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: chartDisplayType ==
                                            ChartDisplayType.monthly
                                            ? 0
                                            : 1,
                                      ),
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Text(
                                    'Monthly',
                                    style: TextStyle(
                                      color: chartDisplayType ==
                                          ChartDisplayType.monthly
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 13,
                                      fontFamily: fontFamilyName,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     setState(() {
                              //       chartDisplayType = ChartDisplayType.all;
                              //     });
                              //   },
                              //   child: Container(
                              //     margin: const EdgeInsets.only(left: 16),
                              //     padding: const EdgeInsets.only(
                              //         left: 16, top: 8, right: 16, bottom: 8),
                              //     decoration: BoxDecoration(
                              //         color: chartDisplayType ==
                              //             ChartDisplayType.all
                              //             ? Colors.white
                              //             : Colors.transparent,
                              //         border: Border.all(
                              //           color: Colors.white,
                              //           width: chartDisplayType ==
                              //               ChartDisplayType.all
                              //               ? 0
                              //               : 1,
                              //         ),
                              //         borderRadius:
                              //         const BorderRadius.all(
                              //             Radius.circular(16))),
                              //     child: Text(
                              //       'All',
                              //       style: TextStyle(
                              //         color: chartDisplayType ==
                              //             ChartDisplayType.all
                              //             ? Colors.black
                              //             : Colors.white,
                              //         fontSize: 13,
                              //         fontFamily: fontFamilyName,
                              //         fontWeight: FontWeight.w700,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Container(
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height * 0.7,
                            child: SingleChildScrollView(
                              child: controller.model.value.data == null
                                  ? Text(
                                'no data found',
                                style:
                                TextStyle(color: Colors.white),
                              )
                                  : Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8,
                                        left: 16,
                                        right: 16),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(
                                                8))),
                                    // height: 400,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'budgeted data',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily:
                                            fontFamilyName,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),
                                        // _pieChart = PieOutsideLabelChart.withRandomData(dataEntries),
                                        SfCircularChart(
                                            palette: <Color>[
                                              Colors.amber,
                                              Colors.brown,
                                              Colors.green,
                                              Colors.redAccent,
                                              Colors.blueAccent,
                                              Colors.teal
                                            ],
                                            series: <
                                                CircularSeries<
                                                    ChartData,
                                                    String>>[
                                              // Render pie chart
                                              PieSeries<ChartData,
                                                  String>(
                                                dataSource:
                                                chartDataBudget,
                                                pointColorMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.color,
                                                xValueMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.label,
                                                yValueMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.sales,
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible:
                                                    true),
                                                emptyPointSettings:
                                                EmptyPointSettings(
                                                    mode: EmptyPointMode
                                                        .average),
                                                dataLabelMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.label,
                                              )
                                            ]),
                                        Container(
                                          width: deviceWidth * 0.6,
                                          child: activityController
                                              .model
                                              .value
                                              .data ==
                                              null
                                              ? SizedBox.shrink()
                                              : GridView.builder(
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                            activityController
                                                .model
                                                .value
                                                .data!
                                                .budgetedData
                                                .length,
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                              4,
                                              childAspectRatio:
                                              deviceWidth /
                                                  (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      4),
                                            ),
                                            itemBuilder:
                                                (BuildContext
                                            context,
                                                int index) {
                                              return Card(
                                                color: activityController
                                                    .model
                                                    .value
                                                    .data!
                                                    .budgetedData[
                                                index]
                                                    .getColor(),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      activityController
                                                          .model
                                                          .value
                                                          .data!
                                                          .budgetedData[index]
                                                          .title
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8,
                                        left: 16,
                                        right: 16),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(
                                                8))),
                                    // height: 400,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'actual data',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily:
                                            fontFamilyName,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),
                                        SfCircularChart(
                                            palette: <Color>[
                                              Colors.amber,
                                              Colors.brown,
                                              Colors.green,
                                              Colors.redAccent,
                                              Colors.blueAccent,
                                              Colors.teal
                                            ],
                                            series: <
                                                CircularSeries<
                                                    ChartData,
                                                    String>>[
                                              // Render pie chart
                                              PieSeries<ChartData,
                                                  String>(
                                                dataSource:
                                                chartDataActual,
                                                pointColorMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.color,
                                                xValueMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.label,
                                                yValueMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.sales,
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible:
                                                    true),
                                                emptyPointSettings:
                                                EmptyPointSettings(
                                                    mode: EmptyPointMode
                                                        .average),
                                                dataLabelMapper:
                                                    (ChartData data,
                                                    _) =>
                                                data.label,
                                              )
                                            ]),
                                        Container(
                                          width: deviceWidth * 0.6,
                                          child: activityController
                                              .model
                                              .value
                                              .data ==
                                              null
                                              ? SizedBox.shrink()
                                              : GridView.builder(
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                            activityController
                                                .model
                                                .value
                                                .data!
                                                .actualData
                                                .length,
                                            gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount:
                                              4,
                                              childAspectRatio:
                                              deviceWidth /
                                                  (MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height /
                                                      4),
                                            ),
                                            itemBuilder:
                                                (BuildContext
                                            context,
                                                int index) {
                                              return Card(
                                                color: activityController
                                                    .model
                                                    .value
                                                    .data!
                                                    .actualData[
                                                index]
                                                    .getColor(),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    Text(
                                                      activityController
                                                          .model
                                                          .value
                                                          .data!
                                                          .actualData[index]
                                                          .title
                                                          .toString(),
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8,
                                        left: 16,
                                        right: 16,
                                        bottom: 16),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(
                                                8))),
                                    //height: 450,
                                    //width: 300,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        const Text(
                                          'Variance Chart',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily:
                                            fontFamilyName,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          child: _barChart =
                                              StackedBarChart
                                                  .withRandomData(
                                                  dataEntriesBarChart),
                                          height: 300,
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 21,
                                                  width: 21,
                                                  decoration:
                                                  const BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        4)),
                                                    color: Color(
                                                        0xff26a3c1),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                const Text(
                                                  'Title Name',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 13,
                                                    fontFamily:
                                                    fontFamilyName,
                                                    fontWeight:
                                                    FontWeight
                                                        .normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 21,
                                                  width: 21,
                                                  decoration:
                                                  const BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .all(Radius
                                                        .circular(
                                                        4)),
                                                    color: Color(
                                                        0xff568dd8),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                const Text(
                                                  'Title Name',
                                                  style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize: 13,
                                                    fontFamily:
                                                    fontFamilyName,
                                                    fontWeight:
                                                    FontWeight
                                                        .normal,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  // varience charts
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8,
                                        left: 16,
                                        right: 16),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(
                                                8))),
                                    height: 410,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        // line graph where the user can select a single activity, and a date range to show the spread between their budget and actual time spent over time
                                        Text(
                                          'Actual  Progression Graph',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily:
                                            fontFamilyName,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          height:
                                          deviceHeight * 0.05,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment
                                                      .centerLeft,
                                                  margin: EdgeInsets
                                                      .only(
                                                      left:
                                                      16.0),
                                                  padding:
                                                  EdgeInsets
                                                      .all(8),
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .white,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          4)),
                                                  child:
                                                  DropdownButtonHideUnderline(
                                                    child:
                                                    DropdownButton<
                                                        Activity>(
                                                      hint: dropDownActualProgression ==
                                                          null
                                                          ? Text(
                                                        'Select an Activity',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      )
                                                          : Text(
                                                        dropDownActualProgression!
                                                            .activity,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                      ),
                                                      items: getActivityTagsController
                                                          .model
                                                          .value
                                                          .activity!
                                                          .map((Activity
                                                      value) {
                                                        return DropdownMenuItem<
                                                            Activity>(
                                                          value:
                                                          value,
                                                          child: Text(value
                                                              .activity
                                                              .toString()),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (Activity?
                                                      value) {
                                                        setState(
                                                              () {
                                                            print(
                                                                "loikkfrnfjfghgh :: " +
                                                                    value!.id
                                                                        .toString());

                                                            dropDownActualProgression =
                                                                value;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: */ /*_show*/
                        /* () {
                                                    Get.defaultDialog(
                                                        title: 'DateRange',
                                                        content: Column(
                                                          children: [
                                                            SfDateRangePicker(
                                                              showActionButtons:
                                                              true,
                                                              onSubmit:
                                                                  (
                                                                  Object? value) {
                                                                Navigator.pop(
                                                                    context);
                                                                customActivityController
                                                                    .getcustomActivityReport(
                                                                    '',
                                                                    '${_startDate}',
                                                                    '${_endDate}');
                                                              },
                                                              onCancel:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              selectionMode:
                                                              DateRangePickerSelectionMode
                                                                  .range,
                                                              onSelectionChanged:
                                                              selectionChanged,
                                                            )
                                                          ],
                                                        ));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    margin: EdgeInsets
                                                        .only(
                                                        left:
                                                        16.0,
                                                        right:
                                                        16.0),
                                                    padding:
                                                    EdgeInsets
                                                        .all(8),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Start date: ${_startDate}"
                                                              "" +
                                                              "\n"
                                                                  "End date: ${_endDate}",
                                                          style: TextStyle(
                                                              fontSize:
                                                              8),
                                                        ),
                                                        Icon(Icons
                                                            .calendar_today_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SfCartesianChart(
                                            primaryXAxis: NumericAxis(
                                                edgeLabelPlacement:
                                                EdgeLabelPlacement
                                                    .shift),
                                            series: <ChartSeries>[
                                              // Renders line chart
                                              LineSeries<SalesData,
                                                  int>(
                                                dataSource:
                                                dataEntriesBarlineActual,
                                                pointColorMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                sales.color,
                                                xValueMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                sales.label,
                                                yValueMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                sales.sales,
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible:
                                                    true),
                                                emptyPointSettings:
                                                EmptyPointSettings(
                                                    mode: EmptyPointMode
                                                        .average),
                                                dataLabelMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                    sales.title
                                                        .toString(),
                                              )
                                            ])
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 8,
                                        left: 16,
                                        right: 16),
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 16),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                        const BorderRadius.all(
                                            Radius.circular(
                                                8))),
                                    height: 410,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        // line graph where the user can select a single activity, and a date range to show the spread between their budget and actual time spent over time
                                        Text(
                                          'Variance Progression Graph',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily:
                                            fontFamilyName,
                                            fontWeight:
                                            FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        SizedBox(
                                          height:
                                          deviceHeight * 0.05,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child:
                                                GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        barrierDismissible: false,
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                      return ListSelection(getActivityTagsController.model.value.activity!);
                                                    });
                                                  },
                                                  child: Container(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    margin: EdgeInsets
                                                        .only(
                                                        left:
                                                        16.0),
                                                    padding:
                                                    EdgeInsets
                                                        .all(8),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                    child: Text(
                                                        'select an activity') */
                        /*DropdownButtonHideUnderline(

                                               child: DropdownButton<Activity>(
                                                 hint: dropDownVarianceProgression == null
                                                     ? Text('Select an Activity',style: TextStyle(color: Colors.black,fontSize: 14),)
                                                     : Text(dropDownVarianceProgression!.activity, style: TextStyle(color: Colors.black,fontSize: 14),
                                                 ),
                                                 items: getActivityTagsController.model.value.activity!.map((Activity value) {
                                                   return DropdownMenuItem<Activity>(
                                                     value: value,
                                                     child: Text(value.activity.toString()),
                                                   );
                                                 }).toList(),
                                                 onChanged: (Activity? value) {
                                                   setState(
                                                         () {
                                                       print("loikkfrnfjfghgh :: "+value!.id.toString());
                                                       dropDownVarianceProgression = value;
                                                     },
                                                   );
                                                 },
                                               ),
                                             )*/
                        /*
                                                    ,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: */
                        /*_show*/ /* () {
                                                    Get.defaultDialog(
                                                        title: 'DateRange',
                                                        content: Column(
                                                          children: [
                                                            SfDateRangePicker(
                                                              showActionButtons:
                                                              true,
                                                              onSubmit:
                                                                  (
                                                                  Object? value) {
                                                                Navigator.pop(
                                                                    context);
                                                                customActivityController
                                                                    .getcustomActivityReport(
                                                                    '',
                                                                    '${_startDate}',
                                                                    '${_endDate}');
                                                              },
                                                              onCancel:
                                                                  () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              selectionMode:
                                                              DateRangePickerSelectionMode
                                                                  .range,
                                                              onSelectionChanged:
                                                              selectionChanged,
                                                            )
                                                          ],
                                                        ));
                                                  },
                                                  child: Container(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    margin: EdgeInsets
                                                        .only(
                                                        left:
                                                        16.0,
                                                        right:
                                                        16.0),
                                                    padding:
                                                    EdgeInsets
                                                        .all(8),
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Start date: ${_startDate}"
                                                              "" +
                                                              "\n"
                                                                  "End date: ${_endDate}",
                                                          style: TextStyle(
                                                              fontSize:
                                                              8),
                                                        ),
                                                        Icon(Icons
                                                            .calendar_today_outlined)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        SfCartesianChart(
                                            primaryXAxis: NumericAxis(
                                                edgeLabelPlacement:
                                                EdgeLabelPlacement
                                                    .shift),
                                            series: <ChartSeries>[
                                              // Renders line chart
                                              LineSeries<SalesData,
                                                  int>(
                                                dataSource:
                                                dataEntriesBarlineVariance,
                                                pointColorMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                sales.color,
                                                xValueMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                sales.label,
                                                yValueMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                sales.sales,
                                                dataLabelSettings:
                                                DataLabelSettings(
                                                    isVisible:
                                                    true),
                                                emptyPointSettings:
                                                EmptyPointSettings(
                                                    mode: EmptyPointMode
                                                        .average),
                                                dataLabelMapper:
                                                    (SalesData sales,
                                                    _) =>
                                                    sales.title
                                                        .toString(),
                                              )
                                            ])
                                      ],
                                    ),
                                  ),
                                  // varience charts end
                                ],
                              ),
                            ))*/
                      ],
                    ),
                  ),
                ],
              )
                  : Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }

  Column Charts(double deviceHeight, double deviceWidth, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: deviceHeight * 0.07,
          child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: dropDownValue == null
                    ? Text('Select to show',
                  style: TextStyle(color: Colors.white),)
                    : Text(dropDownValue!,
                  style: TextStyle(color: Colors.white),
                ),
                items: <String>['Activity', 'Category', 'Sub-category']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(
                        () {
                      dropDownValue = value;
                      if (dropDownValue == 'Activity') {
                        print("working Activity" + Get.arguments[0].toString());
                        activityController.getDayWiseData(
                            Get.arguments[0], '', '', '');
                      } else if (dropDownValue == 'Category') {
                        print("working Category");
                        activityController.getCategoryDayWiseData(Get
                            .arguments[0].toString(), 'daily');
                      } else if (dropDownValue == 'Sub-category') {
                        print("working Sub-category");
                        activityController.getDayWiseData(Get.arguments[0]
                            .toString(), null, '', '');
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),

        dropDownValue == 'Sub-category'
            ? Column(
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
                            _onDropDownItemSelected(newSelected);
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
                child:
                subcategoryDataList.isEmpty ?
                Text('No Sub Activity Found',
                  style: TextStyle(color: Colors.white),)
                    :
                subcategoryDataList.length == 1 ?
                Text(subcategoryDataList[0].title) :

                FormField<String>(
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
            SizedBox(height: 16,),
          ],
        )
            : SizedBox.shrink(),
        dropDownValue == null
            ? SizedBox(
            height: deviceHeight * 0.7,
            child: Center(child: Text(
              'select above options to see charts',
              style: TextStyle(fontSize: 20, color: Colors.white),)))
            : SizedBox(
          height: deviceHeight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (dropDownValue == 'Activity') {
                            activityController.getDayWiseData(
                                Get.arguments[0], '', '', '');
                          } else if (dropDownValue == 'Category') {
                            activityController.getCategoryDayWiseData(
                                Get.arguments[0], 'day');
                          } else if (dropDownValue == 'Sub-category') {
                            activityController.getDayWiseData(
                                Get.arguments[0], '', catId, subCatId);
                            print('work=> ' + catId.toString() +
                                "ljkfkdjf=>" + subCatId.toString());
                          }
                          chartDisplayType = ChartDisplayType.daily;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        padding: const EdgeInsets.only(
                            left: 16, top: 8, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                          color: chartDisplayType ==
                              ChartDisplayType.daily
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: chartDisplayType ==
                                ChartDisplayType.daily
                                ? 0
                                : 1,
                          ),
                        ),
                        child: Text(
                          'Daily',
                          style: TextStyle(
                            color: chartDisplayType ==
                                ChartDisplayType.daily
                                ? Colors.black
                                : Colors.white,
                            fontSize: 13,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (dropDownValue == 'Activity') {
                            activityController.getWeeklyWiseData(null, '', '');
                          } else if (dropDownValue == 'Category') {
                            activityController.getCategoryDayWiseData(
                                Get.arguments[0], 'weekly');
                          } else if (dropDownValue == 'Sub-category') {
                            activityController.getWeeklyWiseData(
                                null, catId, subCatId);
                            print('work=> ' + catId.toString() +
                                "ljkfkdjf=>" + subCatId.toString());
                          }

                          chartDisplayType = ChartDisplayType.weekly;
                          chartDisplayType = ChartDisplayType.weekly;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        padding: const EdgeInsets.only(
                            left: 16, top: 8, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            color: chartDisplayType ==
                                ChartDisplayType.weekly
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.white,
                              width: chartDisplayType ==
                                  ChartDisplayType.weekly
                                  ? 0
                                  : 1,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                        child: Text(
                          'Weekly',
                          style: TextStyle(
                            color: chartDisplayType ==
                                ChartDisplayType.weekly
                                ? Colors.black
                                : Colors.white,
                            fontSize: 13,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (dropDownValue == 'Activity') {
                            activityController.getMonthlyWiseData(null, '', '');
                            activityController.getMonthlyWiseData(null, '', '');
                          } else if (dropDownValue == 'Category') {
                            activityController.getCategoryDayWiseData(
                                Get.arguments[0], 'monthly');
                          } else if (dropDownValue == 'Sub-category') {
                            activityController.getMonthlyWiseData(
                                null, catId, subCatId);
                            print('work=> ' + catId.toString() +
                                "ljkfkdjf=>" + subCatId.toString());
                          }
                          chartDisplayType = ChartDisplayType.monthly;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        padding: const EdgeInsets.only(
                            left: 16, top: 8, right: 16, bottom: 8),
                        decoration: BoxDecoration(
                            color: chartDisplayType ==
                                ChartDisplayType.monthly
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.white,
                              width: chartDisplayType ==
                                  ChartDisplayType.monthly
                                  ? 0
                                  : 1,
                            ),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16))),
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            color: chartDisplayType ==
                                ChartDisplayType.monthly
                                ? Colors.black
                                : Colors.white,
                            fontSize: 13,
                            fontFamily: fontFamilyName,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return activityController.model.value.data == null
                      ? Center(
                      child: Text('no data found'))
                      : Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: 8, left: 16, right: 16),
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8))),
                        // height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text('Budgeted data (in %)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            // _pieChart = PieOutsideLabelChart.withRandomData(dataEntries),
                            Obx(() {
                              // if(chartUpdate.value){
                              //   for (var i = 0; i <
                              //       activityController.model.value.data!.budgetedData.length; i++) {
                              //     chartDataBudget.value.add(ChartData(
                              //         activityController.model.value.data!.budgetedData[i].time,
                              //         double.parse(
                              //             activityController.model.value.data!.budgetedData[i].time)
                              //             .toInt(),
                              //         activityController.model.value.data!.budgetedData[i].getColor()));
                              //   }
                              //   chartUpdate.value = false;
                              // }
                              return SfCircularChart(
                                  onTooltipRender: (TooltipArgs args) {
                                    args.text = args.text;
                                  },
                                  tooltipBehavior: _tooltipBehavior,
                                  palette: <Color>[
                                    Colors.amber,
                                    Colors.brown,
                                    Colors.green,
                                    Colors.redAccent,
                                    Colors.blueAccent,
                                    Colors.teal
                                  ],
                                  onSelectionChanged: (model) {
                                    activityController.chartDataBudget.value =
                                    model as List<ChartData>;
                                  },
                                  series: <CircularSeries<ChartData, String>>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                      dataSource: activityController
                                          .chartDataBudget.value,
                                      pointColorMapper: (ChartData data,
                                          _) => data.color,
                                      xValueMapper: (ChartData data, _) =>
                                      data.label,
                                      yValueMapper: (ChartData data, _) =>
                                      data.sales,
                                      dataLabelSettings: DataLabelSettings(
                                          isVisible: true),
                                      emptyPointSettings:
                                      EmptyPointSettings(
                                          mode: EmptyPointMode.average),
                                      dataLabelMapper: (ChartData data,
                                          _) => data.label,
                                    )
                                  ]
                              );
                            }),
                            // Container(
                            //   width: deviceWidth * 0.6,
                            //   child: GridView.builder(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     shrinkWrap: true,
                            //     itemCount: activityController.model.value.data!
                            //         .budgetedData.length,
                            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 4,
                            //       childAspectRatio: deviceWidth /
                            //           (MediaQuery
                            //               .of(context)
                            //               .size
                            //               .height / 4),
                            //     ),
                            //
                            //     itemBuilder: (BuildContext context,
                            //         int index) {
                            //       return Card(
                            //         color: activityController.model.value
                            //             .data!.budgetedData[index]
                            //             .getColor(),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment
                            //               .center,
                            //           children: [
                            //             Expanded(
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //                 child: Text(activityController.model
                            //                     .value.data!
                            //                     .budgetedData[index].title
                            //                     .toString(),
                            //                   overflow: TextOverflow
                            //                       .ellipsis,
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 10),),
                            //               ),
                            //             ),
                            //
                            //
                            //
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 8, left: 16, right: 16),
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8))),
                        // height: 400,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Text('Actual data (in %)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Obx(() {
                              return SfCircularChart(
                                  onTooltipRender: (TooltipArgs args) {
                                    args.text = args.text;
                                  },
                                  tooltipBehavior: _tooltipBehavior1,
                                  palette: <Color>[
                                    Colors.amber,
                                    Colors.brown,
                                    Colors.green,
                                    Colors.blueAccent.shade700,
                                    Colors.blueAccent.shade100,
                                    Colors.teal
                                  ],
                                  onDataLabelTapped: (value) {
                                    print('VALUE11 :: ' + value.toString());
                                  },
                                  series: <
                                      CircularSeries<ChartData, String>>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                      dataSource: activityController
                                          .chartDataActual.value,
                                      pointColorMapper: (ChartData data,
                                          _) => data.color,
                                      xValueMapper: (ChartData data,
                                          _) => data.label,
                                      yValueMapper: (ChartData data,
                                          _) => data.sales,
                                      dataLabelSettings: DataLabelSettings(
                                          isVisible: true),
                                      emptyPointSettings: EmptyPointSettings(
                                          mode: EmptyPointMode.average),
                                      dataLabelMapper: (ChartData data,
                                          _) => data.label,
                                      enableTooltip: true,
                                      onPointTap: (value) {
                                        print('VALUE :: 22' +
                                            (value.viewportPointIndex)
                                                .toString());
                                        // showToast('VALUE :: 22'+(value.dataPoints![0]).toString());
                                      },
                                    )
                                  ]
                              );
                            }),
                            // Container(
                            //   width: deviceWidth * 0.6,
                            //   child: GridView.builder(
                            //     physics: NeverScrollableScrollPhysics(),
                            //     shrinkWrap: true,
                            //     itemCount: activityController.model.value.data!
                            //         .actualData.length,
                            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            //       crossAxisCount: 4,
                            //       childAspectRatio: deviceWidth /
                            //           (MediaQuery
                            //               .of(context)
                            //               .size
                            //               .height / 4),
                            //     ),
                            //
                            //     itemBuilder: (BuildContext context,
                            //         int index) {
                            //       return Card(
                            //         color: activityController.model.value
                            //             .data!.actualData[index]
                            //             .getColor(),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment
                            //               .center,
                            //           children: [
                            //             Expanded(
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //                 child: Text(activityController.model
                            //                     .value.data!
                            //                     .actualData[index].title
                            //                     .toString(),
                            //                   overflow: TextOverflow
                            //                       .ellipsis,
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 10),),
                            //               ),
                            //             ),
                            //
                            //
                            //           ],
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            top: 8, left: 16, right: 16, bottom: 16),
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 16),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8))),
                        //height: 450,
                        //width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly,
                          children: [
                            const Text(
                              'Variance Chart (in %)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Obx(() {
                              return SfCartesianChart(
                                  primaryXAxis: CategoryAxis(
                                      labelRotation: 25,
                                      majorGridLines: MajorGridLines(
                                          width: 0
                                      ),
                                      minorGridLines: MinorGridLines(
                                          width: 0
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.white
                                      )
                                  ),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: MajorGridLines(
                                        width: 0
                                    ),
                                    minorGridLines: MinorGridLines(
                                        width: 0
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),),
                                  // primaryXAxis: NumericAxis(labelStyle: TextStyle(
                                  //     color: Colors.white,
                                  //     decorationColor: Colors.white
                                  // ),
                                  //     edgeLabelPlacement: EdgeLabelPlacement
                                  //         .shift),
                                  // primaryYAxis: NumericAxis(labelStyle: TextStyle(
                                  //     color: Colors.white,
                                  //     decorationColor: Colors.white
                                  // ),
                                  // ),

                                  onTooltipRender: (TooltipArgs args) {
                                    args.text = args.text;
                                  },
                                  tooltipBehavior: _tooltipBehavior2,
                                  series: <ChartSeries>[
                                    StackedColumnSeries<ChartData, String>(
                                      dataLabelSettings: DataLabelSettings(
                                          useSeriesColor: true,
                                          color: Colors.white,
                                          showCumulativeValues: true,
                                          textStyle: TextStyle(fontSize: 10),
                                          angle: 25,
                                          offset: Offset(2, 2),
                                          isVisible: false),
                                      dataSource: activityController
                                          .dataEntriesBarChart.value,
                                      // Renders the track
                                      // isTrackVisible: true,
                                      xValueMapper: (ChartData data, _) =>
                                      data.label,
                                      yValueMapper: (ChartData data, _) =>
                                      data.sales,
                                      dataLabelMapper: (ChartData sales,
                                          _) => sales.label.toString(),
                                    )
                                  ]
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                dropDownValue == 'Category'
                                    ? Text('x-Axis: Categories',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                                    : Text('x-Axis: Activities',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text('y-Axis: time in %',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   child: _barChart =
                            //       StackedBarChart.withRandomData(
                            //           activityController.dataEntriesBarChart),
                            //   height: 300,
                            // ),
                            const SizedBox(
                              height: 16,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Row(
                            //       children: [
                            //         Container(
                            //           height: 21,
                            //           width: 21,
                            //           decoration: const BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(
                            //                 Radius.circular(4)),
                            //             color: Color(0xff26a3c1),
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           width: 4,
                            //         ),
                            //         const Text(
                            //           'Title Name',
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 13,
                            //             fontFamily: fontFamilyName,
                            //             fontWeight: FontWeight.normal,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     const SizedBox(
                            //       width: 16,
                            //     ),
                            //     Row(
                            //       children: [
                            //         Container(
                            //           height: 21,
                            //           width: 21,
                            //           decoration: const BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.all(
                            //                 Radius.circular(4)),
                            //             color: Color(0xff568dd8),
                            //           ),
                            //         ),
                            //         const SizedBox(
                            //           width: 4,
                            //         ),
                            //         const Text(
                            //           'Title Name',
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 13,
                            //             fontFamily: fontFamilyName,
                            //             fontWeight: FontWeight.normal,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                      // varience charts
                      dropDownValue == 'Activity' ? Container(
                        margin: const EdgeInsets.only(
                            top: 8, left: 16, right: 16),
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8))),
                        height: 440,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // line graph where the user can select a single activity, and a date range to show the spread between their budget and actual time spent over time
                            Text('Variance  Progression Graph (in %)',
                              style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 18,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 8.0,),
                            SizedBox(
                              height: deviceHeight * 0.05,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(left: 16.0),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius
                                              .circular(4)
                                      ),
                                      child: DropdownButtonHideUnderline(

                                        child: DropdownButton<Activity>(
                                          hint: dropDownVarianceProgression ==
                                              null
                                              ? Text('Select an Activity',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),)
                                              : Text(
                                            dropDownVarianceProgression!
                                                .activity,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          items: getActivityTagsController
                                              .model.value.activity?.map((
                                              Activity value) {
                                            return DropdownMenuItem<
                                                Activity>(
                                              value: value,
                                              child: Text(value.activity
                                                  .toString()),
                                            );
                                          }).toList(),
                                          onChanged: (Activity? value) {
                                            setState(
                                                  () {
                                                print("loikkfrnfjfghgh :: " +
                                                    value!.id.toString());
                                                varianceSelectedActivity =
                                                    value.id.toString();

                                                dropDownVarianceProgression =
                                                    value;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: /*_show*/() {
                                        if (dropDownVarianceProgression ==
                                            null) {
                                          Fluttertoast.showToast(
                                              msg: 'Select an activity First',
                                              backgroundColor: AppColors
                                                  .PRIMARY_COLOR);
                                        } else {
                                          Get.defaultDialog(
                                              title: 'Date Range',
                                              content: Container(
                                                width: deviceWidth,
                                                height: deviceHeight * 0.5,
                                                child: Column(
                                                  children: [
                                                    SfDateRangePicker(
                                                      showActionButtons: true,
                                                      onSubmit: (
                                                          Object? value) {
                                                        Navigator.pop(
                                                            context);
                                                        customActivityController
                                                            .getCustomActivityReport(
                                                            Get.arguments[0].toString(),
                                                            varianceSelectedActivity,
                                                            '${_startDateVPG}',
                                                            '${_endDateVPG}');
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      selectionMode: DateRangePickerSelectionMode
                                                          .range,
                                                      onSelectionChanged: selectionChangedVPG,
                                                    )
                                                  ],),
                                              )
                                          );
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius
                                                .circular(4)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              "Start date: ${_startDateVPG}"
                                                  "" +
                                                  "\n""End date: ${_endDateVPG}",
                                              style: TextStyle(
                                                  fontSize: 8),),
                                            Icon(Icons
                                                .calendar_today_outlined)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Obx(() {
                              return SfCartesianChart(
                                  onTooltipRender: (TooltipArgs args) {
                                    args.text = args.text;
                                  },
                                  tooltipBehavior: _tooltipBehavior3,
                                  primaryXAxis: NumericAxis(
                                      majorGridLines: MajorGridLines(
                                          width: 0
                                      ),
                                      minorGridLines: MinorGridLines(
                                          width: 0
                                      ),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        decorationColor: Colors.white,
                                      ),
                                      edgeLabelPlacement: EdgeLabelPlacement
                                          .shift),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: MajorGridLines(
                                        width: 0
                                    ),
                                    minorGridLines: MinorGridLines(
                                        width: 0
                                    ),
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        decorationColor: Colors.white
                                    ),
                                  ),
                                  series: <ChartSeries>[
                                    // Renders line chart
                                    LineSeries<SalesData, int>(
                                      dataSource: customActivityController
                                          .dataEntriesBarlineActual.value,
                                      pointColorMapper: (SalesData sales,
                                          _) => sales.color,
                                      xValueMapper: (SalesData sales,
                                          _) => sales.label,
                                      yValueMapper: (SalesData sales,
                                          _) => sales.sales,
                                      dataLabelSettings: DataLabelSettings(
                                          useSeriesColor: true,
                                          color: Colors.white,
                                          textStyle: TextStyle(fontSize: 10),
                                          angle: 25,
                                          offset: Offset(2, 2),
                                          isVisible: true),
                                      emptyPointSettings: EmptyPointSettings(
                                          mode: EmptyPointMode.average),
                                      dataLabelMapper: (SalesData sales,
                                          _) => sales.title.toString(),
                                    )
                                  ]
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                dropDownValue == 'Category'
                                    ? Text('x-Axis: Categories',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                                    : Text('x-Axis: Activities',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text('y-Axis: time in %',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) : SizedBox.shrink(),
                      dropDownValue == 'Activity' ? Container(
                        margin: const EdgeInsets.only(
                            top: 8, left: 16, right: 16),
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 16),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white,),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(8))),
                        height: 440,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // line graph where the user can select a single activity, and a date range to show the spread between their budget and actual time spent over time
                            Text('Actual Progression Graph (in %)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: fontFamilyName,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8.0,),
                            SizedBox(
                              height: deviceHeight * 0.05,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ListSelection(
                                                  getActivityTagsController
                                                      .model.value.activity!);
                                            });
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(left: 16.0),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius
                                                .circular(4)
                                        ),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            customActivityController.ids
                                                .isEmpty
                                                ? 'Select Activitys'
                                                : customActivityController.ids
                                                .toString(),textScaleFactor: 1.0,),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: /*_show*/() {
                                        Get.defaultDialog(
                                            title: 'Date Range',
                                            content: Container(
                                              width: deviceWidth,
                                              height: deviceHeight * 0.5,
                                              child: Column(
                                                children: [
                                                  SfDateRangePicker(
                                                    showActionButtons: true,
                                                    onSubmit: (Object? value) {
                                                      Navigator.pop(
                                                          context);

                                                      print('customActivityControllergetCustomActivityReport'+Get.arguments[0].toString());
                                                      customActivityController
                                                          .getCustomActivityReport(
                                                          Get.arguments[0].toString(),
                                                          customActivityController.ids.toString(),
                                                          '${_startDateAPG}',
                                                          '${_endDateAPG}');
                                                    },
                                                    onCancel: () {
                                                      Navigator.pop(
                                                          context);
                                                    },
                                                    selectionMode: DateRangePickerSelectionMode
                                                        .range,
                                                    onSelectionChanged: selectionChangedAPG,
                                                  )
                                                ],),
                                            )
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius
                                                .circular(4)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              "Start date: ${_startDateAPG}"
                                                  "" +
                                                  "\n""End date: ${_endDateAPG}",
                                              style: TextStyle(
                                                  fontSize: 8),),
                                            Icon(Icons
                                                .calendar_today_outlined)
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Obx(() {
                              return SfCartesianChart(
                                  onTooltipRender: (TooltipArgs args) {
                                    args.text = args.text;
                                  },
                                  tooltipBehavior: _tooltipBehavior4,
                                  onLegendItemRender: (args) {
                                    // Setting color for the series legend based on its index.
                                    args.color = Colors.white;
                                  },
                                  legend: Legend(
                                    // isVisible: true,
                                      textStyle: TextStyle(color: Colors.white),
                                      // Legend will be placed at the left
                                      position: LegendPosition.bottom
                                  ),
                                  primaryXAxis: NumericAxis(
                                      majorGridLines: MajorGridLines(
                                          width: 0
                                      ),
                                      minorGridLines: MinorGridLines(
                                          width: 0
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.white,
                                          decorationColor: Colors.white
                                      ),
                                      edgeLabelPlacement: EdgeLabelPlacement
                                          .shift),
                                  primaryYAxis: NumericAxis(
                                      majorGridLines: MajorGridLines(
                                          width: 0
                                      ),
                                      minorGridLines: MinorGridLines(
                                          width: 0
                                      ),
                                      labelStyle: TextStyle(
                                          color: Colors.white,
                                          decorationColor: Colors.white
                                      ),
                                      edgeLabelPlacement: EdgeLabelPlacement
                                          .shift),
                                  series: <ChartSeries>[
                                    // Renders line chart
                                    LineSeries<SalesData, int>(
                                      markerSettings: MarkerSettings(
                                          isVisible: true
                                      ),
                                      color: Colors.white,
                                      dataSource: customActivityController.dataEntriesBarLineVariance.value,
                                      pointColorMapper: (SalesData sales,
                                          _) => sales.color,
                                      xValueMapper: (SalesData sales,
                                          _) => sales.label,
                                      yValueMapper: (SalesData sales,
                                          _) => sales.sales,
                                      dataLabelSettings: DataLabelSettings(
                                          useSeriesColor: true,
                                          color: Colors.white,
                                          textStyle: TextStyle(fontSize: 10),
                                          angle: 25,
                                          offset: Offset(2, 2),
                                          isVisible: true),
                                      emptyPointSettings: EmptyPointSettings(
                                          mode: EmptyPointMode.average),
                                      dataLabelMapper: (SalesData sales,
                                          _) => sales.title.toString(),

                                    )
                                  ]
                              );
                            }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                dropDownValue == 'Category'
                                    ? Text('x-Axis: Categories',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                                    : Text('x-Axis: Activities',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text('y-Axis: time in %',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: fontFamilyName,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ) : SizedBox.shrink(),
                      // varience charts end
                      SizedBox(height: 500,)
                    ],
                  );
                })
              ],
            ),
          ),
        ),
      ],
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
        categoryDataList = model.categories;
        // setState(() {
        // });
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
        totalSubCategoryDataList = model.subcategories;
        // setState(() {
        // });
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
      subcategoryDataList.clear();
      _categoryChoose = newSelectedCategory;
      // new work
      catId = _categoryChoose!.id.toString();
      // new end

      subcategoryDataList = totalSubCategoryDataList.where((model) {
        return model.parentId == _categoryChoose?.id;
      }).toList();

      _subcategoryChoose = subcategoryDataList[0];
      activityController.getDayWiseData(Get.arguments[0], '', catId,
          subcategoryDataList.isEmpty ? null : subcategoryDataList[0].id
              .toString());
    });
  }

  void _onDropDownSubCategorySelected(
      SubcategoryListModel? subcategoryListModel) {
    setState(() {
      _subcategoryChoose = subcategoryListModel;
      subCatId = _subcategoryChoose!.id.toString();
      activityController.getDayWiseData(null, '', catId, subCatId.toString());
    });
  }

  void selectionChangedAPG(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDateAPG =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDateAPG = DateFormat('yyyy-MM-dd').format(
          args.value.endDate ?? args.value.startDate).toString();
    });
  }

  void selectionChangedVPG(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDateVPG =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      _endDateVPG = DateFormat('yyyy-MM-dd').format(
          args.value.endDate ?? args.value.startDate).toString();
    });
  }
}

class ListSelection extends StatefulWidget {
  List<Activity> activity;

  ListSelection(this.activity);

  @override
  _ListSelectionState createState() => _ListSelectionState();
}

class _ListSelectionState extends State<ListSelection> {

  final activityController =
  Get.put(ActivityController());

  final customActivityController =
  Get.put(CustomActivityController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Activities'),
      content: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8.0),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.activity.length,
                      itemBuilder: (_, index) {
                        return CheckboxListTile(
                          title: Text(widget.activity[index].activity
                              .toString()),
                          value: widget.activity[index].isSelected,
                          onChanged: (val) {
                            setState(() {
                              widget.activity[index].isSelected = val!;
                            });
                          },
                        );
                      },
                    ),
                  ]),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
              'Cancel'),
          onPressed:
          _cancel,
        ),
        ElevatedButton(
          child: const Text(
              'Submit'),
          onPressed: () {
            for (var item in widget.activity)
              if (item.isSelected) {
                if (customActivityController.ids.value == '') {
                  customActivityController.ids.value = item.id.toString();
                } else {
                  customActivityController.ids.value =
                      customActivityController.ids.value.toString() + ', ' +
                          item.id.toString();
                }
              }

            activityController.getDayWiseData(
                null, customActivityController.ids.value, '', '');
            print('DATA  :: ' + customActivityController.ids.value.toString());
            Get.back();
          },
        ),
      ],
    );
  }

  void _cancel() {
    Navigator.pop(context);
  }

}