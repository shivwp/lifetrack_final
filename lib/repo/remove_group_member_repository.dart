
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> removeGroupeMember(groupId,userIds) async {

  var map = <String, dynamic>{};
  map['group_id'] = groupId;
  map['user_ids'] = userIds;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('remove-groupe-member', map);

  return ModelCommonResponse.fromJson(response!.data);
}