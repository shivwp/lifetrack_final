
import 'package:life_track/models/add_journal_response.dart';
import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> addFilling(reviewMessage) async {
  var map = <String, dynamic>{};
  map['review_massge'] = reviewMessage;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('addfilling', map);

  return ModelCommonResponse.fromJson(response!.data);
}
