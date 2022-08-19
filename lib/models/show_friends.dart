class ModelShowFriendsResponse {
  ModelShowFriendsResponse({
    this.status,
    this.message,
    this.data,
  });
  var status;
  var message;
  List<Data>? data;

  ModelShowFriendsResponse.fromJson(Map<String, dynamic> json){
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
    required this.status,
    required this.reviewMassge,
    required this.privacySetting,
  });
  late final int userId;
  late final String firstName;
  late final String lastName;
  late final String userImage;
  late final String status;
  late final String reviewMassge;
  late final PrivacySetting privacySetting;

  Data.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userImage = json['user_image'];
    status = json['status'];
    reviewMassge = json['review_massge'];
    privacySetting = PrivacySetting.fromJson(json['privacy_setting']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['user_image'] = userImage;
    _data['status'] = status;
    _data['review_massge'] = reviewMassge;
    _data['privacy_setting'] = privacySetting.toJson();
    return _data;
  }
}

class PrivacySetting {
  PrivacySetting({
    required this.profilePhoto,
    required this.moodUpdate,
    required this.charts,
    required this.activity,
    required this.groupAccess,
  });
  late final bool profilePhoto;
  late final bool moodUpdate;
  late final bool charts;
  late final bool activity;
  late final bool groupAccess;

  PrivacySetting.fromJson(Map<String, dynamic> json){
    profilePhoto = json['profile_photo'];
    moodUpdate = json['mood_update'];
    charts = json['charts'];
    activity = json['activity'];
    groupAccess = json['group_access'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['profile_photo'] = profilePhoto;
    _data['mood_update'] = moodUpdate;
    _data['charts'] = charts;
    _data['activity'] = activity;
    _data['group_access'] = groupAccess;
    return _data;
  }
}