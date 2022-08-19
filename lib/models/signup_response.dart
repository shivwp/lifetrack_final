class SignupResponseModel {
  SignupResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });
  late final bool? status;
  late final String? message;
  late final String? token;
  late final SignupResponseDataModel? data;

  SignupResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    data = SignupResponseDataModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['token'] = token;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class SignupResponseDataModel {
  SignupResponseDataModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.verfyUser,
    required this.otp,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    //required this.Your Otp is,
  });
  late final String? email;
  late final String? firstName;
  late final String? lastName;
  late final String? status;
  late final String? verfyUser;
  late final int? otp;
  late final String? updatedAt;
  late final String? createdAt;
  late final int? id;
  //late final int Your Otp is;

  SignupResponseDataModel.fromJson(Map<String, dynamic>? json) {
    email = json?['email'];
    firstName = json?['first_name'];
    lastName = json?['last_name'];
    status = json?['status'];
    verfyUser = json?['verfy_user'];
    otp = json?['otp'];
    updatedAt = json?['updated_at'];
    createdAt = json?['created_at'];
    id = json?['id'];
    //Your Otp is = json['Your Otp is'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['status'] = status;
    _data['verfy_user'] = verfyUser;
    _data['otp'] = otp;
    _data['updated_at'] = updatedAt;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    //_data['Your Otp is'] = Your Otp is;
    return _data;
  }
}
