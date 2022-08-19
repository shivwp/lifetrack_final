import 'package:get/get.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/models/get_profile_response.dart';
import 'package:life_track/models/show_privacy_settings_response.dart';
import 'package:life_track/repo/get_activity_tag_repository.dart';
import 'package:life_track/repo/get_plans_repository.dart';
import 'package:life_track/repo/get_profile_repository.dart';
import 'package:life_track/repo/show_privacy_settings_repository.dart';

class PrivacySettingsController extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelShowPrivacySettings> model = ModelShowPrivacySettings().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }
  getData(){
    showPrivacySettings().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }


}