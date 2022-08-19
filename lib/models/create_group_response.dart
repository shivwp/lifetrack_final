class ModelCreateGroupResponse {
  ModelCreateGroupResponse({
   this.status,
   this.message,
   this.data,
  });
  bool? status;
  String? message;
  Data? data;

  ModelCreateGroupResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = json['data']==null ? null :Data.fromJson(json['data']);
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
    required this.id,
    required this.groupname,
    required this.descrption,
    required this.createBy,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String groupname;
  var descrption;
  late final int createBy;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    groupname = json['groupname'];
    descrption = json['descrption'];
    createBy = json['create_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['groupname'] = groupname;
    _data['descrption'] = descrption;
    _data['create_by'] = createBy;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}