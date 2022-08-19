
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/models/single_user_activity_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelSingleUserActivitiesResponse> getSingleUserActivity(userId) async {
  var map = <String, dynamic>{};
  map['user_id'] =userId;

  print("getSingleUserActivity:::"+map.toString());
  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('get-single-user-activities',map);

  return ModelSingleUserActivitiesResponse.fromJson(response!.data);
}
