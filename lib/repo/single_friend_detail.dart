
import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelAddFriendResponse> singleFriendProfile() async {
  var map = <String, dynamic>{};
  map['user_id'] = '151';


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('singlefriendprofile', map);

  return ModelAddFriendResponse.fromJson(response!.data);
}
