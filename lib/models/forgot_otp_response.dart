class ForgotPasswordOtpResponseModel {
  ForgotPasswordOtpResponseModel({
    required this.status,
    required this.otp,
    required this.message,
  });
  late final bool status;
  late final int? otp;
  late final String? message;

  ForgotPasswordOtpResponseModel.fromJson(Map<String, dynamic>? json) {
    status = json?['status'];
    otp = json?['otp'];
    message = json?['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['otp'] = otp;
    _data['message'] = message;
    return _data;
  }
}
