import 'package:get/get.dart';
import 'package:life_track/models/get_feeling_response.dart';
import 'package:life_track/repo/get_feeling_repository.dart';

class GetFillingController extends GetxController{

  Rx<ModelGetFeelingResponse> model = ModelGetFeelingResponse().obs;
  RxBool isDataloading = false.obs;

  @override
  void onInit() {
    super.onInit();


  }
  getData(){
    getFeeling().then((value) {
      isDataloading.value=true;
      model.value= value;
      return null;
    });
  }
}