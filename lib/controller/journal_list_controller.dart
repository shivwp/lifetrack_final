import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:life_track/models/get_journal_response.dart';
import 'package:life_track/repo/get_journal_repository.dart';

class JournalListController extends GetxController{

  Rx<ModelGetJournalResponse> model = ModelGetJournalResponse().obs;
  RxBool isDataLoading = false.obs;
  var date;
  selectD(){
  if(Get.arguments[0] !=null){
    print("argumentsTrue"+Get.arguments[0].toString());
    date = Get.arguments[0];
  }else{
    date = "";
    print("argumentsfalse"+Get.arguments[0].toString());
  }}
  @override
  void onInit() {
    super.onInit();
    getdata();

  }
  getdata(){
    EasyLoading.show();
    getJournalData(date).then((value) {
      EasyLoading.dismiss();
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}