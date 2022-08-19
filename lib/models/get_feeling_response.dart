class ModelGetFeelingResponse {
  ModelGetFeelingResponse({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  Data? data;

  ModelGetFeelingResponse.fromJson(Map<String, dynamic> json){
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
    required this.userId,
    required this.reviewMassge,
    required this.reviewDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final int userId;
  late final String reviewMassge;
  late final String reviewDate;
  late final int status;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userId = json['user_id'];
    reviewMassge = json['review_massge'];
    reviewDate = json['review_date'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['review_massge'] = reviewMassge;
    _data['review_date'] = reviewDate;
    _data['status'] = status;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}