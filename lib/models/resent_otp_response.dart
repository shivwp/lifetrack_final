class ResendOTPResponseModel {
  ResendOTPResponseModel({
    required this.status,
    required this.message,
    required this.otp,
  });
  late final bool status;
  late final String? message;
  late final int? otp;

  ResendOTPResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    otp = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['token'] = otp;
    return _data;
  }
}
