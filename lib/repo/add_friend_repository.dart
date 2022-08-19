
import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelAddFriendResponse> addFriends(email) async {
  var map = <String, dynamic>{};
    map['email'] = email;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('addfriends', map);

  return ModelAddFriendResponse.fromJson(response!.data);
}
