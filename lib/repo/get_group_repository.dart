
import 'package:life_track/models/group_list_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGroupListResponse> showGroups() async {

  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().get('showgroup',);

  return ModelGroupListResponse.fromJson(response!.data);
}
