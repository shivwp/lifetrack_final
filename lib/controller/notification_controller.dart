import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/get_notification_response.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/models/get_profile_response.dart';
import 'package:life_track/repo/get_activity_tag_repository.dart';
import 'package:life_track/repo/get_plans_repository.dart';
import 'package:life_track/repo/get_profile_repository.dart';
import 'package:life_track/repo/notificatrion_repository.dart';

class GetNotificationController extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelGetNotifications> model = ModelGetNotifications().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }
  getData(){
    EasyLoading.show();
    getNotification().then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      return model.value = value;
    });
  }


}