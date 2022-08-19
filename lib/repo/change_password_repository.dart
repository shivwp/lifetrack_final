
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> changePassword(currentPassword, newPassword) async {
  var map = <String, dynamic>{};
  map['current_password'] = currentPassword;
  map['password'] = newPassword;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('update_password', map);

  return ModelCommonResponse.fromJson(response!.data);
}