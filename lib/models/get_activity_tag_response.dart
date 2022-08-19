class ModelGetActivityTagResponse {
  ModelGetActivityTagResponse({
    this.status,
    this.message,
    this.activity,
  });
  var status;
  var message;
  List<Activity>? activity;

  ModelGetActivityTagResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    activity = List.from(json['activity']).map((e)=>Activity.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['activity'] = activity!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Activity {
  Activity({
    required this.id,
    required this.userid,
    required this.activity,
    this.parentCatgory,
    this.subCategory,
    required this.starttime,
    required this.endtime,
    this.selectcolor,
    required this.selectprivacy,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String userid;
  late final String activity;
  late final int? parentCatgory;
  late final int? subCategory;
  late final String starttime;
  late final String endtime;
  late final String? selectcolor;
  late final String selectprivacy;
  late final String createdAt;
  late final String updatedAt;
  bool isSelected = false;

  Activity.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userid = json['userid'];
    activity = json['activity'];
    parentCatgory = null;
    subCategory = null;
    starttime = json['starttime'];
    endtime = json['endtime'];
    selectcolor = null;
    selectprivacy = json['selectprivacy'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
}