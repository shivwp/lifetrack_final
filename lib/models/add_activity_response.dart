class AddActivityResponseModel {
  AddActivityResponseModel({
    required this.status,
    required this.message,
    required this.actData,
  });
  late final bool status;
  late final String? message;
  late final SavedActivityResponseModel? actData;

  AddActivityResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    actData = SavedActivityResponseModel.fromJson(json['act_data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['act_data'] = actData?.toJson();
    return _data;
  }
}

class SavedActivityResponseModel {
  SavedActivityResponseModel({
    required this.username,
    required this.activity,
    required this.starttime,
    required this.endtime,
    required this.selectprivacy,
    required this.selectcolor,
    required this.parentCatgory,
    required this.subCategory,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final int? username;
  late final String? activity;
  late final String? starttime;
  late final String? endtime;
  late final String? selectprivacy;
  late final String? selectcolor;
  late final String? parentCatgory;
  late final String? subCategory;
  late final String? updatedAt;
  late final String? createdAt;
  late final int? id;

  SavedActivityResponseModel.fromJson(Map<String, dynamic>? json) {
    username = json?['username'];
    activity = json?['activity'];
    starttime = json?['starttime'];
    endtime = json?['endtime'];
    selectprivacy = json?['selectprivacy'];
    selectcolor = json?['selectcolor'];
    parentCatgory = json?['parent_catgory'];
    subCategory = json?['sub_category'];
    updatedAt = json?['updated_at'];
    createdAt = json?['created_at'];
    id = json?['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['activity'] = activity;
    _data['starttime'] = starttime;
    _data['endtime'] = endtime;
    _data['selectprivacy'] = selectprivacy;
    _data['selectcolor'] = selectcolor;
    _data['parent_catgory'] = parentCatgory;
    _data['sub_category'] = subCategory;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}
