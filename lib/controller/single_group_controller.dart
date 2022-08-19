import 'package:get/get.dart';
import 'package:life_track/models/single_friend_detail_response.dart';
import 'package:life_track/models/single_group_response.dart';
import 'package:life_track/repo/single_friend_profile_repository.dart';
import 'package:life_track/repo/single_group_repository.dart';

class SingleGroupController extends GetxController{

  Rx<ModelSingleGroupResponse> model = ModelSingleGroupResponse().obs;
  RxBool isDataLoading = false.obs;
  // var groupId= Get.arguments[0];
  var groupId;

  @override
  void onInit() {
    super.onInit();
    // getMonthlyWiseData();
    // getData(groupId);
    groupId= Get.arguments[0];
     getData();

    print(":::::"+groupId.toString());
  }

  getData(){
    singleGroupDetail(groupId).then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}