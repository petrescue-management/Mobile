import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/models/pet/pet_list_model.dart';

class PetProvider {
  Future<PetListModel> getPetList() async {
    final response = await http.get('');

    if (response.statusCode == 200) {
      return PetListModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Failed to load order - order mode');
    }
    return null;
  }
}
