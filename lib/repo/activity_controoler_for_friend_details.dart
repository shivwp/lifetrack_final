import 'package:get/get.dart';
import 'package:life_track/models/daily_monthly_weekly_response.dart';
import 'package:life_track/models/daily_response.dart';
import 'package:life_track/repo/daywise_activity_repository.dart';
import 'package:life_track/repo/monthly_activity_response.dart';
import 'package:life_track/repo/weekly_activity_response.dart';

class ActivityController01 extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelDailyActivityResponse> model = ModelDailyActivityResponse().obs;
  RxBool isDataLoading = false.obs;

  var userId = Get.arguments[0];

  @override
  void onInit() {
    super.onInit();
    print("kdjjkasfhjdf"+userId.toString());
    getDayWiseData();
  }
  getDayWiseData(){
    dayWiseData01(userId).then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

  getMonthlyWiseData(){
    monthlyWiseData01(userId).then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

  getWeeklyWiseData(){
    weeklyWiseData01(userId).then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}