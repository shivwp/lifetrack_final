
import 'package:get/get.dart';
import 'package:life_track/models/show_friends.dart';
import 'package:life_track/repo/get_friend_repository.dart';

class GetFriendsController extends GetxController{

  Rx<ModelShowFriendsResponse> model = ModelShowFriendsResponse().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getFriendsdata();

  }
  getFriendsdata(){
    getFriends().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}