
import 'package:life_track/models/show_friends.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelShowFriendsResponse> getFriends() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('getfriends',);

  return ModelShowFriendsResponse.fromJson(response!.data);
}
