import 'package:life_track/models/common_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelCommonResponse> updateUserSubscription(
paymentStatus, planId, amount, paymentId, currencyCode, currencySymbol) async {

  var map = <String, dynamic>{};
  map['payment_status'] = paymentStatus??'';
  map['plan_id'] = planId??'';
  map['amount'] = amount??'';
  map['payment_id'] = paymentId??'';
  map['currency_code'] = currencyCode??'';
  map['currency_symbol'] = currencySymbol??'';
  print("<<updateUserSubscription Map values>>>> "+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('update-user-subscription', map);

  return ModelCommonResponse.fromJson(response!.data);
}