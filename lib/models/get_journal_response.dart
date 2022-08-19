class ModelGetJournalResponse {
  ModelGetJournalResponse({
    this.status,
    this.message,
    this.data,
  });
  var status;
  var message;
  List<Data>? data;

  ModelGetJournalResponse.fromJson(Map<String, dynamic> json){
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
    required this.name,
    required this.description,
    required this.date,
    required this.userId,
    this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String description;
  late final String date;
  late final int userId;
  late final Null status;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    description = json['description'];
    date = json['date'];
    userId = json['user_id'];
    status = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['description'] = description;
    _data['date'] = date;
    _data['user_id'] = userId;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}