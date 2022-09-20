import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_track/Contants/constant.dart';

import 'get_added_tags.dart';

class GetDailyActivityModel {
  GetDailyActivityModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool? status;
  late final String? message;
  late final DailyActivityDataModel? data;

  GetDailyActivityModel.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    message = json?['message'];
    if (json?['data'] != null) {
      data = DailyActivityDataModel.fromJson(json?['data']);
    } else {
      data = DailyActivityDataModel.fromJson(json?['activity']);
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class DailyActivityDataModel {
  DailyActivityDataModel({
    required this.bugeted,
    required this.actual,
  });
  List<Bugeted>? bugeted;
  List<Actual>? actual;

  DailyActivityDataModel.fromJson(Map<String, dynamic>? json) {
    bugeted = List.from(json?['bugeted'] ?? [])
        .map((e) => Bugeted.fromJson(e))
        .toList();
    bugeted?.sort((first, second) {
      return (first.startDateTime ?? DateTime.now())
          .compareTo(second.startDateTime ?? DateTime.now());
    });
    actual = List.from(json?['actual'] ?? [])
        .map((e) => Actual.fromJson(e))
        .toList();
    actual?.sort((first, second) {
      return (first.startDateTime ?? DateTime.now())
          .compareTo(second.startDateTime ?? DateTime.now());
    });
  }
  DailyActivityDataModel.fromTag(AddedActivityModel addedActivityModel) {
    bugeted = [Bugeted.fromTag(addedActivityModel)];
    actual = [Actual.fromTag(addedActivityModel)];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bugeted'] = bugeted?.map((e) => e.toJson()).toList();
    _data['actual'] = actual?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Bugeted {
  Bugeted({
    required this.id,
    required this.userId,
    required this.tagId,
    required this.date,
    required this.budgetedStartTime,
    required this.budgetEndTime,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.status,
    required this.tag,
  });
  int? id;
  late final int? userId;
  int? tagId;
  late final String? date;
  String? budgetedStartTime;
  String? budgetEndTime;
  String? actualStartTime;
  String? actualEndTime;
  late final int? status;
  Tag? tag;
  DateTime? startDateTime;
  DateTime? endDateTime;

  Bugeted.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    userId = json?['user_id'];
    tagId = json?['tag_id'];
    date = json?['date'];
    budgetedStartTime = json?['budgeted_start_time'];
    budgetEndTime = json?['budget_end_time'];
    actualStartTime = json?['actual_start_time'];
    actualEndTime = json?['actual_end_time'];
    status = json?['status'];
    tag = Tag.fromJson(json?['tag']);
    startDateTime = hrMinDF.parse(budgetedStartTime!);
    endDateTime = hrMinDF.parse(budgetEndTime!);
  }
  Bugeted.fromTag(AddedActivityModel addedActivityModel) {
    id = null;
    tagId = addedActivityModel.id;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now); //2022-05-25
    date = formattedDate;
    budgetedStartTime = addedActivityModel.starttime;
    budgetEndTime = addedActivityModel.endtime;
    actualStartTime = addedActivityModel.starttime;
    actualEndTime = addedActivityModel.endtime;
  }
  Map<String, dynamic> toJson() {
    /*
       {
                "id": 204,
                "tag_id": 84,
                "date": "2022-05-25",
                "budgeted_start_time": "20:00",
                "budget_end_time": "21:30",
                "actual_start_time": "20:00",
                "actual_end_time": "21:30"
        }
    * */
    final _data = <String, dynamic>{};
    if (id != null) {
      _data['id'] = id;
    }
    //_data['user_id'] = userId;
    _data['tag_id'] = tagId;
    _data['date'] = date;
    if (endDateTime != null) {
      DateFormat df = DateFormat('HH:mm');
      if (endDateTime!.isAtSameMomentAs(DateTime(endDateTime!.year,
          endDateTime!.month, endDateTime!.day - 1, 24, 0))) {
        //if Model end date is 00:00 then we need to update it's day to next day
        endDateTime = DateTime(
            endDateTime!.year, endDateTime!.month, endDateTime!.day, 23, 59);
      }
      budgetEndTime = df.format(endDateTime ?? DateTime.now());
      actualEndTime = df.format(endDateTime ?? DateTime.now());
    } else {
      if ((budgetEndTime ?? "") == "00:00") {
        budgetEndTime = '23:59';
      }
      if ((actualEndTime ?? "") == "00:00") {
        actualEndTime = '23:59';
      }
    }
    _data['budgeted_start_time'] = budgetedStartTime;
    _data['budget_end_time'] = budgetEndTime;
    _data['actual_start_time'] = actualStartTime;
    _data['actual_end_time'] = actualEndTime;
    //_data['status'] = status;
    //_data['tag'] = tag?.toJson();
    return _data;
  }
}

class Tag {
  Tag({
    required this.activity,
    required this.parentCatgory,
    required this.subCategory,
    required this.starttime,
    required this.endtime,
    required this.selectcolor,
    required this.selectprivacy,
  });
  String? activity;
  int? parentCatgory;
  int? subCategory;
  String? starttime;
  String? endtime;
  String? selectcolor;
  String? selectprivacy;

  Tag.fromJson(Map<String, dynamic>? json) {
    activity = json?['activity'];
    parentCatgory = json?['parent_catgory'];
    subCategory = json?['sub_category'];
    starttime = json?['starttime'];
    endtime = json?['endtime'];
    selectcolor = json?['selectcolor'];
    selectprivacy = json?['selectprivacy'];
  }
  Tag.fromTag(AddedActivityModel addedActivityModel) {
    activity = addedActivityModel.activity;
    //parentCatgory = addedActivityModel.parentCatgory;
    //subCategory = addedActivityModel.subCategory;
    selectcolor = addedActivityModel.selectcolor;
    //selectprivacy = addedActivityModel.selectprivacy;
    if (addedActivityModel.starttime != null) {
      starttime = addedActivityModel.starttime;
    }
    if (addedActivityModel.endtime != null) {
      endtime = addedActivityModel.endtime;
    }
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['activity'] = activity;
    _data['parent_catgory'] = parentCatgory;
    _data['sub_category'] = subCategory;
    _data['starttime'] = starttime;
    _data['endtime'] = endtime;
    _data['selectcolor'] = selectcolor;
    _data['selectprivacy'] = selectprivacy;
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

class Actual {
  Actual({
    required this.id,
    required this.userId,
    required this.tagId,
    required this.date,
    required this.budgetedStartTime,
    required this.budgetEndTime,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.status,
    required this.tag,
  });
  int? id;
  late final int? userId;
  int? tagId;
  late final String? date;
  String? budgetedStartTime;
  String? budgetEndTime;
  String? actualStartTime;
  String? actualEndTime;
  late final int? status;
  Tag? tag;
  DateTime? startDateTime;
  DateTime? endDateTime;

  Actual.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    userId = json?['user_id'];
    tagId = json?['tag_id'];
    date = json?['date'];
    budgetedStartTime = json?['budgeted_start_time'];
    budgetEndTime = json?['budget_end_time'];
    actualStartTime = json?['actual_start_time'];
    actualEndTime = json?['actual_end_time'];
    status = json?['status'];
    tag = Tag.fromJson(json?['tag']);
    startDateTime = hrMinDF.parse(actualStartTime!);
    endDateTime = hrMinDF.parse(actualEndTime!);
  }

  Actual.fromTag(AddedActivityModel addedActivityModel) {
    tagId = addedActivityModel.id;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now); //2022-05-25
    date = formattedDate;
    budgetedStartTime = addedActivityModel.starttime;
    budgetEndTime = addedActivityModel.endtime;
    actualStartTime = addedActivityModel.starttime;
    actualEndTime = addedActivityModel.endtime;
  }
  Map<String, dynamic> toJson() {
    /*
       {
                "id": 204,
                "tag_id": 84,
                "date": "2022-05-25",
                "budgeted_start_time": "20:00",
                "budget_end_time": "21:30",
                "actual_start_time": "20:00",
                "actual_end_time": "21:30"
        }
    * */
    final _data = <String, dynamic>{};
    if (id != null) {
      _data['id'] = id;
    }
    //_data['user_id'] = userId;
    _data['tag_id'] = tagId;
    _data['date'] = date;
    if (endDateTime != null) {
      DateFormat df = DateFormat('HH:mm');
      if (endDateTime!.isAtSameMomentAs(DateTime(endDateTime!.year,
          endDateTime!.month, endDateTime!.day - 1, 24, 0))) {
        //if Model end date is 00:00 then we need to update it's day to next day
        endDateTime = DateTime(
            endDateTime!.year, endDateTime!.month, endDateTime!.day, 23, 59);
      }
      //budgetEndTime = df.format(endDateTime ?? DateTime.now());
      actualEndTime = df.format(endDateTime ?? DateTime.now());
    } else {
      if ((budgetEndTime ?? "") == "00:00") {
        budgetEndTime = '23:59';
      }
      if ((actualEndTime ?? "") == "00:00") {
        actualEndTime = '23:59';
      }
    }
    _data['budgeted_start_time'] = budgetedStartTime;
    _data['budget_end_time'] = budgetEndTime;
    _data['actual_start_time'] = actualStartTime;
    _data['actual_end_time'] = actualEndTime;
    //_data['status'] = status;
    //_data['tag'] = tag?.toJson();
    return _data;
  }
}
