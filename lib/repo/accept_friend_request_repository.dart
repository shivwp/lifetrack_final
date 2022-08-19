import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> acceptFriendRequest(userId) async {
  var map = <String, dynamic>{};
  map['user_id'] = userId;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('acceptfriendrequest', map);

  return ModelCommonResponse.fromJson(response!.data);
}