class ModelPagesResponse {
  ModelPagesResponse({
    this.status,
    this.message,
    this.data,
  });
  bool? status;
  String? message;
  Data? data;

  ModelPagesResponse.fromJson(Map<String, dynamic> json){
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
    required this.title,
    required this.description,
    required this.metatitle,
    required this.metadescription,
    required this.keyword,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });
  late final int id;
  late final String title;
  late final String description;
  late final String metatitle;
  late final String metadescription;
  late final String keyword;
  late final String slug;
  late final String createdAt;
  late final String updatedAt;

  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    title = json['title'];
    description = json['description'];
    metatitle = json['metatitle'];
    metadescription = json['metadescription'];
    keyword = json['keyword'];
    slug = json['slug'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['title'] = title;
    _data['description'] = description;
    _data['metatitle'] = metatitle;
    _data['metadescription'] = metadescription;
    _data['keyword'] = keyword;
    _data['slug'] = slug;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}