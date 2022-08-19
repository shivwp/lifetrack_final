import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> updateActivity(activityId, activity) async {
  var map = <String, dynamic>{};
  map['activity_id'] = activityId;
  map['activity'] = activity;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('update-activity', map);

  return ModelCommonResponse.fromJson(response!.data);
}