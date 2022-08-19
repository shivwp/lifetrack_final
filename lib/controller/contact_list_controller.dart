
import 'package:get/get.dart';
import 'package:life_track/models/contact_list_response.dart';
import 'package:life_track/repo/contact_list_repository.dart';

class ContactListController extends GetxController{

  Rx<ModelContactListResponse> model = ModelContactListResponse().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getdaydata();

  }
  getdaydata(){
    contactListData().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}