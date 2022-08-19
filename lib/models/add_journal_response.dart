class ModelAddJournalResponse {
  ModelAddJournalResponse({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool status;
  late final String message;
  late final Data data;

  ModelAddJournalResponse.fromJson(Map<String, dynamic> json){
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
    required this.description,
    required this.date,
    required this.name,
  });
  late final int userId;
  late final String description;
  late final String date;
  late final String name;

  Data.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    description = json['description'];
    date = json['date'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['description'] = description;
    _data['date'] = date;
    _data['name'] = name;
    return _data;
  }
}