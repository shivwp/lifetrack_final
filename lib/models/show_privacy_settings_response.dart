class ModelShowPrivacySettings {
  ModelShowPrivacySettings({
    this.status,
    this.message,
    this.data,
  });
  var status;
  var message;
  List<Data>? data;

  ModelShowPrivacySettings.fromJson(Map<String, dynamic> json){
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
    required this.name,
    required this.key,
    required this.status,
  });
  String? name;
  String? key;
  var status;

  Data.fromJson(Map<String, dynamic> json){
    name = json['name'];
    key = json['key'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['key'] = key;
    _data['status'] = status;
    return _data;
  }
}