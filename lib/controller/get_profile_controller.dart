import 'package:get/get.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/models/get_profile_response.dart';
import 'package:life_track/repo/get_activity_tag_repository.dart';
import 'package:life_track/repo/get_plans_repository.dart';
import 'package:life_track/repo/get_profile_repository.dart';

class GetProfileController extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelGetProfile> model = ModelGetProfile().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }
  getData(){
    getProfileData().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }


}