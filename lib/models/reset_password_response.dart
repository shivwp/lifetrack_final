class ResetPasswordResponseModel {
  ResetPasswordResponseModel({
    required this.status,
    required this.message,
    //required this.user,
  });
  late final bool status;
  late final String? message;
  //late final User? user;

  ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    //user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    //_data['user'] = user.toJson();
    return _data;
  }
}
/*
class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.status,
    required this.verfyUser,
    required this.otpVerfied,
    required this.otp,
    required this.phone,
    required this.userImage,
    required this.emailVerifiedAt,
    required this.customerId,
    this.token,
    required this.isApproved,
    required this.subsStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String firstName;
  late final String lastName;
  late final String email;
  late final String status;
  late final String verfyUser;
  late final int otpVerfied;
  late final String otp;
  late final String phone;
  late final String userImage;
  late final String emailVerifiedAt;
  late final String customerId;
  late final Null token;
  late final int isApproved;
  late final String subsStatus;
  late final String createdAt;
  late final String updatedAt;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    status = json['status'];
    verfyUser = json['verfy_user'];
    otpVerfied = json['otp_verfied'];
    otp = json['otp'];
    phone = json['phone'];
    userImage = json['user_image'];
    emailVerifiedAt = json['email_verified_at'];
    customerId = json['customer_id'];
    token = null;
    isApproved = json['is_approved'];
    subsStatus = json['subs_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    _data['otp'] = otp;
    _data['phone'] = phone;
    _data['user_image'] = userImage;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['customer_id'] = customerId;
    _data['token'] = token;
    _data['is_approved'] = isApproved;
    _data['subs_status'] = subsStatus;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}
*/
