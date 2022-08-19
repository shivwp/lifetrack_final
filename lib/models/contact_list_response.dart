class ModelContactListResponse {
  ModelContactListResponse({
   this.status,
   this.message,
   this.data,
  });
  bool? status;
  String? message;
  List<Data>? data;

  ModelContactListResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.groupId,
    required this.admin,
    required this.accpet,
  });
  late final int id;
  late final int userId;
  late final int groupId;
  late final int admin;
  late final int accpet;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    groupId = json['group_id'];
    admin = json['admin'];
    accpet = json['accpet'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['group_id'] = groupId;
    _data['admin'] = admin;
    _data['accpet'] = accpet;
    return _data;
  }
}