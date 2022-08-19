class CategoryListResponseModel {
  CategoryListResponseModel({
    required this.status,
    required this.message,
    required this.categories,
  });
  late final bool status;
  late final String? message;
  late final List<CategoryListModel> categories;

  CategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    categories = List.from(json['categories'])
        .map((e) => CategoryListModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['categories'] = categories.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CategoryListModel {
  CategoryListModel({
    required this.title,
    required this.id,
  });
  late final String title;
  late final int id;

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['id'] = id;
    return _data;
  }
}
