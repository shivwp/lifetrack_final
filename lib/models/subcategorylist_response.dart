class SubCategoryListResponseModel {
  SubCategoryListResponseModel({
    required this.status,
    required this.message,
    required this.subcategories,
  });
  late final bool status;
  late final String? message;
  late final List<SubcategoryListModel> subcategories;

  SubCategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    subcategories = List.from(json['subcategories'])
        .map((e) => SubcategoryListModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['subcategories'] = subcategories.map((e) => e.toJson()).toList();
    return _data;
  }
}

class SubcategoryListModel {
  SubcategoryListModel({
    required this.title,
    required this.id,
    required this.parentId,
  });
  late final String title;
  late final int id;
  late final int parentId;

  SubcategoryListModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['id'] = id;
    _data['parent_id'] = parentId;
    return _data;
  }
}
