
import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/models/create_group_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCreateGroupResponse> createGroup(groupName, descrption, List<String> userChecked ) async {
  var userIds = '';
  for (var item in userChecked){
    if (userIds == ''){
      userIds = item;
    } else {
    userIds = userIds + ',' + item;
    }
  }

  var map = <String, dynamic>{};
  map['groupname'] = groupName;
  // map['id'] = id;
  map['descrption'] = descrption;
  map['user_ids'] = userIds;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('creategroup', map);

  return ModelCreateGroupResponse.fromJson(response!.data);
}



Future<ModelCreateGroupResponse> editGroup(groupName, groupId, descrption, List<String> userChecked ) async {
  var userIds = '';
  for (var item in userChecked){
    if (userIds == ''){
      userIds = item;
    } else {
      userIds = userIds + ',' + item;
    }
  }

  var map = <String, dynamic>{};
  map['groupname'] = groupName;
   map['id'] = groupId;
  map['descrption'] = descrption;
  map['user_ids'] = userIds;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('creategroup', map);

  return ModelCreateGroupResponse.fromJson(response!.data);
}