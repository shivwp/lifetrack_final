import 'dart:convert';

import 'package:life_track/models/daily_monthly_weekly_response.dart';
import 'package:life_track/models/daily_response.dart';
import 'package:life_track/models/login_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';

Future<ModelDailyActivityResponse> weeklyWiseData(userId, category, subCategory) async {

  String userInfoString =
      await SharedPreferenceHelper.getInstance().userInfo ?? '';
  final userInfoModel =
  LoginResponseModel.fromJson(jsonDecode(userInfoString));
  print(userInfoModel.user?.id ?? 0);

  // print(":::::::monthlyWiseData:::userId "+userId.toString());
  var map = <String, dynamic>{};
  if (userId != null){
    map['user_id'] = userInfoModel.user?.id;
  }
  map['category'] = category??'';
  map['sub_category'] = subCategory??'';
  print("<<weeklyWiseData>>>>"+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('weekly-activity-report', map);

  return ModelDailyActivityResponse.fromJson(response!.data);
}

Future<ModelDailyActivityResponse> weeklyWiseData01(userId) async {

  /*String userInfoString =
      await SharedPreferenceHelper.getInstance().userInfo ?? '';
  final userInfoModel =
  LoginResponseModel.fromJson(jsonDecode(userInfoString));
  print(userInfoModel.user?.id ?? 0);
*/
  // print(":::::::monthlyWiseData:::userId "+userId.toString());
  var map = <String, dynamic>{};
  map['user_id'] = userId;

  print("<<>>>>"+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('weekly-activity-report', map);

  return ModelDailyActivityResponse.fromJson(response!.data);
}