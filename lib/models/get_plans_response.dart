class ModelGetPlansResponse {
  String? status;
  String? message;
  List<Data>? data;

  ModelGetPlansResponse({this.status, this.message, this.data});

  ModelGetPlansResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? userName;
  String? userRole;
  String? addfriends;
  String? creategroup;
  String? subscriptionsType;
  String? name;
  String? price;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.userName,
        this.userRole,
        this.addfriends,
        this.creategroup,
        this.subscriptionsType,
        this.name,
        this.price,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userName = json['user_name'];
    userRole = json['user_role'];
    addfriends = json['addfriends'];
    creategroup = json['creategroup'];
    subscriptionsType = json['subscriptions_type'];
    name = json['name'];
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_role'] = this.userRole;
    data['addfriends'] = this.addfriends;
    data['creategroup'] = this.creategroup;
    data['subscriptions_type'] = this.subscriptionsType;
    data['name'] = this.name;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
