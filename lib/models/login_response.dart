class LoginResponseModel {
  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.user,
  });
  late final bool status;
  late final String? message;
  LoginResponseDataModel? data;
  late final LoginUserModel? user;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data']==null ? null : LoginResponseDataModel.fromJson(json['data']);
    user = LoginUserModel.fromJson(json['users']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    _data['users'] = user?.toJson();
    return _data;
  }
}

class LoginResponseDataModel {
  LoginResponseDataModel({
    required this.token,
  });
  late final String? token;

  LoginResponseDataModel.fromJson(Map<String, dynamic>? json) {
    token = json?['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    return _data;
  }
}

class LoginUserModel {
  LoginUserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
    required this.verfyUser,
    required this.otpVerfied,
    required this.phone,
    required this.userImage,
    this.emailVerifiedAt,
    required this.isApproved,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int? id;
  late final String? firstName;
  late final String? lastName;
  late final String? email;
  late final String? status;
  late final String? verfyUser;
  late final int? otpVerfied;
  late final String? phone;
  late final String? userImage;
  late final String? emailVerifiedAt;
  late final int? isApproved;
  late final String? subsStatus;
  late final String? createdAt;
  late final String? updatedAt;

  LoginUserModel.fromJson(Map<String, dynamic>? json) {
    id = json?['id'];
    firstName = json?['first_name'];
    lastName = json?['last_name'];
    email = json?['email'];
    status = json?['status'];
    verfyUser = json?['verfy_user'];
    otpVerfied = json?['otp_verfied'];
    phone = json?['phone'];
    userImage = json?['image'];
    emailVerifiedAt = json?['email_verified_at'];
    isApproved = json?['is_approved'];
    subsStatus = json?['subs_status'];
    createdAt = json?['created_at'];
    updatedAt = json?['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['email'] = email;
    _data['status'] = status;
    _data['verfy_user'] = verfyUser;
    _data['otp_verfied'] = otpVerfied;
    _data['phone'] = phone;
    _data['image'] = userImage;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['is_approved'] = isApproved;
    _data['subs_status'] = subsStatus;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
