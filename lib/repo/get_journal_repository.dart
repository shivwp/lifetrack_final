
import 'package:life_track/models/get_journal_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelGetJournalResponse> getJournalData(date) async {

  var map = <String, dynamic>{};
  map['date'] = date;


  ApiResponse<dynamic>? response =
  await ApiBaseHelper.getInstance().post('getjournal', map);

  return ModelGetJournalResponse.fromJson(response!.data);
}
