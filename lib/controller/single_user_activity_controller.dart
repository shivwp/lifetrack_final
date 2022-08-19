import 'package:get/get.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/models/single_user_activity_response.dart';
import 'package:life_track/repo/get_activity_tag_repository.dart';
import 'package:life_track/repo/get_plans_repository.dart';
import 'package:life_track/repo/single_user_activity_repository.dart';

class SingleUserActivityController extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelSingleUserActivitiesResponse> model = ModelSingleUserActivitiesResponse().obs;
  RxBool isDataLoading = false.obs;
  var userId = Get.arguments[0];


  @override
  void onInit() {
    super.onInit();

    print("kxjzhnfcj"+userId.toString());
    getData(userId);


  }
  getData(userId){
    getSingleUserActivity(userId).then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }


}