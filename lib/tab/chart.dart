import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:life_track/Contants/appcolors.dart';
import 'package:life_track/controller/activity_controller.dart';
import 'package:life_track/controller/custom-activity-report_controller.dart';
import 'package:life_track/controller/get_activity_tag_controller.dart';
import 'package:life_track/models/categorylist_response.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/subcategorylist_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Contants/constant.dart';
import '../components/background_gradient_container.dart';
import 'chart_helper/outside_label.dart';
import 'chart_helper/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


enum ChartDisplayType { daily, weekly, monthly, all }

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {

  final ActivityController controller = Get.put(ActivityController());
  final GetActivityTagsController getActivityTagsController = Get.put(
      GetActivityTagsController());
  final CustomActivityController customActivityController = Get.put(
      CustomActivityController());


  StackedBarChart? _barChart; // = StackedBarChart.withRandomData();
  PieOutsideLabelChart? _pieChart; // = PieOutsideLabelChart.withRandomData();
  ChartDisplayType chartDisplayType = ChartDisplayType.daily;

  List<SalesData>? _chartData;

  // Activity? dropDownActualProgression;
  Activity? dropDownVarianceProgression;
  String? dropDownValue;
  CategoryListModel? _categoryChoose;
  List<CategoryListModel> categoryDataList = [];
  SubcategoryListModel? _subcategoryChoose;
  List<SubcategoryListModel> totalSubCategoryDataList = [];
  List<SubcategoryListModel> subcategoryDataList = [];

  // DateTimeRange? _selectedDateRange;
  var catId;
  var subCatId;
  var varianceSelectedActivity;
  String? _startDate, _endDate;
  String? _startDateVPG, _endDateVPG;
  String? _startDateAPG, _endDateAPG;

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
    controller.getDayWiseData(null, '', null, '');
    controller.getCategoryDayWiseData(null, 'daily');
    // _chartData = getLineChartData()!;
    super.initState();


    getActivityTagsController.getData();
    customActivityController.getCustomActivityReport(null, '', '', '');
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

    return BackgroundGradientContainer(
      child: SingleChildScrollView(
        child: Obx(() {
          return controller.isDataLoading.value
              ? controller.model.value.data == null ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text('No data found')),
            ],
          ) : Charts(deviceHeight, deviceWidth, context)
              : Center(child: CircularProgressIndicator());
        }),
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
                        print("main dropDownValue " + dropDownValue.toString());
                        // start code to delete clear multiple activity List from APG Graph
                        customActivityController.multipleActivity.clear();
                        // End code to delete clear multiple activity List from APG Graph
                        controller.getDayWiseData(null, '', null, '');
                      }
                      else if (dropDownValue == 'Category') {
                        print("working Category");
                        controller.getCategoryDayWiseData(null, 'daily');
                      }
                      else if (dropDownValue == 'Sub-category') {
                        print("working Sub-category" + catId.toString() + ";;" +
                            subCatId.toString());
                        controller.getDayWiseData(null, '', catId, subCatId);
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
                            _onDropDownSubCategorySelected(newSelected);
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
                            customActivityController.getCustomActivityReport('', '', '', '');
                            customActivityController.getCustomActivityReportAPG(null, null, null, null);
                          } else if (dropDownValue == 'Category') {
                            controller.getCategoryDayWiseData(null, 'day');
                          } else if (dropDownValue == 'Sub-category') {
                            controller.getDayWiseData(
                                null, '', catId, subCatId);
                            print('work=> ' + catId.toString() + "ljkfkdjf=>" +
                                subCatId.toString());
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
                            width: chartDisplayType == ChartDisplayType.daily
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
                            controller.getWeeklyWiseData(null, '', '');
                          } else if (dropDownValue == 'Category') {
                            controller.getCategoryDayWiseData(null, 'weekly');
                          } else if (dropDownValue == 'Sub-category') {
                            controller.getWeeklyWiseData(null, catId, subCatId);
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
                            controller.getMonthlyWiseData(null, '', '');
                            controller.getMonthlyWiseData(null, '', '');
                          } else if (dropDownValue == 'Category') {
                            controller.getCategoryDayWiseData(null, 'monthly');
                          } else if (dropDownValue == 'Sub-category') {
                            controller.getMonthlyWiseData(
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
                  return controller.model.value.data == null ? Center(
                      child: Text('no data found')) : Column(
                    children: [
                      //Budgeted data chart
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
                              //       controller.model.value.data!.budgetedData.length; i++) {
                              //     chartDataBudget.value.add(ChartData(
                              //         controller.model.value.data!.budgetedData[i].time,
                              //         double.parse(
                              //             controller.model.value.data!.budgetedData[i].time)
                              //             .toInt(),
                              //         controller.model.value.data!.budgetedData[i].getColor()));
                              //   }
                              //   chartUpdate.value = false;
                              // }
                              return SfCircularChart(
                                  onTooltipRender: (TooltipArgs args) {
                                    args.text = args.text;
                                  },
                                  tooltipBehavior: _tooltipBehavior1,
                                  palette: <Color>[
                                    Colors.amber,
                                    Colors.brown,
                                    Colors.green,
                                    Colors.redAccent,
                                    Colors.blueAccent,
                                    Colors.teal
                                  ],
                                  // onSelectionChanged: (model) {
                                  //   controller.chartDataBudget.value =
                                  //   model as List<ChartData>;
                                  // },
                                  onDataLabelTapped: (value) {
                                    print('VALUE11 :: ' + value.toString());
                                  },
                                  series: <CircularSeries<ChartData, String>>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                      dataSource: controller.chartDataBudget.value,
                                      pointColorMapper: (ChartData data, _) => data.color,
                                      xValueMapper: (ChartData data, _) => data.label,
                                      yValueMapper: (ChartData data, _) => data.sales,
                                      dataLabelSettings: DataLabelSettings(isVisible: true),
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
                            //     itemCount: controller.model.value.data!
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
                            //         color: controller.model.value
                            //             .data!.budgetedData[index]
                            //             .getColor(),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment
                            //               .center,
                            //           children: [
                            //             Expanded(
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //                 child: Text(controller.model
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
                      //Actual data Chart
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
                                  tooltipBehavior: _tooltipBehavior,
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
                                  // onSelectionChanged: (model) {
                                  //   controller.chartDataActual.value =
                                  //   model as List<ChartData>;
                                  // },
                                  series: <
                                      CircularSeries<ChartData, String>>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                      dataSource: controller.chartDataActual.value,
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
                                        print('VALUE :: 22' + (value.viewportPointIndex).toString());
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
                            //     itemCount: controller.model.value.data!
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
                            //         color: controller.model.value
                            //             .data!.actualData[index]
                            //             .getColor(),
                            //         child: Row(
                            //           mainAxisAlignment: MainAxisAlignment
                            //               .center,
                            //           children: [
                            //             Expanded(
                            //               child: Padding(
                            //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            //                 child: Text(controller.model
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
                      //Variance data Chart
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
                                      majorGridLines: MajorGridLines(width: 0),
                                      minorGridLines: MinorGridLines(width: 0),
                                      labelStyle: TextStyle(color: Colors.white)
                                  ),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: MajorGridLines(width: 0),
                                    minorGridLines: MinorGridLines(width: 0),
                                    labelStyle: TextStyle(color: Colors.white,),),
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
                                      dataSource: controller.dataEntriesBarChart.value,
                                      // Renders the track
                                      // isTrackVisible: true,
                                      xValueMapper: (ChartData data, _) => data.label,
                                      yValueMapper: (ChartData data, _) => data.sales,
                                      dataLabelMapper: (ChartData sales, _) => sales.label.toString(),
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
                            //           controller.dataEntriesBarChart),
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
                      // Variance  Progression Graph
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
                                            dropDownVarianceProgression!.activity, style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                          ),
                                          items: getActivityTagsController.model.value.activity?.map((
                                              Activity value) {
                                            return DropdownMenuItem<Activity>(
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
                                                        Navigator.pop(context);
                                                        customActivityController
                                                            .getCustomActivityReport(
                                                            null,
                                                            varianceSelectedActivity,
                                                            '${_startDateVPG}',
                                                            '${_endDateVPG}');
                                                      },
                                                      onCancel: () {
                                                        Navigator.pop(context);
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
                                            borderRadius: BorderRadius.circular(
                                                4)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              "Start date: ${_startDateVPG}""" +
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
                                  onDataLabelTapped: (value) {
                                    print('VALUE onDataLabelTappedVPG:: ' + value.text.toString());
                                  },
                                  tooltipBehavior: _tooltipBehavior3,

                                  palette: <Color>[
                                    Colors.amber,
                                    Colors.brown,
                                    Colors.green,
                                    Colors.blueAccent.shade700,
                                    Colors.blueAccent.shade100,
                                    Colors.teal
                                  ],

                                  primaryXAxis: NumericAxis(
                                      majorGridLines: MajorGridLines(width: 0),
                                      minorGridLines: MinorGridLines(width: 0),
                                      labelStyle: TextStyle(
                                        color: Colors.white,
                                        decorationColor: Colors.white,
                                      ),
                                      edgeLabelPlacement: EdgeLabelPlacement.shift),
                                  primaryYAxis: NumericAxis(
                                    majorGridLines: MajorGridLines(width: 0),
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
                                      dataSource: customActivityController.dataEntriesBarlineActual.value,
                                      pointColorMapper: (SalesData sales, _) => sales.color,
                                      xValueMapper: (SalesData sales, _) => sales.label,
                                      yValueMapper: (SalesData sales, _) => sales.sales,
                                      dataLabelSettings: DataLabelSettings(
                                          useSeriesColor: true,
                                          color: Colors.white,
                                          textStyle: TextStyle(fontSize: 10),
                                          angle: 45,
                                          offset: Offset(2, 2),
                                          isVisible: true),
                                      enableTooltip: true,
                                      emptyPointSettings: EmptyPointSettings(
                                          mode: EmptyPointMode.average),
                                      dataLabelMapper: (SalesData sales, _) => sales.title.toString(),
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
                      //Actual Progression Graph
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
                                         print("lkojjdhhhh");

                                        // print('LIST LENGTH :: '+getActivityTagsController.model.value.activity![0].toString());

                                        // Get.defaultDialog(
                                        //   title: "GeeksforGeeks",
                                        //   middleText: "Hello world!",
                                        //   backgroundColor: Colors.green,
                                        // titleStyle: TextStyle(color: Colors.white),
                                        // middleTextStyle: TextStyle(color: Colors.white),
                                        // content: ListSelection(getActivityTagsController.model.value.activity!)
                                        // );
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ListSelection(getActivityTagsController.model.value.activity!);
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
                                        child: Obx(() {
                                          // Start Code to comma seperated multiple activity
                                          var activityNames = '';
                                          for (var item in customActivityController.multipleActivity){
                                            if (activityNames == ''){
                                              activityNames = item;
                                            } else {
                                              activityNames = activityNames + ',' + item;
                                            }
                                          }
                                          //End  Code to comma seperated multiple activity
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                                customActivityController.multipleActivity.value.isEmpty
                                                    ? 'Select Activitys'
                                                    : activityNames.toString()
                                                    .toString(),textScaleFactor: 1.0,),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
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
                                                      Navigator.pop(context);
                                                      print("{_startDateAPG??:::::${_startDateAPG ?? ''}");
                                                      print("{_endDateAPG??:::::${_endDateAPG ?? ''}");

                                                      // Start Code to comma seperated multiple activity
                                                      var activityNames = '';
                                                      for (var item in customActivityController.multipleActivity){
                                                        if (activityNames == ''){
                                                          activityNames = item;
                                                        } else {
                                                          activityNames = activityNames + ',' + item;
                                                        }
                                                      }
                                                      //End  Code to comma seperated multiple activity
                                                      print('activityName multiple '+activityNames.toString());
                                                      customActivityController.getCustomActivityReportAPG(
                                                          null,
                                                          customActivityController.ids.toString(),
                                                          '${_startDateAPG ?? ''}',
                                                          '${_endDateAPG ?? ''}');
                                                    },
                                                    onCancel: () {
                                                      Navigator.pop(context);
                                                    },
                                                    selectionMode: DateRangePickerSelectionMode.range,
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
                                      majorGridLines: MajorGridLines(width: 0),
                                      minorGridLines: MinorGridLines(width: 0),
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

  // This function will be triggered when the floating button is pressed
  // void _show() async {
  //   final DateTimeRange? result = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(2022, 1, 1),
  //     lastDate: DateTime.now(),
  //     currentDate: DateTime.now(),
  //     saveText: 'Done',
  //
  //   );
  //
  //   if (result != null) {
  //     // Rebuild the UI
  //     print(result.start.toString());
  //     setState(() {
  //       _selectedDateRange = result;
  //     });
  //   }
  // }

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
      controller.getDayWiseData(null, '', catId,
          subcategoryDataList.isEmpty ? null : subcategoryDataList[0].id
              .toString());
    });
  }

  void _onDropDownSubCategorySelected(
      SubcategoryListModel? subcategoryListModel) {
    setState(() {
      _subcategoryChoose = subcategoryListModel;
      subCatId = _subcategoryChoose!.id.toString();
      controller.getDayWiseData(null, '', catId, subCatId.toString());
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

  final activityController = Get.put(ActivityController());
  final customActivityController = Get.put(CustomActivityController());

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: widget.activity.length,
                  itemBuilder: (_, index) {
                    return CheckboxListTile(
                      title: Text(widget.activity[index].activity.toString()),
                      value: widget.activity[index].isSelected,
                      onChanged: (val) {
                        setState(() {
                          widget.activity[index].isSelected = val!;

                          // start , Code to see multiple Activities on APG Graphs
                          if(widget.activity[index].isSelected==true){
                            if(customActivityController.multipleActivity.contains(widget.activity[index].activity.toString())){
                              customActivityController.multipleActivity.remove(widget.activity[index].activity.toString());
                            }else{
                              customActivityController.multipleActivity.add(widget.activity[index].activity.toString());
                            }
                          }else{
                            if(customActivityController.multipleActivity.contains(widget.activity[index].activity.toString())){
                              customActivityController.multipleActivity.remove(widget.activity[index].activity.toString());
                            }else{
                              customActivityController.multipleActivity.add(widget.activity[index].activity.toString());

                            }
                          }
                        });
                      },
                    );
                  },
                ),
              )
             /* Expanded(
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(8.0),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
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
              )*/,
            ],
          ),
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
            customActivityController.ids.value = '';
            for (var item in widget.activity)
              if (item.isSelected==true) {
                if (customActivityController.ids.value == '') {
                  customActivityController.ids.value = item.id.toString();
                }
                else {
                  customActivityController.ids.value = customActivityController.ids.value.toString() + ', ' + item.id.toString();
                }
              }

            print('DATA  :12121: ' + customActivityController.ids.value.toString());
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

class ChartData {
  String label;
  dynamic sales;
  Color color;

  ChartData(this.label, this.sales, this.color);
}

/*class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}*/

class SalesData {
  int? label;
  String title;
  dynamic sales;
  Color color;

  SalesData(this.label, this.title, this.sales, this.color);
}

