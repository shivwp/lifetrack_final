
import 'package:life_track/models/contact_list_response.dart';
import 'package:life_track/models/show_friends.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelContactListResponse> contactListData() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('contactlist',);

  return ModelContactListResponse.fromJson(response!.data);
}
