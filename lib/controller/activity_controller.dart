import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:life_track/models/daily_response.dart';
import 'package:life_track/repo/daywise_activity_repository.dart';
import 'package:life_track/repo/monthly_activity_response.dart';
import 'package:life_track/repo/weekly_activity_response.dart';
import 'package:life_track/tab/chart.dart';

import '../tab/chart_helper/stacked.dart';

class ActivityController extends GetxController {
  Rx<ModelDailyActivityResponse> model = ModelDailyActivityResponse().obs;
  RxBool isDataLoading = false.obs;

  RxString ids = ''.obs;


  var chartDataBudget = RxList<ChartData>.empty(growable: true);
  var chartDataActual = RxList<ChartData>.empty(growable: true);
  // var dataEntriesBarChart = RxList<BarCharModel>.empty(growable: true);
  var dataEntriesBarChart = RxList<ChartData>.empty(growable: true);
  var dataEntriesBarLineVariance = RxList<SalesData>.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    getDayWiseData(null, '', null, '');
    getCategoryDayWiseData(null,'daily');
  }

  getCategoryDayWiseData(userId, type) {
    EasyLoading.show();
    categoryDayWiseData(userId, type).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      updateChart(value);
      return model.value = value;
    });
  }

  getDayWiseData(userId, activities, category, subCategory) {
    EasyLoading.show();
    dayWiseData(userId, activities, category, subCategory).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      updateChart(value);
      return model.value = value;
    });
  }

  getMonthlyWiseData(userId, category, subCategory) {
    EasyLoading.show();
    monthlyWiseData(userId, category, subCategory).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      updateChart(value);
      return model.value = value;
    });
  }

  getWeeklyWiseData(userId, category, subCategory) {
    EasyLoading.show();
    weeklyWiseData(userId, category, subCategory).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      updateChart(value);
      return model.value = value;
    });
  }

  void updateChart(ModelDailyActivityResponse value) {
    chartDataBudget.clear();
    for (var i = 0; i < value.data!.budgetedData.length; i++) {
      chartDataBudget.value.add(ChartData(
          value.data!.budgetedData[i].title+'('+value.data!.budgetedData[i].time+')',
          double.parse(value.data!.budgetedData[i].time).toInt(),
          value.data!.budgetedData[i].getColor()));
    }

    chartDataActual.clear();
    for (var i = 0; i < value.data!.actualData.length; i++) {
      chartDataActual.value.add(ChartData(
          value.data!.actualData[i].title+'('+value.data!.actualData[i].time+')',
          double.parse(value.data!.actualData[i].time).toInt(),
          value.data!.actualData[i].getColor()));
    }

    dataEntriesBarChart.clear();
    for (var k = 0; k < value.data!.barChat.length; k++) {
      dataEntriesBarChart.value.add(ChartData(
           value.data!.barChat[k].title.toString(),
          double.parse(value.data!.barChat[k].budgetedTime),
          value.data!.actualData[k].getColor()
      ));
    }
    /*dataEntriesBarChart.clear();
    for (var k = 0; k < value.data!.barChat.length; k++) {
      dataEntriesBarChart.add(BarCharModel(
          xAxisUnits: value.data!.barChat[k].title.toString(),
          yAxisUnits:
              double.parse(value.data!.barChat[k].budgetedTime.toString())
                  .toInt()));
    }*/

    dataEntriesBarLineVariance.clear();
    for (var m = 0; m < value.data!.barChat.length; m++) {
          dataEntriesBarLineVariance.add(SalesData(m,
           value.data!.barChat[m].title.toString(),
            double.parse(value.data!.barChat[m]
                .budgetedTime.toString()).toInt(),
           value.data!.barChat[m].getColor(),
          ));
        }
  }
}
