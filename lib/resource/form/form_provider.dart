import 'dart:async';
import 'dart:convert';
import 'package:commons/commons.dart';
import 'package:http/http.dart' as http;
import 'package:pet_rescue_mobile/src/api_url.dart';
import 'package:pet_rescue_mobile/models/registrationform/rescue_report_model.dart';

class FormProvider {
  Future<bool> createRescueRequest(RescueReport rescueReport) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jwtToken = sharedPreferences.getString('token');

    var resBody = {};
    resBody['reportLocation'] = rescueReport.reportLocation;
    resBody['imgReportUrl'] = rescueReport.imgReportUrl;
    resBody['petAttribute'] = rescueReport.petAttribute;
    resBody['reportDescription'] = rescueReport.reportDescription;
    resBody['latitude'] = rescueReport.latitude;
    resBody['longitude'] = rescueReport.longitude;
    resBody['phone'] = rescueReport.phone;

    String str = json.encode(resBody);

    final response = await http.post(
      ApiUrl.createRescueRequest,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + jwtToken,
      },
      body: str,
    );

    if (response.statusCode == 200) {
      return true;
    }
    return null;
  }
}
