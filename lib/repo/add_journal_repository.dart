
import 'package:life_track/models/add_journal_response.dart';
import 'package:life_track/network/api_base_helper.dart';
import 'package:life_track/network/api_response.dart';

Future<ModelAddJournalResponse> addJournal(id, name, description, date) async {
  var map = <String, dynamic>{};
  if (id != ''){
    map['id'] = id;
  }
  map['name'] = name;
  map['description'] = description;
  map['date'] = date;

  ApiResponse<dynamic>? response =
      await ApiBaseHelper.getInstance().post('addjournal', map);

  return ModelAddJournalResponse.fromJson(response!.data);
}
