import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/src/api_url.dart';
import 'package:pet_rescue_mobile/models/center/center_base_model.dart';

class CenterProvider {
  Future<CenterBaseModel> getCenterList() async {
    final response = await http.get(
      ApiUrl.getPetListByType,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    if (response.statusCode == 200) {
      return CenterBaseModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load center list ${response.statusCode}');
    }
    return null;
  }
}
