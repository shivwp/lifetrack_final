import 'dart:convert';

import 'package:life_track/models/daily_monthly_weekly_response.dart';
import 'package:life_track/models/daily_response.dart';
import 'package:life_track/models/login_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';

Future<ModelDailyActivityResponse> dayWiseData(userId, activities, category, subCategory) async {
  String userInfoString =
      await SharedPreferenceHelper.getInstance().userInfo ?? '';
  final userInfoModel = LoginResponseModel.fromJson(jsonDecode(userInfoString));
  print(userInfoModel.user?.id ?? 0);

  // print(":::::::monthlyWiseData:::userId "+userId.toString());
  var map = <String, dynamic>{};
  // map['user_id'] = userInfoModel.user?.id ?? 0;
  if (userId != null){
    map['user_id'] = userId;
  }
  if (category != null){
    map['category'] = category;
  }
  map['activities'] = activities??'';
  map['category'] = category;
  map['sub_category'] = subCategory??'';

  print("<<dayWiseData>>>>" + jsonEncode(map).toString());

  ApiResponse<dynamic>? response =
      await ApiBaseHelper.getInstance().post('daily-activity-report', map);
  print("<<>>>>" + response!.data.toString());

  return ModelDailyActivityResponse.fromJson(response!.data);
}

Future<ModelDailyActivityResponse> categoryDayWiseData(userId, type) async {
  String userInfoString =
      await SharedPreferenceHelper.getInstance().userInfo ?? '';
  final userInfoModel = LoginResponseModel.fromJson(jsonDecode(userInfoString));
  print(userInfoModel.user?.id ?? 0);

  // print(":::::::monthlyWiseData:::userId "+userId.toString());
  var map = <String, dynamic>{};
  // map['user_id'] = userInfoModel.user?.id ?? 0;
  if (userId != null){
    map['user_id'] = userId;
  }
  map['type'] = type??'';
  print("<<>>>>category" + jsonEncode(map).toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('category-based-activity-report', map);
  print("<<>>>>" + response!.data.toString());

  return ModelDailyActivityResponse.fromJson(response!.data);
}

Future<ModelDailyActivityResponse> dayWiseData01(userId) async {
  var map = <String, dynamic>{};
  // map['user_id'] = userInfoModel.user?.id ?? 0;
  map['user_id'] = userId;

  print("<<>>>>" + map.toString());

  ApiResponse<dynamic>? response =
      await ApiBaseHelper.getInstance().post('daily-activity-report', map);

  print("<<>response>>>" + response.toString());

  return ModelDailyActivityResponse.fromJson(response!.data);
}

