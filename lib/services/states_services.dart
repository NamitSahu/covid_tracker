import 'dart:convert';

import 'package:covid_tracker/models/world_states_model.dart';
import 'package:covid_tracker/services/Utils/app_util.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStatesModel> fetchWorkedStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return WorldStatesModel.fromMap(data);
    } else {
      throw Exception("Error");
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception("Error");
    }
  }
}
