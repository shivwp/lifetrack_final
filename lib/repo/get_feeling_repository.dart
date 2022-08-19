
import 'package:life_track/models/contact_list_response.dart';
import 'package:life_track/models/get_feeling_response.dart';
import 'package:life_track/models/show_friends.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGetFeelingResponse> getFeeling() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('getfilling',);

  return ModelGetFeelingResponse.fromJson(response!.data);
}
