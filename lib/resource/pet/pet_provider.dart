import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/models/pet/pet_list_base_model.dart';
import 'package:pet_rescue_mobile/src/api_url.dart';

class PetProvider {
  Future<PetListBaseModel> getPetListByType() async {
    final response = await http.get(
      ApiUrl.getPetListByType,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      return PetListBaseModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load post');
    }
    return null;
  }
}
