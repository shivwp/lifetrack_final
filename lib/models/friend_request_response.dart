class ModelFriendRequestResponse {
  ModelFriendRequestResponse({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  List<Data>? data;

  ModelFriendRequestResponse.fromJson(Map<String, dynamic> json){
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
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userImage,
  });
  var userId;
  var firstName;
  var lastName;
  var userImage;

  Data.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['user_image'] = userImage;
    return _data;
  }
}