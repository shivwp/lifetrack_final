class ModelGetProfile {
  ModelGetProfile({
    this.status,
    this.message,
    this.data,
  });
  var status;
  var message;
  Data? data;

  ModelGetProfile.fromJson(Map<String, dynamic> json){
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
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.verfyUser,
    required this.otpVerfied,
    required this.otp,
    required this.phone,
    required this.emailVerifiedAt,
    required this.image,
    required this.customerId,
    required this.token,
    required this.isApproved,
    required this.subsStatus,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String name;
  late final String email;
  late final String status;
  late final String verfyUser;
  late final int otpVerfied;
  late final String otp;
  late final String phone;
  late final String emailVerifiedAt;
  late final String image;
  late final String customerId;
  late final String token;
  late final int isApproved;
  late final String subsStatus;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    status = json['status'];
    verfyUser = json['verfy_user'];
    otpVerfied = json['otp_verfied'];
    otp = json['otp'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    customerId = json['customer_id'];
    token = json['token'];
    isApproved = json['is_approved'];
    subsStatus = json['subs_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['email'] = email;
    _data['status'] = status;
    _data['verfy_user'] = verfyUser;
    _data['otp_verfied'] = otpVerfied;
    _data['otp'] = otp;
    _data['phone'] = phone;
    _data['email_verified_at'] = emailVerifiedAt;
    _data['image'] = image;
    _data['customer_id'] = customerId;
    _data['token'] = token;
    _data['is_approved'] = isApproved;
    _data['subs_status'] = subsStatus;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}