
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> addGroupMember(groupId,List<String> userChecked) async {
  var userIds = '';
  for (var item in userChecked){
    if (userIds == ''){
      userIds = item;
    } else {
      userIds = userIds + ',' + item;
    }
  }

  var map = <String, dynamic>{};
  map['group_id'] = groupId;
  map['user_ids'] = userIds;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('addcontactlist', map);

  return ModelCommonResponse.fromJson(response!.data);
}