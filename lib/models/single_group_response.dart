class ModelSingleGroupResponse {
  ModelSingleGroupResponse({
    this.status,
    this.message,
    this.data,
  });
  var status;
  var message;
  Data? data;

  ModelSingleGroupResponse.fromJson(Map<String, dynamic> json){
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
    required this.groupname,
    required this.descrption,
    required this.createBy,
    required this.memberData,
  });
  late final int id;
  late final String groupname;
  late final String descrption;
  late final String createBy;
  late final List<MemberData> memberData;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    groupname = json['groupname'];
    descrption = json['descrption'];
    createBy = json['create_by'];
    memberData = List.from(json['member_data']).map((e)=>MemberData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['groupname'] = groupname;
    _data['descrption'] = descrption;
    _data['create_by'] = createBy;
    _data['member_data'] = memberData.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class MemberData {
  MemberData({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.userImage,
    required this.privacySetting,
  });
  late final int userId;
  late final String firstName;
  late final String lastName;
  late final String userImage;
  late final PrivacySetting privacySetting;

  MemberData.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name']==null?"":json['last_name'];
    userImage = json['user_image'];
    privacySetting = PrivacySetting.fromJson(json['privacy_setting']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['first_name'] = firstName;
    _data['last_name'] = lastName;
    _data['user_image'] = userImage;
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