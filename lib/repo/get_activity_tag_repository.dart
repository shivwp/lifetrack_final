
import 'package:life_track/models/get_activity_tag_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGetActivityTagResponse> getActivityTags() async {
  print("jdsbhfgb121");
  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('get_activity_tag',);

  print("jdsbhfgb"+response!.data.toString());

  return ModelGetActivityTagResponse.fromJson(response!.data);
}
