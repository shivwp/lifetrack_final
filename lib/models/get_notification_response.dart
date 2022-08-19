class ModelGetNotifications {
  ModelGetNotifications({
    this.status,
    this.message,
    this.data,
  });
  var status;
  var message;
  List<Data>? data;

  ModelGetNotifications.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data!.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.noticeDate,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
  late final int id;
  late final int userId;
  late final String title;
  late final String description;
  late final String noticeDate;
  late final int status;
  late final Null createdAt;
  late final Null updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    noticeDate = json['notice_date'];
    status = json['status'];
    createdAt = null;
    updatedAt = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['title'] = title;
    _data['description'] = description;
    _data['notice_date'] = noticeDate;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}