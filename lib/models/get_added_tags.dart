import 'package:flutter/material.dart';

import 'get_daily_activity.dart';

class GetAddedTagsResponseModel {
  GetAddedTagsResponseModel({
    required this.status,
    required this.message,
    required this.activity,
  });
  late final bool status;
  late final String? message;
  late final List<AddedActivityModel>? activity;

  GetAddedTagsResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    activity = List.from(json['activity'])
        .map((e) => AddedActivityModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['activity'] = activity?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AddedActivityModel {
  AddedActivityModel({
    required this.id,
    required this.userid,
    required this.activity,
    required this.parentCatgory,
    required this.subCategory,
    required this.starttime,
    required this.endtime,
    required this.selectcolor,
    required this.selectprivacy,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int? id;
  int? activityId = 0;
  late final String? userid;
  String? activity;
  late final int? parentCatgory;
  late final int? subCategory;
  String? starttime;
  String? endtime;
  String? selectcolor;
  late final String? selectprivacy;
  late final String? createdAt;
  late final String? updatedAt;

  AddedActivityModel.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    userid = json?['userid'];
    activity = json?['activity'];
    parentCatgory = json?['parent_catgory'];
    subCategory = json?['sub_category'];
    starttime = json?['starttime'];
    endtime = json?['endtime'];
    selectcolor = json?['selectcolor'];
    selectprivacy = json?['selectprivacy'];
    createdAt = json?['created_at'];
    updatedAt = json?['updated_at'];
  }
  AddedActivityModel.fromTag(Tag? tag, int? tagId, this.activityId) {
    id = tagId;
    activity = tag?.activity;
    selectcolor = tag?.selectcolor;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['userid'] = userid;
    _data['activity'] = activity;
    _data['parent_catgory'] = parentCatgory;
    _data['sub_category'] = subCategory;
    _data['starttime'] = starttime;
    _data['endtime'] = endtime;
    _data['selectcolor'] = selectcolor;
    _data['selectprivacy'] = selectprivacy;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }

  Color getColor() {
    try {
      var n = int.parse(selectcolor ?? '');
      return Color(n);
    } on FormatException {
      return Colors.red;
    }
  }
}
