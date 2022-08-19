
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> updatePrivacySettings(key, value) async {
  var map = <String, dynamic>{};
  map[key] = value;

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('update-privacy-settings', map);

  return ModelCommonResponse.fromJson(response!.data);
}
