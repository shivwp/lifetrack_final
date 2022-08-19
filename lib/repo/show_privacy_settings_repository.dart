
import 'package:life_track/models/add_journal_response.dart';
import 'package:life_track/models/common_response.dart';
import 'package:life_track/models/show_privacy_settings_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelShowPrivacySettings> showPrivacySettings() async {
  var map = <String, dynamic>{};


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('show-privacy-settings', map);

  return ModelShowPrivacySettings.fromJson(response!.data);
}
