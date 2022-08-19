class ModelGroupListResponse {
  ModelGroupListResponse({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  List<Data>? data;

  ModelGroupListResponse.fromJson(Map<String, dynamic> json){
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
    required this.groupname,
    this.descrption,
    required this.createBy,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String groupname;
  late final String? descrption;
  late final String createBy;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    groupname = json['groupname'];
    descrption = null;
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