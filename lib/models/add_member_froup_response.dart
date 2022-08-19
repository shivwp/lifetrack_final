class ModelAddMemberGroupResponse {
  ModelAddMemberGroupResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  ModelAddMemberGroupResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.userId,
    required this.groupId,
    required this.admin,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });
  late final String userId;
  late final String groupId;
  late final int admin;
  late final String updatedAt;
  late final String createdAt;
  late final int id;

  Data.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    groupId = json['group_id'];
    admin = json['admin'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['group_id'] = groupId;
    _data['admin'] = admin;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}