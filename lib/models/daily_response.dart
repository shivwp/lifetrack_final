import 'dart:ui';

import 'package:flutter/material.dart';

class ModelDailyActivityResponse {
  ModelDailyActivityResponse({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  Data? data;

  ModelDailyActivityResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = json['data'] == null ? null : Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.budgetedData,
    required this.actualData,
    required this.barChat,
  });
  late final List<BudgetedData> budgetedData;
  late final List<ActualData> actualData;
  late final List<dynamic> barChat;

  Data.fromJson(Map<String, dynamic> json){
    budgetedData = List.from(json['budgeted_data']).map((e)=>BudgetedData.fromJson(e)).toList();
    actualData = List.from(json['actual_data']).map((e)=>ActualData.fromJson(e)).toList();
    barChat = List.from(json['bar_chat']).map((e)=>BarChat.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['budgeted_data'] = budgetedData.map((e)=>e.toJson()).toList();
    _data['actual_data'] = actualData.map((e)=>e.toJson()).toList();
    _data['bar_chat'] = barChat.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class BudgetedData {
  BudgetedData({
    required this.title,
    required this.time,
    required this.color,
  });
  late final String title;
  late final String time;
  late final String color;

  BudgetedData.fromJson(Map<String, dynamic> json){
    title = json['title'];
    time = json['time'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['time'] = time;
    _data['color'] = color;
    return _data;
  }
  Color getColor() {
    try {
      var n = int.parse(color ?? '');
      return Color(n);
    } on FormatException {
      return Colors.red;
    }
  }
}

class ActualData {
  ActualData({
    required this.title,
    required this.time,
    required this.color,
  });
  late final String title;
  late final String time;
  late final String color;

  ActualData.fromJson(Map<String, dynamic> json){
    title = json['title'];
    time = json['time'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['time'] = time;
    _data['color'] = color;
    return _data;
  }

  Color getColor() {
    try {
      var n = int.parse(color ?? '');
      return Color(n);
    } on FormatException {
      return Colors.red;
    }
  }

}

class BarChat {
  BarChat({
    required this.title,
    required this.budgetedTime,
    required this.actualTime,
    required this.color,
  });
  late final String title;
  late final String budgetedTime;
  late final String actualTime;
  late final String color;

  BarChat.fromJson(Map<String, dynamic> json){
    title = json['title'];
    budgetedTime = json['budgeted_time'];
    actualTime = json['actual_time'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['budgeted_time'] = budgetedTime;
    _data['actual_time'] = actualTime;
    _data['color'] = color;
    return _data;
  }
  Color getColor() {
    try {
      var n = int.parse(color ?? '');
      return Color(n);
    } on FormatException {
      return Colors.red;
    }
  }
}