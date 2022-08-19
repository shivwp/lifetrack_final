
import 'package:get/get.dart';
import 'package:life_track/models/friend_request_response.dart';
import 'package:life_track/models/show_friends.dart';
import 'package:life_track/repo/friend_request_repository.dart';
import 'package:life_track/repo/get_friend_repository.dart';

class FriendRequestController extends GetxController{

  Rx<ModelFriendRequestResponse> model = ModelFriendRequestResponse().obs;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getFriendsRequsetData();

  }
  getFriendsRequsetData(){
    getFriendRequset().then((value) {
      isDataLoading.value = true;
      return model.value = value;
    });
  }

}