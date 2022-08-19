
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> userNotificationStatus(notification) async {
  var map = <String, dynamic>{};
  map['notification'] = notification;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('user-notification-status', map);

  return ModelCommonResponse.fromJson(response!.data);
}