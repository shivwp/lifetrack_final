import 'package:get/get.dart';
import 'package:life_track/models/single_friend_detail_response.dart';
import 'package:life_track/repo/single_friend_profile_repository.dart';

class SingleFriendDetailController extends GetxController{

  Rx<ModelSingleFriendDetailResponse> model = ModelSingleFriendDetailResponse().obs;
  RxBool isDataLoading = false.obs;

  var userId = Get.arguments[0];

  @override
  void onInit() {
    super.onInit();
    // getMonthlyWiseData();
    print("kxjzhnfcj"+userId.toString());
    getData();

  }

getData(){
  getSingleFriendProfile(userId).then((value) {
    isDataLoading.value = true;
    return model.value = value;
  });
}

}