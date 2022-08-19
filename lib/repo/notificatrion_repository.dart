
import 'package:life_track/models/get_notification_response.dart';
import 'package:life_track/models/get_profile_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGetNotifications> getNotification() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('shownotications');

  return ModelGetNotifications.fromJson(response!.data);
}
