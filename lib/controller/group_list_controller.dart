import 'package:get/get.dart';
import 'package:life_track/models/group_list_response.dart';
import 'package:life_track/repo/get_group_repository.dart';

class GroupListController extends GetxController{

  Rx<ModelGroupListResponse> model = ModelGroupListResponse().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    showGroupsData();
  }
  showGroupsData(){
    showGroups().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}