import 'package:life_track/models/add_friends_response.dart';
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> updateTagStatus(tagId) async {
  var map = <String, dynamic>{};
  map['tag_id'] = tagId;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('update-tag-status', map);

  return ModelCommonResponse.fromJson(response!.data);
}