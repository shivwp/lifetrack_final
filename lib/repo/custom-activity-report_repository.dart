
import 'dart:convert';

import 'package:life_track/models/custom-activity-report_response.dart';
import 'package:life_track/models/login_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';
import 'package:life_track/network/shared_pref/shared_preference_helper.dart';

Future<ModelCustomActivityReportResponse> customActivityReport(userId, activities, startDate, endDate) async {
  String userInfoString =
      await SharedPreferenceHelper.getInstance().userInfo ?? '';
  final userInfoModel =
  LoginResponseModel.fromJson(jsonDecode(userInfoString));
  print(userInfoModel.user?.id ?? 0);

  var map = <String, dynamic>{};
  if (userId != null){
    map['user_id'] = userInfoModel.user?.id;
  }
  map['activities'] = activities ?? '';
  map['start_date'] = startDate?? '';
  map['end_date'] = endDate ?? '';


  print("customActivityReport:::::::"+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('custom-activity-report', map);

  return ModelCustomActivityReportResponse.fromJson(response!.data);
}


Future<ModelCustomActivityReportResponse> customActivityReportAPG(userId, activities, startDate, endDate) async {
  String userInfoString =
      await SharedPreferenceHelper.getInstance().userInfo ?? '';
  final userInfoModel =
  LoginResponseModel.fromJson(jsonDecode(userInfoString));
  print(userInfoModel.user?.id ?? 0);

  var map = <String, dynamic>{};
  if (userId != null){
    map['user_id'] = userInfoModel.user?.id;
  }
  map['activities'] = activities ?? '';
  map['start_date'] = startDate?? '';
  map['end_date'] = endDate ?? '';


  print("customActivityReport:::::::"+map.toString());

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('custom-activity-report', map);

  return ModelCustomActivityReportResponse.fromJson(response!.data);
}
