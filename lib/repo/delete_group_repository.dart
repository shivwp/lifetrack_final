
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> deleteGroup(groupId) async {
  var map = <String, dynamic>{};
  map['id'] = groupId;

print("sadfdgfdhdh"+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('deletegroup', map);

  return ModelCommonResponse.fromJson(response!.data);
}