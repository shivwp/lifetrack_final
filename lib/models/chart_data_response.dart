class ModelDayWiseResponse {
  ModelDayWiseResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final List<Data> data;

  ModelDayWiseResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.tagId,
    required this.date,
    required this.budgetedStartTime,
    required this.budgetEndTime,
    required this.actualStartTime,
    required this.actualEndTime,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
  late final int id;
  late final int userId;
  late final int tagId;
  late final String date;
  late final String budgetedStartTime;
  late final String budgetEndTime;
  late final String actualStartTime;
  late final String actualEndTime;
  late final int status;
  late final Null createdAt;
  late final Null updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    tagId = json['tag_id'];
    date = json['date'];
    budgetedStartTime = json['budgeted_start_time'];
    budgetEndTime = json['budget_end_time'];
    actualStartTime = json['actual_start_time'];
    actualEndTime = json['actual_end_time'];
    status = json['status'];
    createdAt = null;
    updatedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['tag_id'] = tagId;
    _data['date'] = date;
    _data['budgeted_start_time'] = budgetedStartTime;
    _data['budget_end_time'] = budgetEndTime;
    _data['actual_start_time'] = actualStartTime;
    _data['actual_end_time'] = actualEndTime;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}