
import 'package:life_track/models/pages_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelPagesResponse> getPages(slug) async {
  var map = <String, dynamic>{};
  map['slug'] = slug;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('page', map);

  return ModelPagesResponse.fromJson(response!.data);
}