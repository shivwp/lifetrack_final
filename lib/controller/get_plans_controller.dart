import 'package:get/get.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/repo/get_plans_repository.dart';

class GetPlansController extends GetxController{

  // Rx<ModelCommonActivityResponse> model = ModelCommonActivityResponse().obs;
  Rx<ModelGetPlansResponse> model = ModelGetPlansResponse().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }
  getData(){
    getSubscriptionPlans().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }


}