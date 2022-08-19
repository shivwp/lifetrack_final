import 'package:get/get.dart';
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/repo/get_activity_tag_repository.dart';
import 'package:life_track/repo/get_plans_repository.dart';

class GetActivityTagsController extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelGetActivityTagResponse> model = ModelGetActivityTagResponse().obs;
  RxBool isDataLoading = false.obs;
  var ids;
  @override
  void onInit() {
    super.onInit();
    getData();
  }
  getData(){
    getActivityTags().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }


}