
import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/models/single_group_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelSingleGroupResponse> singleGroupDetail(groupId) async {
  var map = <String, dynamic>{};
  map['group_id'] = groupId;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('single-group', map);

  return ModelSingleGroupResponse.fromJson(response!.data);
}