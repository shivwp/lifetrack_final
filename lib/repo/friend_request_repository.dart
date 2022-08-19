
import 'package:life_track/models/friend_request_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelFriendRequestResponse> getFriendRequset() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('myfriendrequest',);

  return ModelFriendRequestResponse.fromJson(response!.data);
}
