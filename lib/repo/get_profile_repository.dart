
import 'package:life_track/models/get_profile_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGetProfile> getProfileData() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('get_profile');

  return ModelGetProfile.fromJson(response!.data);
}
