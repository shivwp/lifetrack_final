class ModelSingleFriendDetailResponse {
  ModelSingleFriendDetailResponse({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  Data? data;

  ModelSingleFriendDetailResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
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
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.image,
    required this.privacySetting,
    required this.achievement,
  });
  late final String firstName;
  late final String lastName;
  late final String email;
  late final Null phone;
  late final String image;
  late final List<PrivacySetting> privacySetting;
  late final String achievement;

  Data.fromJson(Map<String, dynamic> json){
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = null;
    image = json['image'];
    privacySetting = List.from(json['privacy_setting']).map((e)=>PrivacySetting.fromJson(e)).toList();
    achievement = json['achievement'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['phone'] = phone;
    _data['image'] = image;
    _data['privacy_setting'] = privacySetting.map((e)=>e.toJson()).toList();
    _data['achievement'] = achievement;
    return _data;
  }
}

class PrivacySetting {
  PrivacySetting({
    required this.name,
    required this.key,
    required this.status,
  });
  late final String name;
  late final String key;
  late final bool status;

  PrivacySetting.fromJson(Map<String, dynamic> json){
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