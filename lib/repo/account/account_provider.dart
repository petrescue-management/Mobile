import 'dart:async';
import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/models/user_model.dart';
import 'package:pet_rescue_mobile/src/api_url.dart';

class AccountProvider {
  Future<String> getJWT(String token) async {
    final response = await http.get(
      ApiUrl.getJWT + "?token=" + token,
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/json; charset=UTF-8",
      },
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove('token');
      sharedPreferences.setString('token', json.decode(response.body));
      return response.body;
    } else {
      throw Exception("can not get jwt");
    }
  }

  Future<UserModel> getUserDetail(String token) async {
    final response = await http.get(
      ApiUrl.getUserDetail,
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization" : "Bearer " + token,
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return UserModel.fromJson(json.decode(response.body));
    }
    return null;
  }
}
