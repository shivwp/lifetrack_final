
import 'package:life_track/models/single_friend_detail_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelSingleFriendDetailResponse> getSingleFriendProfile(userId) async {
  var map = <String, dynamic>{};
  map['user_id'] =userId;

  print("lokksdsdsf"+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('singlefriendprofile', map);

  return ModelSingleFriendDetailResponse.fromJson(response!.data);
}
