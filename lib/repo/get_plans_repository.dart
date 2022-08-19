
import 'package:life_track/models/add_journal_response.dart';
import 'package:life_track/models/get_plans_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGetPlansResponse> getSubscriptionPlans() async {
  var map = <String, dynamic>{};

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('plans', map);

  return ModelGetPlansResponse.fromJson(response!.data);
}
