class ModelAddFriendResponse {
  ModelAddFriendResponse({
    this.status,
    this.message,
    this.data,
  });

  var status;
  var message;
  Data? data;

  ModelAddFriendResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] == null ? null : Data.fromJson(json['data']);
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
    required this.friendFrom,
    required this.friendTo,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  late final int friendFrom;
  late final int friendTo;
  late final String status;
  late final String updatedAt;
  late final String createdAt;
  late final int id;

  Data.fromJson(Map<String, dynamic> json) {
    friendFrom = json['friend_from'];
    friendTo = json['friend_to'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['friend_from'] = friendFrom;
    _data['friend_to'] = friendTo;
    _data['status'] = status;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    return _data;
  }
}
