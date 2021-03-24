import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/models/pet/pet_list_model.dart';
import 'package:pet_rescue_mobile/models/pet/pet_type_list.dart';
import 'package:pet_rescue_mobile/src/api_url.dart';

class PetProvider {
  Future<PetListModel> getPetList() async {
    final response = await http.get(
      ApiUrl.getPetList,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return PetListModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load post');
    }
    return null;
  }

  Future<PetListModel> getPetListByType(String petTypeName) async {
    final response = await http.get(
      ApiUrl.getPetListByType + '$petTypeName&fields=detail&limit=-1',
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return PetListModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load post');
    }
    return null;
  }

  Future<PetTypeList> getPetTypeList() async {
    final response = await http.get(
      ApiUrl.getPetTypes,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return PetTypeList.fromJson(json.decode(response.body));
    } else {
      print('Failed to load post');
    }
    return null;
  }
}
